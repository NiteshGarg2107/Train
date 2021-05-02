//
//  TrainMovements.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

struct TrainMovementsData: Codable {
    var trainMovements: [TrainMovement]?

    enum CodingKeys: String, CodingKey {
        case trainMovements = "objTrainMovements"
    }
}


//<TrainCode>A131 </TrainCode>
//<TrainDate>01 May 2021</TrainDate>
//<LocationCode>BFSTC</LocationCode>
//<LocationFullName>Belfast</LocationFullName>
//<LocationOrder>1</LocationOrder>
//<LocationType>O</LocationType>
//<TrainOrigin>Belfast</TrainOrigin>
//<TrainDestination>Dublin Connolly</TrainDestination>
//<ScheduledArrival>00:00:00</ScheduledArrival>
//<ScheduledDeparture>16:05:00</ScheduledDeparture>
//<ExpectedArrival>00:00:00</ExpectedArrival>
//<ExpectedDeparture>16:05:00</ExpectedDeparture>
//<Arrival/>
//<Departure/>
//<AutoArrival/>
//<AutoDepart/>
//<StopType>C</StopType>

struct TrainMovement: Codable {
    var trainCode: String?
    var locationCode: String?
    var locationFullName: String?
    var expDeparture:String?
    var locationOrder: Int?
    var destinationDetails:String?
    

    enum CodingKeys: String, CodingKey {
        case trainCode = "TrainCode"
        case locationCode = "LocationCode"
        case locationFullName = "LocationFullName"
        case expDeparture = "ExpectedDeparture"
        case locationOrder = "LocationOrder"
        case destinationDetails = "TrainDestination"
    }

//    init(trainCode: String, locationCode: String, locationFullName: String,expDeparture:String, locationOrder: Int) {
//        self.trainCode = trainCode
//        self.locationCode = locationCode
//        self.locationFullName = locationFullName
//        self.expDeparture = expDeparture
//        self.locationOrder = locationOrder
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        let trainCode = try values.decode(String.self, forKey: .trainCode)
//        let locationCode = try values.decode(String.self, forKey: .locationCode)
//        let locationFullName = try values.decode(String.self, forKey: .locationFullName)
//        let departure = try values.decode(String.self, forKey: .expDeparture)
//        let locationOrder = try values.decode(Int.self, forKey: .locationOrder)
//        self.init(trainCode: trainCode, locationCode: locationCode, locationFullName: locationFullName,expDeparture: departure, locationOrder: locationOrder)
//    }
}

