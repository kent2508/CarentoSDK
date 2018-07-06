//
//  CarentoSDK.swift
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/29/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

let API_KEY = "AIzaSyDE0-_MyeRRmETYZI-9JGatVAv6CC3fyks"

public protocol CarentoSDKDelegate: class {
    func carentoOrderCreated(bookInfo: [String: Any])
}

public class CarentoSDK {
    
    public init() {
        
    }
    
    public static let shared = CarentoSDK()
    public weak var delegate: CarentoSDKDelegate?
    
    public static func configuration(serviceApiKey: String, enterpriseToken: String) {
        // init GMS service before using
        GMSServices.provideAPIKey(API_KEY)
        GMSPlacesClient.provideAPIKey(API_KEY)
        // load custom fonts
        FontLoader.loadFont("SFUIDisplay-Regular")
        FontLoader.loadFont("SFUIDisplay-Medium")
        FontLoader.loadFont("SFUIDisplay-Heavy")
        FontLoader.loadFont("SFUIDisplay-Light")
        FontLoader.loadFont("SFUIDisplay-Ultralight")
        FontLoader.loadFont("SFUIDisplay-Bold")
        FontLoader.loadFont("SFUIDisplay-Semibold")
        FontLoader.loadFont("SFUIDisplay-Black")
        FontLoader.loadFont("SFUIDisplay-Thin")
        
        Global.shared.serviceApiKey = serviceApiKey
        Global.shared.enterpriseToken = enterpriseToken
        
        HTTPClient.shared.getConfig { (responseData, error, extended) in
            if let error = error {
                debugPrint(error.localizedDescription)
                _ = CRNotifications.showNotification(type: CRNotifications.error, title: "", message: error.localizedDescription, dismissDelay: 3)
                return
            }
            guard let responseData = responseData as? [String: Any] else {
                _ = CRNotifications.showNotification(type: CRNotifications.error, title: "", message: "Lỗi không xác định", dismissDelay: 3)
                return
            }
            if let hotline = responseData["hotline"] as? String {
                Global.shared.hotline = hotline
            }
            print("hotline = \(Global.shared.hotline)")
        }
    }
    
    public static func setUser(fullName: String, mobileNumber: String) {
        Global.shared.userFullName = fullName
        Global.shared.userMobile = mobileNumber
    }
    
    public static func setFlightInfo(code: String, time: Int) {
        Global.shared.flightCode = code
        Global.shared.flightTime = time
    }
    
    public static func sdkVersion() -> String {
        return "1.0"
    }
    
    public static func showServices(airportCode: String) {
        
        let storyboard = UIStoryboard(name: "CarentoSDK", bundle: Bundle(for: self))
        let sdkNavigation = storyboard.instantiateViewController(withIdentifier: "initial_navigation") as! SDKNavigationController
        if let serviceListVC = sdkNavigation.viewControllers.first as? ServiceListViewController {
            serviceListVC.airportCode = airportCode
        }
        Utils.topViewController()?.present(sdkNavigation, animated: true, completion: {
            // do something
        })
    }
}
