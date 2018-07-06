//
//  CRTLocationInputTextField.swift
//  Carento
//
//  Created by Tuan Anh Vu on 10/18/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import UIKit

class CRTLocationInputTextField: UITextField {

    var beginningEditCallBack: EmptyCallBack?
    var shouldEndEdittingCallBack: EmptyCallBack?
    var didOnExitCallBack: EmptyCallBack?
    @IBInspectable var hideKeyboard: Bool = false
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? UIColor(hexString: "#f8f8f8") : UIColor(hexString: "#EAEAEA")
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
        leftViewMode = .always
        let leftMarginView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: bounds.size.height))
        leftView = leftMarginView
        delegate = self
        addTarget(self, action: #selector(onExit(sender:)), for: .editingDidEndOnExit)
        let customInputView = UIControl(frame: UIScreen.main.bounds)
        customInputView.backgroundColor = UIColor.black
        customInputView.alpha = 0.3
        customInputView.addTarget(self, action: #selector(onInputView), for: .touchUpInside)
        inputAccessoryView = customInputView
        
        layer.cornerRadius = 3.0
    }
    
    @objc func onInputView() {
        resignFirstResponder()
    }
    
    @objc func onExit(sender: UITextField) {
        didOnExitCallBack?(nil)
        resignFirstResponder()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension CRTLocationInputTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        beginningEditCallBack?(nil)
        return hideKeyboard
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        shouldEndEdittingCallBack?(nil)
        return true
    }
}
