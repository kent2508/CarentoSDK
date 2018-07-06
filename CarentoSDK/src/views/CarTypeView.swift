//
//  CarTypeView.swift
//  Carento
//
//  Created by Tuan Anh Vu on 4/17/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import UIKit

@objc protocol CarTypeViewDelegate {
    func didSelectedCarType(_ carTypeBtn: CarTypeButton)
}

class CarTypeView: UIScrollView {
    
    weak var carTypeDelegate: CarTypeViewDelegate?
    
    var carTypes: [CarTypeObject]? {
        didSet {
            self.updateUI()
        }
    }
    var carTypeViews = [CarTypeButton]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(carTypes: [CarTypeObject]) {
        self.init(frame: .zero)
        self.carTypes = carTypes
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    var selectedItem: CarTypeButton?
    var marginConstraints = [NSLayoutConstraint]()
    
    func updateUI() {
        print(frame)
        
        // remove all subviews
        for sv in subviews {
            sv.removeFromSuperview()
        }
        // reset the container
        carTypeViews.removeAll()
        
        if let carTypes = carTypes {
            var prevItem: CarTypeButton?
            marginConstraints.removeAll()
//            var viewWidth = bounds.size.width
            var maxContentSize: CGFloat = 0.0
            let margin: CGFloat = 10.0
            for type in carTypes.enumerated() {
                // create item
                let carTypeItem = CarTypeButton(type: .custom)
                carTypeItem.translatesAutoresizingMaskIntoConstraints = false
                carTypeItem.carTypeObject = type.element
                addSubview(carTypeItem)
                
                carTypeItem.isSelected = false
                carTypeItem.addTarget(self, action: #selector(onCarType(_:)), for: .touchUpInside)
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[item]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["item":carTypeItem]))
                print("current height = \(self.frame.size.height)")
                let itemHeight = self.frame.size.height
                carTypeItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
                let image = carTypeItem.carTypeObject?.activeImage
                let imageMultiplier = (image?.size.width)!/(image?.size.height)!
                let itemWidth = itemHeight*imageMultiplier
                carTypeItem.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
                maxContentSize += itemWidth
                
                if let prev = prevItem {
                    // if this's not the first item, constraint it the previous one
                    let constraint = carTypeItem.leftAnchor.constraint(equalTo: prev.rightAnchor, constant: margin)
                    constraint.isActive = true
                    marginConstraints.append(constraint)
                    maxContentSize += margin
                }
                else {
                    // constraint the first one to the left wall
                    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[item]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["item":carTypeItem]))
                    
                }
                // constraint the last one to the right wall
                if (type.offset == carTypes.count-1) {
                    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[item]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["item":carTypeItem]))
                }
                carTypeViews.append(carTypeItem)
                prevItem = carTypeItem
            }
//            if (maxContentSize < viewWidth) {
//                margin += (viewWidth-maxContentSize)/CGFloat(marginConstraints.count)
//                for constraint in marginConstraints {
//                    constraint.constant = margin
//                }
//            }
            if let firstCar = carTypeViews.first {
                onCarType(firstCar)
            }
        }
    }
    
    @objc func onCarType(_ carTypeBtn: CarTypeButton) {
        if (selectedItem == carTypeBtn) {
            return
        }
        selectedItem?.isSelected = false
        selectedItem = carTypeBtn
        selectedItem?.isSelected = true
        carTypeDelegate?.didSelectedCarType(carTypeBtn)
    }
}

class CarTypeObject {
    var id: String?
    var activeImage: UIImage?
    var inactiveImage: UIImage?
    var vipType: Bool = false
    var nightTrip: Bool = false
    var carType: String?
    var carDescription: String?
    var estimatedPrice: Int = 0
    var roundTripPrice: Int = 0
    var vatPrice: Int = 0
    var vatRoundTripPrice: Int = 0
    var seatType: Int = 0
    var roadChargePrice: Int = 0
    
    init(seatType: String, name: String, description: String) {
        
        switch seatType {
        case "4":
            self.activeImage = UIImage(named: "active_4cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.inactiveImage = UIImage(named: "inactive_4cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.seatType = 4
        case "5":
            self.activeImage = UIImage(named: "active_5cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.inactiveImage = UIImage(named: "inactive_5cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.seatType = 5
        case "7":
            self.activeImage = UIImage(named: "active_7cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.inactiveImage = UIImage(named: "inactive_7cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.seatType = 7
        case "16":
            self.activeImage = UIImage(named: "active_16cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.inactiveImage = UIImage(named: "inactive_16cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.seatType = 16
        default: // "30"
            self.activeImage = UIImage(named: "active_30cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.inactiveImage = UIImage(named: "inactive_30cho", in: Bundle(for: CarTypeObject.self), compatibleWith: nil)
            self.seatType = 30
        }
        self.carType = name
        self.carDescription = description
    }
    
    func loadData(element: [String: Any?]) {
        id = element["id"] as? String
        carDescription = element["car_description"] as? String
        if let price = element["price"] as? NSNumber {
            estimatedPrice = price.intValue
        }
        if let vip = element["car_type"] as? String {
            if (vip == "2") {
                vipType = true
            }
        }
        if let price = element["round_trip_price"] as? NSNumber {
            roundTripPrice = price.intValue
        }
        if let price = element["vat_price"] as? NSNumber {
            vatPrice = price.intValue
        }
        if let price = element["vat_round_trip_price"] as? NSNumber {
            vatRoundTripPrice = price.intValue
        }
        if let price = element["road_charge_info"] as? NSNumber {
            roadChargePrice = price.intValue
        }
        if let night = element["night_added_price"] as? NSNumber {
            nightTrip = night.boolValue
        }
    }
    
}

class CarTypeButton: UIButton {
    
    var carTypeObject: CarTypeObject? {
        didSet {
            setImage(carTypeObject!.inactiveImage, for: .normal)
            setImage(carTypeObject!.activeImage, for: .selected)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    func customInit() {
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor(hexString: "#66aef6") : UIColor(hexString: "#ebebeb")
        }
    }
}
