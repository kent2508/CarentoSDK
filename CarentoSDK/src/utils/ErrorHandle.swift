//
//  ErrorHandle.swift
//  Carento
//
//  Created by Tuan Anh Vu on 4/20/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import Foundation

protocol MyErrorProtocol: Error {
    var localizedDescription: String { get }
    var code: Int { get }
}

struct MyError: MyErrorProtocol {
    
    var localizedDescription: String
    var code: Int
    
    init(localizedDescription: String, code: Int) {
        self.localizedDescription = localizedDescription
        self.code = code
    }
}


enum ErrorType: String {
    case UnsignedIn = "UnsignedIn"
    case InvalidToken = "InvalidToken"
    case NoData = "NoData"
    case Unknow = "Unknow"
    case CanNotConnectToServer = "CanNotConnectToServer"
    
    func description() -> String {
        switch self {
        case .UnsignedIn:
            return "You must sign in first"
        case .InvalidToken:
            return "Token invalid"
        case .NoData:
            return "No data"
        case .CanNotConnectToServer:
            return "Can not connect to server"
        default:
            return "Unknow error"
        }
    }
    
    func code() -> Int {
        switch self {
        case .UnsignedIn:
            return 100000002
        case .InvalidToken:
            return 100000001
        case .NoData:
            return 100000000
        case .CanNotConnectToServer:
            return 404
        default:
            return 999999999
        }
    }
}
