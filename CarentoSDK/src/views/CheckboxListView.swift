//
//  CheckboxListView.swift
//  Carento
//
//  Created by Tuan Anh Vu on 10/20/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import UIKit

@objc protocol CheckboxListViewDelegate {
    func didSelectedBox(_ checkbox: CheckboxItem)
}

class CheckboxListView: UIScrollView {

    weak var checkboxDelegate: CheckboxListViewDelegate?
    
    var checkboxObjects: [CheckboxObject]? {
        didSet {
            self.updateUI()
        }
    }
    var checkboxItems = [CheckboxItem]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    var marginConstraints = [NSLayoutConstraint]()
    
    func updateUI() {
        // remove all subviews
        for sv in subviews {
            sv.removeFromSuperview()
        }
        // reset the container
        checkboxItems.removeAll()
        
        if let objects = checkboxObjects {
            var prevItem: CheckboxItem?
            marginConstraints.removeAll()
            let viewWidth = bounds.size.width
            var maxContentSize: CGFloat = 0.0
            var margin: CGFloat = 10.0
            
            for object in objects.enumerated() {
                // create item
                let checkboxItem = CheckboxItem(type: .custom)
                checkboxItem.translatesAutoresizingMaskIntoConstraints = false
                checkboxItem.currentObject = object.element
                checkboxItem.setTitle(" "+object.element.title, for: .normal)
                checkboxItem.setTitleColor(UIColor.black, for: .normal)
                checkboxItem.titleLabel?.font = object.element.font
                checkboxItem.sizeToFit()
                addSubview(checkboxItem)
                debugPrint(object.element.value)
                checkboxItem.isSelected = object.element.value
                checkboxItem.isUserInteractionEnabled = object.element.canEditting
                checkboxItem.addTarget(self, action: #selector(onCheckbox(_:)), for: .touchUpInside)
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[item]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["item":checkboxItem]))
                let itemHeight = bounds.size.height
                checkboxItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
                let itemWidth = checkboxItem.bounds.size.width + 20
                checkboxItem.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
                maxContentSize += itemWidth
                
                if let prev = prevItem {
                    // if this's not the first item, constraint it the previous one
                    let constraint = checkboxItem.leftAnchor.constraint(equalTo: prev.rightAnchor, constant: margin)
                    constraint.isActive = true
                    marginConstraints.append(constraint)
                    maxContentSize += margin
                }
                else {
                    // constraint the first one to the left wall
                    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[item]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["item":checkboxItem]))
                    
                }
                // constraint the last one to the right wall
                if (object.offset == objects.count-1) {
                    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[item]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["item":checkboxItem]))
                }
                checkboxItems.append(checkboxItem)
                prevItem = checkboxItem
            }
            if (maxContentSize < viewWidth) {
                margin += (viewWidth-maxContentSize)/CGFloat(marginConstraints.count)
                for constraint in marginConstraints {
                    constraint.constant = margin
                }
            }
        }
    }
    
    @objc func onCheckbox(_ checkboxBtn: CheckboxItem) {
        checkboxBtn.isSelected = !checkboxBtn.isSelected
        checkboxDelegate?.didSelectedBox(checkboxBtn)
    }
    
}

enum CheckboxType: Int {
    case parkingFee, nightTrip, VAT, BOT, aroundTrip, internationalStation, domesticStation, none
}

class CheckboxObject {
    var title: String = ""
    var type: CheckboxType = .none
    var value: Bool = false
    var canEditting: Bool = true
    var font: UIFont = SFUIDisplayFont.Regular.font(14)!
    
    init(title: String, type: CheckboxType, defaultValue: Bool=false, canEdit: Bool=true) {
        self.title = title
        self.type = type
        self.value = defaultValue
        self.canEditting = canEdit
    }
    
    init(title: String, type: CheckboxType, defaultFont: UIFont) {
        self.title = title
        self.type = type
        self.font = defaultFont
    }
}

class CheckboxItem: UIButton {
    var currentObject: CheckboxObject?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        setImage(UIImage(named: "inactive_checkbox", in: Bundle(for: CheckboxItem.self), compatibleWith: nil), for: .normal)
        setImage(UIImage(named: "active_checkbox", in: Bundle(for: CheckboxItem.self), compatibleWith: nil), for: .selected)
    }
}
