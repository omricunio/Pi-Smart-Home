//
//  ViewController.swift
//  httpTest
//
//  Created by Omri Cunio on 10/21/17.
//  Copyright © 2017 Omri Cunio. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    @IBOutlet weak var loginActivity: UIActivityIndicatorView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func SubmitButton(_ sender: Any) {
        print(usernameField.text!)
        print(passwordField.text!)
        
        var a=HttpRequest()
        var myUrl = "http://127.0.0.1:5000/login"
        myUrl+="?username="+usernameField.text!+"&password="+passwordField.text!
        loginActivity.startAnimating()
        
        a.request(url: myUrl){ ans in
            print(ans)
            self.loginActivity.stopAnimating()
            if(ans=="true")
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "tabs")
                self.present(controller, animated: true, completion: nil)
            }
            else
            {
                /*let alertController = UIAlertController(title: "Wrong Passsowrd or Username", message: "Please insert the correct Password and Username", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                
                alertController.addAction(alertAction)
                
                present(alertController, animated: true, completion: nil)*/
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginActivity.hidesWhenStopped=true
        
       /* DispatchQueue.main.async {
            print(a.ans)
        }*/
        // Do any additional setup after loading the view, typically from a nib.
    }
//    let urlToRequest = "http://www.kaleidosblog.com/tutorial/nsurlsession_tutorial.php"


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

