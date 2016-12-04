    //
//  AVPlayerView.swift
//  AVFoundationSample
//
//  Created by shoji on 2016/12/04.
//  Copyright © 2016年 shoji fujita. All rights reserved.
//

import AVFoundation
import UIKit

class AVPlayerView: UIView {
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
}
