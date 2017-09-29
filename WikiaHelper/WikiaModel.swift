//
//  WikiaModel.swift
//  WikiaHelper
//
//  Created by Jille van der Weerd on 06/09/2017.
//  Copyright © 2017 De Programmeermeneer. All rights reserved.
//

import Foundation
import UIKit

class User {
    var name : String
    var avatar : UIImage?
    var numberofedits : Int?
    var currentWiki : String
    
    init(userName : String, wiki : String) {
        self.name = userName
        self.currentWiki = wiki
    }
    
    func getWikiData(completionHandler:@escaping (Bool) -> ()) {
        let url = URL(string: "http://www.\(currentWiki).wikia.com/api/v1/User/Details?ids=\(name)&size=100")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let itemArray = json["items"] as! [Any]
                let userArray = itemArray[0] as! [String:Any]
                let edits = userArray["numberofedits"]
                self.numberofedits = edits as! Int
                let avatarString = userArray["avatar"] as! String
                let avatarUrl = URL(string: avatarString)
                let avatarData = try? Data(contentsOf: avatarUrl!)
                self.avatar = UIImage(data: avatarData!)
                completionHandler(true)
            } catch let error as NSError {
                print("NSERROR: \(error)")
                completionHandler(false)
            }
        }).resume()
    }
    
    func latestArticleRequest(completionHandler:@escaping(_ result : [String:String]) -> ()){
        var returnDictionary = [String:String]()
        let url = URL(string: "http://www.\(currentWiki).wikia.com/api/v1/Activity/LatestActivity?limit=25&namespaces=0&allowDuplicates=false")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let itemArray = json["items"] as! [Any]
                var articleArray = [String]()
                for item in itemArray {
                    let dictionary = item as! [String:Any]
                    if articleArray.contains("\(dictionary["article"]!)") {
                        //do nothing if the code is already in the array, as to not show duplicates.
                    } else {
                    articleArray.append("\(dictionary["article"]!)")
                    }
                }
                let stringFromArray = articleArray.joined(separator: ",")
                
                //URLSession to get data from articles
                let articleUrl = URL(string: "http://www.\(self.currentWiki).wikia.com/api/v1/Articles/Details?ids=\(stringFromArray)&abstract=0&width=0&height=0")
                URLSession.shared.dataTask(with: articleUrl!, completionHandler: {(data, response, error) in
                    guard let data = data, error == nil else { return }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        let itemDictionary = json["items"] as! [String:Any]
                        for (key, item) in itemDictionary {
                            let dictionary = item as! [String:Any]
                            let articleTitle = dictionary["title"]! as! String
                            let articleUrlEnd = dictionary["url"]! as! String
                            returnDictionary[articleTitle] = articleUrlEnd
                        }
                    } catch let error as NSError {
                        print("NSERROR in articledata URLSession: \(error)")
                    }
                    completionHandler(returnDictionary)

                    }).resume()
                
            } catch let error as NSError {
                print("NSERROR: \(error)")
            }

        }).resume()
        //succes
    }
    
    func popularArticleRequest(completionHandler:@escaping(_ result : [String:String]) -> ()){
        var returnDictionary = [String:String]()
        let url = URL(string: "http://www.\(currentWiki).wikia.com/api/v1/Articles/Popular?limit=10")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let itemArray = json["items"] as! [Any]
                var articleArray = [String]()
                for item in itemArray {
                    let dictionary = item as! [String:Any]
                    let articleTitle = dictionary["title"] as! String
                    let articleUrlEnd = dictionary["url"] as! String
                    returnDictionary[articleTitle] = articleUrlEnd
                }
                
                
            } catch let error as NSError {
                print("NSERROR: \(error)")
            }
            completionHandler(returnDictionary)
        }).resume()
        //succes
    }
    
    func topArticleRequest(completionHandler:@escaping(_ result : [String:String]) -> ()){
        var returnDictionary = [String:String]()
        let url = URL(string: "http://www.\(currentWiki).wikia.com/api/v1/Articles/Top?limit=20")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let itemArray = json["items"] as! [Any]
                var articleArray = [String]()
                for item in itemArray {
                    let dictionary = item as! [String:Any]
                    let articleTitle = dictionary["title"] as! String
                    let articleUrlEnd = dictionary["url"] as! String
                    returnDictionary[articleTitle] = articleUrlEnd
                }
                
                
            } catch let error as NSError {
                print("NSERROR: \(error)")
            }
            completionHandler(returnDictionary)
        }).resume()
        //succes
    }
}


