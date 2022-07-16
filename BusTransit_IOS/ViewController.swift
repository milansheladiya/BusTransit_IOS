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
    
    
    @IBOutlet weak var imgLoginWithApple: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.layer.cornerRadius = 15.0;
        txtEmail.layer.borderWidth = 1;
        
        txtPassword.layer.cornerRadius = 15.0;
        txtPassword.layer.borderWidth = 1;
        
        btnLogin.layer.cornerRadius = 15.0;
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAdmin"{
            
//            let nav = segue.destination as! UINavigationController
//            let destinationVC = nav.topViewController as! AdminHomeViewController
//            let destinationVC = segue.destination as! ViewMoreDishesViewController
        }
        
    }
    @IBAction func tabLogin(_ sender: UIButton) {
        let emailFromUI = (txtEmail.text != nil) ? txtEmail.text : ""
        let passwordFromUI = (txtPassword.text != nil) ? txtPassword.text : ""
        
        
//        if (!UtilClass.isValidEmail(txtEmail.text!))
//        {
//            UtilClass._Alert(self, "Error", "Invalid Email!")
//            return
//        }
        
        if emailFromUI == "admin" && passwordFromUI == "admin"
        {
            self.performSegue(withIdentifier: "goToAdmin", sender: self)
        }else{
            loginWithFirebase(email: emailFromUI ?? "",password: passwordFromUI ?? "")
        }
                
        
    }
    
    @IBAction func tabSignUp(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToAdmin", sender: self)
        
        
    }
    func loginWithFirebase(email: String , password: String){
        FirebaseUtil.signIn(email: email, pass: password) {
            [weak self] (success) in
                if (success != "") {
                    print("--------> ", success)
                    UtilClass._Alert(self!, "Error", success)
                    return
                }
            else
            {
                UtilClass._Alert(self!, "Success", "Login successed \(FirebaseUtil.auth.currentUser?.uid ?? "M2ND")")
            }
        
        }

    }

}

