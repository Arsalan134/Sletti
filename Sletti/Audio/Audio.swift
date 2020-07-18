//
//  Audio.swift
//  Sletti
//
//  Created by Arsalan Iravani on 18.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import AVFoundation

func configureAudioSession() {
    print("Configuring audio session")
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try session.setMode(AVAudioSessionModeVoiceChat)
    } catch (let error) {
        print("Error while configuring audio session: \(error)")
    }
}

func startAudio() {
    print("Starting audio")
}

func stopAudio() {
    print("Stopping audio")
}
