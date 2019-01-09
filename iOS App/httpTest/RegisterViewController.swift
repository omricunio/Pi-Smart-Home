//
//  RegisterViewController.swift
//  httpTest
//
//  Created by Omri Cunio on 10/27/17.
//  Copyright © 2017 Omri Cunio. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBAction func SubmitButton(_ sender: Any) {
        print(usernameField.text!)
        print(passwordField.text!)
        
        var a=HttpRequest()
        var myUrl = "http://127.0.0.1:5000/register"
        myUrl+="?username="+usernameField.text!+"&password="+passwordField.text!
        
        a.request(url: myUrl){ ans in
            print(ans)
            if(ans=="true")
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
                self.present(controller, animated: true, completion: nil)
            }
        }
    
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
