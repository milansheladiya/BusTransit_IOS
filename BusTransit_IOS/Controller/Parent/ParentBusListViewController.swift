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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitle.title = "Johnnn"
        busListTableView.register(UINib(nibName: ParentBusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ParentBusTableViewCell.identifier)
        busListTableView.dataSource = self
        busListTableView.delegate = self
        loadData()
    }
    func loadData(){
        BusList.BusListCollection.removeAll()
//        print("" + FirebaseUtil.auth.currentUser)
//        fb._readDocumentsWithMultipleFieldValues(_collection: "Bus", _field: "school_id", _value: <#T##[String]#>, callback: <#T##(QuerySnapshot) -> Void#>)
//        fb._readAllDocuments(_collection: "Bus"){
//            QueryDocumentSnapshot in
//            for document in QueryDocumentSnapshot.documents{
//                let docSchoolId = document.data()["school_id"] as! String
//            }
//
//        }
    }

}
extension ParentBusListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BusList.BusListCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParentBusTableViewCell.identifier, for: indexPath) as! ParentBusTableViewCell
        cell.setup(bus: BusList.BusListCollection[indexPath.row])
        return cell
    }
    
    
}
