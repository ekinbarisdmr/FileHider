//
//  NoteViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit
import GoogleMobileAds


class NoteViewController: UIViewController, GADFullScreenContentDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var rewardAd: GADRewardedAd!
    var notes = [Notes]()
    var isPremium: Bool = Bool()
    var rights: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
        notes = StoreManager.shared.getNote()
        isPremium = Utility.isPremium
        rights = Utility.noteRight
        loadRewardAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notes = StoreManager.shared.getNote()
        isPremium = Utility.isPremium
        rights = Utility.noteRight
        loadRewardAd()
        tableView.reloadData()
    }
    
    func setupNavigationController() {
        
        self.navigationItem.title = "Notes"
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
        
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController {
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
        tableView.backgroundColor = UIColor.jaguarColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
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

extension NoteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        
        cell.selectionStyle = .none
        
        if let note = notes[indexPath.row].note {
            cell.noteLabel.text = note
        }
        
        if let title = notes[indexPath.row].title {
            cell.titleLabel.text = title
        }
        
        if isPremium == true {
            cell.highlightIndicator.isHidden = true
            cell.lockImage.isHidden = true
        }
        else {
            if indexPath.row < rights {
                cell.highlightIndicator.isHidden = true
                cell.lockImage.isHidden = true
            }
            else {
                cell.highlightIndicator.isHidden = false
                cell.lockImage.isHidden = false
            }
        }
        return cell
    }
}

extension NoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            notes.remove(at: indexPath.row)
            StoreManager.shared.saveNote(data: notes)
            tableView.reloadData()
        }
    }
    
    func showDetails(indexPath: IndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "NoteDetailsViewController") as? NoteDetailsViewController {
            vc.row = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isPremium == true {
            self.showDetails(indexPath: indexPath)
            
        }
        else {
            if indexPath.row < rights {
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
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let vc = mainStoryboard.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController {
            vc.premium = isPremium
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func earnReward() {
        showAd()
    }
    
    func showAd() {
        if (rewardAd != nil) { rewardAd.present( fromRootViewController: self, userDidEarnRewardHandler: { [self] in
            rights += 1
            Utility.noteRight = rights
            print("Earn reward")
        })
        } else {
            print("Ad wasn't ready")
        }
    }
}




