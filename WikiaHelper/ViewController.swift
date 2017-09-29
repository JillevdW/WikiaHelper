//
//  ViewController.swift
//  WikiaHelper
//
//  Created by Jille van der Weerd on 06/09/2017.
//  Copyright © 2017 De Programmeermeneer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user : User?
    var dictionary = [String:String]()
    var dataArray = [String]()
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var currentWikiLabel: UILabel!
    
    @IBOutlet weak var editsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUser(userName: Defaults.defaults.string(forKey: "name")!, wikia: Defaults.defaults.string(forKey: "wikia")!)
        
        // Do any additional setup after loading the view, typically from a nib.
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUser(userName : String, wikia : String){
        
        self.user = User(userName: userName, wiki: wikia)
        //the function below has a completion handler; which means it only executes code in block whenthe function completed correctly.
        self.user?.getWikiData(){ success in
            self.setupView()
        }
        
        self.user!.latestArticleRequest { (result) in
            self.dictionary = result
            var tempDataArray = [String]()
            if self.dataArray.count == 0 {
                for (key, value) in self.dictionary {
                    tempDataArray.append(key)
                }
            } else {
                for (key, value) in self.dictionary {
                    self.dataArray.append(key)
                }
            }
            
            self.dataArray = Array(Set(self.dataArray).subtracting(tempDataArray))
            
            /*for word in self.dataArray {
                if let foundIndex = self.dataArray.index(where: { $0 == word }) {
                    self.dataArray.remove(at: foundIndex)
                }
            }*/
            self.dataArray+=tempDataArray
            
            self.setupTable()
        }

    }
    
    func setupView(){
        DispatchQueue.main.async {
            self.userNameLabel.text = self.user!.name
            self.currentWikiLabel.text = "\(self.user!.currentWiki) wikia"
            self.avatarImageView.image = self.user!.avatar
            self.editsLabel.text = "Number of edits: \(self.user!.numberofedits!)"
        }
    }
    
    func setupTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //4.5 is a magic number to make the text appear centered in the cell.
        let button = UILabel(frame: CGRect(x: 15, y: cell.bounds.height/4.5, width: cell.bounds.width, height: cell.bounds.height))
        button.text = (self.dataArray[indexPath.row])
        button.alpha = 1
        cell.addSubview(button)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = self.dataArray[indexPath.row]
        let endUrl = self.dictionary[key]
        let url = URL(string: "http://www.\(self.user!.currentWiki).wikia.com\(endUrl!)")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    //function to refresh tableView
    @objc func refresh(_ sender: Any) {
        self.setupUser(userName: Defaults.defaults.string(forKey: "name")!, wikia: Defaults.defaults.string(forKey: "wikia")!)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl.endRefreshing()
        })
    }
}

