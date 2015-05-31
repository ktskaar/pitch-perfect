//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kirk Skaar on 05/12/2015.
//  Copyright (c) 2015 SixOneZero. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButtonEnabled: UIButton!
    @IBOutlet weak var resumeButtonEnabled: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.recordingStatusLabel.text = "Tap to start recording"
        self.recordButton.enabled = true
        self.pauseButtonEnabled.hidden = true
        self.resumeButtonEnabled.hidden = true
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide stop button
        self.recordingStatusLabel.text = "Tap to start recording"
        self.stopButton.hidden = true
        self.recordButton.hidden = false
        self.pauseButtonEnabled.hidden = true
        self.resumeButtonEnabled.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {

        self.recordingStatusLabel.text = "Recording"
        self.stopButton.hidden = false
        self.recordButton.hidden = true
        self.pauseButtonEnabled.hidden = false
        self.resumeButtonEnabled.hidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseAudioRecording(sender: UIButton) {
        audioRecorder.pause()
        self.recordingStatusLabel.text = "Recording paused"
        self.resumeButtonEnabled.hidden = false
        self.pauseButtonEnabled.hidden = true
    }
    
    @IBAction func resumeAudioRecording(sender: UIButton) {
        audioRecorder.record()
        self.recordingStatusLabel.text = "Recording"
        self.resumeButtonEnabled.hidden = true
        self.pauseButtonEnabled.hidden = false
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
        
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            self.recordButton.hidden = false
            self.stopButton.hidden = true
            self.pauseButtonEnabled.hidden = true
            self.resumeButtonEnabled.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
            
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        self.stopButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
}

