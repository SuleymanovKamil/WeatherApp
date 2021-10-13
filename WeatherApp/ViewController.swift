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
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var iconImage: UIImageView!
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
    }
}

//MARK: ViewController methods
extension ViewController {
    func setupView() {
        weatherView.isHidden = true
        loadingView.layer.cornerRadius = 15
        loadingView.layer.shadowColor = UIColor.black.cgColor
        loadingView.layer.shadowOpacity = 0.1
        loadingView.layer.shadowOffset = .zero
        loadingView.layer.shadowRadius = 10
        getLocation()
    }
    
    func addTextOnLabels(weather: JSONWeather) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.temperatureLabel.text = "\(String(describing: Int((weather.main.temp - 273.15))))°C"
            self.cityNameLabel.text = weather.name
            self.weatherLabel.text = "Today " + (weather.weather.first?.main)!
            self.humidityLabel.text = "Wind: " + String(describing: weather.wind.speed) + "m/s"
            self.windLabel.text = "Humidity: " + String(describing:weather.main.humidity) + "% "
            
            self.showWeatherView()
        }
    }
    
    func showWeatherView() {
        loadingView.isHidden = true
        isLoading.stopAnimating()
        weatherView.isHidden = false
    }
}

//MARK: CoreLocation methods
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
        locationManager.stopUpdatingLocation()
        APIService.shared.getWeather(lat: location.coordinate.latitude, long: location.coordinate.longitude) { [weak self] weather in
            self?.addTextOnLabels(weather: weather)
            APIService.shared.getIcon(from: weather) { self?.iconImage.image = $0 }
        }
    }
}

