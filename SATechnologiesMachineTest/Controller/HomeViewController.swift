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
    @IBOutlet weak var startInspectionButton: UIButton!
    
    let viewModel = HomeViewModel()
    
    //MARK: - ViewController Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshButton()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        navigationItem.title = "Inspections"
        
        refresh()
    }
    
    //MARK: - IBActions
    
    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("New")
            addRefreshButton()
            startInspectionButton.isHidden = false
        case 1:
            print("In Progress")
            navigationItem.leftBarButtonItem = nil
            startInspectionButton.isHidden = true
        default:
            print("completed")
            navigationItem.leftBarButtonItem = nil
            startInspectionButton.isHidden = true
        }
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let inspectionViewController = storyboard?.instantiateViewController(withIdentifier: Constant.ViewControllerNames.inspectionViewController) as? InspectionViewController {
            inspectionViewController.viewModel.inpsection = viewModel.inpsection
            navigationController?.pushViewController(inspectionViewController, animated: true)
        }
    }
    
    //MARK: - API calls
    @objc func refresh() {
        viewModel.refreshInspectionAPI { result in
            switch result {
            case .success:
                print("data received")
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
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.inspectionListTableViewCell, for: indexPath) as? InspectionListTableViewCell {
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
