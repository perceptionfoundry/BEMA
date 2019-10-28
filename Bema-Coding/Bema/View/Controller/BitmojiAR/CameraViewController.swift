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



protocol DoubleSegueProtocol {
    func quit()
}


class CameraViewController: UIViewController, ContactList_Protocol, cryptoTransition, DoubleSegueProtocol {
 
    
    
    

    
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var cryptoCurrency: UIButton!
    @IBOutlet weak var cryptoView: UIView!
    @IBOutlet weak var cryptoimage: Custom_ImageView!
    @IBOutlet weak var cryptoAmount: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var gallery: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!

    

    
    
    
    
    @IBOutlet weak var iconView: UIImageView! {
        didSet {
            iconView.backgroundColor = .white
            iconView.layer.cornerRadius = iconView.frame.width/2
            iconView.clipsToBounds = true
        }
    }
    
    private var bitmojiSelectionView: UIView?
    
    var transitionValue = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cryptoView.isHidden = true
        sendButton.isHidden = true

        // fetch your avatar image.
        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
            DispatchQueue.main.async {
                if let avatarURL = avatarURL {
                    
//                    self.iconView.load(from: avatarURL)
                }
            }
        }
    }
    
    
    //******** PERSONALIZE FUNCTION ******
    
    
        private func localAuth(){
                 let context = LAContext()
                            
                            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
                                
                                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To have an confirm transaction via FaceID/TouchID ") { (state, err) in
                                    
                                    if state{
                                        // SEGUE
                                      DispatchQueue.main.async {
                                        
                                        
                                        self.performSegue(withIdentifier: "Next", sender: nil)
                                        }
                                    }
                                    else{
    //                                    self.ShowAlert(Title: "Incorrect Credentials", Message: "Please try again")
                                    }
                                }
                            }
                           
                            else{
                                self.ShowAlert(Title: "FaceID / TouchID not Configured", Message: "Please go to setting and configure it")
                            }
        }

    
    
    
    
    func ShowAlert(Title : String, Message: String){
          let alertVC = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
          let Dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
          alertVC.addAction(Dismiss)
          
          self.present(alertVC, animated: true, completion: nil)
      }
    
    
    
    //***** PROTOCOL **********
      
      func FetchContact(userDetail: [String : Any]) {
          
        
        self.showBitmojiList()
      }
    
    
    
    func ConfiguredCrypto(value: [String : String]) {
          
          self.transitionValue = value
          
          cryptoimage.image = UIImage(named: value["NAME"]!)
          cryptoAmount.text = value["AMOUNT"]
          
          cryptoCurrency.isHidden = true
          cryptoView.isHidden = false
      }
    
    
    func quit() {
        self.navigationController?.popViewController(animated: true)
     }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
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
    
    
    //*********** OUTLET ACTION *************
    @IBAction func ARSnapButtonAction(_ sender: Any) {
        
        cryptoView.center.y = cryptoView.center.y - 50
        sendButton.isHidden = false
        
        contactButton.isHidden = true
        flipButton.isHidden = true
        gallery.isHidden = true
        cameraButton.isHidden = true
        
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
        
       
        
        localAuth()
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
                                
                                dest.quitProtocol = self
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func snapButtonTapped(_ sender: Any) {
//        let snapshot = sceneView.snapshot()
//        let photo = SCSDKSnapPhoto(image: snapshot)
//        let snap = SCSDKPhotoSnapContent(snapPhoto: photo)
//
//        // Sticker
//        let sticker = SCSDKSnapSticker(stickerImage: #imageLiteral(resourceName: "snap-ghost"))
//        snap.sticker = sticker
//
//        // Caption
//        snap.caption = "Snap on Snapchat!"
//
//        // URL
//        snap.attachmentUrl = "https://www.snapchat.com"
//
//        let api = SCSDKSnapAPI(content: snap)
//        api.startSnapping { error in
//
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                // success
//            }
//        }
//    }
    
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
//        addChildViewController(stickerPickerVC)
//        backgroundView.addSubview(stickerPickerVC.view)
//        stickerPickerVC.didMove(toParentViewController: self)
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



