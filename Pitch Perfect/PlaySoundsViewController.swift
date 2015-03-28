//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by David Mulvihill on 3/21/15.
//  Copyright (c) 2015 David Mulvihill. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
                                    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    // init constants for speed and pitch
    let fastplay: Float = 1.5
    let slowplay: Float = 0.5
    let highpitch: Float = 1000
    let lowpitch: Float = -1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        // addresses low playback volume
        var overrideError: NSError?
        if AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker, error: &overrideError) {
        }else{
            println("error in overrideOutputAudioPort")
        }
    }

    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // plays audio at specified speed
    // 1.0 = normal, 0.5 = slow, 1.5 = fast
    
    func playAudio(rate: Float) {
        stopAllAudio()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    // handle special effects (echo, reverb, pitch change)
    func playAudioWithEffect(effect: NSObject) {
        
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect as AVAudioNode)
        
        audioEngine.connect(audioPlayerNode, to: effect as AVAudioNode, format: nil)
        audioEngine.connect(effect as AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch   
        
        playAudioWithEffect(changePitchEffect)
        
    }

    @IBAction func playFastAudio(sender: UIButton) {
        //Play audio fast here....
        playAudio(fastplay)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        //Play audio sloooowly here....
        playAudio(slowplay)
    }
    
    // handle playback with different pitch for chipmunk and vader voices.
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(highpitch)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(lowpitch)
    }
    
    
    @IBAction func playEchoAudio(sender: UIButton) {
        
        var echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.5
        echoEffect.feedback = 50
        echoEffect.wetDryMix = 50
        
        playAudioWithEffect(echoEffect)
        
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset(rawValue: 8)!)
        reverbEffect.wetDryMix = 50
        
        playAudioWithEffect(reverbEffect)

    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
