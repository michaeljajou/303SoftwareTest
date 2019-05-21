//
//  ViewController.swift
//  303Software iOS Test
//
//  Created by Michael Jajou on 5/21/19.
//  Copyright © 2019 Apptomistic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    // Temporary array while setting up table view
    var data: [Person] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        if let url = URL(string: "http://www.filltext.com/?rows=100&fname=%7BfirstName%7D&lname=%7BlastName%7D&city=%7Bcity%7D&pretty=true") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    for object in json {
                        if let item = object as? [String: Any] {
                            self.addPerson(dict: item)
                        }
                    }
                }
            }
            tableView.reloadData()
            task.resume()
        }
    }
    
    func addPerson(dict: [String: Any]) {
        guard let fname = dict["fname"] as? String else { return }
        guard let lname = dict["lname"] as? String else { return }
        guard let city = dict["city"] as? String else { return }
        
        let person = Person(fname: fname, lname: lname, city: city)
        data.append(person)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        let nameLabel = cell.viewWithTag(0) as! UILabel
        let cityLabel = cell.viewWithTag(1) as! UILabel
        let person = data[indexPath.row]
        let name = person.fname + person.lname
        let city = person.city
        nameLabel.text = name
        cityLabel.text = city
        return cell
    }
    
    
}

