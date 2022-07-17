//
//  SchoolListViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-16.
//

import UIKit

class SchoolListViewController: UIViewController,UITableViewDataSource,UISearchResultsUpdating, UISearchBarDelegate {
    let searchController =  UISearchController(searchResultsController: nil)
    let fb = FirebaseUtil()
    
    @IBOutlet weak var schoolListView: UITableView!
    
    var filteredArr = [School]()

    override func viewDidLoad() {
        super.viewDidLoad()
        schoolListView.register(UINib(nibName: SchoolTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SchoolTableViewCell.identifier)
        schoolListView.dataSource = self
        schoolListView.allowsSelection = false
        // Do any additional setup after loading the view.
        
        //Search Controller
            self.navigationItem.setHidesBackButton(true, animated: true)

            searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Schools"
        navigationItem.searchController = searchController

        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false

        
        loadData()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true,completion: nil)
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!

        print("search call",searchText)
        filteredArr = SchoolList.SchoolListCollection.filter
        {
            school in
            if(searchText != ""){
                let searchTextMatched =  school.name.lowercased().contains(searchText.lowercased())
                return searchTextMatched
            }
            return true
        }
    }

    @IBAction func addSchool(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAddSchool", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive){
            return filteredArr.count
        }
        return SchoolList.SchoolListCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCell.identifier, for: indexPath) as! SchoolTableViewCell
        cell.setUp(school: SchoolList.SchoolListCollection[indexPath.row])
        return cell

    }

    func loadData(){
        SchoolList.SchoolListCollection.removeAll()
        fb._readAllDocuments(_collection: "School"){
            QueryDocumentSnapshot in
            for document in QueryDocumentSnapshot.documents{
                    let school = School(
                        school_id:  document.data()["school_id"] as! String,
                        address:  document.data()["address"] as! String,
                        email_id:  document.data()["email_id"] as! String,
                        name:  document.data()["name"] as! String,
                        phone_no:  document.data()["phone_no"] as! String,
                        lat:  document.data()["lat"] as! String,
                        long:  document.data()["long"] as! String)
                SchoolList.SchoolListCollection.append(school)
            }
            self.schoolListView.reloadData()
        }
    }
}
