import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var cityName: String = ""

    var weatherShadow: some ViewModifier {
        ShadowModifier()
    }

    struct ShadowModifier: ViewModifier {
        func body(content: Content) -> some View {
            content.shadow(color: Color.white.opacity(0.7), radius: 0, x: 0.5, y: 1)
        }
    }
    
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
            gradient: Gradient(colors: [color.opacity(0.9), color]),
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
                Text("\(weather.name), \(weather.sys.country)").font(.largeTitle).bold().modifier(weatherShadow)
                Text("\(weather.main.roundedTemp)°").font(.system(size: 120)).modifier(weatherShadow)
                Text("\(weather.weather[0].main)").font(.title2)
                
                Spacer().frame(height: 8)
                
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
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(18)
            }
            
            Spacer().frame(height: 72)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search for a city", text: $cityName)
            }
            .padding()
            .frame(width: 350, height: 40)
            .background(Color.white.opacity(0.3))
            .cornerRadius(18)
            .onSubmit {
                Task {
                    await viewModel.getWeatherData(city: cityName)
                    cityName = ""
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
                .foregroundColor(Color.black.opacity(0.5))
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
