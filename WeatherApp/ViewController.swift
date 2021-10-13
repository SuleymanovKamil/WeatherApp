//
//  ViewController.swift
//  WeatherApp
//
//  Created by Камиль Сулейманов on 13.10.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager: CLLocationManager!
    var weather: JSONWeather?
    var url: String? = nil
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var weatherView: UIView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getLocation()
    }
    func setupView() {
        weatherView.isHidden = true
        loadingView.layer.cornerRadius = 15
        loadingView.layer.shadowColor = UIColor.black.cgColor
        loadingView.layer.shadowOpacity = 0.1
        loadingView.layer.shadowOffset = .zero
        loadingView.layer.shadowRadius = 10
    }
}


extension ViewController {
    func getWeather() {
        guard url != nil else { return }
        
        let session = URLSession.shared.dataTask(with: URL(string: url!)!) {[weak self] data, response, error in
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                do {
                    let weather = try decoder.decode(JSONWeather.self, from: data!)
                    self?.weather = weather
                    self?.addTextOnLabels()
                    self?.getIcon()
                } catch {
                    print("Error parsing JSON")
                }
            }
        }
        session.resume()
    }
    
    func getIcon() {
        guard weather != nil else { return }
        if let url = URL(string: "https://openweathermap.org/img/wn/\(weather!.weather[0].icon)@2x.png") {
            let session = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    if let data = data {
                    self?.iconImage.image = UIImage(data: data)
                    }
                }
            }
            session.resume()
        }
    }
    
    func showWeatherView() {
        loadingView.isHidden = true
        isLoading.stopAnimating()
        weatherView.isHidden = false
    }
    
    func addTextOnLabels() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.temperatureLabel.text = "\(String(describing: Int((self.weather!.main.temp - 273.15))))°C"
            self.cityNameLabel.text = self.weather?.name
            self.weatherLabel.text = "Today " + (self.weather?.weather.first!.main)!
            self.humidityLabel.text = "Wind: " + String(describing:self.weather!.wind.speed) + "m/s"
            self.windLabel.text = "Humidity: " + String(describing:self.weather!.main.humidity) + "% "
            
            self.showWeatherView()
        }

    }
}

extension ViewController: CLLocationManagerDelegate {
    func getLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        url = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=16cf9696c382b9ef7eb3981ea30ed2df"
        locationManager.stopUpdatingLocation()
        getWeather()
    }
}
