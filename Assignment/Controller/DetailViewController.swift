//
//  DetailViewController.swift
//  Assignment
//
//  Created by GadgetZone on 4/6/19.
//  Copyright © 2019 GadgetZone. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var dailyArray = NSArray()
    var hourlyArray = NSArray()
    @IBOutlet weak var tableView: UITableView!
    var dataFrom = false
    override func viewDidLoad() {
        super.viewDidLoad()
        popup()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func setupView() {
        self.title = "Details"
        
        tableView.separatorStyle = .none
    }
    
    private func popup() {
        let title = "Select Type"
        
        let popup = PopupDialog(title: title, message: nil, image: nil)
        
        let buttonOne = CancelButton(title: "Hourly") {
           
            self.dataFrom = true
            self.tableView.reloadData()
        }
        
        let buttonTwo = CancelButton(title: "daily") {
            
            self.dataFrom = false
            self.tableView.reloadData()
        }
        
        let cancel = CancelButton(title: "Cancel") {
            print("You canceled the dialog.")
            self.navigationController?.popToRootViewController(animated: true)
        }
        popup.addButtons([buttonTwo,buttonOne,cancel])
        
        self.present(popup, animated: true, completion: nil)
    }
    
    private func getTimeAndDate(timeStamp: Int,isFrom: Bool) -> String {
        let unixTimestamp = timeStamp
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        if isFrom == true {
            dateFormatter.dateFormat = "h:mm a"
        }
        else {
            dateFormatter.dateFormat = "dd-LLLL-yyyy"
        }
         //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataFrom == true {
            return hourlyArray.count
        }
        return dailyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
        cell.selectionStyle = .none
        var items: NSDictionary?
        if dataFrom == true {
            items = hourlyArray.object(at: indexPath.row) as? NSDictionary
            
            let temperature = items?.value(forKey: "temperature") as? Double
            let humidity = items?.value(forKey: "humidity") as? Double
            let windSpeed = items?.value(forKey: "windSpeed") as? Double
            let pressure = items?.value(forKey: "pressure") as? Double
            let visibility = items?.value(forKey: "visibility") as? Double
            let timeStamp = items?.value(forKey: "time") as? Int ?? 0
            
            
            
            let temperatureStr = String(format: "%.2f", temperature ?? 0)
            let humidityStr = String(format: "%.2f", humidity ?? 0)
            let windSpeedStr = String(format: "%.2f", windSpeed ?? 0)
            let pressureStr = String(format: "%.2f", pressure ?? 0)
            let visibilityStr = String(format: "%.2f", visibility ?? 0)
            
            cell.summaryLabel.text = items?.value(forKey: "summary") as? String
            cell.temperatureLabel.text = "Temperature:" + temperatureStr
            cell.humidityLabel.text = "Humidity:" + humidityStr
            cell.windspeedLabel.text = "WindSpeed:" + windSpeedStr
            cell.pressureLabel.text = "Pressure:" + pressureStr
            cell.visibiltyLabel.text = "Visibility:" + visibilityStr
            cell.timeLabel.text = getTimeAndDate(timeStamp: timeStamp, isFrom: true)
            
            
        }else {
            items = dailyArray.object(at: indexPath.row) as? NSDictionary
            cell.summaryLabel.text = items?.value(forKey: "summary") as? String
            
            
            let temperature = items?.value(forKey: "temperatureHigh") as? Double
            let humidity = items?.value(forKey: "humidity") as? Double
            let windSpeed = items?.value(forKey: "windSpeed") as? Double
            let pressure = items?.value(forKey: "pressure") as? Double
            let visibility = items?.value(forKey: "visibility") as? Double
            let timeStamp = items?.value(forKey: "time") as? Int ?? 0
            
            let temperatureStr = String(format: "%.2f", temperature ?? 0)
            let humidityStr = String(format: "%.2f", humidity ?? 0)
            let windSpeedStr = String(format: "%.2f", windSpeed ?? 0)
            let pressureStr = String(format: "%.2f", pressure ?? 0)
            let visibilityStr = String(format: "%.2f", visibility ?? 0)
            
            cell.summaryLabel.text = items?.value(forKey: "summary") as? String
            cell.temperatureLabel.text = "Temperature High:" + temperatureStr
            cell.humidityLabel.text = "Humidity:" + humidityStr
            cell.windspeedLabel.text = "WindSpeed:" + windSpeedStr
            cell.pressureLabel.text = "Pressure:" + pressureStr
            cell.visibiltyLabel.text = "Visibility:" + visibilityStr
            cell.timeLabel.text = getTimeAndDate(timeStamp: timeStamp, isFrom: false)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
