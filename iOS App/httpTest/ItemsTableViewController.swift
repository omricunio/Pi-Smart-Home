//
//  ItemsTableViewController.swift
//  SmartHome
//
//  Created by Omri Cunio on 11/2/17.
//  Copyrigh
// © 2017 Omri Cunio. All rights reserved.
//

import UIKit
import Foundation

class ItemsTableViewController: UITableViewController{
    
    @IBOutlet weak var onoffbutton: UIBarButtonItem!
    @IBAction func poweronoff(_ sender: Any) {
        turnfunc()
    }
    
    func turnfunc() //turn all the accessorys on or off
    {
        if(ison==true)
        {
            a.postRequest(url: HttpRequest.ip+"/turnall", parameters: ["state" : "off"]) { (ans) in
            if(ans=="true")
            {
                self.onoffbutton.tintColor=UIColor.green
                self.ison=false
                self.data.removeAll()
                self.fetchData()
            }
            }
        }
        else
        {
            if(ison==false)
            {
                a.postRequest(url: HttpRequest.ip+"/turnall", parameters: ["state" : "on"]) { (ans) in
                    if(ans=="true")
                    {
                            self.onoffbutton.tintColor=UIColor.red
                            self.ison=true
                            self.data.removeAll()
                            self.fetchData()
                    }
                }
            }
        }
    }
    @IBAction func addButton(_ sender: Any) { //launch the new item viem view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newitemviewcontroller") as! NewItemViewController//push the items
        navigationController?.pushViewController(controller, animated: true)
        
    }
    @objc func reload() // reloads the accessorys table
    {
        data.removeAll()
        fetchData()
    }
    func fetchData() // sends 2 requests in order to get all the accessorys and their state, calls the function that parse the json (2 different functions)
    {
        a.request(url: HttpRequest.ip+"/getaccessorys"){
            ans in
            self.parseJSONAccessorys(ans: ans)

            self.a.request(url: HttpRequest.ip+"/getaccessorysstatus", completion: { (ans) in
                self.parseAccessorysState(ans: ans)
                print(self.data)
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
            
        }
    }
    func parseAccessorysState(ans: String)
    {
        do
        {
            print(ans)
            let json = try JSONSerialization.jsonObject(with: ans.data(using: .utf8)!, options: []) as? [String:Any]
            statejson=json!
            
        }
        catch
        {
            print(error)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            a.postRequest(url: HttpRequest.ip+"/removeaccessory", parameters: ["id" : data[indexPath.row].id!], completion: { (ans) in
                if(ans=="true")
                {
                    self.data.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                }
            })
        }
    }
    let a=HttpRequest()
    private var data = [accessory]()
    private var statejson:[String:Any]?
    var ison=false
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshcontrol=UIRefreshControl()
        self.refreshControl=refreshcontrol
        //data.append(accessory(type: type.Lamp, name: "myLamp", port: 12, icon: UIImage(named: "bulb")!, id: "1"))
        tableView.dataSource = self
        refreshcontrol.addTarget(self, action: #selector(reload), for: .valueChanged)
        fetchData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    func parseJSONAccessorys(ans: String)// parses the json file, adds the accessorys to an array with accessory objects
    {
        do {
            let json = try JSONSerialization.jsonObject(with: ans.data(using: .utf8)!, options: []) as? [String:Any] // convert to Dict[String:AnyObject]
            if let items = json!["Accessorys"] as? NSArray//get the results in the json
            {
                for i in 0..<items.count
                {
                    if let item=items[i] as? NSDictionary
                    {
                        var name=""
                        var id=""
                        var typeenum:type=type()
                        var port:Int=Int()
                        var icon:UIImage=UIImage()
                        if let idO=item["id"]
                        {
                            id=idO as! String
                        }
                        if let typeO=item["type"]
                        {
                            let typestring=typeO as! String
                            typeenum=type(value: typestring)
                        }
                        if let nameO=item["name"]
                        {
                            name=nameO as! String
                        }
                        if let portO=item["port"]
                        {
                            port=Int(portO as! String)!
                        }
                        if let iconO=item["icon"]
                        {
                            let path=iconO as! String
                            if let iconimg=UIImage(named: path)
                            {
                                icon=iconimg
                            }
                        }
                        data.append(accessory(type: typeenum, name: name, port: port, icon: icon, id: id))
                    }
                }
            }
        }
        catch
        {
            print("ERROR")
        }
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
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {// adds data to each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! as! customCell
        //custom class: customCell is below
        let ac = data[indexPath.row] //accessory object
        cell.onoff.tag=indexPath.row+1
        cell.AccessoryObject=ac
        if let text = ac.name
        {
            cell.label.text = text//text
        }
        if let dtype = ac.type
        {
            cell.actype.text=String(describing: dtype)
        }
        if let img=ac.icon
        {
            cell.cellImage.image=img
        }
        
        if let port = ac.port
        {
            if let stateobj=statejson
            {
                if let state=stateobj[String(port)] as? Int //searches the spesific port on the state list and set it's initial state
                {
                    if(state==0)
                        {
                            cell.onoff.setOn(false, animated: true)
                        }
                        else
                        {
                            if(state==1)
                            {
                                cell.onoff.setOn(true, animated: true)
                            }
                        }
                    
                }
            }
        }
        return cell
    }

    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //user taps the cell calls item view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController// convert it to ItemViewController
        if let name=data[indexPath.row].name
        {
            controller.itemname=name
        }
        if let portnumber=data[indexPath.row].port
        {
            controller.portnumber=portnumber
        }
        if let typename=data[indexPath.row].type?.description
        {
            controller.typename=typename
        }
        let cell = tableView.cellForRow(at: indexPath) as! customCell
        controller.previewimg=cell.cellImage.image
        controller.onoffinitialstate = cell.onoff.isOn.hashValue
        navigationController?.pushViewController(controller, animated: true)
    }
    

}

class customCell : UITableViewCell {
    @IBOutlet weak var onoff: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var actype: UILabel!
    @IBOutlet var cellImage: UIImageView!
    var AccessoryObject: accessory?
    
    @IBAction func onoffpressed(_ sender: Any) {
                let a=HttpRequest()
                print(HttpRequest.ip+"  operation")
                var url = HttpRequest.ip+"/changeaccessorystate?state="+String(onoff.isOn)
                if let obj=AccessoryObject
                {
                    url += "&port="+String(describing: obj.port!)
                    a.request(url: url, completion: { (ans) in
                        
                    })
                }
        }
    }
  

