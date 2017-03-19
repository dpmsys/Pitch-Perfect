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
   
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playHelp: UILabel!
    
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var recordedAudioURL:URL!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    var paused: Bool? = false
    

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
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        configureUI(.notPlaying)
    }
    
    @IBAction func playSoundButtonPressed(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!){
        case  .slow:
            playSound(rate: slowplay)
        case .fast:
            playSound(rate: fastplay)
        case .chipmunk:
            playSound(pitch: highpitch)
        case .vader:
            playSound(pitch: lowpitch)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
    }
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        // stop audio
        stopAudio()
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        pauseAudio()
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
