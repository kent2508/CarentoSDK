//
//  SDKNavigationController.swift
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/29/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import Foundation

class SDKNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addCarentoLogo(target: UIViewController) {
        if let logo = UIImage(named: "small_carento_icon", in: Bundle(for: type(of: target)), compatibleWith: nil) {
            let iconView = UIImageView(image: logo)
            target.navigationItem.titleView = iconView
        }
    }
}
