//
//  Jukebox.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/21/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation
import AVFoundation

enum GameSound: String, Hashable, Playable{

    // MARK: - Cases

    case correctAnswer = "correct"
    case incorrectAnswer = "incorrect"

    // MARK: - Helper Properties

    private var fileType: AVFileType{
        return .wav
    }

    private var loaded: Sound?{
        if let preloaded = loadedGameSounds[self]{
            return preloaded
        }
        else{
            guard let asset = NSDataAsset(name: "Sounds/" + rawValue.trimmingCharacters(in: .whitespacesAndNewlines)) else{
                fatalError("Sound \"\(rawValue)\" not included in bundle")
            }
            if let new = try? Sound(data: asset.data, type: fileType){
                loadedGameSounds[self] = new
                return new
            }
            else{
                return nil
            }
        }
    }

    // MARK: - Playable Conformance

    var duration: TimeInterval{
        return loaded?.duration ?? Double.signalingNaN
    }

    func prepare(){
        loaded?.prepare()
    }

    func play(){
        loaded?.play()
    }
}

// MARK: - Cache Management

private var loadedGameSounds = [GameSound: Sound]()

import UIKit // I feel bad about doing this here, but it's better than exposing a public API to the internal cache imo, since I don't implement this function anywhere else
extension AppDelegate{
    func applicationDidReceiveMemoryWarning(_ application: UIApplication){
        loadedGameSounds.removeAll()
    }
}
