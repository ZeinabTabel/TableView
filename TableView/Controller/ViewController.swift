//
//  ViewController.swift
//  TableView
//
//  Created by Zeinab on 10/28/20.
//  Copyright © 2020 Zeinab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var list: UITableView!
    let refresh = UIRefreshControl()
    let cellName = "CustomCell"
    let segueName = "ViewDetails"
    var comments: [Comments] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func configureTableView() {
        list.rowHeight = UITableView.automaticDimension
        list.estimatedRowHeight = 120.0
        list.delegate = self
        list.dataSource = self
        list.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        list.refreshControl = refresh
        refresh.addTarget(self,
                          action: #selector(refreshComments),
                          for:.valueChanged)
    }
    
    @objc func refreshComments (_ sender:Any) {
        getData()
    }
    
    func getData() {
        guard let url = URL(string:"https://jsonplaceholder.typicode.com/comments/") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.refresh.endRefreshing()
            }
            guard let jsonData = data , error == nil else {
                print("error!")
                return
            }
            do {
                let comments = try JSONDecoder().decode([Comments].self, from: jsonData)
                DispatchQueue.main.async {
                    self.comments = comments
                    self.list.reloadData()
                }
            }
            catch {
                print("Error \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewDetails {
            guard let comment = sender as? Comments else {return}
            destination.comment = comment
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueName, sender: self.comments[indexPath.row])
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellName,
                                                    for: indexPath) as? CustomCell {
            cell.fill(comment: comments[indexPath.row])
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: CustomCellDelegate {
    
    func showData(message: String?) {
            let title = NSLocalizedString("Message", comment: "")
            let okButton = NSLocalizedString("OK", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okButton, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
}




