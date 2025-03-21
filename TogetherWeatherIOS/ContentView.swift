import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var cityName: String = ""
    
    func getBackgroundColor(for temp: Int) -> LinearGradient {
        let color: Color

        switch temp {
        case -10..<0:
            color = .blue
        case 0...9:
            color = .cyan
        case 10...19:
            color = .teal
        case 20...29:
            color = .green
        case 30...34:
            color = .yellow
        case 35...39:
            color = .orange
        case 40...:
            color = .red
        default:
            color = .purple
        }

        return LinearGradient (
            gradient: Gradient(colors: [color.opacity(0.2), color.opacity(0.5), color]),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    func handleLocationUpdate() {
        Task {
            if let lat = locationManager.userLat, let lon = locationManager.userLon {
                await viewModel.getWeatherData(lat: lat, lon: lon)
            } else {
                await viewModel.getWeatherData(city: "Envigado")
            }
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
                        Task {
                            await viewModel.getWeatherData(city: cityName)
                            cityName = ""
                        }
                    }
                Button(action: {
                    Task {
                        await viewModel.getWeatherData(city: cityName)
                    }
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
            Button(action: {
                locationManager.requestLocation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    handleLocationUpdate()
                }
            }) {
                HStack {
                    Image(systemName: "location.fill")
                    Text("My Location")
                }
                .font(.footnote)
                .padding(.top, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(getBackgroundColor(for: viewModel.weatherData?.main.roundedTemp ?? 0))
        .onAppear{
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.userLat) {_ in
            handleLocationUpdate()
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
