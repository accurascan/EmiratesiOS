//
//  ViewController.swift
//  AccuraSDK
//
//  Created by Chang Alex on 1/24/20.
//  Copyright © 2020 Elite Development LLC. All rights reserved.
//

import UIKit
import AVFoundation
//import SDWebImage
class ViewController: UIViewController {
    
    @IBOutlet weak var _viewLayer: UIView!
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _imgPicView: UIImageView!
    @IBOutlet weak var _imgFlipView: UIImageView!
    @IBOutlet weak var _lblTitle: UILabel!
    @IBOutlet weak var _constant_height: NSLayoutConstraint!
    @IBOutlet weak var _constant_width: NSLayoutConstraint!
    
    @IBOutlet weak var lblOCRMsg: UILabel!
    @IBOutlet weak var lblTitleCountryName: UILabel!
    @IBOutlet weak var imageViewCountryImage: UIImageView!
    @IBOutlet weak var constraintFlipImageWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintFlipImageHeight: NSLayoutConstraint!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var viewStatusbar: UIView!
    
    
    var videoCameraWrapper: VideoCameraWrapper? = nil
    
    var shareScanningListing: NSMutableDictionary = [:]
    
    var documentImage: UIImage? = nil
    var docfrontImage: UIImage? = nil

    //MARK:- Variable
    var dictResult : [String : String] = [String : String]()
    var imgViewCard : UIImage?
    var isCheckCard : Bool = false
    
    var isCheckcardBack : Bool = false
    var isCheckCardBackFrint : Bool = false
    
    var isBack : Bool?
    var isFront : Bool?
    
    var imgViewCardFront : UIImage?
    
    var dictFrontResult : [String : String] = [String : String]()
    var dictBackResult : [String : String] = [String : String]()
    
    var isflipanimation : Bool?
    
    var imgPhoto : UIImage?
    var isCheckFirstTime : Bool?
    var setImage : Bool?
    var _imageView1: UIImageView?
    var statusBarRect = CGRect()
    var bottomPadding:CGFloat = 0.0
    var topPadding: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isCheckFirstTime = false
        setImage = true
        imageViewCountryImage.layer.cornerRadius = 8.0
        
        statusBarRect = UIApplication.shared.statusBarFrame
        let window = UIApplication.shared.windows.first
       
        if #available(iOS 11.0, *) {
            bottomPadding = window!.safeAreaInsets.bottom
            topPadding = window!.safeAreaInsets.top
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangedOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
//        ChangedOrientation()
        var width : CGFloat = 0
        var height : CGFloat = 0
        _lblTitle.text = "Scan Front Side of Emirates National ID"
        
        width = UIScreen.main.bounds.size.width
        height = UIScreen.main.bounds.size.height
        width = width * 0.90
        height = height * 0.30

        _constant_width.constant = width
        _constant_height.constant = height
        

        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        _viewLayer.layer.borderColor = UIColor.red.cgColor
        _viewLayer.layer.borderWidth = 3.0
        
        self._imgFlipView.isHidden = true
        
