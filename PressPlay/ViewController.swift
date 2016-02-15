//
//  ViewController.swift
//  PressPlay
//
//  Created by Hoyoung Jung on 2/1/16.
//  Copyright © 2016 Hoyoung Jung. All rights reserved.
//

import UIKit
import AVFoundation

var songs = ["Dreams Last", "Next To You", "No Pressure", "New Days", "Find Me", "Believe in Me"]

var player: AVAudioPlayer = AVAudioPlayer()

class ViewController: UIViewController, UITableViewDelegate {

    var songTitle: String = ""
    
    @IBOutlet var trackList: UITableView!
    
    @IBOutlet var musicSlider: UISlider!
    
    @IBOutlet var volumeSlider: UISlider!
    
    @IBAction func play(sender: AnyObject) {
        player.play()
        updateMusicSlider()
    }
    
    @IBAction func pause(sender: AnyObject) {
        player.pause()
    }
    
    
    
    
    @IBAction func adjustVolume(sender: AnyObject) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func musicScrub(sender: AnyObject) {
        player.currentTime = NSTimeInterval(musicSlider.value)
    }
    
    func updateMusicSlider() {
        musicSlider.value = Float(player.currentTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Syncing listArray with NSUserDefaults for permanent data storage if the NSUserDefaults exists
        if NSUserDefaults.standardUserDefaults().objectForKey("songs") != nil {
            
            songs = NSUserDefaults.standardUserDefaults().objectForKey("songs") as! [String]
            
        }
        
        do {
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Dreams Last", ofType: "mp3")!))
            musicSlider.maximumValue = Float(player.duration)
        } catch {
            // error
            print("something went wrong")
        }
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateMusicSlider"), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        songTitle = songs[indexPath.row]
        
        do {
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(songTitle, ofType: "mp3")!))
            musicSlider.maximumValue = Float(player.duration)
        } catch {
            // error
            print("something went wrong")
        }
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateMusicSlider"), userInfo: nil, repeats: true)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songs.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Track")
        
        cell.textLabel?.text = songs[indexPath.row]

        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            songs.removeAtIndex(indexPath.row)
            
            NSUserDefaults.standardUserDefaults().setObject(songs, forKey: "songs")
            
            trackList.reloadData()
            
        }
        
    }

}

