//
//  APIService.swift
//  WeatherApp
//
//  Created by Камиль Сулейманов on 13.10.2021.
//

import UIKit

class APIService {
    static let shared = APIService()
     func getWeather(lat: Double, long: Double, completion: @escaping (JSONWeather) -> ()) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=16cf9696c382b9ef7eb3981ea30ed2df")  else { return }
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if error == nil, let data = data {
                let decoder = JSONDecoder()
                do {
                    let weather = try decoder.decode(JSONWeather.self, from: data)
                    completion(weather)
                } catch {
                    print("Error parsing JSON")
                }
            }
        }
        session.resume()
    }
    
     func getIcon(from weather: JSONWeather, completion: @escaping (UIImage) -> ()) {
        if let url = URL(string: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png") {
            let session = URLSession.shared.dataTask(with: url) {  data, response, error in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    if let data = data {
                        completion(UIImage(data: data)!)
                    }
                }
            }
            session.resume()
        }
    }
    
}
