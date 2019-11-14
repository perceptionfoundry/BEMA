//
//  ViewController.swift
//  SnapClient
//
//  Created by Kei Fujikawa on 2018/06/15.
//  Copyright © 2018年 Kboy. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SCSDKCreativeKit
import SCSDKBitmojiKit
import LocalAuthentication
import ARVideoKit
import Photos







class CameraViewController: UIViewController, ContactList_Protocol, cryptoTransition, DoubleSegueProtocol, RenderARDelegate, RecordARDelegate {
    
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var cryptoCurrency: UIButton!
    @IBOutlet weak var cryptoView: UIView!
    @IBOutlet weak var cryptoimage: Custom_ImageView!
    @IBOutlet weak var cryptoAmount: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cryptoButton:UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var gallery: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var screenShotView:UIImageView!
    
    
    
    var reciever : User?
    
    
    
    @IBOutlet weak var iconView: UIImageView! {
        didSet {
            iconView.backgroundColor = .white
            iconView.layer.cornerRadius = iconView.frame.width/2
            iconView.clipsToBounds = true
        }
    }
    
    private var bitmojiSelectionView: UIView?
    
    var transitionValue = [String:Any]()
    
    
    //******* ARVIdeo
    var recorder:RecordAR?
    var screenShotImage : UIImage?
    var selectedCrypto = ""
    var selectedAmount = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                cryptoView.isHidden = true
                sendButton.isHidden = true
                screenShotView.isHidden = true
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.initialConfigure()
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        
        
        if recorder?.status == .recording {
            recorder?.stopAndExport()
        }
        recorder?.onlyRenderWhileRecording = true
        recorder?.prepare(ARWorldTrackingConfiguration())
        
