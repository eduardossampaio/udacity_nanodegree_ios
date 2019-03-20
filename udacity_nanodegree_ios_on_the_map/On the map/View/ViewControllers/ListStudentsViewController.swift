//
//  ListStudentsViewController.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 11/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation
import UIKit

class ListStudentsViewController: ContentBaseViewController , UITableViewDataSource,UITableViewDelegate  {
   
    @IBOutlet weak var tableView: UITableView!
    private var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        retrieveStudents()
    }
    func retrieveStudents(){
      super.retrieveStudents() { succeed,error, students in
            if succeed {
                DispatchQueue.main.async {
                    self.students = students!
                    self.tableView.reloadData()
                }
            }
        }
    }
        
    @IBAction func onReloadPressed(_ sender: Any) {
        super.reloadStudents() { succeed,error, students in
            if succeed {
                DispatchQueue.main.async {
                    self.students = students!
                    self.tableView.reloadData()
                }
            }
        }
    }
    @IBAction func onLogoutPressed(_ sender: Any) {
        super.logout()
    }
    @IBAction func onNewPressed(_ sender: Any) {
        super.goToNewLocationScreen()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let student = students[indexPath.item]
        cell.textLabel?.text = student.firstName
        cell.detailTextLabel?.text = student.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = students[indexPath.item]
        Utils.openUrl(url: student.mediaURL)
    }

}
