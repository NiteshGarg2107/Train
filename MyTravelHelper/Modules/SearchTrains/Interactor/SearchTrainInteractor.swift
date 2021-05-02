//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing

enum APIBaseURLStore {
    ///BaseUrl of the Server
    static var baseUrl: String {
        return "http://api.irishrail.ie/realtime/realtime.asmx/"
    }
// MARK: API Services
    //Login
    static let kgetAllStation =                      "\(baseUrl)getAllStationsXML"
}

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        if Reach().isNetworkReachable() == true {
            getServiceDate(header: nil, url: APIBaseURLStore.kgetAllStation) { (result: Result<Stations,Error>) in
                
                switch result {
                case .success(let station):
                    self.presenter!.stationListFetched(list: station.stationsList)
                case .failure(let err):
                    //Todo: Show error Popup
                    print(err)
                }
            }
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        if Reach().isNetworkReachable() {
            getServiceDate(header: nil, url: "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML?StationCode=\(sourceCode)") { (result: Result<StationData,Error>) in
                switch result {
                case .success(let stationData):
                    if let _trainsList = stationData.trainsList, _trainsList.count > 0 {
                        self.proceesTrainListforDestinationCheck(trainsList: _trainsList)
                    } else {
                        self.presenter!.showNoTrainAvailbilityFromSource()
                    }
                case .failure(let err):
                    //Todo: Show error Popup
                    print(err)
                }
            }
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var _trainsList = trainsList
        let today = Date()
        let group = DispatchGroup()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: today)
        
        for index  in 0...trainsList.count-1 {
            group.enter()
            if Reach().isNetworkReachable() {
                getServiceDate(header: nil, url: "http://api.irishrail.ie/realtime/realtime.asmx/getTrainMovementsXML?TrainId=\(trainsList[index].trainCode)&TrainDate=\(dateString)") { (result: Result<TrainMovementsData,Error>) in
                    
                    switch result {
                    case .success(let trainMovements):
                        if let _movements = trainMovements.trainMovements {
                            let sourceIndex = _movements.firstIndex(where: {$0.locationCode?.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                            let destinationIndex = _movements.firstIndex(where: {$0.locationCode?.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                            let desiredStationMoment = _movements.filter{$0.locationCode?.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                            let isDestinationAvailable = desiredStationMoment.count == 1

                            if isDestinationAvailable && sourceIndex! < destinationIndex! {
                                _trainsList[index].destinationDetails = desiredStationMoment.first
                            }
                        }
                        group.leave()
                    case .failure(let err):
                        //Todo: Show error Popup
                        print(err)
                    }
                }
            } else {
                self.presenter!.showNoInterNetAvailabilityMessage()
                return
            }
        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }
    
    func getServiceDate<T: Decodable>(header: [String: String]? ,url: String, completion: @escaping (_ result: Result<T,Error>) -> Void) -> Void {
        
        guard let url = URL(string: url) else { return }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 300
        if header != nil {
            config.httpAdditionalHeaders = header
        }
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url)
        request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        session.dataTask(with: request) { (data, resp, error) in
            if error != nil {
                completion(.failure(error!))
            }
            guard let respdata = data else {return}
            DispatchQueue.main.async {
            do {
                let data = try XMLDecoder().decode(T.self, from: respdata)
                completion(.success(data))
            } catch let jasonError{
                completion(.failure(jasonError))

            }
            }
        }.resume()
    }
}
