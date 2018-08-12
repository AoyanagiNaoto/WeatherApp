//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Aoyagi Naoto on 2018/08/12.
//  Copyright © 2018年 vertex. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class DetailViewController:
    UIViewController{
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var todayLabel:UILabel!
    @IBOutlet weak var todayWeatherImage:UIImageView!
    @IBOutlet weak var todayWeatherLabel:UILabel!
    @IBOutlet weak var todayTempLabel:UILabel!
 
    
    @IBOutlet weak var tomorrowLabel:UILabel!
    @IBOutlet weak var tomorrowWeatherImage:UIImageView!
    @IBOutlet weak var tomorrowWeatherLabel:UILabel!
    @IBOutlet weak var tomorrowTempLabel:UILabel!
    
    
    @IBOutlet weak var aftertomorrowLabel:UILabel!
    @IBOutlet weak var aftertomorrowWeatherImage:UIImageView!
    @IBOutlet weak var aftertomorrowWeatherLabel:UILabel!
    @IBOutlet weak var aftertomorrowTempLabel:UILabel!
    
    var cityId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard !cityId.isEmpty else {
            self.simpleAlert(title: "エラー", message: "cityIDを参照できません")
            return
        }
        
        Alamofire.request("http://weather.livedoor.com/forecast/webservice/json/v1?city=\(cityId)").responseJSON{(response: DataResponse<Any>)in
            
            if response.result.isFailure == true{
                self.simpleAlert(title: "通信エラー", message: "通信に失敗しました")
            return
                
            }
            
                guard let val = response.result.value as?[String: Any]
                    else{
                        self.simpleAlert(title: "エラー", message: "通信結果がJSONではありませんでした")
                        return
                        
                }
                
                let json = JSON(val)
                self.titleLabel.text = json["title"].string
        
        
                if let forecasts = json["forecasts"].array {
                    
                    let todayWeather = forecasts[0]
                    
                    self.todayLabel.text = todayWeather["dateLabel"].stringValue
                    if let imgUrl = todayWeather["image"]["url"].string{
                        self.todayWeatherImage.sd_setImage(with: URL(string: imgUrl))
                    }
                    self.todayWeatherLabel.text = todayWeather["telop"].stringValue
                    self.todayTempLabel.text = self.generateTemperatureText(todayWeather["temperture"])
                
                    let tomorrowWeather = forecasts[1]
                    self.tomorrowLabel.text = tomorrowWeather["dateLabel"].stringValue
                    if let imgUrl = tomorrowWeather["image"]["url"].string {
                        self.tomorrowWeatherImage.sd_setImage(with: URL(string: imgUrl))
                    }
                    self.tomorrowWeatherLabel.text = tomorrowWeather["telop"].stringValue
                    self.tomorrowTempLabel.text = self.generateTemperatureText(tomorrowWeather["temperature"])

               
                    let afterTomorrowWeather = forecasts[2]
                
                    self.aftertomorrowLabel.text = afterTomorrowWeather["dateLabel"].stringValue
                    if let imgUrl = afterTomorrowWeather["image"]["url"].string {
                        self.aftertomorrowWeatherImage.sd_setImage(with: URL(string: imgUrl))
                    }
                    self.aftertomorrowWeatherLabel.text = afterTomorrowWeather["telop"].stringValue
                    self.aftertomorrowTempLabel.text = self.generateTemperatureText(afterTomorrowWeather["temperature"])
                    }
            
/*            if let forecasts = json ["forcasts"].array{
                
                let todayWeather = forecasts[0]
             
                
                
            }
 */
        }
        
  
        
    
}

func simpleAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
}
    
    func generateTemperatureText(_ temperature: JSON) -> String {
        
        var resultText = ""
        
        if let min = temperature["min"]["celsius"].string {
            resultText += min + "℃"
        } else {
            resultText += "-"
        }
        
        resultText += " / "
        
        if let max = temperature["max"]["celsius"].string {
            resultText += max + "℃"
        } else {
            resultText += "-"
        }
        
        return resultText
        
       

    }
    
  /*
    self.todayTemperatureLabel.text = self.generateTemperatureText(todayWeather["temperature"])
    
    let tomorrowWeather = forecasts[1]
    
    self.tomorrowLabel.text = tomorrowWeather["dateLabel"].stringValue
    if let imgUrl = tomorrowWeather["image"]["url"].string {
        self.tomorrowImage.sd_setImage(with: URL(string: imgUrl))
    }
    self.tomorrowWeatherLabel.text = tomorrowWeather["telop"].stringValue
    self.tomorrowTemperatureLabel.text = self.generateTemperatureText(tomorrowWeather["temperature"])
    
    
    if forecasts.count >= 3 {
    let afterTomorrowWeather = forecasts[2]
    
    self.afterTomorrowLabel.text = afterTomorrowWeather["dateLabel"].stringValue
    if let imgUrl = afterTomorrowWeather["image"]["url"].string {
    self.afterTomorrowImage.sd_setImage(with: URL(string: imgUrl))
    }
    self.afterTomorrowWeatherLabel.text = afterTomorrowWeather["telop"].stringValue
    self.afterTomorrowTemperatureLabel.text = self.generateTemperatureText(afterTomorrowWeather["temperature"])
    }*/

}
/*
func insertData(dateLabel:UILabel, imageView:UIImageView,
                weatherLabel:UILabel, tempLabel:UILabel, dataNum:JSON) {
    
                dateLabel.text = data["dataLabel"].stringValue
    
                if let imgUrl = todayWeather["image"]["url"].string{
                    imageView.sd_setImage(with: URL(string: imgUrl))
        }
                weatherLabel.text = data["telop"].stringValue
                tempLabel.text = self.generateTempText(data)["temperature"]

}*/
