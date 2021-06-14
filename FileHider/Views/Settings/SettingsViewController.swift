//
//  SettingsViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 8.06.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var isPremium: UISwitch!
    @IBOutlet weak var premiumView: SquareView!
    @IBOutlet weak var passwordView: SquareView!
    @IBOutlet weak var contactView: SquareView!
    @IBOutlet weak var voteView: SquareView!
    @IBOutlet weak var passwordImage: CircleImage!
    @IBOutlet weak var contactImage: CircleImage!
    @IBOutlet weak var voteImage: CircleImage!
    @IBOutlet weak var premiumImage: CircleImage!
    @IBOutlet weak var changePassword: UIButton!
    var premium: Bool = Bool()
    var objects = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        view.backgroundColor = UIColor.jaguarColor()
        premium = Utility.isPremium
        isPremium.setOn(premium, animated: true)
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        premium = Utility.isPremium
        isPremium.setOn(premium, animated: true)

    }

    func setupNavigationController() {
        
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.selectiveYellow()]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.selectiveYellow()]
        self.navigationController?.navigationBar.tintColor = UIColor.selectiveYellow()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.jaguarColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.setStatusBar(backgroundColor: UIColor.jaguarColor())
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    @IBAction func isPremium(_ sender: UISwitch) {
        
        if sender.isOn {
            self.premium = true
            
        }
        else {
            self.premium = false
        }
        Utility.isPremium = premium
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
