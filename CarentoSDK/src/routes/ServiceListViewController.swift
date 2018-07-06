//
//  ServiceListViewController.swift
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/28/18.
//  Copyright © 2018 Carento. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage

class ServiceListViewController: BaseViewController {
    
    var airportCode: String?
    var services = [ServiceObject]()
    var firstLoad = true
    
    @IBOutlet weak var serviceTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedMap = true
        setupUI()
        print("aiport code = \(airportCode ?? "")")
    }
    
    func setupUI() {
        if let nav = navigationController as? SDKNavigationController {
            nav.addCarentoLogo(target: self)
        }
        // add the close btn to left
        let closeBtn = UIBarButtonItem(image: UIImage(named: "close_btn", in: Bundle(for: ServiceListViewController.self), compatibleWith: nil), style: .done, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeBtn
        
        // get service data
        reloadServices()
    }
    
    @IBAction func onHotLineButton() {
        Utils.dialTo(phoneNumber: Global.shared.hotline)
    }
    
    @objc func close() {
        dismiss(animated: true) {
            // do something
        }
    }
    
    func reloadServices() {
        let activityIndicator = FWActivityIndicatorView.show(in: view)
        HTTPClient.shared.getServices(airportCode: airportCode) { [weak self] (responseData, error, extended) in
            activityIndicator?.hide()
            guard let weakSelf = self else {return}
            if let error = error {
                debugPrint(error.localizedDescription)
                _ = CRNotifications.showNotification(type: CRNotifications.error, title: "", message: error.localizedDescription, dismissDelay: 3)
                return
            }
            print(responseData ?? "")
            guard let responseData = responseData as? [[String: Any]] else {
                _ = CRNotifications.showNotification(type: CRNotifications.error, title: "", message: "no data", dismissDelay: 3)
                return
            }
            
            weakSelf.services.removeAll()
            for object in responseData {
                weakSelf.services.append(ServiceObject(info: object))
            }
            weakSelf.serviceTable.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == String.SegueName.toPriceRoute) {
            let controller = segue.destination as! PriceRouteViewController
            if let indexPath = serviceTable.indexPathForSelectedRow {
                let rowData = services[indexPath.row]
                if let name = rowData.name {
                    controller.titleString = name
                    Global.shared.currentTripName = name
                }
                controller.currentService = rowData
            }
        }
    }
}

extension ServiceListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if services.count > 0 {
            let tableHeight = tableView.frame.size.height
            var marginTop = tableHeight-CGFloat(services.count)*60.0-10.0
            if marginTop < 0 {
                marginTop = 0.0
            }
            serviceTable.contentInset = UIEdgeInsetsMake(marginTop, 0, 0, 0)
            return services.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.CellIdentity.CityServices, for: indexPath) as! CityServiceCell
        let rowData = services[indexPath.row]
        
        if let url = rowData.iconURL {
            cell.imvImage.sd_setImage(with: url, completed: { (image, err, isGetFromCache, originalImageUrl) in
                if let _ = err {
                    cell.widthOfIcon.constant = 0.0
                }
                else {
                    cell.widthOfIcon.constant = 30.0
                }
            })
        }
        else {
            cell.widthOfIcon.constant = 0.0
        }
        cell.lbText.text = rowData.name
        cell.lbSub.text = rowData.description
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select row at index \(indexPath.row)")
        let rowData = services[indexPath.row]
        if rowData.grouped {
            performSegue(withIdentifier: String.SegueName.toLongTripList, sender: nil)
        }
        else {
            performSegue(withIdentifier: String.SegueName.toPriceRoute, sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.0
        cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.0, UIScreen.main.bounds.size.height, 0.0)
        
        UIView.animate(withDuration: self.firstLoad ? TimeInterval(0.5+CGFloat(indexPath.row+1)*0.2) : 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }) { (animated) in
            self.firstLoad = false
        }
    }
    
}
