//
//  ViewController.swift
//  GymJamsV2
//
//  Created by Kevin Nguyen on 7/7/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
            // To do - build in error handling
            }
        }     
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
        // NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
        loginBtn.layer.cornerRadius = 25
    }
    
    func updateAfterFirstLogin () {
        print("updateAfterFirstLogin called")
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self as SPTAudioStreamingDelegate
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error == nil) {
                print("playing!")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup () {
        SPTAuth.defaultInstance().clientID = "7961aed494fc44f09442f5c523738196"
        SPTAuth.defaultInstance().redirectURL = URL(string: "gym-jams-login://callback")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }


}

