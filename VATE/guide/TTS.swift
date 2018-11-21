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
        if(self.tts.isSpeaking) {
            self.tts.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        self.tts.speak(AVSpeechUtterance(string: text))
        self.tts.speak(AVSpeechUtterance(string: indication))
        
    }
}
