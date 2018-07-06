//
//  BookObject.swift
//  Carento
//
//  Created by Tuan Anh Vu on 5/9/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import Foundation

enum TripStatus: Int {
    case waiting, confirmed, connected, rejected, finished
    
}

class BookObject {
    var title: String?
    var code: String?
    var note: String?
    var originAddressComponents: String?
    var destinationAddressComponents: String?
    var serviceTimeType: Int = 1 // 0: go now, 1: schedule
    var goScheduleTime: TimeInterval = 0.0
    var distance: Int = 0 // in meters
    var price: Int = 0
    var carType: Int = 1 // 1: normal, 2: vip
    var carSeat: Int = 4
    var status: TripStatus = .waiting // 0: waiting, 1: confirm, 2: connected, 3: rejected, 10: finished
    var statusText: String?
    var driver: DriverObject?
    var routing: RoutingObject?
    var bookingForFullName: String?
    var bookingForMobile: String?
    var extraStops: [LocationObject]?
    
    init(bookInfo: [String: Any]) {
        self.title = bookInfo["title"] as? String
        self.code = bookInfo["code"] as? String
        self.note = bookInfo["note"] as? String
        self.originAddressComponents = bookInfo["origin_address_components"] as? String
        self.destinationAddressComponents = bookInfo["destination_address_components"] as? String
        if let type = bookInfo["type"] as? NSNumber {
            self.serviceTimeType = type.intValue
        }
        if let time = bookInfo["go_schedule_at"] as? NSNumber {
            self.goScheduleTime = time.doubleValue
        }
        if let distance = bookInfo["distance"] as? NSNumber {
            self.distance = distance.intValue
        }
        if let price = bookInfo["price"] as? NSNumber {
            self.price = price.intValue
        }
        if let carType = bookInfo["car_type"] as? NSNumber {
            self.carType = carType.intValue
        }
        if let seat = bookInfo["car_seat"] as? NSNumber {
            self.carSeat = seat.intValue
        }
        if let status = bookInfo["status"] as? NSNumber {
            switch status.intValue {
            case 10:
                self.status = .finished
            case 3:
                self.status = .rejected
            case 2:
                self.status = .connected
            case 1:
                self.status = .confirmed
            default:
                self.status = .waiting
            }
            
        }
        self.statusText = bookInfo["status_text"] as? String
        
        if let driverInfo = bookInfo["driver"] as? [String: Any] {
            self.driver = DriverObject(driverInfo: driverInfo)
        }
        
        if let routing = bookInfo["routing_info"] as? [String: Any] {
            self.routing = RoutingObject(routingInfo: routing)
        }
        
        if let bookingFor = bookInfo["booking_for_info"] as? [String: String] {
            self.bookingForFullName = bookingFor["full_name"]
            self.bookingForMobile = bookingFor["phone_number"]
        }
        
        if let stops = bookInfo["extra_stops"] as? [[String: Any]] {
            if stops.count > 0 {
                extraStops = [LocationObject]()
                for stop in stops {
                    if let add = stop["address"] as? String, let lat = stop["location_lat"] as? NSNumber, let lng = stop["location_lng"] as? NSNumber {
                        extraStops!.append(LocationObject(lat: lat.doubleValue, long: lng.doubleValue, name: add))
                    }
                }
            }
        }
    }
}
