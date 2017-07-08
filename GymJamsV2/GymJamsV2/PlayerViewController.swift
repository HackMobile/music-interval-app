//
//  PlayerViewController.swift
//  GymJamsV2
//
//  Created by Kyle on 7/8/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    @IBAction func prevButtonPressed(_ sender: Any) {
        player?.skipPrevious({(error) in
            if error != nil {
                print("Error: couldn't skip");
            } else {
                print ("Skipping Previous")
            }
        });
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        player?.skipNext({(error) in
            if error != nil {
                print("Error: couldn't skip");
            } else {
                print ("Skipping next")
            }
        });
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player?.setShuffle(true, callback: {(error) in
            if error != nil {
                print("Error: couldn't shuffle");
            } else {
                print ("Shuffling")
            }
        });
        // Do any additional setup after loading the view.
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
