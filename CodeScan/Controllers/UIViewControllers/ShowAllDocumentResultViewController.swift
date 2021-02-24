//
//  ShowAllDocumentResultViewController.swift
//  AccuraSDK
//
//  Created by kuldeep on 12/11/19.
//  Copyright © 2019 Elite Development LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreImage
import Accelerate
import Alamofire

struct Objects {
    var name : String!
    var objects : String!
    
    init(sName: String, sObjects: String) {
        self.name = sName
        self.objects = sObjects
    }
    
}

let KEY_TITLE           =  "KEY_TITLE"
let KEY_VALUE           =  "KEY_VALUE"
let KEY_FACE_IMAGE      =  "KEY_FACE_IMAGE"
let KEY_FACE_IMAGE2     =  "KEY_FACE_IMAGE2"
let KEY_DOC1_IMAGE      =  "KEY_DOC1_IMAGE"
let KEY_DOC2_IMAGE      =  "KEY_DOC2_IMAGE"

class ShowAllDocumentResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    //MARK:- Outlet
    @IBOutlet weak var tblViewAllDocumentResult: UITableView!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var btnCancle: UIButton!
    
    @IBOutlet weak var btnFaceMatch: UIButton!
    @IBOutlet weak var viewNavigationBar: UIView!
    
    
    //MARK:- Variable
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var dictFinalResultFront : [String : String] = [String:String]()
    var dictFinalResultBack : [String : String] = [String:String]()
    var arrFinalResultFront  = [Objects]()
    var arrFinalResultBack  = [Objects]()
    
    var imgViewCountryCard : UIImage?
    
    var imgViewFront : UIImage?
    var imgViewBack : UIImage?
    var arrSecurity = [String]()
    var dictScanningData:NSDictionary = NSDictionary()
    var imagePhoto : UIImage?
    var arrFace : [String] = [String]()
    var arrDocumentData: [[String:AnyObject]] = [[String:AnyObject]]()
    var arrDocumentDataFace: [[String:AnyObject]] = [[String:AnyObject]]()
    var isFirstTime:Bool = false
    
    var retval: Int = 0
    var lines = ""
    var success = false
    var passportType = ""
    var country = ""
    var surName = ""
    var givenNames = ""
    var passportNumber = ""
    var passportNumberChecksum = ""
    var nationality = ""
    var birth = ""
    var birthChecksum = ""
    var sex = ""
    var expirationDate = ""
    var otherID = ""
    var expirationDateChecksum = ""
    var personalNumber = ""
    var personalNumberChecksum = ""
    var secondRowChecksum = ""
    var placeOfBirth = ""
    var placeOfIssue = ""
    var mrz_val = ""
    
    let picker: UIImagePickerController = UIImagePickerController()
    var faceRegion: NSFaceRegion?
    var photoImage: UIImage?
    var faceChozImage : UIImage?
    var faceScoreData: String?
    
    //MARK:- ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
       viewNavigationBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        
        isFirstTime = true
        
        let fmInit = EngineWrapper.isEngineInit()
        if !fmInit{
            
            /*
             FaceMatch SDK method initiate SDK engine
             */
            
            EngineWrapper.faceEngineInit()
        }
        
        /*
         Facematch SDK method to get SDK engine status after initialization
         Return: -20 = Face Match license key not found, -15 = Face Match license is invalid.
         */
        let fmValue = EngineWrapper.getEngineInitValue() //get engineWrapper load status
        if fmValue == -20{
            GlobalMethods.showAlertView("key not found", with: self)
        }else if fmValue == -15{
            GlobalMethods.showAlertView("License Invalid", with: self)
        }
        
        if UserDefaults.standard.value(forKey: "ScanningDataMRZ") != nil{
            dictScanningData  = UserDefaults.standard.value(forKey: "ScanningDataMRZ") as! NSDictionary  // Get UserDefaults Store Dictionary 
        }
        
        if let strline: String =  dictScanningData["lines"] as? String {
            self.lines = strline
        }
        if let strpassportType: String =  dictScanningData["passportType"] as? String  {
            self.passportType = strpassportType
        }
        if let stRetval: String = dictScanningData["retval"] as? String   {
            self.retval = Int(stRetval) ?? 0
        }
        if let strcountry: String =  dictScanningData["country"] as? String {
            self.country = strcountry
        }
        if let strsurName: String = dictScanningData["surName"] as? String {
            self.surName = strsurName
        }
        if let strgivenNames: String =  dictScanningData["givenNames"] as? String  {
            self.givenNames = strgivenNames
        }
        if let strpassportNumber: String = dictScanningData["passportNumber"] as? String   {
            self.passportNumber = strpassportNumber
        }
        if let strpassportType: String =  dictScanningData["passportType"] as? String {
            self.passportType = strpassportType
        }
        
        if let strpassportNumberChecksum: String = dictScanningData["passportNumberChecksum"] as? String {
            self.passportNumberChecksum = strpassportNumberChecksum
        }
        if let strnationality: String =  dictScanningData["nationality"] as? String  {
            self.nationality = strnationality
        }
        if let strbirth: String = dictScanningData["birth"] as? String  {
            self.birth = strbirth
        }
        if let strbirthChecksum: String = dictScanningData["BirthChecksum"] as? String{
            self.birthChecksum = strbirthChecksum
        }
        if let strsex: String =  dictScanningData["sex"] as? String {
            self.sex = strsex
        }
        if let strexpirationDate: String = dictScanningData["expirationDate"] as? String {
            self.expirationDate = strexpirationDate
        }
        
        if let strexpirationDateChecksum: String = dictScanningData["expirationDateChecksum"] as? String  {
            self.expirationDateChecksum = strexpirationDateChecksum
        }
        if let strpersonalNumber: String = dictScanningData["personalNumber"] as? String{
            self.personalNumber = strpersonalNumber
        }
        if let strpersonalNumberChecksum: String = dictScanningData["personalNumberChecksum"] as? String {
            self.personalNumberChecksum = strpersonalNumberChecksum
        }
        if let strsecondRowChecksum: String = dictScanningData["secondRowChecksum"] as? String {
            self.secondRowChecksum = strsecondRowChecksum
        }
        if let strplaceOfBirth: String = dictScanningData["placeOfBirth"] as? String{
            self.placeOfBirth = strplaceOfBirth
        }
        if let strplaceOfIssue: String = dictScanningData["placeOfIssue"] as? String {
            self.placeOfIssue = strplaceOfIssue
        }
        
        
