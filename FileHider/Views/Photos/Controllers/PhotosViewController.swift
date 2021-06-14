//
//  PhotosViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit
import AVKit
import GoogleMobileAds

class PhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GADFullScreenContentDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            addButton.layer.cornerRadius = addButton.frame.size.height / 2
        }
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var playerViewController = AVPlayerViewController()
    var imagePicker = UIImagePickerController()
    var photos = [Photos]()
    var videos = [Videos]()
    var player = AVPlayer()
    var isPremium = Bool()
    var rewardAd: GADRewardedAd!
    var right = Int()
    
    enum Mode {
        case view
        case select
    }
    
    
    var viewMode: Mode = .view {
        didSet {
            switch viewMode {
                case .view:
                    for (key, value) in dictionarySelectedIndecPath {
                        if value {
                            collectionView.deselectItem(at: key, animated: true)
                        }
                    }
                    dictionarySelectedIndecPath.removeAll()
                    
                    selectBarButton.title = "Select"
                    navigationItem.leftBarButtonItem = nil
                    collectionView.allowsMultipleSelection = false
                    
                case.select:
                    selectBarButton.title = "Cancel"
                    navigationItem.leftBarButtonItem = deleteBarButton
                    collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    lazy var selectBarButton: UIBarButtonItem = {
        
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return barButtonItem
        
    }()
    
    lazy var deleteBarButton: UIBarButtonItem = {
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
        return barButtonItem
        
    }()
    
    var dictionarySelectedIndecPath: [IndexPath: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.jaguarColor()
        collectionView.backgroundColor = UIColor.jaguarColor()
        imagePicker.delegate = self
        setups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        photos = StoreManager.shared.getGallery()
        videos = StoreManager.shared.getVideos()
        isPremium = Utility.isPremium
        right = Utility.photoRight
        collectionView.reloadData()
        setupCollectionView()
        loadRewardAd()
    }
    
    func setups() {
        setupNavigationController()
        setupBarButtonItems()
        setupCollectionView()
        loadRewardAd()
        right = Utility.photoRight
        isPremium = Utility.isPremium
    }
    
    func setupNavigationController() {
        
        self.navigationItem.title = "Photos"
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
        
    }
    
    func setupCollectionView() {
        
        collectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = UIColor.jaguarColor()
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
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = selectBarButton
    }
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
        viewMode = viewMode == .view ? .select : .view
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        var deleteNeededIndexPaths: [IndexPath] = []
        for (key, value) in dictionarySelectedIndecPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
            
            if segmentedControl.selectedSegmentIndex == 0 {
                photos.remove(at: i.item)
            }
            else if segmentedControl.selectedSegmentIndex == 1 {
                videos.remove(at: i.item)
            }
        }
        
        collectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndecPath.removeAll()
        StoreManager.shared.savePhotos(data: photos)
        StoreManager.shared.saveVideos(data: videos)
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.navigationItem.title = "Photos"
            collectionView.reloadData()
        }
        else {
            self.navigationItem.title = "Videos"
            collectionView.reloadData()
        }
    }
    
    @IBAction func addButton(_ sender:Any) {
        
        let alertController = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in self.openCamera()
            
        }))
        
        alertController.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: {_ in
            self.openGallery()
        }))
        
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func openCamera() {
        
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        else {
            
            let alert  = UIAlertController(title: "Error", message: "Camera is not found.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func openGallery() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)

        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
            imagePicker.videoQuality = .type640x480
            imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}

            let newImage = Photos(selectedImage: image)
            photos.insert(newImage, at: 0)
            StoreManager.shared.savePhotos(data: photos)
            collectionView.reloadData()
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            picker.dismiss(animated: true, completion: nil)
            
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            let thumbnailImage = getThumbnailImage(forUrl: videoURL)
            
            if let videoImage = thumbnailImage {
                let newVideo = Videos(videoImage: videoImage, videoUrl: videoURL)
                videos.insert(newVideo, at: 0)
                StoreManager.shared.saveVideos(data: videos)
                collectionView.reloadData()
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
            
        }
        catch let error {
            print(error)
        }
        return nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width - 30) / 3 , height: (self.collectionView.frame.size.width - 30) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}


extension PhotosViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return photos.count
        }
        else {
            return videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotosCollectionViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.imageView.image = photos[indexPath.row].selectedImage
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            cell.imageView.image = videos[indexPath.row].videoImage
        }
        
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

extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch viewMode {
            case .view:
                collectionView.deselectItem(at: indexPath, animated: true)
                
                if isPremium == true {
                    showImage(indexPath: indexPath)
                }
                else {
                    if indexPath.row < right {
                        showImage(indexPath: indexPath)
                    }
                    else {
                        let alert  = UIAlertController(title: "Error!", message: "You must buy the premium", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Buy the premium", style: .default, handler: {_ in self.getPremium()
                            
                        } ))
                        alert.addAction(UIAlertAction(title: "I may watch the add", style: .default, handler: {_ in
                            self.earnReward()
                        }))
                        alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            case .select:
                dictionarySelectedIndecPath[indexPath] = true
        }
    }
    
    func getPremium() {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController {
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func earnReward() {
        showAd()
    }
    
    func showAd() {
        if (rewardAd != nil) { rewardAd.present( fromRootViewController: self, userDidEarnRewardHandler: { [self] in
            right += 1
            Utility.photoRight = right
            print("ödül kazandı")
            
        })
        }
        else {
            print("Ad wasn't ready")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if viewMode == .select {
            dictionarySelectedIndecPath[indexPath] = false
        }
    }
    
    func showImage(indexPath: IndexPath) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let vc = mainStoryboard.instantiateViewController(identifier: "PhotoDetailsViewController") as? PhotoDetailsViewController {
                
                vc.image = photos[indexPath.row].selectedImage
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            
            if let videoUrl = videos[indexPath.row].videoUrl {
                player = AVPlayer(url: videoUrl)
                playerViewController.player = player
                self.present(playerViewController, animated: true, completion: {
                    self.playerViewController.player?.play()
                })
            }
        }
    }
}
