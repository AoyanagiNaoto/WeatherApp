//
//  TableViewController.swift
//  WeatherApp
//
//  Created by Aoyagi Naoto on 2018/08/12.
//  Copyright © 2018年 vertex. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class TableViewController: UITableViewController {
    
    var prefectures: [Pref] = []

    
        func simpleAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        

          Alamofire.request("https://query.yahooapis.com/v1/public/yql?q=select*%20from%20xml%20where%20url%20%3D%20%27http%3A%2F%2Fweather.livedoor.com%2Fforecast%2Frss%2Fprimary_area.xml%27&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys").responseJSON{(
            response: DataResponse<Any>) in

            if response.result.isFailure == true {
                self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
                return
            }
            
            guard let val = response.result.value as? [String: Any] else {
                self.simpleAlert(title: "通信エラー", message: "通信結果がJSONではありませんでした")
                return
            }
            
            let json = JSON(val)
            
            let prefJSON = json["query"]["results"]["rss"]["channel"]["source"]["pref"].arrayValue
                
            self.prefectures = prefJSON.map{ item in
                return Pref(pref: item)
                
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return prefectures.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let cities = prefectures[section].cities
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return prefectures[section].title
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath)

        cell.textLabel?.text = prefectures[indexPath.section].cities[indexPath.row].title
        cell.detailTextLabel?.text = prefectures[indexPath.section].cities[indexPath.row].id
        
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let detailVC = segue.destination as? DetailViewController {

            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                detailVC.cityId = prefectures[indexPath.section].cities[indexPath.row].id
            }
        }
    }
}

