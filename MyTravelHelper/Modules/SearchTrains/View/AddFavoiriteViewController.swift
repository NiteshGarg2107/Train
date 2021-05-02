//
//  AddFavoiriteViewController.swift
//  MyTravelHelper
//
//  Created by Nitesh Garg on 02/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import UIKit

class AddFavoiriteViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    var station: [Station]?
    let cellIdentifier = "cell"
    var stationArr = [Station]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Favourite"
        let button = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveStation))
        button.tintColor = UIColor.blue
        self.navigationItem.rightBarButtonItem = button
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    @objc func saveStation(sender: UIBarButtonItem?) {
        let data = stationArr.map{$0.stationDesc}
        UserDefaults.standard.set(data, forKey: "station")
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddFavoiriteViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return station?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = station?[indexPath.row].stationDesc
        if stationArr.contains((station?[indexPath.row])!) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let station =  station?[indexPath.row] else {
            return
        }
        if !stationArr.contains(station) {
            stationArr.append(station)
        } else {
            stationArr.remove(at: stationArr.firstIndex(of: station)!)
        }
        tableview.reloadData()
    }
}
