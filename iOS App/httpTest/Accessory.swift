//
//  Lamp.swift
//  SmartHome
//
//  Created by Omri Cunio on 1/2/18.
//  Copyright © 2018 Omri Cunio. All rights reserved.
//

import Foundation
import UIKit
class accessory
{
    let type: type?
    let name: String?
    let port: Int?
    let icon: UIImage?
    let id: String?
    init(type: type, name: String, port: Int, icon: UIImage, id: String)
    {
        self.type=type
        self.name=name
        self.port=port
        self.icon=icon
        self.id=id
    }
}
extension accessory: CustomStringConvertible{
    var description: String{
        return "type: \(type!) name: \(name!) port: \(port!) icon: \(icon!) id: \(id!)"
    }
}
enum type{
    case Lamp
    case Fan
    case None
    init(value: String)
    {
        switch value{
        case "Fan":
            self = .Fan
        case "Lamp":
            self = .Lamp
        default:
            print("No Compatible Value")
            self = .None
        }
    }
    var description: String{
        switch self{
        case .Lamp:
            return "Lamp"
        case .Fan:
            return "Fan"
        case .None:
            return "None"
        }
    }
    init()
    {
        self = .None
    }
}
