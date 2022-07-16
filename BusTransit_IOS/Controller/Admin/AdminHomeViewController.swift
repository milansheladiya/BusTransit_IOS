//
//  AdminHomeViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-15.
//

import UIKit
import Firebase
import FirebaseFirestore

class AdminHomeViewController: UIViewController {

    @IBOutlet weak var schoolCountView: UIView!
    @IBOutlet weak var busCountView: UIView!
    @IBOutlet weak var driverCountView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var schoolCountLbl: UILabel!
    @IBOutlet weak var driverCountLbl: UILabel!
    @IBOutlet weak var busCountLbl: UILabel!
    
    let fb = FirebaseUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolCountView.layer.cornerRadius = 20
        busCountView.layer.cornerRadius = 20
        driverCountView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.goToSchoolList))
        self.schoolCountView.addGestureRecognizer(gesture)
        loadData()
    }
    @objc func goToSchoolList(sender : UITapGestureRecognizer) {
        // Do what you want
        self.performSegue(withIdentifier: "goToSchools", sender: self)
    }

    @IBAction func logoutHandler(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData(){
        
        fb._readAllDocuments(_collection: "School"){
            QueryDocumentSnapshot in
            self.schoolCountLbl.text = String(QueryDocumentSnapshot.documents.count)
        }
        fb._readAllDocuments(_collection: "Bus"){
            QueryDocumentSnapshot in
            self.busCountLbl.text = String(QueryDocumentSnapshot.documents.count)
        }
        UserList.UserListCollection.removeAll()
        fb._readAllDocuments(_collection: "User"){
            QueryDocumentSnapshot in
            for document in QueryDocumentSnapshot.documents{
                let userType = document.data()["user_type"] as! String
                if(userType == Constants.DRIVER){
                    let user = User(
                        user_id: document.data()["user_id"] as! String,
                        bus_id: document.data()["bus_id"] as! String,
                        email_id: document.data()["email_id"] as! String,
                        fullName: document.data()["fullName"] as! String,
                        gender: document.data()["gender"] as! String,
                        phone_no: document.data()["phone_no"] as! String,
                        address: document.data()["address"] as! String,
                        user_lat: document.data()["user_lat"] as! String,
                        user_long: document.data()["user_long"] as! String,
                        photo_url: document.data()["photo_url"] as! String,
                        user_type: document.data()["user_type"] as! String,
                        school_id: document.data()["school_id"] as! [String]
                    )
                    UserList.UserListCollection.append(user)
                }
            }
            self.driverCountLbl.text = String(UserList.UserListCollection.count)
        }
    }
}
