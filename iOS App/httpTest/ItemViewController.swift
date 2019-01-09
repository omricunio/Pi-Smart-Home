//
//  ItemViewController.swift
//  SmartHome
//
//  Created by Omri Cunio on 2/11/18.
//  Copyright © 2018 Omri Cunio. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    @IBOutlet weak var timerField: UITextField!
    @IBOutlet weak var PortNumberLabel: UILabel!
    @IBOutlet weak var TypeNameLabel: UILabel!
    @IBOutlet weak var onoff: UISwitch!
    @IBOutlet public var label: UILabel!
    @IBOutlet weak var preview: UIImageView!
    let a=HttpRequest()
    @IBAction func onoffpressed(_ sender: Any) {
        print(HttpRequest.ip+"  operation")
        var url = HttpRequest.ip+"/changeaccessorystate?state="+String(onoff.isOn)
            url += "&port="+String(describing: portnumber)
            a.request(url: url, completion: { (ans) in
                
            })
    }
    @IBAction func timerFieldSubmit(_ sender: Any) { //sends timer action
        if(timerField.text?.isEmpty)!
        {
            timerField.placeholder="Insert how many seconds"
        }
        else
        {
            let url=HttpRequest.ip+"/accessorytimer?time="+timerField.text!+"&port="+String(describing: portnumber)
            a.request(url: url, completion: { (ans) in
            })
        }
    }
    
    var previewimg:UIImage?
    var onoffinitialstate: Int = 0
    var portnumber: Int = 0
    var typename: String = ""
    var itemname: String = "" //object in swift must have a initial value
    override func viewDidLoad() {
        super.viewDidLoad()
        preview.image=previewimg
        label.text=itemname
        TypeNameLabel.text=typename
        PortNumberLabel.text=String(portnumber)
        if(onoffinitialstate==0)
        {
            onoff.setOn(false, animated: true)
        }
        else
        {
            if(onoffinitialstate==1)
            {
                onoff.setOn(true, animated: true)
            }
        }
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
