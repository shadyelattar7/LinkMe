//
//  AudioRecorder.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 18/11/2023.
//

import Foundation
import AVFoundation


class AudioRecorder: NSObject {
    
    /// Properties.
    ///
    private var audioRecorder: AVAudioRecorder!
    
    /// Specify the file URL where you want to save the recorded audio.
    ///
    private let audioFilename = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("audioRecording.wav")
    
    
    /// Method for setup audio recorder.
    ///
    func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true)
            
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                AVNumberOfChannelsKey: 1,
                AVSampleRateKey: 44100.0
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            print("Error setting up audio session or creating audio recorder: \(error.localizedDescription)")
        }
    }
    
    /// Method for start recording.
    ///
    func startRecording() {
        if !audioRecorder.isRecording {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                audioRecorder.record()
                print("Recording started")
            } catch {
                print("Error starting recording: \(error.localizedDescription)")
            }
        }
    }
    
    /// Method for stop recording.
    ///
    func stopRecording() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
            print("Recording stopped")
        }
    }
}

// MARK: Delegate audio recorder.

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished successfully. Recorded file: \(audioFilename.path)")
        } else {
            print("Recording failed")
        }
    }
}
