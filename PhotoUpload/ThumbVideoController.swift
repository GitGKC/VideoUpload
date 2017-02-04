//
//  ThumbVideoController.swift
//  PhotoUpload
//
//  Created by GKC on 2017/2/3.
//  Copyright © 2017年 GKC. All rights reserved.
//

import UIKit
import Photos

class ThumbVideoController: UIViewController {
    
    let backView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var pathKey: [Int:String] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "ThumbVideosController"
        self.view.backgroundColor = UIColor.white
        
        backView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backView.bounces = true
        backView.showsHorizontalScrollIndicator = false
        backView.backgroundColor = UIColor.white
        self.view.addSubview(backView)
        
        self.showLibraryVideoThumbs()
    }

    func showLibraryVideoThumbs() {
        let fetchOpt = PHFetchOptions()
        fetchOpt.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        // videos Asset
        let videosAsset = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: fetchOpt)
        
        videosAsset.enumerateObjects( { (aAsset:PHAsset, count:Int, stop) in
//            print(aAsset);
            PHImageManager.default().requestAVAsset(forVideo: aAsset, options: nil) { (asset:AVAsset?, audioMix:AVAudioMix?, info:[AnyHashable : Any]?) in
                
                let filePath = info?["PHImageFileSandboxExtensionTokenKey"]
//                print(filePath ?? "")
                // 字符串处理
                let lyricArr = (filePath as! String).components(separatedBy: ";")
                let priPath = lyricArr.last
                
                // e.g.   /private/var/mobile/Media/DCIM/100APPLE/IMG_0431.MOV
                let index = priPath?.index((priPath?.startIndex)!, offsetBy: 8)
                let videoPath = lyricArr.last?.substring(from: index!)
                
                let with = (UIScreen.main.bounds.size.width - 15)/4.0
                let thumbImg = self.getFirstFrame(videoPath!, size: CGSize.init(width: with, height: with))
                
//                后台线程，需要在主线程绘图
                DispatchQueue.main.async(execute: {
                    let imageView = UIImageView.init(image: thumbImg)
                    imageView.frame = CGRect(x: 3 + CGFloat.init(count%4)*(3+with), y: 3 + CGFloat.init(count/4)*(3+with), width: with, height: with)
                    
                    let dValue = asset?.duration.value
                    let dTimescale = asset?.duration.timescale
                    let timeLb = self.videoDurationLb(Int.init(dValue!)/Int.init(dTimescale!))
                    timeLb.center = CGPoint.init(x: 55, y: 60)
                    imageView.addSubview(timeLb)
                    
                    self.backView.addSubview(imageView)
                    imageView.tag = 100+count
                    self.pathKey[100+count] = videoPath
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.upload(_:)))
                    imageView.isUserInteractionEnabled = true
                    imageView.addGestureRecognizer(tap)
                })
            }
        })
    }
    
    func upload(_ tap: UITapGestureRecognizer) {
        let path = self.pathKey[(tap.view?.tag)!]
        UploadManager().uploadAVPath(path)
    }
    
    func videoDurationLb(_ seconds:Int) -> UILabel {
        let minute = seconds/60
        let second = seconds%60
        
        let lb = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 13))
        lb.backgroundColor = UIColor.clear
        lb.textColor = UIColor.white
        lb.text = "\(minute):\(String.init(format: "%02d", second))"
        lb.font = UIFont.systemFont(ofSize: 10)
        return lb
    }
    
    func getFirstFrame(_ videoPath: String, size: CGSize) -> UIImage? {
        let AVUrl = URL.init(fileURLWithPath: videoPath, isDirectory: false)
        let opt = ["AVURLAssetPreferPreciseDurationAndTimingKey":NSNumber.init(value: false)]
        let urlAsset = AVURLAsset.init(url: AVUrl, options: opt)
        let generator = AVAssetImageGenerator.init(asset: urlAsset)
        generator.appliesPreferredTrackTransform = false
        generator.maximumSize = size
        do {
            let cgImg = try generator.copyCGImage(at: CMTime.init(value: 0, timescale: 10), actualTime: nil)
            return UIImage.init(cgImage: cgImg)
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
}
