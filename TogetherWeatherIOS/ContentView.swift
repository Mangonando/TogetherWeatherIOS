import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cityName: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            if let weather = viewModel.weatherData {
                Text("\(weather.name), \(weather.sys.country)").font(.largeTitle).bold()
                Text("\(weather.weather[0].main)").font(.title2)
                Text("\(weather.main.roundedTemp) °c").font(.title)
                Text("\(weather.main.roundedFeelsLike) °c").font(.title3)
                Text("\(weather.main.roundedTempMin) °c").font(.title3)
                Text("\(weather.main.roundedTempMax) °c").font(.title3)
            }
            HStack {
                TextField("Enter city name", text: $cityName)
                    .padding()
                    .frame(width: 250, height: 40)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .onSubmit {
                        viewModel.getWeatherData(city: cityName)
                    }
                Button(action: {
                    viewModel.getWeatherData(city: cityName)
                }) {
                    Text("Search")
                        .foregroundColor(.white)
                        .font(.title3)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient (
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.5), Color.blue]),
                startPoint: .bottom,
                endPoint: .top
            )
        )
        .onAppear{
            viewModel.getWeatherData(city: "Berlin")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