        // Switch off the orientation lock for UIViewControllers with AR Scenes
        recorder?.rest()
        
    }

    

    func ShowAlert(Title : String, Message: String){
        let alertVC = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let Dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertVC.addAction(Dismiss)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    
    //***** PROTOCOL **********
    
    func FetchContact(userDetail: User) {
        
        self.reciever = userDetail
        
//        print(self.reciever?.displayName)
        
        self.showBitmojiList()
    }
    
    
    
    func ConfiguredCrypto(value: [String : String]) {
        
        self.transitionValue = value
        
        cryptoimage.image = UIImage(named: value["NAME"]!)
        cryptoAmount.text = value["AMOUNT"]
        
        
        self.selectedCrypto = value["NAME"]!
        self.selectedAmount = value["AMOUNT"]!
        
        
        cryptoCurrency.isHidden = true
        cryptoView.isHidden = false
    }
    
    
    
    func quit() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //*********
    
    
    
    
    
    func initialConfigure(){
        
    
        recorder = RecordAR(ARSceneKit: sceneView)
        
        
        
        /*----👇---- ARVideoKit Configuration ----👇----*/
        
        // Set the recorder's delegate
        recorder?.delegate = self
        
        // Set the renderer's delegate
        recorder?.renderAR = self
        
        // Configure the renderer to perform additional image & video processing 👁
        recorder?.onlyRenderWhileRecording = false
        
        // Configure ARKit content mode. Default is .auto
        recorder?.contentMode = .aspectFill
        
        //record or photo add environment light rendering, Default is false
        recorder?.enableAdjustEnvironmentLighting = true
        
        // Set the UIViewController orientations
        recorder?.inputViewOrientations = [.landscapeLeft, .landscapeRight, .portrait]
        // Configure RecordAR to store media files in local app directory
        recorder?.deleteCacheWhenExported = false
        
        
        
        // fetch your avatar image.
        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
            DispatchQueue.main.async {
//                if let avatarURL = avatarURL {
//                    
//                    //                    self.iconView.load(from: avatarURL)
//                }
            }
        }
        
    }
    
    
    // MARK: About creating node
    
    private func setImageToScene(image: UIImage) {
        if let camera = sceneView.pointOfView {
            let position = SCNVector3(x: 0, y: 0, z: -0.5)
            let convertedPosition = camera.convertPosition(position, to: nil)
            let node = createPhotoNode(image, position: convertedPosition)
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    private func createPhotoNode(_ image: UIImage, position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let scale: CGFloat = 0.3
        let geometry = SCNPlane(width: image.size.width * scale / image.size.height,
                                height: scale)
        geometry.firstMaterial?.diffuse.contents = image
        node.geometry = geometry
        node.position = position
        return node
    }
    
    private func showBitmojiList(){
        
        // Make bitmoji background view
        let viewHeight: CGFloat = 300
        let screen: CGRect = UIScreen.main.bounds
        let backgroundView = UIView(
            frame: CGRect(
                x: 0,
                y: screen.height - viewHeight,
                width: screen.width,
                height: viewHeight
            )
        )
        view.addSubview(backgroundView)
        bitmojiSelectionView = backgroundView
        
        // add child ViewController
        let stickerPickerVC = SCSDKBitmojiStickerPickerViewController()
        stickerPickerVC.delegate = self
        //        addChildViewController(stickerPickerVC)
        //        backgroundView.addSubview(stickerPickerVC.view)
        //        stickerPickerVC.didMove(toParentViewController: self)
        present(stickerPickerVC, animated: true, completion: nil)
        
    }
    
    
    
    
    func exportMessage(success: Bool, status:PHAuthorizationStatus) {
        if success {
            let alert = UIAlertController(title: "Exported", message: "Media exported to camera roll successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Awesome", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if status == .denied || status == .restricted || status == .notDetermined {
            let errorView = UIAlertController(title: "😅", message: "Please allow access to the photo library in order to save this media file.", preferredStyle: .alert)
            let settingsBtn = UIAlertAction(title: "Open Settings", style: .cancel) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
                    }
                }
            }
            errorView.addAction(UIAlertAction(title: "Later", style: UIAlertAction.Style.default, handler: {
                (UIAlertAction)in
            }))
            errorView.addAction(settingsBtn)
            self.present(errorView, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Exporting Failed", message: "There was an error while exporting your media file.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //*********** OUTLET ACTION *************
    @IBAction func ARSnapButtonAction(_ sender: UIButton) {
        
        cryptoView.center.y = cryptoView.center.y - 50
        sendButton.isHidden = false
        
        contactButton.isHidden = true
        flipButton.isHidden = true
        gallery.isHidden = true
        cameraButton.isHidden = true
        cryptoButton.isHidden = true
        
        
        if sender.tag == 0 {
            //Photo
            if recorder?.status == .readyToRecord {
                let image = self.recorder?.photo()
                
                self.screenShotImage = image
                self.screenShotView.image = image
                self.screenShotView.isHidden = false
                
                self.recorder?.export(UIImage: image) { saved, status in
                    if saved {
                        // Inform user photo has exported successfully
                        self.exportMessage(success: saved, status: status)
                    }
                }
            }
        }
        
    }
    
    @IBAction func addActionButton(_ sender: Any) {
        performSegue(withIdentifier: "Contact_Segue", sender: nil)
    }
    
    @IBAction func flipCameraAction(_ sender: Any) {
    }
    
    @IBAction func cryptoButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "Crypto_Segue", sender: nil)
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        sceneView.session.pause()

        performSegue(withIdentifier: "Next", sender: nil)
    }
    
    
    
    
    
    
    
    
    //************** PREPARE SEGUE ****
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "Contact_Segue"{
            let dest = segue.destination as! ContactListVC
            
            dest.contactProtocol = self
        }
            
        else if segue.identifier == "Crypto_Segue"{
            let dest = segue.destination as! CryptoList_AR_VC
            
            dest.cryptoProtocol = self
        }
            
        else if segue.identifier == "Next"{
            let dest = segue.destination as! AR_ConfirmVC
            
            dest.arImage = screenShotImage
            dest.recieverDetail = self.reciever!
            
            dest.cryptoCurrency = self.selectedCrypto
            dest.tranferAmount = self.selectedAmount
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
    @IBAction func bitmojiButtonTapped(_ sender: Any) {
        // Make bitmoji background view
        let viewHeight: CGFloat = 300
        let screen: CGRect = UIScreen.main.bounds
        let backgroundView = UIView(
            frame: CGRect(
                x: 0,
                y: screen.height - viewHeight,
                width: screen.width,
                height: viewHeight
            )
        )
        view.addSubview(backgroundView)
        bitmojiSelectionView = backgroundView
        
        // add child ViewController
        let stickerPickerVC = SCSDKBitmojiStickerPickerViewController()
        stickerPickerVC.delegate = self
        present(stickerPickerVC, animated: true, completion: nil)
        
    }
}










extension CameraViewController: SCSDKBitmojiStickerPickerViewControllerDelegate {
    
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String, image: UIImage?) {
        
        
        UIImage.load()
        
        if let image = UIImage.load(from: bitmojiURL) {
            DispatchQueue.main.async {
                self.setImageToScene(image: image)
                self.dismiss(animated: true, completion: nil)
                
                self.bitmojiSelectionView?.removeFromSuperview()
            }
        }
        
    }
    
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String) {
        
        bitmojiSelectionView?.removeFromSuperview()
        
        
        
        if let image = UIImage.load(from: bitmojiURL) {
            DispatchQueue.main.async {
                self.setImageToScene(image: image)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, searchFieldFocusDidChangeWithFocus hasFocus: Bool) {
        
    }
}




//MARK: - ARVideoKit Delegate Methods
extension CameraViewController {
    func frame(didRender buffer: CVPixelBuffer, with time: CMTime, using rawBuffer: CVPixelBuffer) {
        // Do some image/video processing.
    }
    
    func recorder(didEndRecording path: URL, with noError: Bool) {
        if noError {
            // Do something with the video path.
        }
    }
    
    func recorder(didFailRecording error: Error?, and status: String) {
        // Inform user an error occurred while recording.
    }
    
    func recorder(willEnterBackground status: RecordARStatus) {
        // Use this method to pause or stop video recording. Check [applicationWillResignActive(_:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622950-applicationwillresignactive) for more information.
        if status == .recording {
            recorder?.stopAndExport()
        }
    }
}
