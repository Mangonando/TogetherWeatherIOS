import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cityName: String = ""
    
    func getBackgroundColor(for temp: Int) -> LinearGradient {
        if temp >= -10 && temp < -1 {
            return LinearGradient (
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.5), Color.blue]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else if temp >= 0 && temp <= 9 {
            return LinearGradient (
                gradient: Gradient(colors: [Color.cyan.opacity(0.2), Color.cyan.opacity(0.5), Color.cyan]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else if temp >= 10 && temp <= 19 {
            return LinearGradient (
                gradient: Gradient(colors: [Color.teal.opacity(0.2), Color.teal.opacity(0.5), Color.teal]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else if temp >= 20 && temp <= 29 {
            return LinearGradient (
                gradient: Gradient(colors: [Color.green.opacity(0.2), Color.green.opacity(0.5), Color.green]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else if temp >= 30 && temp <= 34 {
            return LinearGradient (
                gradient: Gradient(colors: [Color.yellow.opacity(0.2), Color.yellow.opacity(0.5), Color.yellow]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else if temp >= 35 && temp <= 39 {
            return LinearGradient (
                gradient: Gradient(colors: [Color.orange.opacity(0.2), Color.orange.opacity(0.5), Color.orange]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else if temp > 40 {
            return LinearGradient (
                gradient: Gradient(colors: [Color.red.opacity(0.2), Color.red.opacity(0.5), Color.red]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            return LinearGradient (
                gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.purple.opacity(0.5), Color.purple]),
                startPoint: .bottom,
                endPoint: .top
            )
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if let weather = viewModel.weatherData {
                Text("\(weather.name), \(weather.sys.country)").font(.largeTitle).bold()
                Text("\(weather.weather[0].main)").font(.title2)
                Text("\(weather.main.roundedTemp) °c").font(.system(size: 72))
                
                Spacer().frame(height: 12)
                
                HStack(spacing: 50){
                    VStack(){
                        Text("\(weather.main.roundedFeelsLike) °c").font(.title3)
                        Text("Feels like")
                    }
                    VStack(){
                        Text("\(weather.main.roundedTempMin) °c").font(.title3)
                        Text("Min temp")
                    }
                    VStack(){
                        Text("\(weather.main.roundedTempMax) °c").font(.title3)
                        Text("Max temp")
                    }

                }
            }
            
            Spacer().frame(height: 72)
            
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
        .background(getBackgroundColor(for: viewModel.weatherData?.main.roundedTemp ?? 0))
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
