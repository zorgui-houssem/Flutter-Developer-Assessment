# WeatherNow 🌤️

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-brightgreen?style=for-the-badge)](#🏗️-architecture)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**WeatherNow** is a production-grade weather forecasting application built with **Flutter** using **Clean Architecture** principles. Designed with an **offline-first** approach, it manages state seamlessly via **BLoC**, and features a premium user interface rich in **glassmorphism**, dynamic gradients, and smooth interactive micro-animations.

---

## 🌟 Key Features

*   🔍 **Real-Time Autocomplete with Debounce**: Smart city suggestions with a 300ms debounce to optimize network request load and API usage.
*   💾 **Offline-First (Smart Caching)**: Caches weather data securely locally. Disconnections gracefully transition to local storage data accompanied by a premium orange connectivity alert.
*   📜 **Recent Searches**: Remembers the 5 most recent unique search terms as dynamic, interactive chips, persisted locally across application restarts.
*   🌗 **Dark/Light Mode Theme Toggle**: An elegant interface adapting dynamically to light or dark mode preferences, persisted locally via NoSQL Hive database.
*   💎 **Premium Glassmorphic Design System**: Uses customized modern gradients, micro-animations, loading shimmers, and clear typography for an immersive user experience.
*   🚀 **Automated Dependency Injection**: Out-of-the-box configuration with `get_it` and `injectable` for robust decoupling.

---

## 🏗️ Architecture

The codebase strictly follows **Clean Architecture** guidelines, splitting responsibilities into three isolated layers:

```
lib/
 ├── core/                  # Global utilities, theme configurations, styling constants, & exceptions
 ├── injection/             # Dependency Injection setup using GetIt and Injectable modules
 ├── features/              # Feature modules
 │    └── weather/
 │         ├── domain/      # Business logic: pure entities and use cases (GetWeather)
 │         ├── data/        # Data management: models, local/remote data sources, and repositories
 │         └── presentation/# UI components: BLoC logic, screens, and custom widgets
 └── main.dart              # App bootstrap and critical initialization logic
```

---

## 🛠️ Tech Stack & Packages

*   **State Management**: `flutter_bloc`
*   **Local Caching & Database**: `hive` & `hive_flutter`
*   **Dependency Injection**: `get_it` & `injectable` (with `injectable_generator`)
*   **Networking**: `dio` (with offline interceptors)
*   **Connectivity**: `connectivity_plus`
*   **Environment Configuration**: `flutter_dotenv`

---

## 🚀 Setup & Installation

### Prerequisites:
*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (version `>=3.0.0` supported)
*   An active **OpenWeatherMap API Key** (Current Weather Data API)

### Step-by-Step Guide:

1.  **Clone the repository** to your local machine.
2.  **Configure Environment Variables**:
    *   Create a `.env` file at the root of the project by copying `.env.example`:
        ```env
        OPENWEATHER_API_KEY=your_api_key_here
        ```
3.  **Fetch Flutter dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run code generation (Dependency Injection Setup)**:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
5.  **Launch the Application**:
    ```bash
    flutter run
    ```

---

## 🧪 Testing

The repository contains a robust suite of unit and widget tests verifying use cases, caching mechanisms, BLoC state emissions, and repositories.

To run all unit tests:
```bash
flutter test
```

All tests run successfully:
```txt
All tests passed!
```
