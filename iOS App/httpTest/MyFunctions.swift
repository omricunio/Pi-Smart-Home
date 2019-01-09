//
//  MyFunctions.swift
//  httpTest
//
//  Created by Omri Cunio on 10/23/17.
//  Copyright © 2017 Omri Cunio. All rights reserved.
//

import Foundation
import Alamofire
class HttpRequest{
    
    
    static var ip="http://172.20.10.4:5000"
    //let ip="http://omripi:5000"
    func request(url: String, completion :@escaping (String)->()){  // HTTP Request Using AlamoFire module
        Alamofire.request(url).responseData { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)") // original server data as UTF8 string
                completion(utf8Text)
            }
            else
            {
                completion("false")
            }
        }
    }
    func postRequest(url: String, parameters: [String:Any], completion: @escaping (String)->()){
        Alamofire.request(url, method: .post, parameters: parameters).responseData {
            response in
            if let data=response.data, let utf8Text = String(data: data, encoding: .utf8)
            {
                completion(utf8Text)
            }
        }
    }
    func imagerequest(url: String, completion :@escaping (UIImage)->()){  // HTTP Image Request
        let imageurl = URL(string: url)
        let session = URLSession(configuration: .default)
        let getImageFromUrl = session.dataTask(with: imageurl!) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        if let image = UIImage(data: imageData)
                        {
                            //displaying the image
                            completion(image)
                        }
                        
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        getImageFromUrl.resume()
    }
    
}
