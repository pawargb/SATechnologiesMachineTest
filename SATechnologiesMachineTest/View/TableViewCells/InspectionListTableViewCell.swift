//
//  InspectionListTableViewCell.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 08/07/24.
//

import UIKit

class InspectionListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var inspectionAreaLabel: UILabel!
    @IBOutlet weak var inspectionTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(inspectionArea: String?, inspectionType: String?){
        inspectionAreaLabel.text = inspectionArea
        inspectionTypeLabel.text = inspectionType
    }
}
