//
//  PeopleViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit
import GoogleMobileAds

class PeopleViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var people = [People]()
    var isPremium: Bool = Bool()
    var rewardAd: GADRewardedAd!
    var right: Int = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        setupTableView()
        right = Utility.personRight
        loadRewardAd()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        people = StoreManager.shared.getPeople()
        isPremium = Utility.isPremium
        right = Utility.personRight
        loadRewardAd()
        print(isPremium)
        tableView.reloadData()
    }
    
    func setupNavigationbar() {
        
        self.navigationItem.title = "People"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.selectiveYellow()]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.selectiveYellow()]
        self.navigationController?.navigationBar.tintColor = UIColor.selectiveYellow()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.jaguarColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.setStatusBar(backgroundColor: UIColor.jaguarColor())
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
                
    }
    
    @objc func didTapAdd() {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "AddPeopleViewController") as? AddPeopleViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: "PeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "peopleCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.jaguarColor()
        
    }
    
    func loadRewardAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request, completionHandler: { [self] ad, error in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            rewardAd = ad
            print("Rewarded ad loaded.")
            rewardAd.fullScreenContentDelegate = self
            
        })
    }
    
    func ad( _ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}

extension PeopleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleTableViewCell
        
        cell.selectionStyle = .none
        
        if let image = people[indexPath.row].img {
            cell.avatarImage.image = image
        }
        
        cell.avatarName.text = people[indexPath.row].name ?? ""
        
        if isPremium == true {
            cell.lockImage.isHidden = true
            cell.highlightIndicator.isHidden = true
        }
        else {
            
            if indexPath.row < right {
                
                cell.lockImage.isHidden = true
                cell.highlightIndicator.isHidden = true
            }
            else {
                
                cell.lockImage.isHidden = false
                cell.highlightIndicator.isHidden = false
            }
        }
        return cell
    }
}

extension PeopleViewController: UITableViewDelegate {
    
    func showDetails(indexPath: IndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(identifier: "PeopleDetailsViewController") as? PeopleDetailsViewController {
            vc.people = people[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isPremium == true {
            self.showDetails(indexPath: indexPath)
        }
        else {
            if indexPath.row < right {
                self.showDetails(indexPath: indexPath)
            }
            else {
                let alert  = UIAlertController(title: "Error!", message: "You must buy the premium", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Buy the premium", style: .default, handler: {_ in
                    self.getPremium()
                    
                } ))
                
                alert.addAction(UIAlertAction(title: "I may watch the add.", style: .default, handler: {_ in
                    self.earnReward()
                }))
                
                alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getPremium() {
        
        if let vc = AppDelegate.mainStoryboard.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func earnReward() {
        showAd()
    }
    
    func showAd() {
        if (rewardAd != nil) { rewardAd.present( fromRootViewController: self, userDidEarnRewardHandler: { [self] in
            right += 1
            Utility.personRight = right
            print("Earn reward")
            
        })
        } else {
            print("Ad wasn't ready")
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            people.remove(at: indexPath.row)
            StoreManager.shared.savePeople(data: people)
            tableView.reloadData()
        }
    }
}

