//
//  InspectionViewController.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 08/07/24.
//

import UIKit

class InspectionViewController: UIViewController {
    
    let viewModel = InspectionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let inspectionName = viewModel.inpsection?.inspection.inspectionType.name ?? ""
        
        navigationItem.title = "\(inspectionName) Inspection"
    }

}
