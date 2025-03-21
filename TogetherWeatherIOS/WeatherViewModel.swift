// Here the fetch and process of WeatherData will happen
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    
    private let apiKey = "381d05859658f31ed63e13e5da45cbef"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeatherData(city: String) async {
        guard let url = URL(string: "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric") else {
            print("Invalid city URL")
            return
        }
                await fetchWeather(from: url)
    }

    func getWeatherData(lat: Double, lon: Double) async {
        guard let url = URL(string: "\(baseUrl)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else {
            print("Invalid lat and lon URL")
            return
        }
                await fetchWeather(from: url)
    }

    private func fetchWeather(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)

            DispatchQueue.main.async {
                self.weatherData = decodedData
            }
        }
        catch {print("Error decoding JSON")}
    }
}

