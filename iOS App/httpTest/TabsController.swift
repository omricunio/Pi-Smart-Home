//
//  TabsController.swift
//  SmartHome
//
//  Created by Omri Cunio on 1/15/18.
//  Copyright © 2018 Omri Cunio. All rights reserved.
//

import Foundation
import UIKit
class TabsController: UITabBarController {
    
    public var index=0
    override func viewDidLoad() {
        self.selectedIndex=index
    }

}
