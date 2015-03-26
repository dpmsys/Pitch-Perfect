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
    var paused: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        micHelp.text = "Tap to Record"
        pauseButton.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        micHelp.text = "Recording in progress..."
        
        recordButton.enabled = false
        pauseButton.hidden = false
        stopButton.hidden = false

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()                                                         
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            //save the recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url,title: recorder.url.lastPathComponent)
        
            //Move to the next scene aka perform seque
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as
                 PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        if (paused) {
            paused = false
            micHelp.text = "Recording in progress..."
            audioRecorder.record()
        }else{
            paused = true
            micHelp.text = "Recording paused"
            audioRecorder.pause()
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordButton.enabled = true
        stopButton.hidden = true
        
        audioRecorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
}
