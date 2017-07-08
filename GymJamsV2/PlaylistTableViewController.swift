//
//  PlaylistTableViewController.swift
//  GymJamsV2
//
//  Created by Robert Posada on 7/8/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UITableViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    // Mark: properties
    
    var playlists = [String]()
    var playlistUris = [URL]()
    
    var player: SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SPTPlaylistList.playlists(forUser: sesh!.canonicalUsername, withAccessToken: sesh!.accessToken, callback: { (error, results) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let playLists = results as! SPTListPage
                for playList in playLists.items {
                    if let playlist = playList as? SPTPartialPlaylist {
                        self.playlists.append(playlist.name)
                        self.playlistUris.append(playlist.uri)
                    }
                }
                self.tableView.reloadData()
            }
        })
        
        initializePlayer(authSession: sesh!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playlists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlaylistTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaylistTableViewCell else {
            fatalError("The dequeue cell is not an instance of playlisttableviewcell")
        }
        let playlist = playlists[indexPath.row]
        cell.nameLabel.text = playlist
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell \(indexPath.row) selected")
        print(playlistUris[indexPath.row])
        let uri: String = playlistUris[indexPath.row].absoluteString
        print("uri: " + uri)
        player?.playSpotifyURI(uri, startingWith: 0, startingWithPosition: 2) { error in
            print("inside audio callback")
            if error != nil {
                print("*** failed to play: \(String(describing: error))")
                return
            }
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
