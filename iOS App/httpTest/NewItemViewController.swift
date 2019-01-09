//
//  NewItemViewController.swift
//  SmartHome
//
//  Created by Omri Cunio on 12/31/17.
//  Copyright © 2017 Omri Cunio. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBAction func Done(_ sender: Any) {// checks the field and sends the new accessory to the server
        var bol=true
        if(nameField.text?.isEmpty)!
        {
            nameField.placeholder="Insert a name!"
            bol=false        }
        if(portField.text?.isEmpty)!
        {
            portField.placeholder="Insert a port!"
            bol=false
        }
        if(bol==true)
        {
                a.postRequest(url: HttpRequest.ip+"/checkforport", parameters: ["port":portField.text!]) {(ans) in
                    print(ans)
                if(ans=="true"){
                    let row=self.mypicker.selectedRow(inComponent: 0)// gets the selected in type list
                        var pars=[String:Any]()
                    pars.updateValue(self.types[row], forKey: "type")
                    pars.updateValue(self.nameField.text!, forKey: "name")
                    pars.updateValue(self.portField.text!, forKey: "port")
                    pars.updateValue(self.icons[self.index], forKey: "icon")
                    self.a.postRequest(url: HttpRequest.ip+"/addnewaccessory", parameters: pars) { (ans) in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "tabs") as! TabsController//push the items
                            controller.index=1
                            self.present(controller, animated: true, completion: {
                                
                            })
                        }
                    
                }
                else
                {
                    if(ans=="false")
                    {
                        self.portField.placeholder="Port already exist!"
                        self.portField.text=""
                        
                    }
                }
            }
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //num of sections
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: types[row]) //each row in the picker and toString
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count //num of rows
    }
    @IBAction func nextbutton(_ sender: Any) { // handles next and back icon button
        let button=sender as! UIButton
        switch button.tag
        {
        case 0:
            if(index >= icons.count-1)
            {
                index=0
            }
            else
            {
                index+=1
            }
            let imgname=icons[index]
            iconimageview.image=UIImage(named: imgname)
        case 1:
            if(index <= 0)
            {
                index=icons.count-1
            }
            else
            {
                index-=1
            }
            let imgname=icons[index]
            iconimageview.image=UIImage(named: imgname)
        default:
            print("noButton")
        }
        print(index)
    }
    
    @IBOutlet weak var mytitle: UILabel!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mypicker: UIPickerView!
    var types: [type] = []
    var icons: [String] = []
    var index=0
    let a=HttpRequest()
    @IBOutlet weak var iconimageview: UIImageView!
    override func viewDidLoad() {
        types=[type.Fan,type.Lamp] //using the enum
        
        let a=iconsStruct()
        icons=a.iconArray
        //print(icons.count)
        mypicker.dataSource=self
        mypicker.delegate=self
        
        iconimageview.image=UIImage(named: icons[index])
        
        iconimageview.layer.borderWidth=3.0
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
