//
//  Utils.swift
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/29/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import Foundation

enum LanguageType: String {
    case VN = "vi-VN"
    case ENus = "en-US"
    
    func object() -> Language {
        switch self {
        case .ENus:
            return Language(title_: "English-US", image_: "us_flag", code_: "en-US", localize_: "en")
        default:
            return Language(title_: "Vietnam", image_: "vn_flag", code_: "vi-VN", localize_: "vi")
        }
    }
}

struct Language {
    var title: String = "Vietnam"
    var image: String = "vn_flag"
    var code: String = "vi-VN"
    var localizeCode: String = "vi"
    
    init(title_: String, image_: String, code_: String, localize_: String) {
        title = title_
        image = image_
        code = code_
        localizeCode = localize_
    }
}

class Utils {
    // get top controller
    static func topViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        else {
            return nil
        }
    }
    
    static func dialTo(phoneNumber: String?) {
        guard let number = phoneNumber?.replacingOccurrences(of: " ", with: "") else {return}
        let tel = "tel://\(number)"
        if let url = URL(string: tel) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    class func stringFrom(int: Int) -> String {
        return Utils.stringFrom(number: NSNumber(value: int))
    }
    
    class func stringFrom(number: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = ","
        numberFormatter.groupingSeparator = "."
        if let formattedString = numberFormatter.string(from: number) {
            return formattedString
        }
        return "0.0"
    }
    
    // convert from meters to kilometers and export as string
    static func convertedToDistanceString(from distance: Int) -> String {
        let km = Int(distance/1000)
        let tail = distance % 1000
        return "\(km).\(tail)km"
    }
    
}

// MARK: - DATE extension
extension Date {
    func prettyDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    func normalDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    static func normalDateFormatFrom(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    static func dayAndMonthStringFrom(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    static func timeStringFrom(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    static func stringFromTimeInterval(interval: TimeInterval) -> String {
        if (Date().timeIntervalSince1970 > interval) {
            return "Quá ngày"
        }
        let ti = Int(interval-Date().timeIntervalSince1970)
        let days = ti / (24*60*60)
        let hours = (ti - days*24*60*60) / 3600
        let minutes = (ti - days*24*60*60 - hours*60*60) / 60
        
        
        if (days > 0) {
            return String(format: "Còn %0.0d ngày %0.2d giờ", days,hours)
        }
        else {
            if hours > 0 {
                return String(format: "%0.2d giờ %0.2d phút",hours,minutes)
            }
            else {
                return String(format: "%0.2d phút",minutes)
            }
        }
    }
}

// MARK: - UIColor extension
extension UIColor {
    convenience init(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    convenience init(hexString: String, alpha: Float) {
        var hex = hexString
        
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
            //            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1))
        }
        
        if (hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil) {
            
            if hex.count == 3 {
                let redHex = String(hex[..<hex.index(hex.startIndex, offsetBy: 1)])
                //                let redHex   = hex.substring(to: hex.index(hex.startIndex, offsetBy: 1))
                let greenHex = String(hex[hex.index(hex.startIndex, offsetBy: 1)..<hex.index(hex.startIndex, offsetBy: 2)])
                //                let greenHex = hex.substring(with: hex.index(hex.startIndex, offsetBy: 1)..<hex.index(hex.startIndex, offsetBy: 2))
                let blueHex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
                //                let blueHex  = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let redHex = String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])
            //            let redHex = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            let greenHex = String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])
            //            let greenHex = hex.substring(with: hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4))
            let blueHex = String(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)])
            //            let blueHex = hex.substring(with: hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6))
            
            var redInt:   CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt:  CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        }
        else {
            self.init()
        }
    }
    
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: Float) {
        let hexString = NSString(format: "%2X", hex)
        self.init(hexString: hexString as String , alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    class func randomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
