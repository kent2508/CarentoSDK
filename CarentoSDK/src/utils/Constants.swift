//
//  Constants.swift
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/29/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import MapKit

let normalTextColor = UIColor(hexString: "#000000")
let globalBlueColor = UIColor(hexString: "#66aef6")
let selectedColor = UIColor(hexString: "#673B1E")
let deselectedColor = UIColor(hexString: "#e5bfa6")
let unselectedColor = UIColor(hexString: "#5aa5f6")

typealias EmptyCallBack = (_ callbackData: Any?) -> Void
typealias GeoCoderCallBack = (_ address: [String]?) -> Void

public enum SFUIDisplayFont: String {
    case Regular = "SFUIDisplay-Regular"
    case Medium = "SFUIDisplay-Medium"
    case Heavy = "SFUIDisplay-Heavy"
    case Light = "SFUIDisplay-Light"
    case UltraLight = "SFUIDisplay-Ultralight"
    case Bold = "SFUIDisplay-Bold"
    case SemiBold = "SFUIDisplay-Semibold"
    case ExtraBold = "SFUIDisplay-Black"
    case Thin = "SFUIDisplay-Thin"
    
    func font (_ size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
    
    func CTFont (_ size: CGFloat) -> CTFont {
        return CTFontCreateWithName((self.rawValue as CFString?)!, size, nil)
    }
}

extension String {
    struct CellIdentity {
        static var CityServices: String {return "CityServiceCell"}
        static var LongTripServices: String {return "LongTripServiceCell"}
    }
}

extension String {
    struct SegueName {
        static var toPriceRoute: String {return "toPriceRouteView"}
        static var toLongTripList: String {return "toLongTripList"}
        static var longTripToPriceRoute: String {return "longTripToPriceRoute"}
        static var historyToPriceRoute: String {return "historyToPriceRoute"}
        static var toSearchLocation: String {return "toSearchLocationView"}
    }
}

extension Notification.Name {
    static let pickUpLocationChanged = Notification.Name("kPickUpLocationChanged")
    static let googleMapIsMoving = Notification.Name("kGoogleMapIsMoving")
}

struct LocationObject {
    var addressName: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    init(lat: Double, long: Double, name: String) {
        addressName = name
        latitude = lat
        longitude = long
    }
    
    func getLocObject() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
