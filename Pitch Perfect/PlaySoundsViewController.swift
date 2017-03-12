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
    var recordedAudioURL:URL!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    
    // init constants for speed and pitch
    let fastplay: Float = 1.5
    let slowplay: Float = 0.5
    let highpitch: Float = 1000
    let lowpitch: Float = -1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forWriting: receivedAudio.filePathURL as URL, settings: [:])
        
        try! audioPlayer = AVAudioPlayer(contentsOf: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        
        // addresses low playback volume
        
        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        //      }else{
        //          print("error in overrideOutputAudioPort")
        //      }
    }

    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // plays audio at specified speed
    // 1.0 = normal, 0.5 = slow, 1.5 = fast
    
    func playAudio(_ rate: Float) {
        stopAllAudio()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    // handle special effects (echo, reverb, pitch change)
    func playAudioWithEffect(_ effect: NSObject) {
        
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioEngine.attach(audioPlayerNode)
        
        audioEngine.attach(effect as! AVAudioNode)
        
        audioEngine.connect(audioPlayerNode, to: effect as! AVAudioNode, format: nil)
        audioEngine.connect(effect as! AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()

    }
    
    func playAudioWithVariablePitch(_ pitch: Float) {
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch   
        
        playAudioWithEffect(changePitchEffect)
        
    }

    @IBAction func playFastAudio(_ sender: UIButton) {
        //Play audio fast here....
        playAudio(fastplay)
    }
    
    @IBAction func playSlowAudio(_ sender: UIButton) {
        //Play audio sloooowly here....
        playAudio(slowplay)
    }
    
    // handle playback with different pitch for chipmunk and vader voices.
    
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(highpitch)
    }
    
    @IBAction func playVaderAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(lowpitch)
    }
    
    
    @IBAction func playEchoAudio(_ sender: UIButton) {
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.5
        echoEffect.feedback = 50
        echoEffect.wetDryMix = 50
        
        playAudioWithEffect(echoEffect)
        
    }
    
    @IBAction func playReverbAudio(_ sender: UIButton) {
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset(rawValue: 8)!)
        reverbEffect.wetDryMix = 50
        
        playAudioWithEffect(reverbEffect)

    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
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