//        tblViewAllDocumentResult.estimatedRowHeight = 60.0
//        tblViewAllDocumentResult.rowHeight = UITableView.automaticDimension
        
        
        for (key,value) in dictFinalResultFront{
            
            let ansData = Objects.init(sName: key, sObjects: value)
            
            if ansData.name.contains("_img"){
                arrFace.append(ansData.objects)
            }
        }
        
        for (key,value) in dictFinalResultBack{
            let ansData = Objects.init(sName: key, sObjects: value)
            if ansData.name.contains("_img"){
                arrSecurity.append(ansData.objects)
            }
        }
        
        
        self.tblViewAllDocumentResult.register(UINib.init(nibName: "UserImgTableCell", bundle: nil), forCellReuseIdentifier: "UserImgTableCell")
        
        self.tblViewAllDocumentResult.register(UINib.init(nibName: "ResultTableCell", bundle: nil), forCellReuseIdentifier: "ResultTableCell")
        
        self.tblViewAllDocumentResult.register(UINib.init(nibName: "DocumentTableCell", bundle: nil), forCellReuseIdentifier: "DocumentTableCell")
        
        self.tblViewAllDocumentResult.register(UINib.init(nibName: "FaceMatchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "FaceMatchResultTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set TableView Height
        self.tblViewAllDocumentResult.estimatedRowHeight = 60.0
        self.tblViewAllDocumentResult.rowHeight = UITableView.automaticDimension
        
        
        print("\(retval)")
        
        mrz_val = "CORRECT"
        if retval == 1 {
            mrz_val = "CORRECT"
        } else {
            
        }
        
        if isFirstTime{
            isFirstTime = false
            self.setData()
        }
        
        
    }
    
    func setData(){
        //Set tableView Data
        for index in 0..<18{
            var dict: [String:AnyObject] = [String:AnyObject]()
            switch index {
            case 1:
                dict = [KEY_VALUE: lines] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 2:
                var firstLetter: String = ""
                var strFstLetter: String = ""
                let strPassportType = passportType.lowercased()
                
                if !lines.isEmpty{
                    firstLetter = (lines as? NSString)?.substring(to: 1) ?? ""
                    strFstLetter = firstLetter.lowercased()
                }
                
                var dType: String = ""
                if strPassportType == "v" || strFstLetter == "v" {
                    dType = "VISA"
                }
                else if passportType == "p" || strFstLetter == "p" {
                    dType = "PASSPORT"
                }
                else if passportType == "d" || strFstLetter == "p" {
                    dType = "DRIVING LICENCE"
                }
                else {
                    if (strFstLetter == "d") {
                        dType = "DRIVING LICENCE"
                    } else {
                        dType = "ID"
                    }
                }
                
                dict = [KEY_VALUE: dType,KEY_TITLE:"DOCUMENT TYPE : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 3:
                dict = [KEY_VALUE: country,KEY_TITLE:"COUNTRY : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 4:
                dict = [KEY_VALUE: surName,KEY_TITLE:"LAST NAME : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 5:
                dict = [KEY_VALUE: givenNames,KEY_TITLE:"FIRST NAME : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 6:
                let stringWithoutSpaces = passportNumber.replacingOccurrences(of: "<", with: "")
                dict = [KEY_VALUE: stringWithoutSpaces,KEY_TITLE:"DOCUMENT NO : "] as [String : AnyObject]
                arrDocumentData.append(dict)
            case 7:
                dict = [KEY_VALUE: passportNumberChecksum,KEY_TITLE:"DOCUMENT CHECK NUMBER : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 8:
                dict = [KEY_VALUE: nationality,KEY_TITLE:"NATIONALITY : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 9:
                dict = [KEY_VALUE: date(toFormatedDate: birth),KEY_TITLE:"DATE OF BIRTH : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 10:
                dict = [KEY_VALUE: birthChecksum,KEY_TITLE:"BIRTH CHECK NUMBER : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 11:
                var stSex: String = ""
                if sex == "F" {
                    stSex = "FEMALE";
                }
                if sex == "M" {
                    stSex = "MALE";
                }
                dict = [KEY_VALUE: stSex,KEY_TITLE:"SEX : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 12:
                dict = [KEY_VALUE: date(toFormatedDate: expirationDate),KEY_TITLE:"DATE OF EXPIRY : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 13:
                dict = [KEY_VALUE: expirationDateChecksum,KEY_TITLE:"EXPIRATION CHECK NUMBER : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 14:
                dict = [KEY_VALUE: personalNumber,KEY_TITLE:"OTHER ID : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 15:
                dict = [KEY_VALUE: personalNumberChecksum,KEY_TITLE:"OTHER ID CHECK : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 16:
                dict = [KEY_VALUE: secondRowChecksum,KEY_TITLE:"SECOND ROW CHECK NUMBER : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 17:
                var stResult: String = ""
                if retval == 1 {
                    stResult = "CORRECT MRZ";
                }
                else if retval == 2 {
                    stResult = "INCORRECT MRZ";
                }
                else {
                    stResult = "FAIL";
                }
                dict = [KEY_VALUE: stResult,KEY_TITLE:"RESULT : "] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            default:
                break
            }
        }
    }
    


func getValue(stKey: String) -> String {

    let arrResult = arrDocumentData.filter( { (details: [String:AnyObject]) -> Bool in
        return ("\(details[KEY_TITLE] ?? "" as AnyObject)" == stKey )
    })
    print(arrResult)
    let dictResult = arrResult.isEmpty ? [String:AnyObject]() : arrResult[0]
    var stResult: String = ""
    if dictResult[KEY_VALUE] != nil { stResult = "\(dictResult[KEY_VALUE] ?? "" as AnyObject)"  }
    else{ stResult = "" }
    return stResult
    }
    
    func getValue1(stKey: String) -> String {

    let arrResult = arrDocumentDataFace.filter( { (details: [String:AnyObject]) -> Bool in
        return ("\(details[KEY_TITLE] ?? "" as AnyObject)" == stKey )
    })
    print(arrResult)
    let dictResult = arrResult.isEmpty ? [String:AnyObject]() : arrResult[0]
    var stResult: String = ""
    if dictResult[KEY_VALUE] != nil { stResult = "\(dictResult[KEY_VALUE] ?? "" as AnyObject)"  }
    else{ stResult = "" }
    return stResult
    }

    
    //MARK:- Custom
    func date(toFormatedDate dateStr: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        let date: Date? = dateFormatter.date(from: dateStr ?? "")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func date(to dateStr: String?) -> String? {
        // Convert string to date object
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyMMdd"
        let date: Date? = dateFormat.date(from: dateStr ?? "")
        dateFormat.dateFormat = "yyyy-MM-dd"
        if let date = date {
            return dateFormat.string(from: date)
        }
        return nil
    }
    
    //MARK:- Button Action
    @IBAction func btnCancleAction(_ sender: Any) {
        removeAllData()
    }
    
    @IBAction func btnFaceMatchAction(_ sender: UIButton) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.mediaTypes = ["public.image"]
        self.present(picker, animated: true, completion: nil)
    }
    
    func removeAllData(){
        dictFinalResultBack.removeAll()
        dictFinalResultFront.removeAll()
        arrSecurity.removeAll()
        arrFinalResultFront.removeAll()
        arrFinalResultBack.removeAll()
        imagePhoto = nil
        imgViewBack = nil
        imgViewFront = nil
        UserDefaults.standard.removeObject(forKey: "ScanningDataMRZ")
        self.navigationController?.popViewController(animated: true)
    }
    
    //Remove Same Value
    func removeOldValue(_ removeKey: String){
        var removeIndex: String = ""
        for (index,dict) in arrDocumentData.enumerated(){
            if dict[KEY_TITLE] != nil{
                if dict[KEY_TITLE] as! String == removeKey{
                    removeIndex = "\(index)"
                }
            }
        }
        if !removeIndex.isEmpty{ arrDocumentData.remove(at: Int(removeIndex)!)}
        tblViewAllDocumentResult.reloadData()
    }
    
    //MARK:- Image Rotation
    @objc func loadPhotoCaptured() {
        let img = allImageViewsSubViews(picker.viewControllers.first?.view)?.last
        if img != nil {
            if let imgView: UIImageView = img as? UIImageView{
                imagePickerController(picker, didFinishPickingMediaWithInfo: convertToUIImagePickerControllerInfoKeyDictionary([convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage) : imgView.image!]))
            }
        } else {
            picker.dismiss(animated: true)
        }
    }
    
    /**
     * This method is used to get captured view
     * Param: UIView
     * Return: array of UIImageview
     */
    func allImageViewsSubViews(_ view: UIView?) -> [AnyHashable]? {
        var arrImageViews: [AnyHashable] = []
        if (view is UIImageView) {
            if let view = view {
                arrImageViews.append(view)
            }
        } else {
            for subview in view?.subviews ?? [] {
                if let all = allImageViewsSubViews(subview) {
                    arrImageViews.append(contentsOf: all)
                }
            }
        }
        return arrImageViews
    }
    
    /**
     * This method is used to compress image in particular size
     * Param: UIImage and covert size
     * Return: compress UIImage
     */
    func compressimage(with image: UIImage?, convertTo size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let destImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return destImage
    }
    
    //MARK:- UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker.dismiss(animated: true, completion: nil)
        SVProgressHUD.show(withStatus: "Loading...")
//        DispatchQueue.global(qos: .background).async {
            guard var chosenImage:UIImage = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else{return}
            
            //Capture Image Left flipped
            if picker.sourceType == UIImagePickerController.SourceType.camera && picker.cameraDevice == .front {
                var flippedImage: UIImage? = nil
                if let CGImage = chosenImage.cgImage {
                    flippedImage = UIImage(cgImage: CGImage, scale: chosenImage.scale, orientation: .leftMirrored)
                }
                chosenImage = flippedImage!
            }
            
            //Image Resize
            
            let ratio = CGFloat(chosenImage.size.width) / chosenImage.size.height
            chosenImage = self.compressimage(with: chosenImage, convertTo: CGSize(width: 600 * ratio, height: 600))!
            
            
            self.faceRegion = nil;
            if (self.photoImage != nil){
                print(self.photoImage!)
                /*
                 Accura Face SDK method to detect user face from document image
                 Param: Document image
                 Return: User Face
                 */
                
                self.faceRegion = EngineWrapper.detectSourceFaces(self.photoImage)
                print(self.faceRegion as Any)
            }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                if (self.faceRegion != nil){
                    /*
                     Accura Face SDK method to detect user face from selfie or camera stream
                     Params: User photo, user face found in document scanning
                     Return: User face from user photo
                     */
                    let face2 : NSFaceRegion? = EngineWrapper.detectTargetFaces(chosenImage, feature1: self.faceRegion?.feature as Data?)   //identify face in back image which found in front image
                    
                   
                    
                    
                    /*
                     Accura Face SDK method to get face match score
                     Params: face image from document with user image from selfie or camera stream
                     Returns: face match score
                     */
                    let fm_Score = EngineWrapper.identify(self.faceRegion?.feature, featurebuff2: face2?.feature)
                    if(fm_Score != 0.0){
                        let data = face2?.bound
                         
                         
                        let image = self.resizeImage(image: chosenImage, targetSize: data!)
                        var isFindImg: Bool = false
                        
                        self.faceChozImage = image
                        
//                        for (index,var dict) in self.arrDocumentData.enumerated(){
//                            for st in dict.keys{
//                                if st == KEY_FACE_IMAGE{
//
//                                    //                                    self.arrDocumentData[index] = dict
//                                    isFindImg = true
//                                    break
//                                }
//                                if isFindImg{ break }
//                            }
//                        }
                        
                        self.removeOldValue("LIVENESS SCORE : ")
                        self.btnFaceMatch.isHidden = true
                        self.removeOldValue("FACEMATCH SCORE : ")
                        let twoDecimalPlaces = String(format: "%.2f", fm_Score * 100) //Match score Convert Float Value
                        let dict = [KEY_VALUE: "\(twoDecimalPlaces)",KEY_TITLE:"FACEMATCH SCORE : "] as [String : AnyObject]
                        self.arrDocumentDataFace.insert(dict, at: 0)
                        
                    }else {
                        self.btnFaceMatch.isHidden = false
                    }
                }
                UIView.animate (withDuration: 0.1, animations: {
                    self.tblViewAllDocumentResult.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }) {(_) in
                    self.tblViewAllDocumentResult.reloadData()
                }
                SVProgressHUD.dismiss()
            })
//        }
    }
    
         func resizeImage(image: UIImage, targetSize: CGRect) -> UIImage {
            
            let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
            var newX = targetSize.origin.x - (targetSize.size.width * 0.4)
            var newY = targetSize.origin.y - (targetSize.size.height * 0.4)
            var newWidth = targetSize.size.width * 1.8
            var newHeight = targetSize.size.height * 1.8
            
            if newX < 0 {
                newX = 0
            }
            
            if newY < 0 {
                newY = 0
            }
            
            if newX + newWidth > image.size.width{
                newWidth = image.size.width - newX
            }
            
            if newY + newHeight > image.size.height{
                newHeight = image.size.height - newY
            }
            
            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
            let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
            
            let image1: UIImage = UIImage(cgImage: imageRef)
            
            // Actually do the resizing to the rect using the ImageContext stuff
    //        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    //        image.draw(in: rect)
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()

            return image1
        }
    
    //MARK:- Table View Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return arrFace.count
        case 1:
            return arrDocumentDataFace.count
        case 2:
            return arrDocumentData.count
        case 3:
            return arrSecurity.count
        case 4:
            return 2
        default:
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Set Document data
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserImgTableCell") as! UserImgTableCell
            cell.selectionStyle = .none
            if (UIDevice.current.orientation == .landscapeRight) {
                cell.user_img.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            } else if (UIDevice.current.orientation == .landscapeLeft) {
                cell.user_img.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double.pi / 2)))
            }
            //            if imagePhoto != nil{
            //                cell.user_img.image = imagePhoto
            //            }
            let objData = arrFace[indexPath.row]
            
            if let decodedData = Data(base64Encoded: objData, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedData)
                photoImage = image
                cell.User_img2.isHidden = true
                cell.user_img.image = image
            }
            
            if faceChozImage != nil{
                cell.User_img2.isHidden = false
                cell.User_img2.image = faceChozImage
            }
            
            
            return cell
        }
        if indexPath.section == 1{
            let cell: FaceMatchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FaceMatchResultTableViewCell") as! FaceMatchResultTableViewCell
            if !arrDocumentDataFace.isEmpty{
                cell.viewBG.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
                let  dictResultData: [String:AnyObject] = arrDocumentDataFace[indexPath.row]
                cell.lblName.text = "FACEMATCH SCORE : \(dictResultData[KEY_VALUE] as? String ?? "")"
            }
            
            return cell
        }
        
        
        if indexPath.section == 2{
            let  dictResultData: [String:AnyObject] = arrDocumentData[indexPath.row]
            let cell: ResultTableCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell") as! ResultTableCell
            cell.lblName.font = UIFont(name: "Aller-Regular", size: 14.0)
            cell.lblValue.font = UIFont(name: "Aller-Regular", size: 14.0)
            cell.viewHeaderData.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
            if indexPath.row == 0{
                cell.lblSide.text = "MRZ"
                cell.constarintViewHaderHeight.constant = 25
                cell.lblName.text = "MRZ:"
                cell.lblValue.text = dictResultData[KEY_VALUE] as? String ?? ""
                
            }else{
                cell.constarintViewHaderHeight.constant = 0
                cell.lblName.text = dictResultData[KEY_TITLE] as? String ?? ""
                cell.lblValue.text = dictResultData[KEY_VALUE] as? String ?? ""
            }
            
            return cell
        }
        if indexPath.section == 3{
            let cell: ResultTableCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell") as! ResultTableCell
            //            cell.cornerRadius = 8
            cell.selectionStyle = .none
            if !arrSecurity.isEmpty{
                cell.viewHeaderData.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
                
                if indexPath.row == 0{
                    cell.lblSide.text = "BACK SIDE OCR"
                    cell.constarintViewHaderHeight.constant = 25
                    let objData = arrSecurity[0]
                    cell.lblName.text = "SIGN"
                    if let decodedData = Data(base64Encoded: objData, options: .ignoreUnknownCharacters) {
                        let image = UIImage(data: decodedData)
                        let attachment = NSTextAttachment()
                        attachment.image = image
                        let attachmentString = NSAttributedString(attachment: attachment)
                        cell.lblValue.attributedText = attachmentString
                    }
                }else{
                    cell.constarintViewHaderHeight.constant = 0
                    let objData = arrSecurity[indexPath.row]
                    cell.lblName.text = "SIGN"
                    
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: objData)
                    let attachmentString = NSAttributedString(attachment: attachment)
                    cell.lblValue.attributedText = attachmentString
                }
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableCell") as! DocumentTableCell
            
            cell.viewBG.layer.cornerRadius = 8.0
            cell.viewBG.layer.borderWidth = 0.2
            cell.viewBG.layer.borderColor = UIColor.lightGray.cgColor
            
            cell.selectionStyle = .none
            
            cell.lblDocName.textColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
            if indexPath.row == 0{
                cell.lblDocName.text = "FRONT SIDE:"
                if imgViewFront != nil{
                cell.imgDocument.image = imgViewFront
                }
            }else{
                cell.lblDocName.text = "BACK SIDE:"
                if imgViewBack != nil{
                cell.imgDocument.image = imgViewBack
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 140.0
        }else if indexPath.section == 1{
            return 40
        }else if indexPath.section == 2{
            return UITableView.automaticDimension
        }else if indexPath.section == 3{
            return UITableView.automaticDimension
        }else{
            return 240
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
           return 5
        }else if section == 1{
           return 5
        }else{
          return 20
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0{
            let headerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewTable.frame.width, height: 15))
            headerView.backgroundColor = UIColor.clear
            return headerView
        }else if section == 1{
            let headerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewTable.frame.width, height: 15))
            headerView.backgroundColor = UIColor.clear
            return headerView
        }else{
            let headerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewTable.frame.width, height: 30))
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
        
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToUIImagePickerControllerInfoKeyDictionary(_ input: [String: Any]) -> [UIImagePickerController.InfoKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIImagePickerController.InfoKey(rawValue: key), value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

