//
//  Forecast.swift
//  Mobile Weather App
//
//  Created by Stewart Lynch on 2021-01-18.
//

import Foundation

struct JSONWeather: Codable {
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let timezone, id: Int
    let name: String
}

struct Clouds: Codable {
    let all: Int
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

