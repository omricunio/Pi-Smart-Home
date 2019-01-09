//
//  MusicTableViewController.swift
//  SmartHome
//
//  Created by Omri Cunio on 11/4/17.
//  Copyright © 2017 Omri Cunio. All rights reserved.
//

import UIKit

class MusicTableViewController: UITableViewController {
    var items: [[String:String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(items)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let miniImage=cell.viewWithTag(1) as! UIImageView
        let songname=cell.viewWithTag(2) as! UILabel
        let artistname=cell.viewWithTag(3) as! UILabel
        
        let a = HttpRequest()
        let item=items[indexPath.row]
        if let imgurl=item["imageurl"]
        {
            a.imagerequest(url: imgurl+"200x200.jpg") { ans in
                DispatchQueue.main.async {
                    miniImage.image=ans
                }
            }
        }
        if let sname=item["songname"]
        {
            songname.text=sname
        }
        if let arname=item["artist"]
        {
            artistname.text=arname
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let a = HttpRequest()
        let itemforimage=items[indexPath.row]
        let alert=UIAlertController(title: "Loading", message: "Please Wait..", preferredStyle: UIAlertControllerStyle.alert )
        present(alert, animated: true) {
            a.imagerequest(url: itemforimage["imageurl"]!+"600x600.jpg") { ans in
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SelectedSongViewController") as! SelectedSongViewController
                    controller.item=self.items[indexPath.row] //push the items
                    controller.artwork=ans
                    alert.dismiss(animated: true, completion: {
                        self.navigationController?.pushViewController(controller, animated: true)
                    })
                }
            }
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
