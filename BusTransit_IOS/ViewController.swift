//
//  ViewController.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-08.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UtilClass.getUIColor(hex: "#FFD100")
        // Do any additional setup after loading the view.
        
        txtEmail.layer.cornerRadius = 15.0;
        txtEmail.layer.borderWidth = 1;
        
        txtPassword.layer.cornerRadius = 15.0;
        txtPassword.layer.borderWidth = 1;
        
        btnLogin.layer.cornerRadius = 15.0;

        
//        getRandomColor()
        
    }

    
    func getRandomColor() {
        let red   = CGFloat((arc4random() % 256)) / 255.0
        let green = CGFloat((arc4random() % 256)) / 255.0
        let blue  = CGFloat((arc4random() % 256)) / 255.0
        let alpha = CGFloat(1.0)

        UIView.animate(withDuration: 1.0, delay: 0.0, options:[.repeat, .autoreverse], animations: {
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }, completion:nil)
    }

}

