//
//  CustomTabBarControllerParent.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-08-15.
//

import UIKit

class CustomTabBarControllerParent:UITabBarController
{
    
    @IBInspectable var initialIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
    }
    
}
