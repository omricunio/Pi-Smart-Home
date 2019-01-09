//
//  SecondViewController.swift
//  httpTest
//
//  Created by Omri Cunio on 10/26/17.
//  Copyright © 2017 Omri Cunio. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var a=HttpRequest()
        var myUrl = "http://127.0.0.1:5000/info"
        //myUrl+="?username="+usernameField.text!+"&password="+passwordField.text!
        
        a.request(url: myUrl){ ans in
            print(ans)
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
