//
//  SearchResultsController.swift
//  TestMap
//
//  Created by Tuan Anh Vu on 6/29/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import Foundation
import UIKit

protocol LocateOnTheMap: class {
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class SearchResultsController: UITableViewController {
    
    var searchResults = [String]()
    weak var delegate: LocateOnTheMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count = \(searchResults.count)")
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        // 1
        self.dismiss(animated: true, completion: nil)
        // 2
        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let path = urlpath, let url = URL(string: path) else {return}
        let task = URLSession.shared.dataTask(with: url as URL) { [weak self] (data, response, error) -> Void in
            // 3
            guard let weakSelf = self else {return}
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    var lat = Global.shared.defaultLocation.latitude
                    var lon = Global.shared.defaultLocation.longitude
                    if let res = dic["results"] as? [Any], let first = res.first as? [String: Any], let geo = first["geometry"] as? [String: Any], let loc = geo["location"] as? [String: Any], let latNumb = loc["lat"] as? NSNumber, let lonNumb = loc["lng"] as? NSNumber {
                        lat = latNumb.doubleValue
                        lon = lonNumb.doubleValue
                    }
//                    let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
                    
//                    let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
                    // 4
                    weakSelf.delegate?.locateWithLongitude(lon, andLatitude: lat, andTitle: weakSelf.searchResults[indexPath.row])
                }
                
            }catch {
                print("Error")
            }
        }
        // 5
        task.resume()
    }
        
    func reloadDataWithArray(_ array:[String]){
        searchResults = array
        tableView.reloadData()
    }
}

