//
//  PasswordViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 11.06.2021.
//

import UIKit

class PasswordViewController: UIViewController {
    
    @IBOutlet weak var number0: CircleButton!
    @IBOutlet weak var number1: CircleButton!
    @IBOutlet weak var number2: CircleButton!
    @IBOutlet weak var number3: CircleButton!
    @IBOutlet weak var number4: CircleButton!
    @IBOutlet weak var number5: CircleButton!
    @IBOutlet weak var number6: CircleButton!
    @IBOutlet weak var number7: CircleButton!
    @IBOutlet weak var number8: CircleButton!
    @IBOutlet weak var number9: CircleButton!
    @IBOutlet weak var done: CircleButton!
    @IBOutlet weak var passwordView: SquareView!
    @IBOutlet weak var view1: CircleView!
    @IBOutlet weak var view2: CircleView!
    @IBOutlet weak var view3: CircleView!
    @IBOutlet weak var view4: CircleView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordImage: UIImageView!
    var userPasscode = String()
    var savedCode = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCode = Utility.isPassword
        if !savedCode.isEmpty {
            done.setTitle("Log In", for: .normal)
            passwordLabel.text = "Please entry password"
        }
        else {
            done.setTitle("Sign Up", for: .normal)
            passwordLabel.text = "Create Password"
        }
    }
    
    @IBAction func passwordButtons(_ sender: UIButton) {
        
        userPasscode = userPasscode + sender.tag.toString
        switch userPasscode.count {
            case 1:
                view1.backgroundColor = UIColor.jaguarColor()
            case 2:
                view2.backgroundColor = UIColor.jaguarColor()
            case 3:
                view3.backgroundColor = UIColor.jaguarColor()
            case 4:
                view4.backgroundColor = UIColor.jaguarColor()
                
                if !savedCode.isEmpty {
                    if savedCode == String(userPasscode.prefix(4)) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabbar")
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        self.present(mainTabBarController, animated: true, completion: nil)
                    }
                    else {
                        passwordView.shake()
                    }
                }
                else {
                    Utility.isPassword = userPasscode
                }
            default:
                break
        }
    }
    
    @IBAction func deletePassword(_ sender: Any) {
        
        if !userPasscode.isEmpty {
            userPasscode.removeAll()
            view1.backgroundColor = .white
            view2.backgroundColor = .white
            view3.backgroundColor = .white
            view4.backgroundColor = .white
            
        }
    }
    
    @IBAction func donePassword(_ sender: Any) {
        
        if !savedCode.isEmpty {
            if String(userPasscode.prefix(4)) == savedCode {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "tabbar")
                mainTabBarController.modalPresentationStyle = .fullScreen
                self.present(mainTabBarController, animated: true, completion: nil)
                
            }
            else {
                self.userPasscode = ""
            }
        }
        else {
            self.savedCode = String(userPasscode.prefix(4))
            Utility.isPassword = savedCode
            done.setTitle("Log In", for: .normal)
            passwordLabel.text = "Please entry password"
            userPasscode.removeAll()
            view1.backgroundColor = .white
            view2.backgroundColor = .white
            view3.backgroundColor = .white
            view4.backgroundColor = .white

        }
    }
}
