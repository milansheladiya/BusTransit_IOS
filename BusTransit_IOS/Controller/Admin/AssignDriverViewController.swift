//
//  AssignDriverViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-26.
//

import UIKit

class AssignDriverViewController: UIViewController {
    var schoolName = ""
    var address = ""
    var destinationAddress = ""
    var busId = ""
    var busNumber:Int = 0
    var driver:User?
    
    let fb = FirebaseUtil()
    
    @IBOutlet weak var busNumberLbl: UILabel!
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var schoolAddressLbl: UILabel!
    @IBOutlet weak var terminalAddressLbl: UILabel!
    @IBOutlet weak var driverCountLbl: UILabel!
    @IBOutlet weak var deleteBusBtn: UIButton!
    @IBOutlet weak var driverListTableView: UITableView!
    @IBOutlet weak var schoolNameView: UIView!
    @IBOutlet weak var detailView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverListTableView.register(UINib(nibName: DriverTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DriverTableViewCell.identifier)
        driverListTableView.dataSource = self
        driverListTableView.delegate = self
        setup()
    }
    
    func setup(){
        busNumberLbl.text = "Bus Number : " + String(busNumber)
        schoolNameLbl.text = schoolName
        schoolAddressLbl.text = address
        terminalAddressLbl.text = destinationAddress
        schoolNameView.layer.cornerRadius = 20
        detailView.layer.cornerRadius = 15
        deleteBusBtn.layer.cornerRadius = 20
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    @IBAction func backButtonHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func deleteBusHandler(_ sender: UIButton) {
        let uialert = UIAlertController(title: "Confirm?", message: "Are you sure you want to delete bus?", preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(
            UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in
                FirebaseUtil._deleteDocumentWithId(_collection: "Bus", _docId: self.busId)
                self.dismiss(animated: true)
            })
        )
        uialert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(uialert, animated: true, completion: nil)

    }
    func loadData(){
        UserList.UserListCollection.removeAll()
        FirebaseUtil._db.collection("User")
            .whereField("user_type", isEqualTo: Constants.DRIVER)
            .whereField("bus_id", isEqualTo: "")
            .getDocuments() {
                (querySnapshot, err)  in
                for document in querySnapshot!.documents{
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
                self.driverListTableView.reloadData()
                self.driverCountLbl.text = "Driver List("+String(UserList.UserListCollection.count) + ")"
            }
    }
}
extension AssignDriverViewController:UITableViewDelegate,UITableViewDataSource,DriverTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserList.UserListCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DriverTableViewCell.identifier, for: indexPath) as! DriverTableViewCell
        cell.setup(driver: UserList.UserListCollection[indexPath.row],busId:self.busId)
        cell.delegate = self
        return cell
    }
    
    func allocateDriver(driver: User, busId: String) {
        let uialert = UIAlertController(title: "Confirm?", message: "Are you sure you want to allocate driver?", preferredStyle: UIAlertController.Style.alert)
        let nestedAlert = UIAlertController(title: "Success?", message: "Driver allocated successfully", preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(
            UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "User", _docId: driver.user_id, _data: [
                    "bus_id":busId
                ])
                self.dismiss(animated: true)
                self.present(nestedAlert, animated: true)
            })
        )
        uialert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        nestedAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
        self.present(uialert, animated: true, completion: nil)
        
    }
}
