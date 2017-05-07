//
//  SoundClueViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import AVFoundation

class SoundClueViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    lazy var sound = Data()
    
    var timer : Timer?
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var soundGraph: UIImageView!
    @IBOutlet weak var lineGraph: UIImageView!
    
    @IBOutlet weak var lineGraphWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupAP () {
        lineGraph.alpha = 0
        do {
            audioPlayer = try AVAudioPlayer(data: sound)
            self.slider.maximumValue = Float(audioPlayer.duration)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Timer
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector(StepViewController.Constants.AppventureTimerFunc), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Sound Methods
    
    @IBAction func slider(_ sender: UISlider) {
        audioPlayer.currentTime = Double(slider.value)
        updateAppventureTimer()
        
    }
    @IBAction func playSound(_ sender: UIButton) {
        audioPlayer.play()
        startTimer()
        lineGraph.alpha = 1

}
    @IBAction func pauseSound(_ sender: UIButton) {
        audioPlayer.pause()
        timer?.invalidate()
    }
    @IBAction func stopSound(_ sender: UIButton) {
        audioPlayer.pause()
        audioPlayer.currentTime = 0
        timer?.invalidate()
        lineGraph.alpha = 0

    }
    
    func updateAppventureTimer() {
        
        if audioPlayer != nil {
            
            let fraction = Double(audioPlayer.currentTime)/Double(audioPlayer.duration)
            let totalLength = soundGraph.bounds.width
            
            self.lineGraphWidth.constant = -self.soundGraph.bounds.width + CGFloat(fraction * Double(totalLength))
            self.slider.value = Float(audioPlayer.currentTime)

            
            
        }
        
    }
    
}
