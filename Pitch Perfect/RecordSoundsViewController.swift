//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by David Mulvihill on 3/19/15.
//  Copyright (c) 2015 David Mulvihill. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var micHelp: UILabel!

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var paused: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        micHelp.text = "Press mic to Record"
        pauseButton.isHidden = true
        stopButton.isHidden = true
        recordButton.isEnabled = true
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.string(from: currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        micHelp.text = "Recording in progress..."
        
        recordButton.isEnabled = false
        pauseButton.isHidden = false
        stopButton.isHidden = false

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()                                                         
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
        
            //Move to the next scene aka perform seque
            self.performSegue(withIdentifier: "stopRecording", sender: recorder.url)
            
        }else{
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
            pauseButton.isHidden = true
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    @IBAction func pauseRecording(_ sender: UIButton) {
        if (paused == true) {
            paused = false
            micHelp.text = "Recording in progress..."
            audioRecorder.record()
        }else{
            paused = true
            micHelp.text = "Recording paused"
            audioRecorder.pause()
        }
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recordButton.isEnabled = true
        stopButton.isHidden = true
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
}
