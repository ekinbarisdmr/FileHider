//
//  Alerts.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 14.06.2021.
//

import Foundation
import UIKit


class Alerts {

    class func show(inViewController viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okey", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }

}
