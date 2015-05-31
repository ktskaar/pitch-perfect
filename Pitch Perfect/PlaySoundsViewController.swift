//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kirk Skaar on 05/17/2015.
//  Copyright (c) 2015 SixOneZero. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    // var playSpeed: Float!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // path to audio file
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        playSound(0.7, volume: 1.0, delay: 0.0, andEcho: false)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playSound(1.5, volume: 1.0, delay: 0.0, andEcho: false)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioReverbAffect = AVAudioUnitReverb()
        audioReverbAffect.wetDryMix = 100
        audioReverbAffect.loadFactoryPreset(AVAudioUnitReverbPreset(rawValue: 4)!)
        audioEngine.attachNode(audioReverbAffect)
        
        audioEngine.connect(audioPlayerNode, to: audioReverbAffect, format: nil)
        audioEngine.connect(audioReverbAffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playSound(1.0, volume: 1.0, delay: 0.0, andEcho: true)
    }
    
    func playSound(atRate: Float, volume: Float, delay: Double, andEcho: Bool) {
        
        var playTime:NSTimeInterval
        playTime = audioPlayer.deviceCurrentTime + delay
        
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = atRate
        audioPlayer.volume = volume
        audioPlayer.playAtTime(playTime)
        if (andEcho){
            audioPlayer2.currentTime = 0.0
            audioPlayer2.rate = atRate
            audioPlayer2.volume = 0.6
            audioPlayer2.playAtTime(playTime + 0.2)
        }
    }
    
    @IBAction func stopAudioPlay(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        // audioEngine.reset()
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
