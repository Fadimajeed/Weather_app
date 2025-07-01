# Weather App

## Project Overview

This is a modern and intuitive Flutter weather application designed to provide real-time weather forecasts, animated visualizations, and location-based services. It features a dynamic user interface with background gradients that adapt to weather conditions, custom-designed weather icons, and detailed meteorological data, offering a rich and engaging user experience.

## Key Features

*   **Real-time Weather Data:** Displays current weather conditions, including temperature, humidity, wind speed, and sunrise/sunset times.
*   **Animated Visualizations:** Features custom-painted weather icons (sun, clouds, rain, snow, thunderstorm, moon) that dynamically change based on the weather. Includes a temperature chart for hourly predictions and an interactive sunrise/sunset arc visualization.
*   **Location Services:** Automatically detects the user's current location to provide immediate weather information. Also includes a city search functionality for users to look up weather in other locations.
*   **Dynamic UI/UX:** Implements dynamic background gradients that transition based on weather conditions, enhancing the visual appeal and user immersion. Smooth animated transitions are used throughout the application.
*   **Forecast Data:** Provides a comprehensive 5-day weather forecast and detailed hourly temperature predictions.
*   **Responsive Design:** Ensures a consistent and optimized user experience across various mobile devices and screen sizes.

## Technologies Used

*   **Flutter SDK:** The primary framework for building cross-platform mobile applications.
*   **Dart Language:** The programming language used for development.
*   **`flutter_bloc`:** For robust and predictable state management, separating business logic from the UI.
*   **`geolocator`:** To handle location services, including requesting permissions and fetching current location.
*   **`weather`:** A Flutter package for fetching weather data from OpenWeatherMap API.
*   **`flutter_dotenv`:** For securely managing API keys and other environment variables.
*   **CustomPaint:** Utilized for drawing custom weather icons and the sunrise/sunset arc, showcasing advanced Flutter UI capabilities.

## Getting Started

To set up and run the weather application locally, follow these steps:

### Prerequisites

*   **Flutter SDK:** Ensure you have Flutter installed. If not, refer to the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
*   **OpenWeatherMap API Key:** Obtain a free API key from OpenWeatherMap. You will need this to fetch weather data. Register here: [https://openweathermap.org/api](https://openweathermap.org/api)

### Installation

1.  **Clone the repository:**
    ```bash
   git clone https://github.com/Fadimajeed/Weather_app.git
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd weather_app
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Configure API Key:**
    *   Create a `.env` file in the root directory of the project.
    *   Add your OpenWeatherMap API key to the `.env` file in the following format:
        ```env
        API_KEY=your_openweather_api_key_here
        ```
        *Replace `your_openweather_api_key_here` with your actual API key.*

5.  **Run the application:**
    ```bash
    flutter run
    ```

## Project Structure

```
lib/
├── main.dart
├── bloc/
│   ├── search_bloc.dart
│   ├── search_event.dart
│   ├── search_state.dart
│   ├── weather_loctaion_bloc.dart
│   ├── weather_loctaion_event.dart
│   └── weather_loctaion_state.dart
├── main_screens/
│   ├── home_screen.dart
├── extras/
│   ├── charts.dart
│   ├── forecast.dart
│   └── search.dart
├── shapes/
│   ├── all_shapes.dart
│   ├── cloud.dart
│   ├── moon.dart
│   ├── rain.dart
│   ├── snow.dart
│   ├── sun.dart
│   ├── sunset_arc.dart
│   └── Thunderstorm.dart
└── backscreencolors/
    └── allcolors.dart
```

## State Management

This project leverages the **`flutter_bloc`** library for robust and scalable state management. BLoC (Business Logic Component) pattern is implemented to separate the application's business logic from the UI, ensuring a clear and maintainable architecture. Specifically:

*   **`WeatherLoctaionBloc`:** Manages the state related to the user's current location and fetches weather data based on it.
*   **`WeatherSearchBloc`:** Handles the state for weather searches by city name.

This approach promotes unidirectional data flow, testability, and improved performance by rebuilding only necessary widgets when state changes.

## Screenshots

![Allow weather_app to access this device's location?](https://github.com/Fadimajeed/Weather_app/blob/master/weather-app-images/Screenshot_1751327580.png?raw=true)
![Mountain View weather details](https://github.com/Fadimajeed/Weather_app/blob/master/weather-app-images/Screenshot_1751327584.png?raw=true)
![Detailed weather forecast with chart](https://github.com/Fadimajeed/Weather_app/blob/master/weather-app-images/Screenshot_1751327636.png?raw=true)
![Baghdad weather search](https://github.com/Fadimajeed/Weather_app/blob/master/weather-app-images/Screenshot_1751327637.png?raw=true)
![London weather details](https://github.com/Fadimajeed/Weather_app/blob/master/weather-app-images/Screenshot_1751327702.png?raw=true)


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


