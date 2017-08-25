//
//  ListTableTableViewController.swift
//  OnTheMap
//
//  Created by Raksha Vadim on 26.07.17.
//  Copyright © 2017 Vadim. All rights reserved.
//

import UIKit


class ListTableTableViewController: UITableViewController {

    var data: UdacityDataModel = UdacityDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        if let tabController = self.tabBarController as? MainTabBarViewController {
            if tabController.isDataLoaded {
                self.loaded(tabController.UdacityData)
            } else {
                tabController.handlerAfterLoadData.append({
                    self.loaded(tabController.UdacityData)
                })
            }
        }
        print("handler Added from List")
    }

    private func loaded(_ data: UdacityDataModel) {
        self.data = data
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.studentsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let student = data.studentsList[indexPath.row]
        
        cell.imageView?.image = #imageLiteral(resourceName: "Pin")
        cell.textLabel?.text = "\(student.firstName!) \(student.lastName!)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.tableView.frame.width,
                height: 44
            )
        )
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.openURL(URL(string: data.studentsList[indexPath.row].mediaURL!) ?? URL(string: "http://google.com")!)
    }
}
