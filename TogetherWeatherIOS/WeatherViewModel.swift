// Here the fetch and process of WeatherData will happen
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    
    private let apiKey = "381d05859658f31ed63e13e5da45cbef"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeatherData(city: String) async {
        var components = URLComponents(string: baseUrl)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")]

        guard let url = components?.url else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            self.weatherData = decodedData
            print("JSON successfully decoded")
        }
        catch {print("Error decoding JSON")}
    }
}

