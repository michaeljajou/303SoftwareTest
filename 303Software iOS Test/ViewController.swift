import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    // Array while setting up table view
    var data: [Person] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        // If we can convert the string to a URL, then proceed
        if let url = URL(string: "http://www.filltext.com/?rows=100&fname=%7BfirstName%7D&lname=%7BlastName%7D&city=%7Bcity%7D&pretty=true") {
            
            // Create a dispatch group in order to let the table view know when to reload its data
            let myGroup = DispatchGroup()
            
            // Attempt to get JSON data from URL Session
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                // Unwrap data in guard statement
                guard let data = data else { return }
                
                // Convert the data of people into an array
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    
                    // Iterate through each object, and construct a person object
                    for object in json {
                        myGroup.enter()
                        if let item = object as? [String: Any] {
                            self.addPerson(dict: item)
                            myGroup.leave()
                            // enter and exit dispatch group
                        }
                    }
                    
                    // Once we have added all people from data to array, reload table view
                    myGroup.notify(queue: .main) {
                        self.tableView.reloadData()
                    }
                }
            }
            task.resume()
        }
    }
    
    func addPerson(dict: [String: Any]) {
        
        // Attempt to fetch names and city from dictionary
        guard let fname = dict["fname"] as? String else { return }
        guard let lname = dict["lname"] as? String else { return }
        guard let city = dict["city"] as? String else { return }
        
        // Construct the person and add it to data
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
        
        // Get the proper labels from the cells view using tags
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let cityLabel = cell.viewWithTag(2) as! UILabel
        
        // Fetch names and city from data
        let person = data[indexPath.row]
        let name = person.fname + " " + person.lname
        let city = person.city
        nameLabel.text = name
        cityLabel.text = city
        
        return cell
    }
    
    
}

