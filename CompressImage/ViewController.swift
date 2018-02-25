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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        var mb:Double = 0
        UiImageView.image =  image
        if let imageData = UIImagePNGRepresentation(image!) {
            let bytes = imageData.count
            mb = Double(bytes) / (1024.0 * 1024)
        } else if let imageData = UIImageJPEGRepresentation(image!, 1){
            
                let bytes = imageData.count
                mb = Double(bytes) / (1024.0 * 1024)
        }
        picker.dismiss(animated: true, completion: nil)
        imgOriginalSize.text = String(format: "%.2f Mb", mb)
        
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
        
    }
    
}

