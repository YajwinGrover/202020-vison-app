//
//  ViewController.swift
//  20 20 20 vision app
//
//  Created by Yajwin Grover on 11/18/20.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    
    @IBOutlet weak var display: NSTextField!
    @IBOutlet weak var start: NSButton!
    @IBOutlet weak var reset: NSButton!
    
    @IBOutlet weak var muteToggle: NSButton!
    var minutes = 10;
    var seconds = 0;
    var player: AVAudioPlayer?
    
    var timer = Timer()
    var countdownTimer = Timer()
    var notStartedTimer = Timer()
    
    var estimatedHour: Int = 0
    var estimatedMinute: Int = 0
    
    var buttons: [NSButton] = []
    
    @IBOutlet weak var bar1: NSButton!
    @IBOutlet weak var bar2: NSButton!
    @IBOutlet weak var bar3: NSButton!
    @IBOutlet weak var bar4: NSButton!
    @IBOutlet weak var bar5: NSButton!
    @IBOutlet weak var bar6: NSButton!
    @IBOutlet weak var bar7: NSButton!
    @IBOutlet weak var bar8: NSButton!
    @IBOutlet weak var bar9: NSButton!
    @IBOutlet weak var bar10: NSButton!
    
    var counter = 0;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset.isHidden = true
        buttons = [bar1,bar2,bar3,bar4,bar5,bar6,bar7,bar8,bar9,bar10]
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(ViewController.startTime(_:)), userInfo: nil, repeats: true)
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    
    @IBAction func reset(_ sender : Any?){
        timer.invalidate()
        start.isHidden = false
        reset.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(ViewController.startTime(_:)), userInfo: nil, repeats: true)
    }
   
    
    
    
    
    
    @objc func timeEnded() {
        timer.invalidate()
        let notification = NSUserNotification()
        notification.title = "20 minutes is up"
        notification.subtitle = "Look 20 feet away fro 20 seconds"
        NSUserNotificationCenter.default.deliver(notification)
        if(muteToggle.state == .off){
            playSound(file: "DigitalTone", ext: "wav")
        }
       
        
        countdown()
        
        
    }
    
    
    @objc func countdown(){
        countdownTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.removeBoxes), userInfo: nil, repeats: true)
    }
    
    @objc func removeBoxes(){
        buttons[counter].isHidden = true
        counter += 1
        if (counter >= 10){
            stopCountdown()
        }
    }
    @objc func stopCountdown(){
        countdownTimer.invalidate()
        minutes = 10
        seconds = 0
        counter = 0
        if(muteToggle.state == .off){
            playSound(file:"GongSound", ext:"wav")
        }
       
        
        for button in buttons{
            button.isHidden = false
        }
       startTime(self)
    }
    
    @objc func playSound(file:String, ext:String){
        let path = Bundle.main.path(forResource: file, ofType: ext)!
        let url = URL(fileURLWithPath: path)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            
            
            
            player?.play()
            
        }
        catch let error{
            print(error.localizedDescription);
        }
    }
    
    @IBAction func startTime(_ sender : Any?){
        timer.invalidate();
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        estimatedMinute = minutes + 10
        estimatedHour = hour
        
        if estimatedMinute >= 60 {
            estimatedMinute -= 60
            estimatedHour += 1
        }
        
        if estimatedHour > 12 {
            estimatedHour = estimatedHour - 12
        }
        
        start.isHidden = true
        reset.isHidden = false
        
        update()
        
        timer = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(ViewController.timeEnded), userInfo: nil, repeats: true)
    }
    
    
    @objc func update(){
        display.stringValue = String(estimatedHour) + ":" + String(estimatedMinute)
    }
    
    
    
    
}

