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
    let tts = AVSpeechSynthesizer()
    
    func speak(text: String, indication: String) {
        if(tts.isSpeaking) {
            tts.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        speakText(string: text)
        speakIndication(string: indication)
    }
    
    private func speakText(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.pitchMultiplier = 1
        tts.speak(utterance)
    }
    
    private func speakIndication(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.pitchMultiplier = 1.2
        utterance.preUtteranceDelay = 0.5 // seconds before the utterance will be spoken
        tts.speak(utterance)
    }
}
