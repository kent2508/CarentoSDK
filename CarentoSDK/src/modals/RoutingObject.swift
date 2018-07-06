//
//  RoutingObject.swift
//  Carento
//
//  Created by Tuan Anh Vu on 5/11/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import Foundation

class RoutingObject {
    var realDuration: Int = 0
    var startedAtLocation: Double = 0.0
    var finishAtLocation: Double = 0.0
    var status: Int = 0 // 0: waiting, 1: confirm, 2: connected, 3: rejected, 10: finish
    var statusText: String?
    
    init(routingInfo: [String: Any]) {
        if let duration = routingInfo["real_duration"] as? NSNumber {
            self.realDuration = duration.intValue
        }
        if let origin = routingInfo["started_at"] as? NSNumber {
            self.startedAtLocation = origin.doubleValue
        }
        if let des = routingInfo["finished_at"] as? NSNumber {
            self.finishAtLocation = des.doubleValue
        }
        if let status = routingInfo["status"] as? NSNumber {
            self.status = status.intValue
        }
        self.statusText = routingInfo["status_text"] as? String
    }
}
