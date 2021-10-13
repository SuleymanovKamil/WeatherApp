//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Камиль Сулейманов on 13.10.2021.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    var vc: ViewController!
    
    override func setUpWithError() throws {
        vc = ViewController()
    }
    
    override func tearDownWithError() throws {
        vc = nil
    }
    
    func testGettingData() throws {
        vc.weather = nil
        vc.url = "https://api.openweathermap.org/data/2.5/weather?lat=42.9764&lon=47.5024&appid=16cf9696c382b9ef7eb3981ea30ed2df"
        vc.getWeather()
        sleep(2)
        XCTAssertNotNil(vc.weather)
    }
}
