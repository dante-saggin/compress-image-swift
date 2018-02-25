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
        if let imageData = UIImagePNGRepresentation(image) {
            let bytes = imageData.count
            mb = Double(bytes) / (1024.0 * 1024)
        } else if let imageData = UIImageJPEGRepresentation(image, 1){
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
        let compressedImage = compressImage(image: UiImageView.image!)
        getSizeAnd(image: compressedImage, label: imgCompressedSize)
        DispatchQueue.main.async {
            self.UiImageView.image = compressedImage
        }
    }
    
    
    func compressImage(image:UIImage) -> UIImage {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 841/2 //A4 default size
        let maxWidth : CGFloat = 594/2
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
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
//        let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
        UIGraphicsEndImageContext();
        
        return img!;
    }
}

