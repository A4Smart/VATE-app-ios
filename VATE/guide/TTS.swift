//
//  TTS.swift
//  VATE
//
//  Created by Marco Fincato on 21/11/2018.
//  Copyright © 2018 Marco Fincato. All rights reserved.
//

import Foundation
import AVFoundation

class TTS {
    private let tts = AVSpeechSynthesizer()
    private var indication = ""
    
    func speak(text: String, indication: String) {
        if(tts.isSpeaking) {
            tts.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        self.indication = indication
        speakText(string: text)
        speakIndication(string: indication)
    }
    
    func skipText() {
        if(tts.isSpeaking) {
            tts.stopSpeaking(at: AVSpeechBoundary.immediate)
            speakIndication(string: indication)
        }
    }
    
    private func speakText(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.pitchMultiplier = 1
        utterance.postUtteranceDelay = 0.5 // seconds before the next utterance will be spoken
        tts.speak(utterance)
    }
    
    private func speakIndication(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.pitchMultiplier = 1.2
        tts.speak(utterance)
    }
}
