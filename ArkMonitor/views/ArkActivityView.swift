//
//  ArkActivityView.swift
//  ArkMonitor
//
//  Created by Andrew on 2017-09-11.
//  Copyright © 2017 vrlc92. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

public struct ArkActivityView {
    
    static private let activityData = ActivityData(type: NVActivityIndicatorType.lineScale)

    static public func startAnimating() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    static public func stopAnimating() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}

