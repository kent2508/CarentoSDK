//
//  ServiceObject.swift
//  Carento
//
//  Created by Tuan Anh Vu on 4/25/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import Foundation

class ServiceObject {
    var code: String?
    var name: String?
    var description: String?
    var tipText: String?
    var iconURL: URL?
    var directType: Int = 1 // 1: go, 2: back, 3: go & back
    var distance: Int = 0 // in meter (1000 m = 1 km)
    var estimatedDuration: Int = 0 // in minutes
    var estimatedPrice: Int = 0 // in VND curency
    var providedCarTypes: [String]? // "1": normal, "2": luxury
    var providedCarSeat: [String]? // 4,7,16,30
    var locationName: String?
    var locationLatitude: Double = 0.0
    var locationLongitude: Double = 0.0
    var fixLocation: Bool = false
    var timeBeforeBooking: Double = 0.0  // in second
    var grouped = false
    var subObjects: [ServiceObject]?
    
    init(info: [String: Any]) {
        code = info["service_code"] as? String
        name = info["name"] as? String
        description = info["description"] as? String
        tipText = info["tip"] as? String
        if let urlString = info["icon_url"] as? String {
            iconURL = URL(string: urlString)
        }
        if let type = info["direct_type"] as? NSNumber {
            directType = type.intValue
        }
        if let dis = info["distance"] as? NSNumber {
            distance = dis.intValue
        }
        if let duration = info["duration_estimate"] as? NSNumber {
            estimatedDuration = duration.intValue
        }
        if let price = info["price_estimate"] as? NSNumber {
            estimatedPrice = price.intValue
        }
        providedCarTypes = info["provide_car_types"] as? [String]
        providedCarSeat = info["provide_car_seat"] as? [String]
        locationName = info["location_name"] as? String
        if let lat = info["location_lat"] as? NSNumber {
            locationLatitude = lat.doubleValue
        }
        if let long = info["location_lng"] as? NSNumber {
            locationLongitude = long.doubleValue
        }
        if let fixed = info["fix_location"] as? NSNumber {
            fixLocation = fixed.boolValue
        }
        if let time = info["time_before_booking"] as? NSNumber {
            timeBeforeBooking = time.doubleValue * 60
        }
        if let group = info["group"] as? NSNumber {
            grouped = group.boolValue
            if grouped {
                subObjects = [ServiceObject]()
                if let objects = info["sub_services"] as? [[String: Any]] {
                    for obj in objects {
                        subObjects?.append(ServiceObject(info: obj))
                    }
                }
            }
        }
    }
}
