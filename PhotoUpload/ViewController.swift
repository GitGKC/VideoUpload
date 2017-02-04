//
//  ViewController.swift
//  PhotoUpload
//
//  Created by GKC on 2017/1/19.
//  Copyright © 2017年 GKC. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ViewController"
        
        let segCtl = UISegmentedControl(items: ["ImagePicker", "PhotoKit"])
        segCtl.frame = CGRect(x: 60, y: 100, width: 200, height: 30)
        self.view.addSubview(segCtl)
        segCtl.addTarget(self, action: #selector(segClick), for: UIControlEvents.valueChanged)
    }
    
    func segClick(seg: UISegmentedControl) {
        switch seg.selectedSegmentIndex {
            
//            PhotoKit 的方式 ：
        case 1:
            guard PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized else {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    guard status == PHAuthorizationStatus.authorized else {
                        print("requestAuthorization restricted")
                        return
                    }
                    //TODO:
                    DispatchQueue.main.async(execute: {
                        let thumbsVideoCtl = ThumbVideoController()
                        self.navigationController?.pushViewController(thumbsVideoCtl, animated: true)
                    })
                })
                return
            }
            DispatchQueue.main.async(execute: {
                let thumbsVideoCtl = ThumbVideoController()
                self.navigationController?.pushViewController(thumbsVideoCtl, animated: true)
            })
            
//            ImagePicker 的方式：
        default:
            guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) else {
                print("not support library")
                return
            }
            
            let imagePick = UIImagePickerController()
            imagePick.delegate = self;
            imagePick.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePick.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeAudio as String]
            imagePick.view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
            self.present(imagePick, animated: true) {
                print("present ImagePicker --> ")
                
            }
        }
    }
    

    //MARK: --- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        print(info.description)
        /*
         
         ["UIImagePickerControllerMediaType": public.movie, "UIImagePickerControllerMediaURL": file:///private/var/mobile/Containers/Data/Application/74164AD9-0762-499D-B388-02C38611F741/tmp/trim.680F0518-93AB-44EC-AC36-1393A56992D8.MOV, "UIImagePickerControllerReferenceURL": assets-library://asset/asset.MOV?id=0C402B9D-12C6-47D5-9307-8C3DA6DFCE01&ext=MOV]
         
         */
        print(info["UIImagePickerControllerMediaURL"] ?? "")
        
        picker.popViewController(animated: true)
        print("pop ImagePicker -->")
    }
    
    
}

