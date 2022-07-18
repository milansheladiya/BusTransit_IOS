//
//  AssignBusViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-17.
//

import UIKit

class AssignBusViewController: UIViewController {
    
    var name = ""
    var email = ""
    var address = ""
    var phoneNo = ""
    var schoolId = ""
    var school_lat = ""
    var school_long = ""
    
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var schoolEmailLbl: UILabel!
    @IBOutlet weak var schoolAddressLbl: UILabel!
    @IBOutlet weak var schoolPhoneNoLbl: UILabel!
    @IBOutlet weak var busCountLbl: UILabel!
    @IBOutlet weak var noBusLbl: UILabel!
    
    @IBOutlet weak var deleteBusBtn: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var schoolNameView: UIView!
    
    @IBOutlet weak var busListTableView: UITableView!
    
    let fb = FirebaseUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        busListTableView.register(UINib(nibName: BusListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BusListTableViewCell.identifier)
        busListTableView.dataSource = self
        busListTableView.delegate = self
        setup()
  }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddBus"{
            let destinationVC = segue.destination as! AddBusViewController
            destinationVC.source = address
            destinationVC.source_lat = school_lat
            destinationVC.source_long = school_long
            destinationVC.school_id = schoolId
        }
    }
    @IBAction func backHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func addBusHandler(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToAddBus", sender: self)
    }
    func setup(){
        schoolNameLbl.text = name
        schoolEmailLbl.text = email
        schoolAddressLbl.text = address
        schoolPhoneNoLbl.text = phoneNo
        schoolNameView.layer.cornerRadius = 20
        detailView.layer.cornerRadius = 15
        deleteBusBtn.layer.cornerRadius = 20
        noBusLbl.isHidden = true
    }
    func loadData(){
        BusList.BusListCollection.removeAll()
        fb._readAllDocuments(_collection: "Bus"){
            QueryDocumentSnapshot in
            for document in QueryDocumentSnapshot.documents{
                let docSchoolId = document.data()["school_id"] as! String
                if(self.schoolId == docSchoolId){
                    let school = Bus(
                        bus_id: document.data()["bus_id"] as! String,
                        bus_number: document.data()["bus_number"] as! Int,
                        active_sharing: document.data()["active_sharing"] as! Bool,
                        current_lat: document.data()["current_lat"] as! String,
                        current_long: document.data()["current_long"] as! String,
                        destination_lat: document.data()["destination_lat"] as! String,
                        destination_long: document.data()["destination_long"] as! String,
                        destination: document.data()["destination"] as! String,
                        going_to_school: document.data()["going_to_school"] as! Bool,
                        school_id: document.data()["school_id"] as! String,
                        source_lat: document.data()["source_lat"] as! String,
                        source_long: document.data()["source_long"] as! String,
                        source: document.data()["source"] as! String)
                    BusList.BusListCollection.append(school)
                }
            }
            if(BusList.BusListCollection.count == 0){
                self.noBusLbl.isHidden = false
                self.busListTableView.isHidden = true
            }else{
                self.noBusLbl.isHidden = true
                self.busListTableView.isHidden = false
            }
            self.busListTableView.reloadData()
            self.busCountLbl.text = "Bus Section("+String(BusList.BusListCollection.count) + ")"
        }
    }
    
}
extension AssignBusViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BusList.BusListCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusListTableViewCell.identifier, for: indexPath) as! BusListTableViewCell
        cell.setUp(bus: BusList.BusListCollection[indexPath.row])
        return cell
    }
    
}
