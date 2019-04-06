//
//  ViewController.swift
//  Assignment
//
//  Created by GadgetZone on 4/5/19.
//  Copyright © 2019 GadgetZone. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var locationManager = CLLocationManager()
    var weather: Weather?
    var currentWeather: CurrentlyWeather?
    var isApiCalled = false
    
    @IBOutlet weak var temperatureImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeZoneNameLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLevel: UILabel!
    @IBOutlet weak var PressureLabel: UILabel!
    
    lazy var hourly = NSArray()
    lazy var daily = NSArray()
    
    override func viewDidLoad() {
        
    
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        setupView()
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Weather"
    }
    private func setupView() {
        self.title = "Weather"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        

        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        checkAuth()
        
    }
    
    @IBAction func moreAction(_ sender: Any) {
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL yyyy"
        timeFormatter.dateFormat = "h:mm a"
        let dateStr =  dateFormatter.string(from: currentDate)
        let timeStr =  timeFormatter.string(from: currentDate)
        
        let title = "\(dateStr) \n \(timeStr)"
        
        guard let currentWeathers = self.currentWeather  else { return }
        let message = "Summary: \(currentWeathers.summary) \n ApparentTemperature: \(currentWeathers.temperature) \n WindGust: \(currentWeathers.windGust) \n WindBearing: \(currentWeathers.windBearing) \n Visibility: \(currentWeathers.visibility)"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)

        // Create buttons
        let buttonOne = CancelButton(title: "Done") {
            print("You canceled the dialog.")
        }
        
        let buttonTwo = CancelButton(title: "Show In Details") {
            print(self.hourly)
            if let sb = UIStoryboard.init(name: "Main", bundle: nil) as? UIStoryboard {
                let vc : DetailViewController = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.dailyArray = self.daily
                vc.hourlyArray = self.hourly
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }

        popup.addButtons([buttonTwo,buttonOne])

        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    
   
    
    private func checkTemperature(temperature: Float) {
        print(temperature)
        if temperature <= 33 {
            temperatureImageView.image = UIImage.init(named: "snowing")
        }
        else if temperature <= 68 {
            temperatureImageView.image = UIImage.init(named: "cloud")
        }
        else if temperature <= 104 {
            temperatureImageView.image = UIImage.init(named: "both")
        }
        else {
            temperatureImageView.image = UIImage.init(named: "sunny")
        }
    }
    
    private func checkAuth() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                print("nd")
            case .restricted:
                print("re")
            case .denied:
                print("de")
                let alert = UIAlertController.init(title: "Alert", message: "Would You Like to Share Your Location with us", preferredStyle: .alert)
                let action1 = UIAlertAction.init(title: "Yes", style: .default) { (action) in
                    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
                let action2 = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
                
            case .authorizedAlways:
                print("au")
            case .authorizedWhenInUse:
                print("awiu")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    
    private func weatherApiFetch(latitude: CLLocationDegrees,longitude: CLLocationDegrees) {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        print(latitude)
        print(longitude)
        isApiCalled = true
        
        guard let url = URL(string: "https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/\(latitude),\(longitude)") else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let jsonResponse = response.result.value as? NSDictionary {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let timeZone = jsonResponse.value(forKey: "timezone") as? String
                    
                    self.weather = Weather(latitude: "0", longitude: "0", timeZone: timeZone ?? "")
                    
                    
                    
                    if let weathers = self.weather {
                        self.timeZoneNameLabel.text = weathers.timeZone
                    }
                    
                    if let hourlyDict = jsonResponse.value(forKey: "hourly") as? NSDictionary {
                        self.hourly = hourlyDict.value(forKey: "data") as! NSArray
                    }
                    
                    if let dailyDict = jsonResponse.value(forKey: "daily") as? NSDictionary {
                        self.daily = dailyDict.value(forKey: "data") as! NSArray
                    }
                    
                    if let currentDict = jsonResponse.value(forKey: "currently") as? NSDictionary {
                        
                        let summary = currentDict.value(forKey: "summary") as? String
                        let icon = currentDict.value(forKey: "icon") as? String
                        let temperature = currentDict.value(forKey: "temperature") as? Double
                        let pressure = currentDict.value(forKey: "pressure") as? Double
                        let humidity = currentDict.value(forKey: "humidity") as? Double
                        let windGust = currentDict.value(forKey: "windGust") as? Double
                        let windSpeed = currentDict.value(forKey: "windSpeed") as? Double
                        let windBearing = currentDict.value(forKey: "windBearing") as? Double
                        let visibility = currentDict.value(forKey: "visibility") as? Double
                        
                        let temperatureStr = String(format: "%.2f", temperature ?? 0)
                        let pressureStr = String(format: "%.2f", pressure ?? 0)
                        let humidityStr = String(format: "%.2f", humidity ?? 0)
                        let windGustStr = String(format: "%.2f", windGust ?? 0)
                        let windSpeedStr = String(format: "%.2f", windSpeed ?? 0)
                        let windBearingStr = String(format: "%.2f", windBearing ?? 0)
                        let visibilityStr = String(format: "%.2f", visibility ?? 0)
                        
                        
                        self.currentWeather = CurrentlyWeather(time: 1234, summary: summary ?? "", icon: icon ?? "", temperature: temperatureStr, pressure: pressureStr, humidity: humidityStr, windSpeed: windSpeedStr, windGust: windGustStr, windBearing: windBearingStr, visibility: visibilityStr)
                        
                        
                        if let currentWeathers = self.currentWeather {
                            
                            self.temperatureLabel.text = currentWeathers.temperature + "°F"
                            
                            self.windLabel.text = currentWeathers.windSpeed + "mph"
                            
                            self.humidityLevel.text = "\(currentWeathers.humidity)%"
                            
                            self.PressureLabel.text = "\(currentWeathers.pressure)%"
                            
                            
                            let sid = Float(temperature ?? 0)
                            self.checkTemperature(temperature: sid)
                            
                        }
                    }
                    
                    
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isApiCalled == false {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            let latitude = locValue.latitude
            let longitude = locValue.longitude
            weatherApiFetch(latitude: latitude, longitude: longitude)
        }
    }
    
}
