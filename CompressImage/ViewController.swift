//
//  ViewController.swift
//  CompressImage
//
//  Created by Dante Henrique Strutzel Saggin on 24/02/18.
//  Copyright © 2018 DHSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getSizeAnd(image: UIImage, label: UILabel){
        var mb:Double = 0
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            let bytes = imageData.count
            mb = Double(bytes) / (1024.0 * 1024)
        } else if let imageData = UIImagePNGRepresentation(image){
            let bytes = imageData.count
            mb = Double(bytes) / (1024.0 * 1024)
        }
        
        DispatchQueue.main.async {
                label.text = String(format: "%.2f Mb", mb)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        UiImageView.image =  image
        getSizeAnd(image: image!, label: imgOriginalSize)
        picker.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var UiImageView: UIImageView!
    @IBOutlet weak var imgCompressedSize: UILabel!
    @IBOutlet weak var imgOriginalSize: UILabel!
    
    @IBAction func captureImageAction(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func compressImageAction(_ sender: UIButton) {
        let compressedImage = compressImage(image: UiImageView.image!, expectedSizeKb: 100)
        print(compressedImage.size)
        getSizeAnd(image: compressedImage, label: imgCompressedSize)
        DispatchQueue.main.async {
            self.UiImageView.image = compressedImage
        }
    }
    
    
    func compressImage(image:UIImage, expectedSizeKb: Int) -> UIImage {
        var expectedSizeBytes = 0
        if expectedSizeKb > 0{
                expectedSizeBytes = expectedSizeKb * 1024
        } else {
            expectedSizeBytes = 1024
        }
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        var maxHeight : CGFloat = 841 //A4 default size I'm thinking about a document
        var maxWidth : CGFloat = 594
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 1
        var imageData:Data = UIImageJPEGRepresentation(image, compressionQuality)!
        while imageData.count > expectedSizeBytes {
            
            if (actualHeight > maxHeight || actualWidth > maxWidth){
                if(imgRatio < maxRatio){
                    imgRatio = maxHeight / actualHeight;
                    actualWidth = imgRatio * actualWidth;
                    actualHeight = maxHeight;
                }
                else if(imgRatio > maxRatio){
                    imgRatio = maxWidth / actualWidth;
                    actualHeight = imgRatio * actualHeight;
                    actualWidth = maxWidth;
                }
                else{
                    actualHeight = maxHeight;
                    actualWidth = maxWidth;
                    compressionQuality = 1;
                }
            }
            let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
            UIGraphicsBeginImageContext(rect.size);
            image.draw(in: rect)
            let img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if let imgData = UIImageJPEGRepresentation(img!, compressionQuality) {
                if imgData.count > expectedSizeBytes {
                    if compressionQuality > 0.4 {
                            compressionQuality -= 0.1
                    } else {
                        maxHeight = maxHeight * 0.9
                        maxWidth = maxWidth * 0.9
                    }
                }
                imageData = imgData
            }
            
           
        }
        
        
        return UIImage(data: imageData)!
    }
}

