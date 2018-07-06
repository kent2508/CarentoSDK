//
//  HTTPClient.swift
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/29/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import Foundation
import Alamofire

//let baseURLString: String = "http://enapi.carento.net/"
let baseURLString: String = "http://enapi.staging.carento.net/"

let kAPIDevKey: String = "X-Carento-Enterprise-Api-Key"
//let kServiceAPIKey = "LJL12K3JLKJ1238DAF8D"
let kAuthorizationKey: String = "Authorization"
//let kAuthorizationToken: String = "Bearer CMVCf63y3EuRHLjmM4goj7X9b2ec1Pgw"
let kLanguageKey: String = "X-Carento-Language"

typealias RequestResult = (_ responseData: Any?, _ error: MyError?, _ extendData: Any?) -> Void

enum ApiName: String {
    case GetConfig = "" // GET
    case GetCityList = "site/list-city" // GET
    
    case GetServiceInCity = "location-service/list" // GET
    
    case GetPriceRoute = "location-service/price-route" // POST
    case UserCreatBook = "location-service/create-book" // POST
    
    func URL() -> URL {
        return NSURL(string: baseURLString + rawValue)! as URL
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    
    let generalHeaders = [
        kAPIDevKey: Global.shared.serviceApiKey ?? "",
        kAuthorizationKey: "Bearer \(Global.shared.enterpriseToken ?? "")",
        kLanguageKey: Global.shared.currentLanguageCode
    ]
    lazy var manager: SessionManager? = {
        let man = Alamofire.SessionManager.default
        man.session.configuration.timeoutIntervalForRequest = 10.0
        return man
    }()
    
    func handleResponse(response: DataResponse<Any>, result: RequestResult?) {
        debugPrint(response)
        switch response.result {
        case .success:
            if let jsonData = response.result.value as? [String: Any] {
                guard let statusCode = jsonData["statusCode"] as? NSNumber else {
                    result?(nil, MyError(localizedDescription: ErrorType.NoData.description(), code: ErrorType.NoData.code()), nil)
                    return
                }
                if (statusCode == 200) {
                    debugPrint(jsonData["data"] ?? "")
                    result?(jsonData["data"], nil, jsonData["message"])
                }
                else {
                    if let message = jsonData["message"] as? String, let errCode = jsonData["errorCode"] as? NSNumber {
                        result?(nil, MyError(localizedDescription: message, code: errCode.intValue), nil)
                    }
                    else {
                        result?(nil, MyError(localizedDescription: ErrorType.NoData.description(), code: ErrorType.NoData.code()), nil)
                    }
                }
            }
            else {
                result?(nil, MyError(localizedDescription: ErrorType.NoData.description(), code: ErrorType.NoData.code()), nil)
            }
        case .failure(let error):
            result?(nil, MyError(localizedDescription: error.localizedDescription, code: 404), nil)
        }
    }
}

// MARK: - Get data
extension HTTPClient {
    func getConfig(completion: RequestResult?) {
        let url = ApiName.GetConfig.URL()
        manager?.request(url, parameters: nil, headers: generalHeaders).responseJSON { (response) in
            self.handleResponse(response: response, result: completion)
        }
    }
    
    func getCities(completion: RequestResult?) {
        let url = ApiName.GetCityList.URL()
        manager?.request(url, parameters: nil, headers: generalHeaders).responseJSON { (response) in
            self.handleResponse(response: response, result: completion)
        }
    }
    
    func getServices(airportCode: String?, completion: RequestResult?) {
        let url = ApiName.GetServiceInCity.URL()
        var params = [String: Any]()
        if let airportCode = airportCode {
            params["airport_code"] = airportCode
        }
        print(params)
        manager?.request(url, parameters: params, headers: generalHeaders).responseJSON { (response) in
            self.handleResponse(response: response, result: completion)
        }
    }
}

// MARK: - Booking
extension HTTPClient {
    
    func estimatePriceRoute(estimateInfo: [String: Any], completion: RequestResult?) {
        let url = ApiName.GetPriceRoute.URL()
        manager?.request(url, method: .post, parameters: estimateInfo, encoding: JSONEncoding.default, headers: generalHeaders).responseJSON { (response) in
            self.handleResponse(response: response, result: completion)
        }
    }
    
    func createBook(bookInfo: [String: Any], completion: RequestResult?) {
        let url = ApiName.UserCreatBook.URL()
        manager?.request(url, method: .post, parameters: bookInfo, encoding: JSONEncoding.default, headers: generalHeaders).responseJSON { (response) in
            self.handleResponse(response: response, result: completion)
        }
    }
}
