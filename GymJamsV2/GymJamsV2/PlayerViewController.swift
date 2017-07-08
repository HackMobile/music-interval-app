//
//  PlayerViewController.swift
//  GymJamsV2
//
//  Created by Kyle on 7/8/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate{
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var updateAlbum: UILabel!
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        
        sliderValueLabel.text = "\(currentValue)"
        sliderVal = currentValue
    }
    @IBOutlet weak var updateName: UILabel!
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
        player?.seek(to: 30, callback: {(error) in
            if error != nil {
                print("Error: couldn't skip");
            } else {
                print ("Skipping Previous")
            }
        });
        updateName.text = metadata.currentTrack?.name;
        updateAlbum.text = metadata.currentTrack?.artistName;
        
        var cover = metadata.currentTrack?.albumCoverArtURL;
        
    }
    
    var timer_ = Timer()
    
    @IBAction func playButtonPressed(_ sender: Any) {
        if (player?.playbackState.isPlaying)! {
            player?.setIsPlaying(false, callback: {(error) in
                if error != nil {
                    print("Error: couldn't pause");
                } else {
                    print ("Pausing")
                }
            });
            timer.invalidate()
        } else {
            player?.setIsPlaying(true, callback: {(error) in
                if error != nil {
                    print("Error: couldn't start");
                } else {
                    print ("Starting")
                }
            });
            setTimer()
        }
    }
    
    @IBAction func prevButtonPressed(_ sender: Any) {
        player?.skipPrevious({(error) in
            if error != nil {
                print("Error: couldn't skip");
            } else {
                print ("Skipping Previous")
            }
        });
        counter = sliderVal
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        player?.skipNext({(error) in
            if error != nil {
                print("Error: couldn't skip");
            } else {
                print ("Skipping next")
            }
        });
        counter = sliderVal
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = String(counter)
        
        player?.setShuffle(true, callback: {(error) in
            if error != nil {
                print("Error: couldn't shuffle")
            } else {
                print ("Shuffling")
            }
        });
        
        player!.playbackDelegate = self
        player!.delegate = self as SPTAudioStreamingDelegate
        
        // Do any additional setup after loading the view.
        timer_ = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector: #selector(PlayerViewController.updateCounter), userInfo: nil, repeats: true)
    }
    
    func updateCounter() {
        timerLabel.text = String(counter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
