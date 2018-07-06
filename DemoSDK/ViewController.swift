//
//  ViewController.swift
//  DemoSDK
//
//  Created by Tuan Anh Vu on 6/26/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import UIKit
import CarentoSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("sdk version: \(CarentoSDK.sdkVersion())")
        CarentoSDK.setUser(fullName: "Vu Tuan Anh", mobileNumber: "0975657785")
        CarentoSDK.setFlightInfo(code: "VNA41G14GWTT55", time: Int(NSDate().timeIntervalSince1970))
        CarentoSDK.shared.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onOpenCarentoUI() {
        CarentoSDK.showServices(airportCode: "HAN")
    }
    
}

extension ViewController: CarentoSDKDelegate {
    func carentoOrderCreated(bookInfo: [String : Any]) {
        print(bookInfo)
    }
}

