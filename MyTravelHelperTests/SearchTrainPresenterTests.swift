//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenter!
    var view = SearchTrainMockView()
    var interactor = SearchTrainInteractorMock()
   

    
    override func setUp() {
      presenter = SearchTrainPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }

    func testfetchallStations() {
        let expectation = self.expectation(description: "fetchAllStation")
        presenter.fetchallStations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.view.isSaveFetchedStatinsCalled)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 7) { (error) in
            guard let error = error else { return }
            XCTFail("\(error)")
        }
    }
    
    func testfetchTrainsFromSource() {
        let expectation = self.expectation(description: "fetchAllStation")
        presenter.stationsList = [Station(desc: "Sligo", latitude: 54.1911, longitude: 54.1911, code: "SLIGO", stationId: 1), Station(desc: "Boyle", latitude: 54.1911, longitude: 54.1911, code: "BOYLE", stationId: 2)]
        presenter.searchTapped(source: "Sligo", destination: "Boyle")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            XCTAssertTrue(self.view.isFetchTrainSuccessFully)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 15) { (error) in
            guard let error = error else { return }
            XCTFail("\(error)")
        }
    }

    override func tearDown() {
        presenter = nil
    }
}


class SearchTrainMockView:PresenterToViewProtocol {
    var isSaveFetchedStatinsCalled = false
    var isFetchTrainSuccessFully = false

    func saveFetchedStations(stations: [Station]?) {
        isSaveFetchedStatinsCalled = true
    }

    func showInvalidSourceOrDestinationAlert() {
        
    }
    
    func updateLatestTrainList(trainsList: [StationTrain]) {
        isFetchTrainSuccessFully  = true
    }
    
    func showNoTrainsFoundAlert() {

    }
    
    func showNoTrainAvailbilityFromSource() {

    }
    
    func showNoInterNetAvailabilityMessage() {

    }
}

class SearchTrainInteractorMock:PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        presenter?.stationListFetched(list: [Station(desc: "Sligo", latitude: 54.1911, longitude: 54.1911, code: "SLIGO", stationId: 1), Station(desc: "Boyle", latitude: 54.1911, longitude: 54.1911, code: "BOYLE", stationId: 2)])
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        presenter?.fetchedTrainsList(trainsList: [StationTrain(trainCode: "A915", fullName: "Sligo", stationCode: "SLIGO", trainDate: "02 May 2021", dueIn: 0, lateBy: 0, expArrival: "00:00:00", expDeparture: "09:05:00"), StationTrain(trainCode: "A901", fullName: "Boyle", stationCode: "BOYLE", trainDate: "02 May 2021", dueIn: 0, lateBy: 0, expArrival: "09:37:30", expDeparture: "09:39:30")])
    }
}
