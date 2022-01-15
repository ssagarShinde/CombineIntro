//
//  UserVC.swift
//  IntroCombine
//
//  Created by Sagar on 15/01/22.
//

import UIKit
import Combine

class UserVC: UIViewController {

    var observer : AnyCancellable?
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    var arrUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        observer = APIHandler.fetchUser(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] users in
                print(users)
                self?.arrUser = users
                DispatchQueue.main.async {
                    self?.tblView.reloadData()
                }
            })
    }
}

extension UserVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell() }
        let data = arrUser[indexPath.row]
        cell.textLabel?.text = data.name
        return cell
    }
}
