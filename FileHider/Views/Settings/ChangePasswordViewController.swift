//
//  ChangePasswordViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 12.06.2021.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var newPassword2Textfield: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    var oldPassword: String = String()
    var newPassword: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextfield.delegate = self
        newPasswordTextfield.delegate = self
        newPassword2Textfield.delegate = self
        
        title = "Change Password"
        oldPassword = Utility.isPassword
        setupTextFields()
        changeButton.layer.cornerRadius = 16
    }
    
    
    func setupTextFields() {
        
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        oldPasswordTextfield.inputAccessoryView = toolbar
        newPasswordTextfield.inputAccessoryView = toolbar
        newPassword2Textfield.inputAccessoryView = toolbar
        
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
    
    @IBAction func changeButton(_ sender: Any) {
        
        if let oldPassword: String = oldPasswordTextfield.text, let newPassword1: String = newPasswordTextfield.text, let newPassword2: String = newPassword2Textfield.text {
            if oldPassword == oldPassword {
                if !newPassword1.isEmpty && !newPassword2.isEmpty {
                    if newPassword1 == newPassword2 {
                        Utility.isPassword = newPassword1
                    }
                    else {
                        Alerts.show(inViewController: self, title: "Error!", message: "The passwords you entered are not the same.")
                    }
                }
                else {
                    Alerts.show(inViewController: self, title: "Error!", message: "Please enter all passwords.")
                    
                }
            }
            else {
                Alerts.show(inViewController: self, title: "Error!", message: "Old password is incorrect.")
            }
        }
        Alerts.show(inViewController: self, title: "Success!", message: "Password changed.")
        
    }
}
