//
//  ParentBusListViewController.swift
//  BusTransit_IOS
//
//  Created by Namra on 2022-08-04.
//

import UIKit

class ParentBusListViewController: UIViewController {

    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var busListTableView: UITableView!
    let fb = FirebaseUtil()
    var busDetails:BusToDriverModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitle.title = UserList.GlobleUser.fullName
        busListTableView.register(UINib(nibName: ParentBusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ParentBusTableViewCell.identifier)
        busListTableView.dataSource = self
        busListTableView.delegate = self
        loadData()
    }
    @IBAction func logout(_ sender: UIBarButtonItem) {
        FirebaseUtil.logout()
        self.dismiss(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBusLocationDetails"{
            let destinationVC = segue.destination as! BusLocationDetailsViewController
            destinationVC.busDetails = busDetails
        }
    }
    func loadData(){
        var schoolId:[String] = []
        var busList:[Bus] = []
        fb._readDocumentsWithMultipleFieldValues(_collection: "School", _field: "name", _value: UserList.GlobleUser.school_id){
            QueryDocumentSnapshot in
            for document in QueryDocumentSnapshot.documents{
                let docSchoolId = document.data()["school_id"] as! String
                schoolId.append(docSchoolId)
            }
            self.fb._readDocumentsWithMultipleFieldValues(_collection: "Bus", _field: "school_id", _value: schoolId) { QuerySnapshot in
                for document in QuerySnapshot.documents{
                    let bus = Bus(
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
                    busList.append(bus)
                }
                
                //Fetching driver for each bus
                for busObj in busList{
                    
                    self.fb._readAllDocumentsWithField(_collection: "User", _field: "bus_id", _value: busObj.bus_id){
                        QuerySnapshot in
                        for document in QuerySnapshot.documents{
                            let driver:User? = UtilClass.FirebaseToUserMap(doc: document)
                            //Check if driver is assigned to bus
                            if(driver != nil){
                                let parentBus = BusToDriverModel(
                                    bus_id:  busObj.bus_id,
                                    bus_number:  busObj.bus_number,
                                    active_sharing:  busObj.active_sharing,
                                    current_lat:  busObj.current_lat,
                                    current_long:  busObj.current_long,
                                    destination_lat:  busObj.destination_lat,
                                    destination_long:  busObj.destination_long,
                                    destination: busObj.destination,
                                    going_to_school:  busObj.going_to_school,
                                    school_id:  busObj.school_id,
                                    source_lat:  busObj.source_lat,
                                    source_long:  busObj.source_long,
                                    source:  busObj.source,
                                    user_id: document.data()["user_id"] as! String,
                                    email_id: document.data()["email_id"] as! String,
                                    fullName: document.data()["fullName"] as! String,
                                    phone_no: document.data()["phone_no"] as! String,
                                    photo_url: document.data()["photo_url"] as! String,
                                    gender: document.data()["gender"] as! String,
                                    address: document.data()["address"] as! String,
                                    school_id_list: document.data()["school_id"] as! [String]
                                )
                                ParentBusList.BusListCollection.append(parentBus)
                            }
                        }
                        self.busListTableView.reloadData()
                    }
                }
            }
        }
    }
}
extension ParentBusListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParentBusList.BusListCollection.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParentBusTableViewCell.identifier, for: indexPath) as! ParentBusTableViewCell
        cell.setup(bus: ParentBusList.BusListCollection[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        busDetails = ParentBusList.BusListCollection[indexPath.row]
        self.performSegue(withIdentifier: "goToBusLocationDetails", sender: self)
    }
    
}
