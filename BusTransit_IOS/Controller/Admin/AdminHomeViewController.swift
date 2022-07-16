//
//  AdminHomeViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-15.
//

import UIKit

class AdminHomeViewController: UIViewController {

    @IBOutlet weak var schoolCountView: UIView!
    @IBOutlet weak var busCountView: UIView!
    @IBOutlet weak var driverCountView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolCountView.layer.cornerRadius = 20
        busCountView.layer.cornerRadius = 20
        driverCountView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logoutHandler(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
