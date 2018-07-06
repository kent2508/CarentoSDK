//
//  DriverObject.swift
//  Carento
//
//  Created by Tuan Anh Vu on 5/9/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import Foundation

class DriverObject {
    var name: String?
    var mobile: String?
    var avatar: String?
    var license: String?
    var carImage: String?
    var carName: String?
    var carId: String?
    var routingStatus: Int = 0 // 0: waiting, 1: running, 2: dropped by user, 3: dropped by driver, 10: finish
    var routingStatusText: String?
    
    init(driverInfo: [String: Any]) {
        self.name = driverInfo["full_name"] as? String
        self.mobile = driverInfo["msisdn"] as? String
        self.avatar = driverInfo["avatar_img"] as? String
        self.license = driverInfo["license_plate"] as? String
        self.carImage = driverInfo["car_image"] as? String
        self.carName = driverInfo["car_name"] as? String
        self.carId = driverInfo["car_id"] as? String
        if let status = driverInfo["routing_status"] as? NSNumber {
            self.routingStatus = status.intValue
        }
        self.routingStatusText = driverInfo["routing_status_text"] as? String
    }
}
