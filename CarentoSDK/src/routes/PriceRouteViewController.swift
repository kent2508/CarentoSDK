//
//  PriceRouteViewController.swift
//  Carento
//
//  Created by Tuan Anh Vu on 10/18/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD

class PriceRouteViewController: BaseViewController {

    @IBOutlet weak var inputBox: UIView!
    @IBOutlet weak var carBox: UIView!
    @IBOutlet weak var taxBox: UIView!
    @IBOutlet weak var buttonBox: UIView!
    
    var tfEdittingLocation: CRTLocationInputTextField?
    
    @IBOutlet weak var tfTakeUpLocation1: CRTLocationInputTextField!
    @IBOutlet weak var tfTakeUpLocation2: CRTLocationInputTextField!
    @IBOutlet weak var tfTakeUpLocation3: CRTLocationInputTextField!
    @IBOutlet weak var tfDropDownLocation: CRTLocationInputTextField!
    @IBOutlet weak var tfTakeUpTime: CRTLocationInputTextField!
    @IBOutlet weak var tfTakeUpTime2: CRTLocationInputTextField!
    
    @IBOutlet weak var lbCarType: UILabel!
    @IBOutlet weak var lbCarTypeDescription: UILabel!
    
    @IBOutlet weak var lbEstimatedPrice: UILabel!
    @IBOutlet weak var lbEstimatedDistance: UILabel!
    
    @IBOutlet weak var btnAddLoc: UIButton!
    @IBOutlet weak var btnRemoveLoc1: UIButton!
    @IBOutlet weak var btnRemoveLoc2: UIButton!
    @IBOutlet weak var btnCheckmark: UIButton!
    @IBOutlet weak var btnCheckmark2: UIButton!
    
    @IBOutlet weak var imvTime2: UIImageView!
    
    @IBOutlet weak var constraintHeightOfInputBox: NSLayoutConstraint!
    @IBOutlet weak var constraintTopMarginOfTakeUpLoc2: NSLayoutConstraint!
    @IBOutlet weak var constraintTopMarginOfTakeUpLoc3: NSLayoutConstraint!
    @IBOutlet weak var constraintTopMarginOfDropDownLoc: NSLayoutConstraint!
    @IBOutlet weak var constraintTopMarginFromCarBoxToInputBox: NSLayoutConstraint!
    @IBOutlet weak var constraintTopMarginOfTakeUpTime2: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomMarginOfButtonBox: NSLayoutConstraint!
    
    @IBOutlet weak var carTypeView: CarTypeView!
    @IBOutlet weak var checkboxView: CheckboxListView!
    
    @IBOutlet weak var bookButtonLabel: UILabel!
    @IBOutlet weak var lbPickCar: UILabel!
    
    var selectedCarType: CarTypeObject?
    
