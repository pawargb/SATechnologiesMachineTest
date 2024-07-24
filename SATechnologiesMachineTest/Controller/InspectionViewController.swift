//
//  InspectionViewController.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 08/07/24.
//

import UIKit

class InspectionViewController: UIViewController {
    
    @IBOutlet weak var inspectionTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let viewModel = InspectionViewModel()
    var inspectionSubmitted : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inspectionTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        inspectionTableView.rowHeight = UITableView.automaticDimension
        inspectionTableView.separatorStyle = .none
        if viewModel.inspection?.status == InspectionStatus.completed.rawValue {
            submitButton.isHidden = true
            scoreLabel.isHidden = false
            scoreLabel.text = "Your Score is: \(viewModel.inspection?.score ?? 0.0)"
        } else {
            areAllAnswersSelected()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inspectionTableView.reloadData()
    }
    
    func areAllAnswersSelected(){
        if self.viewModel.areAllAnswerSelected() {
            self.submitButton.isEnabled = true
        } else {
            self.submitButton.isEnabled = false
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        print("Submit Button Clicked")
        viewModel.submitInspection { result in
            switch result {
            case .success(let isSubmitted):
                CustomAlertController.present(title: "Success", message: "Inspection submitted Successfully. Your Score is \(self.viewModel.score)") {
                    self.inspectionSubmitted?()
                    self.navigationController?.popViewController(animated: true)
                }

            case .failure(let error):
                CustomAlertController.present(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

extension InspectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories[section].questions?.allObjects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = inspectionTableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as? QuestionTableViewCell {
            if let question = viewModel.categories[indexPath.section].questions?.allObjects as? [QuestionsEntity] {
                cell.setDataOnUI(question: question[indexPath.row])
            }
            cell.allowAnswerChange = viewModel.inspection?.status != InspectionStatus.completed.rawValue
            cell.answerSelected = {
                self.areAllAnswersSelected()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.categories[section].name
    }
}
