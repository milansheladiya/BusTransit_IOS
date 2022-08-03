//
//  SchoolTableViewCell.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-16.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    static let identifier = String(describing: SchoolTableViewCell  .self )
    @IBOutlet weak var schoolName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 10
    }
    func setUp(school:School){
        schoolName.text = school.name
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

}
