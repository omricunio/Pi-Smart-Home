//
//  IpEditorViewController.swift
//  SmartHome
//
//  Created by Omri Cunio on 4/9/18.
//  Copyright © 2018 Omri Cunio. All rights reserved.
//

import UIKit

class IpEditorViewController: UIViewController {

    @IBAction func done(_ sender: Any) {
        HttpRequest.ip=ipField.text!
    }
    @IBOutlet weak var ipField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ipField.text=HttpRequest.ip
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
