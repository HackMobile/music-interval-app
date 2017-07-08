//
//  ViewController.swift
//  GymJams
//
//  Created by Kevin Nguyen on 7/7/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var auth = SPTAuth.defaultInstance()
    var loginURL: URL?
    
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    
    let clientId = "7961aed494fc44f09442f5c523738196"
    let callbackURL = "gym-jams-login://callback"

    @IBAction func loginButtonPressed(_ sender: Any) {
        print("hi")
        if UIApplication.shared.canOpenURL(loginURL!) {
            
            UIApplication.shared.open(loginURL!, options: [:], completionHandler: nil)
            if (auth?.canHandle(auth?.redirectURL))! {
                // To do - build in error handling
            }
        }
        
    }
    
    override func viewDidLoad() {
        print("hii")
        super.viewDidLoad()
        // NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin))
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
    }
    
    func updateAfterFirstLogin () {
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
            self.player!.playbackDelegate = self as! SPTAudioStreamingPlaybackDelegate
            self.player!.delegate = self as! SPTAudioStreamingDelegate
            try! player!.start(withClientId: auth?.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup () {
        auth!.clientID = clientId
        auth!.redirectURL = URL(string: callbackURL)
        auth!.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope]
        loginURL = auth!.spotifyAppAuthenticationURL()
    }

}

