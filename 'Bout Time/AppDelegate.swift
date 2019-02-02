//
//  AppDelegate.swift
//  'Bout Time
//
//  Created by Michael Hulet on 11/30/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
        // Override point for customization after application launch.

        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true, options: [])

        return true
    }
}
