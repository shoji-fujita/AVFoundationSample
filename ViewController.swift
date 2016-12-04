//
//  ViewController.swift
//  AVFoundationSample
//
//  Created by shoji on 2016/12/04.
//  Copyright © 2016年 shoji fujita. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class ViewController: UIViewController {
    
    var playerItem : AVPlayerItem!
    var videoPlayer : AVPlayer!
    
    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "sample", ofType: "mov")!
        let fileURL = URL(fileURLWithPath: path)
        let avAsset = AVURLAsset(url: fileURL, options: nil)
        playerItem = AVPlayerItem(asset: avAsset)
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let layer = playerView.layer as! AVPlayerLayer
        layer.videoGravity = AVLayerVideoGravityResize
        layer.player = videoPlayer
        view.layer.addSublayer(layer)
        
        slider.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        
        let interval = Double(0.5 * slider.maximumValue) / Double(slider.bounds.maxX)
        let time = CMTimeMakeWithSeconds(interval, Int32(NSEC_PER_SEC))
        videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: nil) { time -> Void in
            let duration = CMTimeGetSeconds((self.videoPlayer.currentItem?.duration)!)
            let time = CMTimeGetSeconds(self.videoPlayer.currentTime())
            let value = Float(self.slider.maximumValue - self.slider.minimumValue) * Float(time) / Float(duration) + Float(self.slider.minimumValue)
            self.slider.value = value
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
    }
    
    func finishPlaying(notification: NSNotification) {
        UIView.animate(withDuration: 2, animations: { () -> Void in
            self.playerView.alpha = 0.0
        }, completion: { finished in
            UIView.animate(withDuration: 2, animations: { () -> Void in
                self.playerView.alpha = 1.0
            })
        })
    }
    
    @IBAction func tappedStartButton(_ sender: UIButton) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    @IBAction func valueChangedSlider(_ sender: UISlider) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(Float64(slider.value), Int32(NSEC_PER_SEC)))
    }
    
}