        if status == .authorized {
            setOCRData()
            isCheckFirstTime = true
            let shortTap = UITapGestureRecognizer(target: self, action: #selector(handleTapToFocus(_:)))
            shortTap.numberOfTapsRequired = 1
            shortTap.numberOfTouchesRequired = 1
            self.view.addGestureRecognizer(shortTap)
        } else if status == .denied {
            let alert = UIAlertController(title: "AccuraSdk", message: "It looks like your privacy settings are preventing us from accessing your camera.", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "OK", style: .default) { _ in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
            alert.addAction(yesButton)
            
            self.present(alert, animated: true, completion: nil)
        } else if status == .restricted {
            
        } else if status == .notDetermined  {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.isCheckFirstTime = true
                    
                    DispatchQueue.main.async {
                        self._imageView.frame = CGRect(x: 80, y: 0, width: self._imageView.frame.size.width + (UIScreen.main.bounds.width / 4), height: self._imageView.frame.size.height + (UIScreen.main.bounds.height / 4))
                        self._imageView.setNeedsLayout()
                        self._imageView.layoutSubviews()
                        
                        self.setOCRData()
                        
                        self.ChangedOrientation()
                        
                        self.videoCameraWrapper?.startCamera()
                        
                    }
                    
                    
                    let shortTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToFocus(_:)))
                    shortTap.numberOfTapsRequired = 1
                    shortTap.numberOfTouchesRequired = 1
                } else {
                    print("Not granted access")
                }
            }
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        viewNavigation.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        viewStatusbar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        
        isFront = true
        if setImage!{
        setImage = false
        _imageView.setNeedsLayout()
        _imageView.layoutSubviews()
        }
        
        if isCheckFirstTime!{
        _imageView.frame = CGRect(x: 80, y: 0, width: _imageView.frame.size.width + (UIScreen.main.bounds.width / 4), height: _imageView.frame.size.height + (UIScreen.main.bounds.height / 4))
            
        isCheckFirstTime = true
        self.ChangedOrientation()
        
        if videoCameraWrapper == nil {
            setOCRData()
        }
            
        videoCameraWrapper?.startCamera()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        videoCameraWrapper?.stopCamera()
        videoCameraWrapper = nil
        _imageView.image = nil
        super.viewWillDisappear(animated)
    }
    
    @IBAction func backAction(_ sender: Any) {
        videoCameraWrapper?.stopCamera()
        if UserDefaults.standard.value(forKey: "ScanningDataMRZ") != nil{
            UserDefaults.standard.removeObject(forKey: "ScanningDataMRZ")
        }
        exit(0)
//        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Other Method
    func setOCRData(){
        
        dictBackResult.removeAll()
        dictFrontResult.removeAll()
        dictResult.removeAll()

        isCheckCard = false
        isCheckcardBack = false
        isCheckCardBackFrint = false
        isflipanimation = false

        let filepathAlt = Bundle.main.path(forResource: "haarcascade_frontalface_alt", ofType: "xml")

        videoCameraWrapper = VideoCameraWrapper.init(delegate: self, andImageView: _imageView, andLabelMsg: lblOCRMsg, andFacePath: filepathAlt)
    }
    
    
//    func setOCRData1(){
//        
////        dictBackResult.removeAll()
////        dictFrontResult.removeAll()
////        dictResult.removeAll()
////
////        isCheckCard = false
////        isCheckcardBack = false
////        isCheckCardBackFrint = false
////        isflipanimation = false
////
////        let filepathAlt = Bundle.main.path(forResource: "haarcascade_frontalface_alt", ofType: "xml")
//        
//        videoCameraWrapper = VideoCameraWrapper.init(delegate: self)
//    }
    
    
    @objc private func ChangedOrientation() {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        
        width = UIScreen.main.bounds.size.width
        height = UIScreen.main.bounds.size.height - (statusBarRect.height + bottomPadding + topPadding)
        
        width = width * 5 / 5.6
        height = width * CGFloat(0.636666667)
        _constant_width.constant = width
        _constant_height.constant = height
        
        videoCameraWrapper?.changedOrintation(width, height: height)
        
        DispatchQueue.main.async {
           UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
               self.view.layoutIfNeeded()
           }) { _ in
            }
        }
    }
    
    @objc func handleTapToFocus(_ tapGesture: UITapGestureRecognizer?) {
        
        let acd = AVCaptureDevice.default(for: .video)
        if tapGesture!.state == .ended {
            let thisFocusPoint = tapGesture!.location(in: _viewLayer)
            let focus_x = Double(thisFocusPoint.x / _viewLayer.frame.size.width)
            let focus_y = Double(thisFocusPoint.y / _viewLayer.frame.size.height)
            if acd?.isFocusModeSupported(.autoFocus) ?? false && acd?.isFocusPointOfInterestSupported != nil {
                do {
                    try acd?.lockForConfiguration()
                    
                    if try acd?.lockForConfiguration() != nil {
                        acd?.focusMode = .autoFocus
                        acd?.focusPointOfInterest = CGPoint(x: CGFloat(focus_x), y: CGFloat(focus_y))
                        acd?.unlockForConfiguration()
                    }
                } catch {
                }
            }
        }
        
    }
    
    func flipAnimation() {
        self._imgFlipView.isHidden = false
        UIView.animate(withDuration: 1.5, animations: {
            UIView.setAnimationTransition(.flipFromLeft, for: self._imgFlipView, cache: true)
            AudioServicesPlaySystemSound(1315)
        }) { _ in
            self._imgFlipView.isHidden = true
        }
    }
}

extension ViewController: VideoCameraWrapperDelegate {
    
    func processedImage(_ image: UIImage!) {
        _imageView.image = image
    }
    
    func recognizeFailed(_ message: String!) {
        GlobalMethods.showAlertView(message, with: self)
    }

    func matchedItem(_ image: UIImage!, dict setData: NSMutableDictionary!) {
        if isFront == true{
            imgViewCardFront = image
        }else{
            imgViewCard = image
        }
        dictResult = setData as! [String : String]

        if self.isFront!{
             isFront = false
            if !self.isCheckCard{
                self.isCheckCard = true
                self.dictFrontResult.removeAll()
                self.dictFrontResult = self.dictResult
                self.dictResult.removeAll()
                self._lblTitle.text! = "Now Scan Back side of Emirates National ID"
            }else{
                self.dictResult.removeAll()
            }
        }else{
            if !self.isCheckcardBack{
                self.isCheckcardBack = true
                self.dictBackResult.removeAll()
                self.dictBackResult = self.dictResult
                self.dictResult.removeAll()
                self._lblTitle.text! = "Scan Front side of Emirates National ID"
            }
        }
        
        if self.dictFrontResult.count != 0 && self.dictBackResult.count != 0{
            if !self.isCheckCardBackFrint{
                self.isCheckCardBackFrint = true
                self.videoCameraWrapper?.stopCamera()
                _imageView.image = nil
                AudioServicesPlaySystemSound(SystemSoundID(1315))
                let vc : ShowAllDocumentResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowAllDocumentResultViewController") as! ShowAllDocumentResultViewController
                vc.dictFinalResultFront = self.dictFrontResult
                vc.dictFinalResultBack = self.dictBackResult
                vc.imgViewBack = self.imgViewCard
                vc.imgViewFront = self.imgViewCardFront
    
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if !self.isflipanimation!{
                self.isflipanimation = true
                self.flipAnimation()
                return
            }else{
                return
            }
        }
        
    }

}
