//
//  SelectedSongViewController.swift
//  SmartHome
//
//  Created by Omri Cunio on 11/5/17.
//  Copyright © 2017 Omri Cunio. All rights reserved.
//

import UIKit
import AVKit
import CoreData
class SelectedSongViewController: UIViewController {
    @IBOutlet weak var favoritebutton: UIButton!
    let mp = AVPlayer()
    @IBAction func Favorite(_ sender: Any) //favorite buttton (on/off)
    {
        if(favorite)// removes the song from the list
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Songs") //Connection to Core Data
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                var i=0
                for data in result as! [NSManagedObject] {
                    if(item["songname"]==(data.value(forKey: "songname") as! String) && item["artist"]==(data.value(forKey: "artist") as! String))
                    {
                        context.delete(data)
                        do {
                            try context.save()
                            favorite=false
                            let b=sender as! UIButton
                            b.setImage(UIImage(named:"blankheart"), for: UIControlState.normal)
                            break
                        }
                        catch
                        {
                            print("Failed saving")
                        }
                    }
                    
                    i+=1
                }
                
            } catch {
                
                print("Failed")
            }
        }
        else // adds the song to the the list
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Songs", in: context)
            let newSong = NSManagedObject(entity: entity!, insertInto: context)
        
            newSong.setValue(item["songname"], forKey: "songname")
            newSong.setValue(item["artist"], forKey: "artist")
            newSong.setValue(item["imageurl"], forKey: "imageurl")
            newSong.setValue(item["songurl"], forKey: "songurl")
            do {
                try context.save()
                favorite=true
                let b=sender as! UIButton
                b.setImage(UIImage(named:"redheart"), for: UIControlState.normal)
            }
            catch
            {
                print("Failed saving")
            }
        }

    }
    
    @IBAction func button(_ sender: Any) {
        if(casting)
        {
            
            if(playingOnServer)
            {
                sendaction(action: "stop")
            }
            else
            {
                sendaction(action: "play")
                if(Int(VolumeSlider.value)==0)
                {
                    sendaction(action: "setvolume&volume=50")
                }
                else
                {
                    sendaction(action: "setvolume&volume="+String(VolumeSlider.value))
                }
            }
        }
        else
        {
            if(mp.currentItem?.duration==mp.currentTime())
            {
                mp.seek(to: kCMTimeZero)
                playbutton.setImage(UIImage(named: "playicon"), for: UIControlState.normal)
            }
            else
            {
                if(mp.rate==0)
                {
                    mp.play()
                    playbutton.setImage(UIImage(named: "stopicon"), for: UIControlState.normal)
                }
                else
                {
                    mp.seek(to: kCMTimeZero)
                    mp.pause()
                    playbutton.setImage(UIImage(named: "playicon"), for: UIControlState.normal)
                }
            }
        }
    }
    
    @IBAction func castbutton(_ sender: UIButton) { //cast button-> cast mode (controls the server)
        if(casting) //stop casting
        {
           sendaction(action: "stop") //Stop Cast
           sender.backgroundColor=UIColor.gray.withAlphaComponent(0)
           playbutton.setImage(UIImage(named: "playicon"), for: UIControlState.normal)
           playingOnServer=false
           casting=false
           VolumeSlider.isHidden=true
        }
        else //start casting
        {
            playbutton.setImage(UIImage(named: "playicon"), for: UIControlState.normal) //Start Cast
            mp.seek(to: kCMTimeZero)
            mp.pause()
            let a=HttpRequest()
            let url=HttpRequest.ip+"/music?songurl="+item["songurl"]!
            let alert=UIAlertController(title: "Connecting To Your SmartHome", message: "Please Wait..", preferredStyle: UIAlertControllerStyle.alert)
            present(alert, animated: true) {

                a.request(url: url) { (ans) in
                    //sent
                    alert.dismiss(animated: true)
                    print(ans)
                    if(ans=="true")
                    {
                        sender.backgroundColor=UIColor.cyan.withAlphaComponent(0.5)
                        self.casting=true
                        self.VolumeSlider.isHidden=false

                    }
                    else
                    {
                        let erroralert=UIAlertController(title: "Error", message: "Could not connect to SmartHome", preferredStyle: UIAlertControllerStyle.alert)
                        erroralert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ans) in
                            erroralert.dismiss(animated: true)
                        }))
                        self.present(erroralert, animated: true)
                    }
                }
            }
        }
    }
    


    @IBAction func VolumeHasChanged() { //sends volume change to the server every 2%
        let volumevalue=Int(VolumeSlider.value*100)
        if(volumevalue>=oVolumeValue+2||volumevalue<=oVolumeValue-2){
            sendaction(action: "setvolume&volume="+String(volumevalue))
            print(volumevalue)
        }
        oVolumeValue=volumevalue
    }
    
    var oVolumeValue:Int=0
    @IBOutlet weak var VolumeSlider: UISlider!
    @IBOutlet weak var backimage: UIImageView!
    @IBOutlet weak var songname: UILabel!
    @IBOutlet weak var artworkimage: UIImageView!
    @IBOutlet weak var artistname: UILabel!
    @IBOutlet weak var playbutton: UIButton!
    var casting: Bool=false
    var playingOnServer: Bool=false
    var item: [String:String] = [:]
    var artwork: UIImage = UIImage()
    var favorite:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
        VolumeSlider.isHidden=true
        oVolumeValue=Int(VolumeSlider.value)
        songname.text=item["songname"]
        artistname.text=item["artist"]
        artworkimage.image=artwork
        backimage.image=artwork

        //imageView Shadow
        artworkimage.layer.shadowColor = UIColor.gray.cgColor
        artworkimage.layer.shadowOffset = CGSize(width: 0, height: 1)
        artworkimage.layer.shadowOpacity = 1
        artworkimage.layer.shadowRadius = 2
        artworkimage.clipsToBounds = false
        
        if item["favorite"] != nil
        {
            favorite=true
            favoritebutton.setImage(UIImage(named:"redheart"), for: UIControlState.normal)
        }
        print(item["songurl"]!)
        mp.replaceCurrentItem(with: AVPlayerItem(url: URL(string: item["songurl"]!)!))
        
        //creating a dataTask
        // Do any additional setup after loading the view.
    }
    
    func sendaction(action: String){ //stop or play
        let a=HttpRequest()
        let url=HttpRequest.ip+"/musicactions?action="+action
        a.request(url: url) { (ans) in
            //sent
            if(ans=="true")
            {
                if(action=="play")
                {
                    self.playbutton.setImage(UIImage(named: "stopicon"), for: UIControlState.normal)
                    self.playingOnServer=true
                }
                else
                {
                    if(action=="stop")
                    {
                        self.playbutton.setImage(UIImage(named: "playicon"), for: UIControlState.normal)
                        self.playingOnServer=false
                    }
                }
            }
        }
    }
    
    func play()
    {
        mp.play()
        //mp.replaceCurrentItem(with: AVPlayerItem(url: URL(string: item["songurl"]!)!))
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
