//
//  ChooseMusicViewController.swift
//  SmartHome
//
//  Created by Omri Cunio on 11/4/17.
//  Copyright © 2017 Omri Cunio. All rights reserved.
//

import UIKit
import CoreData
class ChooseMusicViewController: UIViewController {
    
    //var dic: [String:String] = [:]
    var items: [[String:String]] = [] //the songs
    
    @IBAction func Favorites(_ sender: Any) {
        items.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Songs")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var i=0
            for data in result as! [NSManagedObject] {
                items.append([String:String]())
                
                items[i]["songname"]=(data.value(forKey: "songname") as! String)
                items[i]["artist"]=(data.value(forKey: "artist") as! String)
                items[i]["imageurl"]=(data.value(forKey: "imageurl") as! String)
                items[i]["songurl"]=(data.value(forKey: "songurl") as! String)
                items[i]["favorite"]="yes"
                
                i+=1
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "musictableviewcontroller") as! MusicTableViewController
            controller.items=items //push the items
            navigationController?.pushViewController(controller, animated: true)//present view
            
        } catch {
            
            print("Failed")
        }

    }
    @IBOutlet weak var searchField: UITextField!
    @IBAction func Finish(_ sender: Any) { //submit button
        send()
    }
    func send() // send a request to apple's servers
    {
        let alert=UIAlertController(title: "Searching The Song", message: "Please Wait..", preferredStyle: UIAlertControllerStyle.alert)
        present(alert,animated: true){
            let str=self.searchField.text
            var newstr=String()
            for char in (str?.characters)!{ // " " to -> "+"
                if(char==" ")
                {
                    newstr.append("+")
                }
                else
                {
                    newstr.append(char)
                }
            }
            print(newstr)
            let a=HttpRequest()
            let myUrl = "https://itunes.apple.com/search?term="+newstr
            
            a.request(url: myUrl){ ans in
                self.parse(ans: ans)
                alert.dismiss(animated: true, completion: {
                    
                    
                })
            }
        }
    }
    func parse(ans: String)
    {
        items.removeAll()
        do {
            let json = try JSONSerialization.jsonObject(with: ans.data(using: .utf8)!, options: []) as? [String:Any] // convert to Dict[String:AnyObject]
            if let results = json!["results"] as? NSArray//get the results in the json
            {
                for i in 0..<results.count //all the songs he found in iTunes
                {
                    if let item = results[i] as? NSDictionary
                    {
                        //print(item)
                        items.append([String:String]())//new Dict
                        if let songname = item["trackName"] as? String
                        {
                            items[i]["songname"]=songname
                        }
                        if let artist = item["artistName"] as? String
                        {
                            items[i]["artist"]=artist
                        }
                        if let imageurl = item["artworkUrl100"] as? String // **High-Res image**
                        {
                            let imag=imageurl.dropLast(13)
                            items[i]["imageurl"]=String(imag)
                            
                        }
                        if let previewurl = item["previewUrl"] as? String
                        {
                            items[i]["songurl"]=previewurl
                        }
                    }
                }
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "musictableviewcontroller") as! MusicTableViewController
            controller.items=items //push the items
            navigationController?.pushViewController(controller, animated: true)//present view controller
            /*for i in 0..<items.count{
                print(items[i]["songname"]!+" ")
                print(items[i]["artist"]!+" ")
                print(items[i]["songurl"]!+" ")
                print("/n")
            }*/
            //let item = results![0] as? NSDictionary//final song
            //print(item!["artistId"]!)
        }
        catch
        {
            print("ERROR")
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
