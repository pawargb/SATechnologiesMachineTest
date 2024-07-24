//
//  UITableViewExtension.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 14/07/24.
//
import UIKit
import Foundation

extension UITableView {
    func reloadData(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0) {
            self.reloadData()
        } completion: { _ in
            completion?()
        }

    }
}
