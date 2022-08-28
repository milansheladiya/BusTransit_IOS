//
//  ViewController.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-08.
//

import UIKit
import CryptoKit
import AuthenticationServices
import FirebaseAuth
class ViewController: UIViewController {
   
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    
    @IBOutlet weak var imgLoginWithApple: UIImageView!
    
    let fb = FirebaseUtil()
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.layer.cornerRadius = 15.0;
        txtEmail.layer.borderWidth = 1;
        
        txtPassword.layer.cornerRadius = 15.0;
        txtPassword.layer.borderWidth = 1;
        
        btnLogin.layer.cornerRadius = 15.0;
        setupAppleButton();
        
    }
    func setupAppleButton() {
            view.addSubview(appleButton)
            appleButton.cornerRadius = 12
            appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
            appleButton.translatesAutoresizingMaskIntoConstraints = false
            appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            appleButton.widthAnchor.constraint(equalToConstant: 235).isActive = true
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            appleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
    }
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
        
        if emailFromUI == "admin@gmail.com" && passwordFromUI == "Admin@123"
        {
            print("Call")
            self.performSegue(withIdentifier: "goToAdmin", sender: self)
        }else{
            loginWithFirebase(email: emailFromUI ?? "",password: passwordFromUI ?? "")
        }
                
        
    }
    
    @IBAction func tabSignUp(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToSignup", sender: self)
        
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
@available(iOS 13.0, *)
extension ViewController:ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if (error != nil) {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error?.localizedDescription ?? "")
                        return
                    }
                    guard let user = authResult?.user else { return }
                    let email = user.email ?? ""
                    let displayName = user.displayName ?? ""
                    guard let uid = Auth.auth().currentUser?.uid else { return }
//                    let db = FirebaseUtil._db;
                    print("uid \(uid) email \(email) displayName \(displayName)")
//                    db.collection("User").document(uid).setData([
//                        "email": email,
//                        "displayName": displayName,
//                        "uid": uid
//                    ]) { err in
//                        if let err = err {
//                            print("Error writing document: \(err)")
//                        } else {
//                            print("the user has sign up or is logged in")
//                        }
//                    }
                }
            }
        }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // Handle error.
            print("Sign in with Apple errored: \(error)")
        }
}
extension ViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
extension ViewController{
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    
}
