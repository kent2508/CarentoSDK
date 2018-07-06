//
//  SearchLocationViewController.swift
//  Carento
//
//  Created by Tuan Anh Vu on 10/21/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SearchLocationViewController: BaseViewController {

    @IBOutlet weak var btnChoose: UIButton!
    var searchResultController: SearchResultsController?
    var resultsArray = [String]() // this variable hold all search result
    var gmsFetcher: GMSAutocompleteFetcher?
    var pickUpLocation: CLLocationCoordinate2D?
    var dropDownLocation: CLLocationCoordinate2D?
    @IBOutlet weak var constraintBottomMarginOfButtonBox: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setCustomBackButton()
        if let title = Global.shared.currentMarkerLoc?.addressName {
            setCustomTitle(text: title)
        }
        else {
            setCustomTitle(text: "Carento")
        }
        addedMap = true
        
//        constraintBottomMarginOfButtonBox.constant = Global.sharedInstance.readyToPickLocation ? 16 : -200.0
        
        // setup the search controller
        if searchResultController == nil {
            searchResultController = SearchResultsController(style: .plain)
            searchResultController?.delegate = self
        }
        // setup the fetcher
        if gmsFetcher == nil {
            gmsFetcher = GMSAutocompleteFetcher()
            gmsFetcher?.delegate = self
            let filter = GMSAutocompleteFilter()
            filter.country = "VN"
            gmsFetcher?.autocompleteFilter = filter
        }
        
        btnChoose.layer.masksToBounds = false
        btnChoose.layer.cornerRadius = 5.0
        btnChoose.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        btnChoose.layer.shadowOpacity = 0.5
        btnChoose.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btnChoose.layer.shadowRadius = 2.0
        btnChoose.setTitle("Chọn", for: .normal)
        
        Global.shared.map?.settings.myLocationButton = true
        
        if let loc = dropDownLocation {
            Global.shared.focusTo(location: loc)
        }
//        self.onSearch(button: nil);
        
        let locIconView: UIImageView = UIImageView(image: UIImage(named: "new-loc-icon", in: Bundle(for: SearchLocationViewController.self), compatibleWith: nil))
        self.view.addSubview(locIconView)
        locIconView.center = self.view.center
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(pickUpLocationChanged), name: Notification.Name.pickUpLocationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mapIsMoving), name: Notification.Name.googleMapIsMoving, object: nil)
        
        Global.shared.enablePickLocation = true
        Global.shared.changeMapDelegate(enable: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Global.shared.enablePickLocation = false
        Global.shared.changeMapDelegate(enable: false)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.pickUpLocationChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.googleMapIsMoving, object: nil)
    }
    
    @objc func pickUpLocationChanged() {
        if let title = Global.shared.currentMarkerLoc?.addressName {
            setCustomTitle(text: title)
        }
    }
    
    @objc func mapIsMoving() {
//        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        activity.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        self.navigationItem.titleView = activity
//        activity.startAnimating()
        
        setCustomTitle(text: "Đang tìm kiếm")
    }
    
    override func onBack(button: UIButton) {
        super.onBack(button: button)
    }
    
    @IBAction func onSearch(button: UIButton?) {
        let searchResultsController = UISearchController(searchResultsController: searchResultController)
        searchResultsController.searchBar.setValue("Huỷ", forKey: "cancelButtonText")
        searchResultsController.searchBar.delegate = self
        present(searchResultsController, animated: true) {
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let weakSelf = self else {return}
                searchResultsController.view.frame = weakSelf.view.frame
            })
        }
    }
    
    @IBAction func onChoose(button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SearchLocationViewController: UISearchBarDelegate {
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("tracker X - searchBar textDidChange: I'm here")
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
}

extension SearchLocationViewController: LocateOnTheMap {
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        print("tracker X - locateWithLongitude: I'm here")
        DispatchQueue.main.async { () -> Void in
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            Global.shared.map?.animate(to: camera)
            Global.shared.createMarker(loc: LocationObject(lat: lat, long: lon, name: title))
        }
        
    }
}

extension SearchLocationViewController: GMSAutocompleteFetcherDelegate {
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
        print("tracker X - didFailAutocompleteWithError: I'm here")
        print(error.localizedDescription)
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        print("tracker X - didAutocomplete: I'm here")
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction? {
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        searchResultController?.reloadDataWithArray(self.resultsArray)
    }
}
