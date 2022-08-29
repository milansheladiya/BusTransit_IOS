//
//  NoBusAssignedViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-08-28.
//

import UIKit

class NoBusAssignedViewController: UIViewController {

    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitle.title = UserList.GlobleUser.fullName
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
