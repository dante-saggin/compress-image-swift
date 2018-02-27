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
        if let imageData = UIImageJPEGRepresentation(image, 1) {
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
        do {
            try UiImageView.image?.compressImage(100, completion: { (image, compressRatio) in
                print(image.size)
                
                DispatchQueue.main.async {
                    self.getSizeAnd(image: image, label: self.imgCompressedSize)
                    self.UiImageView.image = image
                }
            })
        } catch UIImage.CompressImageErrors.invalidExSize {
            print("This size is invalid")
        } catch UIImage.CompressImageErrors.sizeImpossibleToReach{
            print("Impossible To Reach this size too small")
        } catch {
            print("Unhandled Error")
        }
       
    }
    
    
    
}

