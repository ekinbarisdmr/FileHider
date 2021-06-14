//
//  PeopleDetailsViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit

class PeopleDetailsViewController: UIViewController {
    
    @IBOutlet weak var backButton:      UIButton!
    @IBOutlet weak var imageColorView:  UIView!
    @IBOutlet weak var nameColorView:   UIView!
    @IBOutlet weak var numberColorView: UIView!
    @IBOutlet weak var mailColorView:   UIView!
    @IBOutlet weak var avatarImage:     UIImageView!
    @IBOutlet weak var nameLabel:       UILabel!
    @IBOutlet weak var numberLabel:     UILabel!
    @IBOutlet weak var mailLabel:       UILabel!
    
    var people: People = People()

    override func viewDidLoad() {
        super.viewDidLoad()
        get()
        avatarImage.layer.borderWidth = 2
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.layer.borderColor = UIColor.jaguarColor().cgColor
        imageColorView.layer.borderColor = UIColor.jaguarColor().cgColor
        nameColorView.roundCorners(corners: [.topRight, .bottomRight], radius: 35)
        numberColorView.roundCorners(corners: [.bottomLeft, .topLeft], radius: 35)
        mailColorView.roundCorners(corners: [.topRight, .bottomRight], radius: 35)
        imageColorView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 70)

    }
    
    @IBAction func backButton(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func get() {
        nameLabel.text = people.name
        mailLabel.text = people.mail
        avatarImage.image = people.img
        numberLabel.text = people.number
    }
}
