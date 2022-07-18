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
    
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var schoolEmailLbl: UILabel!
    @IBOutlet weak var schoolAddressLbl: UILabel!
    @IBOutlet weak var schoolPhoneNoLbl: UILabel!
    
    @IBOutlet weak var deleteBusBtn: UIButton!
    @IBOutlet weak var detailView: UIStackView!
    @IBOutlet weak var schoolNameView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    @IBAction func backHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true,completion: nil)
    }
    func setup(){
        schoolNameLbl.text = name
        schoolEmailLbl.text = email
        schoolAddressLbl.text = address
        schoolPhoneNoLbl.text = phoneNo
        schoolNameView.layer.cornerRadius = 10
        detailView.layer.cornerRadius = 10
        deleteBusBtn.layer.cornerRadius = 10
    }
}
