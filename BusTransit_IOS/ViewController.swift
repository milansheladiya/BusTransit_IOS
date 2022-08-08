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
    
    let fb = FirebaseUtil()
    
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
        let emailFromUI = (txtEmail.text != nil) ? txtEmail.text : "admin"
        let passwordFromUI = (txtPassword.text != nil) ? txtPassword.text : "admin"
        
        
//        if (!UtilClass.isValidEmail(txtEmail.text!))
//        {
//            UtilClass._Alert(self, "Error", "Invalid Email!")
//            return
//        }
        
        if emailFromUI == "admin" && passwordFromUI == "admin"
        {
            print("Call")
            self.performSegue(withIdentifier: "goToAdmin", sender: self)
        }else{
            loginWithFirebase(email: emailFromUI ?? "",password: passwordFromUI ?? "")
        }
                
        
    }
    
    @IBAction func tabSignUp(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToSignup", sender: self)
        
//        self.performSegue(withIdentifier: "goToParentStory", sender: self)
        
    }
    
    
    func navigateToScreen(screenId: String){
        self.performSegue(withIdentifier: screenId, sender: self)
    }
    func loginWithFirebase(email: String , password: String){
        FirebaseUtil.signIn(email: email, pass: password) {
            [weak self] (success) in
                if (success != "") {
                    UtilClass._Alert(self!, "Error", success)
                    return
                }
            FirebaseUtil._db.collection("User").document(FirebaseUtil.auth.currentUser!.uid).getDocument { (docSnapshot, error) in
                if let doc = docSnapshot {
                    let userType = doc.get("user_type") as! String
                    UserList.GlobleUser = User(
                        user_id: doc.get("user_id") as! String,
                        bus_id: doc.get("bus_id") as! String,
                        email_id: doc.get("email_id") as! String,
                        fullName: doc.get("fullName") as! String,
                        gender: doc.get("gender") as! String,
                        phone_no: doc.get("phone_no") as! String,
                        address: doc.get("address") as! String,
                        user_lat: doc.get("user_lat") as! String,
                        user_long: doc.get("user_long") as! String,
                        photo_url: doc.get("photo_url") as! String,
                        user_type: doc.get("user_type") as! String,
                        school_id: doc.get("school_id") as! [String])
                    if(userType == Constants.DRIVER){
                        self?.navigateToScreen(screenId: "goToDriver")
                    }else{
                        self?.navigateToScreen(screenId: "goToParent")
                    }
                }
            }
        }

    }
    
    
   
}

