//
//  BaseViewController.swift
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/29/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import Foundation
import GoogleMaps

class BaseViewController: UIViewController {
    var titleString = ""
    var mapView: GMSMapView?
    var addedMap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        if addedMap {
            addGoogleMap()
        }
    }
    
    func setCustomBackButton() {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "back_icon", in: Bundle(for: BaseViewController.self), compatibleWith: nil), for: .normal)
        btn.addTarget(self, action: #selector(onBack(button:)), for: .touchUpInside)
        btn.sizeToFit()
        let backBarBtn = UIBarButtonItem(customView: btn)
        navigationItem.leftBarButtonItem = backBarBtn
    }
    
    @objc func onBack(button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func setCustomTitle(text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = normalTextColor
        label.textAlignment = .center
        label.sizeToFit()
        label.font = SFUIDisplayFont.Bold.font(16)
        navigationItem.titleView = label
    }
    
    func addGoogleMap() {
        if mapView != nil {
            mapView?.removeFromSuperview()
            mapView = nil
        }
        mapView = Global.shared.map
        mapView?.frame = view.bounds
        if let mapView = mapView {
            view.insertSubview(mapView, at: 0)
        }
    }
}

extension BaseViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = NavAnimation()
        if fromVC is ServiceListViewController {
            animation.transitionMode = .present
        }
        else {
            animation.transitionMode = .pop
        }
        return animation
    }
}