    var readyToChooseCar = false {
        didSet {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.constraintTopMarginFromCarBoxToInputBox.constant = weakSelf.readyToChooseCar ? -5.0 : -(weakSelf.carBox.frame.size.height + weakSelf.taxBox.frame.size.height + 10.0)
                weakSelf.carBox.alpha = weakSelf.readyToChooseCar ? 1.0 : 0.0
                weakSelf.taxBox.alpha = weakSelf.readyToChooseCar ? 1.0 : 0.0
                weakSelf.view.layoutIfNeeded()
            }
        }
    }
    
    var currentHeightOfInputBox: CGFloat = 154.0
    var numberOfTakeUpLocation = 1 {
        didSet {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let weakSelf = self else {return}
                // change the top margin of dropdown textfield
                weakSelf.constraintTopMarginOfDropDownLoc.constant = 8.0 + CGFloat(weakSelf.numberOfTakeUpLocation-1)*(weakSelf.tfTakeUpLocation1.bounds.size.height + 8.0)
                // change the height of input box
                weakSelf.constraintHeightOfInputBox.constant = weakSelf.currentHeightOfInputBox + CGFloat(weakSelf.numberOfTakeUpLocation-1)*(weakSelf.tfTakeUpLocation1.bounds.size.height + 8.0)
                weakSelf.view.layoutIfNeeded()
            }
        }
    }
    
    var currentService: ServiceObject?
    var startTime: TimeInterval = 0.0
    var backTime: TimeInterval = 0.0
    var extraLocation1: LocationObject?
    var extraLocation2: LocationObject?
    
    var priceOptions: [CheckboxObject] = [CheckboxObject(title: "VAT", type: .VAT)]
    var cloneBookObject: BookObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addedMap = true
        setupUI()
        
        if let currentService = currentService {
            // load the fixed location, config state of textfields, ...
            loadDefaultLocation(service: currentService)
            // show/hide the text field of time backtrip
            if (currentService.directType == 3) {
                self.enableRoundTrip(true)
                priceOptions.append(CheckboxObject(title: "Khứ hồi", type: .aroundTrip, defaultValue: true, canEdit: true))
            }
            
            // set the default price
            lbEstimatedPrice.text = Utils.stringFrom(int: currentService.estimatedPrice) + "đ"
            // load the available car types if it exist
            if let seatTypes = currentService.providedCarSeat {
                var types = [CarTypeObject]()
                for seatType in seatTypes {
                    types.append(CarTypeObject(seatType: seatType, name: seatType + " chỗ", description: "Các loại xe"))
                }
                carTypeView?.carTypes = types
            }
        }
        
        // this code is for clone feature, cloning data from a trip in past and fill to input fields
        if let clone = cloneBookObject {
            tfTakeUpLocation1.text = clone.originAddressComponents
            tfDropDownLocation.text = clone.destinationAddressComponents
        }
    }
    
    func setupUI() {
//        if let nav = navigationController as? SDKNavigationController {
//            nav.addCarentoLogo(target: self)
//        }
        setCustomBackButton()
        setCustomTitle(text: titleString)
        constraintBottomMarginOfButtonBox.constant = -200.0
        
        inputBox.layer.masksToBounds = false
        inputBox.layer.cornerRadius = 5.0
        inputBox.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        inputBox.layer.shadowOpacity = 0.5
        inputBox.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        inputBox.layer.shadowRadius = 3.0
        
        carBox.layer.masksToBounds = false
        carBox.layer.cornerRadius = 5.0
        carBox.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        carBox.layer.shadowOpacity = 0.5
        carBox.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        carBox.layer.shadowRadius = 1.0
        
        taxBox.layer.masksToBounds = false
        taxBox.layer.cornerRadius = 5.0
        taxBox.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        taxBox.layer.shadowOpacity = 0.5
        taxBox.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        taxBox.layer.shadowRadius = 1.0
        
        buttonBox.layer.masksToBounds = false
        buttonBox.layer.cornerRadius = 5.0
        buttonBox.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        buttonBox.layer.shadowOpacity = 0.5
        buttonBox.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        buttonBox.layer.shadowRadius = 3.0
        
        bookButtonLabel.text = "Đặt xe"
        lbPickCar.text = "Chọn xe"
        
        tfTakeUpLocation1?.beginningEditCallBack = { [weak self] (callbackData) in
            print("chon diem don 1")
            //            self.readyToChooseCar = true
            self?.tfEdittingLocation = self?.tfTakeUpLocation1
            self?.performSegue(withIdentifier: String.SegueName.toSearchLocation, sender: nil)
        }
        // tfEdittingLocation = tfTakeUpLocation1 // set it as default editting textfield
        tfTakeUpLocation2?.beginningEditCallBack = { [weak self] (callbackData) in
            print("chon diem don 2")
            //            self.readyToChooseCar = true
            self?.tfEdittingLocation = self?.tfTakeUpLocation2
            self?.performSegue(withIdentifier: String.SegueName.toSearchLocation, sender: nil)
        }
        tfTakeUpLocation3?.beginningEditCallBack = { [weak self] (callbackData) in
            print("chon diem don 3")
            //            self.readyToChooseCar = true
            self?.tfEdittingLocation = self?.tfTakeUpLocation3
            self?.performSegue(withIdentifier: String.SegueName.toSearchLocation, sender: nil)
        }
        tfDropDownLocation?.beginningEditCallBack = { [weak self] (callbackData) in
            print("chon diem den")
            //            self.readyToChooseCar = false
            self?.tfEdittingLocation = self?.tfDropDownLocation
            self?.performSegue(withIdentifier: String.SegueName.toSearchLocation, sender: nil)
        }
        tfTakeUpTime?.placeholder = "Giờ đón"
        tfTakeUpTime?.beginningEditCallBack = { [weak self] (callbackData) in
            print("chon gio don")
            let min = Date().addingTimeInterval(60 * 60)
            let picker = DateTimePicker.show(selected: min, minimumDate: min, maximumDate: nil)
            picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
            picker.darkColor = UIColor.darkGray
            picker.doneButtonTitle = "OK"
            picker.todayButtonTitle = "Hôm nay"
            picker.cancelButtonTitle = "Huỷ"
            picker.is12HourFormat = false
            picker.dateFormat = "hh:mm aa dd/MM/YYYY"
            picker.completionHandler = { date in
                self?.tfTakeUpTime.text = date.prettyDateFormat()
                self?.startTime = date.timeIntervalSince1970
                self?.btnCheckmark.isSelected = true
                self?.tryToEstimateThePrice()
            }
        }
        tfTakeUpTime2?.placeholder = "Giờ về"
        tfTakeUpTime2?.beginningEditCallBack = { [weak self] (callbackData) in
            print("chon gio ve")
            let min = Date().addingTimeInterval(60 * 60)
            let picker = DateTimePicker.show(selected: min, minimumDate: min, maximumDate: nil)
            picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
            picker.darkColor = UIColor.darkGray
            picker.doneButtonTitle = "OK"
            picker.todayButtonTitle = "Hôm nay"
            picker.cancelButtonTitle = "Huỷ"
            picker.is12HourFormat = false
            picker.dateFormat = "hh:mm aa dd/MM/YYYY"
            picker.completionHandler = { date in
                self?.tfTakeUpTime2.text = date.prettyDateFormat()
                self?.backTime = date.timeIntervalSince1970
                self?.btnCheckmark2.isSelected = true
                self?.tryToEstimateThePrice()
            }
        }
        
        lbEstimatedPrice.font = SFUIDisplayFont.SemiBold.font(15)
        carTypeView.carTypeDelegate = self
        checkboxView.checkboxDelegate = self
        
    }
    
    func enableRoundTrip(_ enabled: Bool) {
        self.currentHeightOfInputBox = enabled ? (self.currentHeightOfInputBox + self.tfTakeUpLocation1.bounds.size.height + 8.0) : (self.currentHeightOfInputBox - self.tfTakeUpLocation1.bounds.size.height - 8.0)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.constraintTopMarginOfTakeUpTime2.constant = enabled ? 56.0 : 0.0
            self.imvTime2.alpha = enabled ? 1.0 : 0.0
            self.tfTakeUpTime2.alpha = enabled ? 1.0 : 0.0
            self.btnCheckmark2.alpha = enabled ? 1.0 : 0.0
            self.constraintHeightOfInputBox.constant = self.currentHeightOfInputBox
            self.view.layoutIfNeeded()
        }
        hasRoundTrip = enabled
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let _ = currentService else {
            return
        }
        if let currentLoc = Global.shared.currentMarkerLoc {
            tfEdittingLocation?.text = currentLoc.addressName
            if (tfEdittingLocation == tfTakeUpLocation1) {
                pickupCoordinate = CLLocationCoordinate2D(latitude: currentLoc.latitude, longitude: currentLoc.longitude)
//                Global.sharedInstance.currentMarkerLoc = nil
            }
            else if (tfEdittingLocation == tfDropDownLocation) {
                dropdownCoordinate = CLLocationCoordinate2D(latitude: currentLoc.latitude, longitude: currentLoc.longitude)
//                Global.sharedInstance.currentMarkerLoc = nil
            }
            else if (tfEdittingLocation == tfTakeUpLocation2) { // add extra stops
                extraLocation1 = currentLoc
//                Global.sharedInstance.currentMarkerLoc = nil
            }
            else if (tfEdittingLocation == tfTakeUpLocation3) {
                extraLocation2 = currentLoc
//                Global.sharedInstance.currentMarkerLoc = nil
            }
            
        }
        
        debugPrint(pickupCoordinate ?? "chua setup pickup location")
        debugPrint(dropdownCoordinate ?? "chua setup dropdown location")
        
        extraPickupCoordinates.removeAll()
        switch numberOfTakeUpLocation {
        case 2:
            if (tfTakeUpLocation2.tag == 1) {
                if let extraLocation1 = extraLocation1 {
                    extraPickupCoordinates = [extraLocation1]
                }
            }
            else if (tfTakeUpLocation3.tag == 1) {
                if let extraLocation2 = extraLocation2 {
                    extraPickupCoordinates = [extraLocation2]
                }
            }
        case 3:
            if let extraLocation1 = extraLocation1, let extraLocation2 = extraLocation2 {
                if (tfTakeUpLocation2.tag == 1) {
                    extraPickupCoordinates = [extraLocation1, extraLocation2]
                }
                else {
                    extraPickupCoordinates = [extraLocation2, extraLocation1]
                }
            }
            else {
                if let extraLocation1 = extraLocation1 {
                    extraPickupCoordinates = [extraLocation1]
                }
                else if let extraLocation2 = extraLocation2 {
                    extraPickupCoordinates = [extraLocation2]
                }
            }
        default:
            break
        }
        // calculate the price route here
        debugPrint(extraPickupCoordinates)
        tryToEstimateThePrice()
        tfEdittingLocation = nil
    }
    
    func tryToEstimateThePrice() {
        guard let currentService = currentService else {
            return
        }
        if (currentService.directType == 3) {
            if ((pickupCoordinate != nil) && (dropdownCoordinate != nil) && btnCheckmark.isSelected && btnCheckmark2.isSelected) {
                estimateThePrice()
            }
        }
        else {
            if (pickupCoordinate != nil) && (dropdownCoordinate != nil) && btnCheckmark.isSelected {
                estimateThePrice()
            }
        }
    }
    
    var pickupCoordinate: CLLocationCoordinate2D?
    var extraPickupCoordinates = [LocationObject]()
    var dropdownCoordinate: CLLocationCoordinate2D?
    
    func loadDefaultLocation(service: ServiceObject) {
        switch service.directType {
        case 1, 3:
            tfTakeUpLocation1.isEnabled = true
            tfTakeUpLocation1.placeholder = "Điểm xuất phát"
            pickupCoordinate = nil
            
            tfDropDownLocation.isEnabled = service.fixLocation ? false : true
            tfDropDownLocation.text = service.locationName
            dropdownCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(service.locationLatitude), longitude: CLLocationDegrees(service.locationLongitude))
        case 2:
            tfTakeUpLocation1.isEnabled = service.fixLocation ? false : true
            tfTakeUpLocation1.text = service.locationName
            pickupCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(service.locationLatitude), longitude: CLLocationDegrees(service.locationLongitude))
            
            tfDropDownLocation.isEnabled = true
            tfDropDownLocation.placeholder = "Điểm đến"
            dropdownCoordinate = nil
        default: // 3
            break
        }
    }

    @IBAction func onAdd(button: UIButton) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.numberOfTakeUpLocation += 1
            if (self.numberOfTakeUpLocation == 2) {
                self.tfTakeUpLocation2.alpha = 1.0
                self.btnRemoveLoc1.alpha = 1.0
                self.constraintTopMarginOfTakeUpLoc2.constant = 8.0 + self.tfTakeUpLocation1.bounds.size.height + 8.0
                self.tfTakeUpLocation2.tag = 1
                self.tfTakeUpLocation2.placeholder = "Điểm xuất phát 2"
                
                self.tfTakeUpLocation3.alpha = 0.0
                self.btnRemoveLoc2.alpha = 0.0
                self.constraintTopMarginOfTakeUpLoc3.constant = 8.0
                self.tfTakeUpLocation3.tag = 0
            }
            if (self.numberOfTakeUpLocation == 3) {
                if (self.constraintTopMarginOfTakeUpLoc2.constant == 8.0) {
                    self.tfTakeUpLocation2.alpha = 1.0
                    self.btnRemoveLoc1.alpha = 1.0
                    self.constraintTopMarginOfTakeUpLoc2.constant = 8.0 + 2*(self.tfTakeUpLocation1.bounds.size.height + 8.0)
                    self.tfTakeUpLocation2.tag = 2
                    self.tfTakeUpLocation2.placeholder = "Điểm xuất phát 3"
                }
                else {
                    self.tfTakeUpLocation3.alpha = 1.0
                    self.btnRemoveLoc2.alpha = 1.0
                    self.constraintTopMarginOfTakeUpLoc3.constant = 8.0 + 2*(self.tfTakeUpLocation1.bounds.size.height + 8.0)
                    self.tfTakeUpLocation3.tag = 2
                    self.tfTakeUpLocation3.placeholder = "Điểm xuất phát 3"
                }
                
                self.btnAddLoc.isHidden = true
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func onRemove(button: UIButton) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) { [weak self] () in
            guard let weakSelf = self else {return}
            weakSelf.numberOfTakeUpLocation -= 1
            if (weakSelf.numberOfTakeUpLocation == 1) {
                weakSelf.tfTakeUpLocation2.text = ""
                weakSelf.tfTakeUpLocation2.alpha = 0.0
                weakSelf.btnRemoveLoc1.alpha = 0.0
                weakSelf.constraintTopMarginOfTakeUpLoc2.constant = 8.0
                weakSelf.tfTakeUpLocation2.tag = 0
                weakSelf.extraLocation1 = nil
                
                weakSelf.tfTakeUpLocation3.text = ""
                weakSelf.tfTakeUpLocation3.alpha = 0.0
                weakSelf.btnRemoveLoc2.alpha = 0.0
                weakSelf.constraintTopMarginOfTakeUpLoc3.constant = 8.0
                weakSelf.tfTakeUpLocation3.tag = 0
                weakSelf.extraLocation2 = nil
            }
            if (weakSelf.numberOfTakeUpLocation == 2) {
                if (button == weakSelf.btnRemoveLoc1) {
                    weakSelf.tfTakeUpLocation2.text = ""
                    weakSelf.tfTakeUpLocation2.alpha = 0.0
                    weakSelf.btnRemoveLoc1.alpha = 0.0
                    weakSelf.constraintTopMarginOfTakeUpLoc2.constant = 8.0
                    weakSelf.tfTakeUpLocation2.tag = 0
                    weakSelf.extraLocation1 = nil
                    
                    weakSelf.constraintTopMarginOfTakeUpLoc3.constant = 8.0 + weakSelf.tfTakeUpLocation1.bounds.size.height + 8.0
                    weakSelf.tfTakeUpLocation3.tag = 1
                    weakSelf.tfTakeUpLocation3.placeholder = "Điểm xuất phát 2"
                }
                if (button == weakSelf.btnRemoveLoc2) {
                    weakSelf.tfTakeUpLocation3.text = ""
                    weakSelf.tfTakeUpLocation3.alpha = 0.0
                    weakSelf.btnRemoveLoc2.alpha = 0.0
                    weakSelf.constraintTopMarginOfTakeUpLoc3.constant = 8.0
                    weakSelf.tfTakeUpLocation3.tag = 0
                    weakSelf.extraLocation2 = nil
                    
                    weakSelf.constraintTopMarginOfTakeUpLoc2.constant = 8.0 + weakSelf.tfTakeUpLocation1.bounds.size.height + 8.0
                    weakSelf.tfTakeUpLocation2.tag = 1
                    weakSelf.tfTakeUpLocation2.placeholder = "Điểm xuất phát 2"
                }
            }
            
            if (weakSelf.btnAddLoc.isHidden) {
                weakSelf.btnAddLoc.isHidden = false
            }
            weakSelf.view.layoutIfNeeded()
            
        }
        tryToEstimateThePrice()
    }
    
    var bookedObject: BookObject?
    @IBAction func onBook(button: UIButton) {
        print("Book now")
        let bookData = fillData()
        SVProgressHUD.show(withStatus: "Đang tạo yêu cầu")
        HTTPClient.shared.createBook(bookInfo: bookData) { [weak self] (responseData, error, extended) in
            SVProgressHUD.dismiss()
            guard let weakSelf = self else {return}
            if let error = error {
                debugPrint(error.localizedDescription)
                _ = CRNotifications.showNotification(type: CRNotifications.error, title: "", message: error.localizedDescription, dismissDelay: 3)
                return
            }
            guard let responseData = responseData as? [String: Any] else {
                _ = CRNotifications.showNotification(type: CRNotifications.error, title: "", message: "Lỗi không xác định", dismissDelay: 3)
                return
            }
            if let delegate = CarentoSDK.shared.delegate {
                delegate.carentoOrderCreated(bookInfo: responseData)
            }
            weakSelf.navigationController?.dismiss(animated: true, completion: {
                // do something
            })
        }
    }
    
    @IBAction func onCallHotline(button: UIButton) {
        Utils.dialTo(phoneNumber: Global.shared.hotline)
    }
    
    var priceCode: String?
    var priceElementId: String?
    var currentDistance = 0
    
    func estimateThePrice() {
        guard let currentService = currentService, let code = currentService.code else {
            return
        }
        guard let pickupLoc = pickupCoordinate else {
            return
        }
        var estimateData = [
            "service_code": code,
            "time_wait": 0,
            "pickup_location": "\(pickupLoc.latitude),\(pickupLoc.longitude)",
            "go_trip_time" : startTime,
            "back_trip_time" : backTime
        ] as [String: Any]
        if (extraPickupCoordinates.count > 0)  {
            var extraStops = [Dictionary<String, Any>]()
            for loc in extraPickupCoordinates {
                extraStops.append([
                    "address" : loc.addressName,
                    "location_lat" : loc.latitude,
                    "location_lng" : loc.longitude
                    ])
            }
            estimateData["extra_stops"] = extraStops
        }
        print(estimateData)
        SVProgressHUD.show(withStatus: "Đang xác định giá")
        HTTPClient.shared.estimatePriceRoute(estimateInfo: estimateData) { [weak self] (responseData, error, extended) in
            SVProgressHUD.dismiss()
            guard let weakSelf = self else {return}
            if let error = error {
                debugPrint(error.localizedDescription)
                _ = CRNotifications.showNotification(type: CRNotifications.error, title: "", message: error.localizedDescription, dismissDelay: 3)
                return
            }
            print(responseData ?? "")
            guard let responseData = responseData as? [String: Any] else {
                _ = CRNotifications.showNotification(type: CRNotifications.error, title: "", message: "Lỗi không xác định", dismissDelay: 3)
                return
            }
            self?.priceCode = responseData["code"] as? String
            if let distance = responseData["distance"] as? NSNumber {
                weakSelf.currentDistance = weakSelf.hasRoundTrip ? 2*distance.intValue : distance.intValue
                weakSelf.lbEstimatedDistance?.text = Utils.convertedToDistanceString(from: weakSelf.currentDistance)
            }
            if let elements = responseData["price_elements"] as? [[String: Any]] {
                var types = [CarTypeObject]()
                for element in elements {
                    if let carTypeName = element["car_seat"] as? String, let carTypeDescription = element["car_description"] as? String {
                        let carTypeObj = CarTypeObject(seatType: carTypeName, name: carTypeName + " chỗ", description: carTypeDescription)
                        carTypeObj.loadData(element: element)
                        types.append(carTypeObj)
                    }
                }
                if (types.count > 0) {
                    weakSelf.carTypeView?.carTypes = types
                }
                
            }
            if let roadCharge = responseData["road_charge_info"] as? NSNumber {
                if roadCharge.intValue > 0 {
                    weakSelf.priceOptions.append(CheckboxObject(title: "Phí cầu đường", type: .BOT))
                }
            }
            var newOptions: [CheckboxObject]?
            if let nightAdded = responseData["night_added_price"] as? NSNumber {
                if nightAdded.boolValue {
                    newOptions = weakSelf.priceOptions
                    newOptions?.append(CheckboxObject(title: "Đón đêm", type: .nightTrip, defaultValue: true, canEdit: false))
                }
            }
            if let new = newOptions {
                weakSelf.checkboxView.checkboxObjects = new
            }
            else {
                weakSelf.checkboxView.checkboxObjects = weakSelf.priceOptions
            }
            // show the car, tax info
            weakSelf.readyToChooseCar = true
            weakSelf.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf.constraintBottomMarginOfButtonBox.constant = 16.0
                weakSelf.view.layoutIfNeeded()
            })
        }
    }
    
    var hasVAT: Bool = false
    var hasRoundTrip: Bool = false
    var hasNightTrip: Bool = false
    var hasParkingFee: Bool = false
    var hasBOTFee: Bool = false
    
    func updatePrice(carInfo: CarTypeObject) {
        var goPrice = carInfo.estimatedPrice
        goPrice += hasVAT ? carInfo.vatPrice : 0
        goPrice += hasRoundTrip ? carInfo.roundTripPrice : 0
        goPrice += (hasRoundTrip && hasVAT) ? carInfo.vatRoundTripPrice : 0
        goPrice += hasBOTFee ? carInfo.roadChargePrice : 0
        goPrice += (hasRoundTrip && hasBOTFee) ? carInfo.vatRoundTripPrice : 0
        lbEstimatedPrice.text = Utils.stringFrom(int: goPrice)+"đ"
        priceElementId = carInfo.id
        
        // also, update the distance
        lbEstimatedDistance?.text = Utils.convertedToDistanceString(from: currentDistance)
    }
    
    func fillData() -> [String: Any] {
        var toDict = [String: Any]()
        toDict["full_name"] = Global.shared.userFullName
        toDict["msisdn"] = Global.shared.userMobile
        toDict["pickup_address_components"] = tfTakeUpLocation1.text
        toDict["is_round_trip"] = hasRoundTrip ? 1 : 0
        toDict["is_vat"] = hasVAT ? 1 : 0
        toDict["service_code"] = currentService?.code ?? "0"
        toDict["price_code"] = priceCode ?? ""
        toDict["price_element_id"] = priceElementId ?? ""
        toDict["note"] = ""
        toDict["booking_for_fullname"] = Global.shared.userFullName
        toDict["booking_for_msisdn"] = Global.shared.userMobile
        toDict["flight_code"] = Global.shared.flightCode
        toDict["flight_time"] = NSNumber(value: Int(Global.shared.flightTime))
        
        print("book info: \(toDict)")
        return toDict
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case String.SegueName.toSearchLocation:
            let targetController = segue.destination as! SearchLocationViewController
            if tfEdittingLocation == tfDropDownLocation {
                targetController.dropDownLocation = dropdownCoordinate
            }
            else {
                targetController.pickUpLocation = pickupCoordinate
            }
        default:
            break
        }
    }
    

}

extension PriceRouteViewController: CarTypeViewDelegate {
    func didSelectedCarType(_ carTypeBtn: CarTypeButton) {
        selectedCarType = carTypeBtn.carTypeObject
        if let selectedCarType = selectedCarType {
            lbCarType.text = String(format: "Bạn đang chọn loại xe có %1$@ chỗ", "\(selectedCarType.seatType)")
            lbCarTypeDescription.text = selectedCarType.carDescription
            updatePrice(carInfo: selectedCarType)
        }
    }
}

extension PriceRouteViewController: CheckboxListViewDelegate {
    func didSelectedBox(_ checkbox: CheckboxItem) {
        switch checkbox.currentObject!.type {
        case .VAT:
            hasVAT = checkbox.isSelected
        case .aroundTrip:
            enableRoundTrip(checkbox.isSelected)
            currentDistance = hasRoundTrip ? currentDistance*2 : currentDistance/2
        case .BOT:
            hasBOTFee = checkbox.isSelected
        case .nightTrip:
            hasNightTrip = checkbox.isSelected
        case .parkingFee:
            hasParkingFee = checkbox.isSelected
        default: // none
            break
        }
        if let carTypeObj = selectedCarType {
            updatePrice(carInfo: carTypeObj)
        }
    }
}
