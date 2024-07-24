//
//  HomeViewController.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - properties
    
    @IBOutlet weak var inspectionStatusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var inspectionListTableView: UITableView!
   
    
    let viewModel = HomeViewModel()
    
    //MARK: - ViewController Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshButton()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        navigationItem.title = "Inspections"
        inspectionListTableView.register(UINib(nibName: "InspectionListTableViewCell", bundle: nil), forCellReuseIdentifier: "InspectionListTableViewCell")
        fetchInspectionFromDB()
        setNameForSegment()
    }
    
    func fetchInspectionFromDB() {
        
        viewModel.fetchInspectionFromDB()
        inspectionListTableView.reloadData()
    }
    
    //MARK: - IBActions
    
    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            addRefreshButton()
            reloadTable(with: .new)
        case 1:
            navigationItem.leftBarButtonItem = nil
            reloadTable(with: .inProgress)
        default:
            navigationItem.leftBarButtonItem = nil
            reloadTable(with: .completed)
        }
    }
    
    func reloadTable(with filter: InspectionStatus) {
        viewModel.selectedInspectionFilter = filter
        inspectionListTableView.reloadData()
    }
    
    //MARK: - API calls
    @objc func refresh() {
        viewModel.refreshInspectionAPI { [weak self] result in
            switch result {
            case .success:
                self?.setNameForSegment()
                self?.inspectionListTableView.reloadData()
            case .failure(let error):
                CustomAlertController.present(title: "Error", message: error.localizedDescription)
            }
        }
    }

    @objc func logout() {
        LoginManager.shared.markUserLoggedOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: Constant.ViewControllerNames.loginViewController)
        
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let window = scene.window
            
            window?.rootViewController = loginViewController
            scene.window = window
            window?.makeKeyAndVisible()
        }
    }

    func addRefreshButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refresh))
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.inspectionListTableViewCell, for: indexPath) as? InspectionListTableViewCell {
            let inspection = viewModel.filteredArray[indexPath.row]
            cell.setData(inspectionArea: inspection.inspectionArea?.name, inspectionType: inspection.inspectionType?.name)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let inspectionViewController = main.instantiateViewController(withIdentifier: Constant.ViewControllerNames.inspectionViewController) as? InspectionViewController {
            
            let inspection = viewModel.filteredArray[indexPath.row]
            inspectionViewController.viewModel.inspection = inspection
            if inspection.status == InspectionStatus.new.rawValue {
                inspection.status = InspectionStatus.inProgress.rawValue
                CoreDataManager.shared.saveContext()
                
                viewModel.filteredArray.remove(at: indexPath.row)
                inspectionListTableView.deleteRows(at: [indexPath], with: .fade)
                setNameForSegment()
            }
            inspectionViewController.inspectionSubmitted = {
                self.reloadTable(with: self.viewModel.selectedInspectionFilter)
                self.setNameForSegment()
            }
            navigationController?.pushViewController(inspectionViewController, animated: true)
        }
    }
    
    func setNameForSegment() {
        inspectionStatusSegmentedControl.setTitle("New (\(viewModel.getCount(for: .new)))", forSegmentAt: 0)
        inspectionStatusSegmentedControl.setTitle("In Progress (\(viewModel.getCount(for: .inProgress)))", forSegmentAt: 1)
        inspectionStatusSegmentedControl.setTitle("Completed (\(viewModel.getCount(for: .completed)))", forSegmentAt: 2)
    }
}
