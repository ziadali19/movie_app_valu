# 🎬 CineScout - Flutter Movie Discovery App

A production-quality Flutter application that showcases modern mobile development practices with clean architecture, comprehensive testing, and real-world API integration.

## 📱 App Overview

**CineScout** (branded as "Valu Movies") is a sophisticated movie discovery application built with Flutter that demonstrates enterprise-level development practices. The app provides a seamless experience for browsing popular movies, searching the vast TMDB database, viewing detailed movie information, and managing a personal favorites collection with offline support.

## 🎥 App Demo Video

**Watch the complete feature demonstration:**

[![CineScout App Demo](https://img.shields.io/badge/▶️_Watch_Full_Demo-FF0000?style=for-the-badge&logo=googledrive&logoColor=white)](https://drive.google.com/file/d/1thVXLSXLVcOc9SlXjEQB06JobodFiTAu/view?usp=sharing)

🎥 [Watch App Demo](https://drive.google.com/file/d/1thVXLSXLVcOc9SlXjEQB06JobodFiTAu/view?usp=sharing)

### 🎬 Demo Showcases:

- **🎭 Movie Discovery**: Smooth browsing with infinite scroll
- **🔍 Smart Search**: Real-time search with debouncing
- **📄 Rich Details**: Comprehensive movie information
- **❤️ Favorites System**: Add/remove with offline storage
- **🔄 Error Handling**: Graceful error recovery
- **⚡ Performance**: Optimized scrolling and responsive UI

---

## ✨ Key Features Implemented

### 🎯 Core User Stories (All Implemented)

1. **📺 Browse Popular Movies**

   - Paginated list of trending movies with infinite scroll
   - Pull-to-refresh functionality for latest content
   - Smooth navigation to detailed movie views

2. **🔍 Advanced Search**

   - Real-time movie search with intelligent debouncing
   - Paginated search results with optimized performance
   - Comprehensive search across TMDB's extensive database

3. **📄 Detailed Movie Information**

   - Rich movie details including genres, runtime, ratings, and overview
   - Production company and country information
   - IMDB integration and release date details

4. **❤️ Personal Favorites System**

   - Local storage with Hive for offline access
   - Add/remove movies from favorites with visual feedback
   - Search within saved favorites
   - Persistent storage that works completely offline

5. **🔄 Robust Error Handling**
   - Meaningful error messages with retry mechanisms
   - Graceful offline experience with cached data
   - Smart error recovery and user feedback

## 🏗️ Architecture Excellence

### Feature-Based Architecture with Clean Principles

📁 Project Structure

```
lib/
├── main.dart                          # App entry point with Hive initialization
├── movie_app_valu.dart                 # App widget configuration
│
├── core/                              # 🔧 Shared Infrastructure
│   ├── helpers/
│   │   ├── bloc_observer.dart         # BLoC state monitoring
│   │   ├── extensions.dart            # Dart extensions
│   │   ├── show_toast.dart            # Custom snackbar
│   │   ├── sizes_config.dart          # Screen utilities
│   │   └── spacing.dart               # Spacing helpers
│   │
│   ├── network/
│   │   ├── api_error_handler.dart     # Error handling
│   │   ├── dio_helper.dart            # Dio configuration
│   │   ├── exceptions.dart            # Custom exceptions
│   │   ├── failure_model.dart         # Error models
│   │   └── generic_response.dart      # API response wrapper
│   │
│   ├── routing/
│   │   ├── app_router.dart            # Route generation
│   │   └── routes.dart                # Route constants
│   │
│   ├── services/
│   │   ├── service_locator.dart       # Dependency injection
│   │   └── shared_perferences.dart    # Local storage
│   │
│   ├── theming/
│   │   ├── colors.dart                # Color palette
│   │   ├── styles.dart                # Typography
│   │   └── themes.dart                # App themes
│   │
│   ├── utils/
│   │   └── constants.dart             # API keys & URLs
│   │
│   └── widgets/
│       ├── app_error_view.dart        # Error state widget
│       ├── app_loading.dart           # Loading widget
│       ├── elevated_button_without_icon.dart
│       ├── error_header.dart          # Error banner
│       └── search_bar.dart            # Shared search bar
│
└── features/                          # 🎯 Feature Modules
    │
    ├── main-navigation/               # 🧭 App Navigation
    │   ├── controller/bloc/
    │   └── presentation/
    │       ├── components/
    │       └── screens/
    │
    ├── movies/                        # 🎬 Popular Movies
    │   ├── controller/bloc/
    │   ├── data/
    │   │   ├── models/
    │   │   ├── remote_data_source/
    │   │   └── repository/
    │   └── presentation/
    │       ├── components/
    │       └── screens/
    │
    ├── search/                        # 🔍 Movie Search
    │   ├── controller/bloc/
    │   ├── data/
    │   │   ├── remote_data_source/
    │   │   └── repository/
    │   └── presentation/
    │       ├── components/
    │       └── screens/
    │
    ├── movie_details/                 # 📄 Movie Details
    │   ├── controller/bloc/
    │   ├── data/
    │   │   ├── models/
    │   │   ├── remote_data_source/
    │   │   └── repository/
    │   └── presentation/
    │       ├── components/
    │       └── screens/
    │
    └── favorites/                     # ❤️ Local Favorites
        ├── controller/bloc/
        ├── data/
        │   ├── models/
        │   ├── local_data_source/
        │   └── repository/
        └── presentation/
            ├── components/
            └── screens/
```

### 🎯 Architectural Patterns Used

- **🏛️ Feature-Based Architecture with Clean Principles**: Separation of presentation, business logic, and data layers
- **🔄 BLoC Pattern**: Predictable state management with reactive programming
- **🗂️ Repository Pattern**: Abstraction of data sources with Either pattern
- **💉 Dependency Injection**: GetIt for loose coupling and testability
- **🧩 Component-Based UI**: Modular, reusable widgets

## 🛠️ Technical Implementation Highlights

### State Management Excellence

- **BLoC + RxDart**: Advanced reactive programming with stream transformations
- **Smart Debouncing**: Optimized search with 300ms debounce using RxDart
- **Enum-Based States**: Type-safe state management with clear transitions
- **Error State Handling**: Sophisticated error management with retry logic

### Network Architecture

- **Dio HTTP Client**: Professional-grade networking with interceptors
- **Automatic API Key Injection**: Centralized authentication handling
- **Error Response Mapping**: Consistent error handling across all endpoints
- **Request/Response Logging**: Comprehensive debugging capabilities

### Local Storage Innovation

- **Hive Database**: Lightning-fast NoSQL storage for favorites
- **Type-Safe Models**: Code-generated adapters for reliable persistence
- **Offline-First Design**: Full functionality without internet connection
- **CRUD Operations**: Complete favorites management system

### UI/UX Excellence

- **Responsive Design**: flutter_screenutil for consistent layouts
- **Modern Material Design**: Contemporary UI with custom theming
- **Optimized Scrolling**: CustomScrollView with Slivers for performance
- **Error Recovery**: User-friendly error states with retry mechanisms

## 🧪 Comprehensive Testing Strategy

### Testing Philosophy

Following TDD principles with comprehensive coverage of business logic and critical user flows.

```
test/                                          # 🧪 Comprehensive Test Suite
├── features/                                  # Feature-based test organization
│   │
│   ├── 🎬 movies/                             # Movies Feature Tests (Complete)
│   │   ├── controller/bloc/
│   │   │   ├── movies_bloc_test.dart          # 480 lines - Complete BLoC testing
│   │   │   │   ├── ✅ LoadMoviesEvent tests (initial load scenarios)
│   │   │   │   ├── ✅ LoadMoreMoviesEvent tests (pagination logic)
│   │   │   │   ├── ✅ RefreshMoviesEvent tests (pull-to-refresh)
│   │   │   │   ├── ✅ RetryLoadingMoviesEvent tests (error recovery)
│   │   │   │   ├── ✅ Error handling scenarios (network failures)
│   │   │   │   ├── ✅ Pagination logic validation (hasMorePages)
│   │   │   │   ├── ✅ State transition verification (enum-based states)
│   │   │   │   └── ✅ Edge cases (empty responses, API errors)
│   │   │   └── 🤖 movies_bloc_test.mocks.dart # 81 lines - Generated BLoC mocks
│   │   │
│   │   └── data/                              # Data layer comprehensive testing
│   │       ├── models/
│   │       │   └── movie_test.dart            # 151 lines - Model testing
│   │       │       ├── ✅ JSON serialization/deserialization
│   │       │       ├── ✅ Object equality and hashCode
│   │       │       ├── ✅ Edge cases (null values, missing fields)
│   │       │       └── ✅ Helper getters validation
│   │       │
│   │       ├── repository/
│   │       │   ├── movies_repository_test.dart # 204 lines - Repository testing
│   │       │   │   ├── ✅ Either pattern success scenarios
│   │       │   │   ├── ✅ Either pattern error scenarios
│   │       │   │   ├── ✅ API error mapping
│   │       │   │   └── ✅ Repository abstraction validation
│   │       │   └── 🤖 movies_repository_test.mocks.dart # 73 lines - Repository mocks
│   │       │
│   │       └── remote_data_source/
│   │           ├── movies_remote_data_source_test.dart # 276 lines - API testing
│   │           │   ├── ✅ TMDB API integration
│   │           │   ├── ✅ Query parameters validation
│   │           │   ├── ✅ Response parsing
│   │           │   ├── ✅ Error response handling
│   │           │   └── ✅ Network exception scenarios
│   │           └── 🤖 movies_remote_data_source_test.mocks.dart # 296 lines - Dio mocks
│   │
│   ├── 🔍 search/                             # Search Feature Tests (Complete)
│   │   ├── controller/bloc/
│   │   │   ├── search_bloc_test.dart          # 381 lines - Advanced testing
│   │   │   │   ├── ✅ SearchMoviesEvent with RxDart debouncing
│   │   │   │   ├── ✅ LoadMoreSearchResultsEvent pagination
│   │   │   │   ├── ✅ ClearSearchEvent state reset
│   │   │   │   ├── ✅ RetrySearchEvent error recovery
│   │   │   │   ├── ✅ Debouncing behavior validation (300ms)
│   │   │   │   ├── ✅ Search query management
│   │   │   │   ├── ✅ Pagination with search context
│   │   │   │   ├── ✅ Empty search results handling
│   │   │   │   └── ✅ Network error scenarios
│   │   │   └── 🤖 search_bloc_test.mocks.dart # 91 lines - Generated BLoC mocks
│   │   │
│   │   └── data/                              # Search data layer testing
│   │       ├── repository/
│   │       │   ├── search_repository_test.dart # 127 lines - Search repository
│   │       │   │   ├── ✅ Search API integration through repository
│   │       │   │   ├── ✅ Either pattern for search results
│   │       │   │   ├── ✅ Error handling and mapping
│   │       │   │   └── ✅ Search query validation
│   │       │   └── 🤖 search_repository_test.mocks.dart # 84 lines - Repository mocks
│   │       │
│   │       └── remote_data_source/
│   │           ├── search_remote_data_source_test.dart # 141 lines - Search API
│   │           │   ├── ✅ TMDB search endpoint integration
│   │           │   ├── ✅ Search query parameter handling
│   │           │   ├── ✅ Pagination with search context
│   │           │   ├── ✅ Response parsing and validation
│   │           │   └── ✅ Search-specific error scenarios
│   │           └── 🤖 search_remote_data_source_test.mocks.dart # 296 lines - Dio mocks
│   │
│   └── 📄 movie_details/                      # Movie Details Tests (Complete)
│       ├── controller/bloc/
│       │   ├── movie_details_bloc_test.dart   # 632 lines - Comprehensive testing
│       │   │   ├── ✅ LoadMovieDetailsEvent tests
│       │   │   ├── ✅ RetryLoadingMovieDetailsEvent tests
│       │   │   ├── ✅ Movie ID parameter validation
│       │   │   ├── ✅ API integration and response handling
│       │   │   ├── ✅ Error state management
│       │   │   ├── ✅ Loading state transitions
│       │   │   ├── ✅ Complex model handling
│       │   │   ├── ✅ Integration with favorites system
│       │   │   └── ✅ Edge cases and error recovery
│       │   └── 🤖 movie_details_bloc_test.mocks.dart # 82 lines - Generated BLoC mocks
│       │
│       └── data/                              # Details data layer testing
│           ├── models/
│           │   └── movie_details_test.dart    # 522 lines - Complex model testing
│           │       ├── ✅ Comprehensive JSON serialization
│           │       ├── ✅ Nested model handling (Genre, ProductionCompany, etc.)
│           │       ├── ✅ Complex object equality and hashCode
│           │       ├── ✅ Helper getters (formattedRuntime, genreNames, etc.)
│           │       ├── ✅ Edge cases and null handling
│           │       ├── ✅ TMDB API response mapping
│           │       └── ✅ Production company/country model testing
│           │
│           ├── repository/
│           │   ├── movie_details_repository_test.dart # 399 lines - Repository testing
│           │   │   ├── ✅ Movie details API integration
│           │   │   ├── ✅ Either pattern success/error scenarios
│           │   │   ├── ✅ Movie ID validation and handling
│           │   │   ├── ✅ API error mapping and transformation
│           │   │   ├── ✅ Repository abstraction validation
│           │   │   └── ✅ Complex response handling
│           │   └── 🤖 movie_details_repository_test.mocks.dart # 74 lines - Repository mocks
│           │
│           └── remote_data_source/
│               ├── movie_details_remote_data_source_test.dart # 339 lines - API testing
│               │   ├── ✅ TMDB movie details endpoint
│               │   ├── ✅ Movie ID parameter handling
│               │   ├── ✅ Complex response parsing (genres, companies, etc.)
│               │   ├── ✅ Network error handling
│               │   ├── ✅ HTTP status code validation
│               │   └── ✅ Malformed response handling
│               └── 🤖 movie_details_remote_data_source_test.mocks.dart # 296 lines - Dio mocks
```

### Testing Approach

- **Unit Tests**: Business logic validation for all BLoCs and repositories
- **BLoC Testing**: State transitions and event handling verification
- **Mock Integration**: Mockito for dependency isolation
- **Edge Case Coverage**: Error scenarios, network failures, and boundary conditions

### Test Coverage Highlights

- ✅ **Movies Feature**: Complete BLoC testing with pagination scenarios
- ✅ **Search Feature**: Debouncing, pagination, and error handling tests
- ✅ **Movie Details**: API integration and state management tests
- ✅ **Repository Layer**: Either pattern and error handling validation

## 🚀 Advanced Features Implemented

### Performance Optimizations

- **Infinite Scroll**: Efficient pagination with load-more capabilities
- **Image Caching**: CachedNetworkImage for optimized image loading
- **Memory Management**: Proper disposal of controllers and resources
- **Responsive UI**: Adaptive layouts for different screen sizes

### Developer Experience

- **Comprehensive Logging**: Detailed network and state logging
- **Error Boundaries**: Graceful error handling throughout the app
- **Code Generation**: Hive adapters and JSON serialization

### Nice-to-Have Features Implemented

- ✅ **Pull-to-Refresh**: Intuitive content refresh across all screens
- ✅ **Search Debouncing**: Optimized API calls with intelligent debouncing
- ✅ **Advanced Error Handling**: Retry strategies and user feedback
- ✅ **Responsive Design**: Consistent experience across mobiles, tablets
- ✅ **Offline Support**: Complete favorites functionality without internet

## 🔧 Technical Stack

### Core Dependencies

```yaml
# State Management & Architecture
flutter_bloc: ^8.1.3 # BLoC pattern implementation
rxdart: ^0.28.0 # Reactive programming extensions
get_it: ^7.6.4 # Dependency injection
dartz: ^0.10.1 # Functional programming (Either pattern)

# Networking & Data
dio: ^5.3.2 # HTTP client with interceptors
hive: ^2.2.3 # Fast NoSQL database
hive_flutter: ^1.1.0 # Hive Flutter integration
cached_network_image: ^3.3.0 # Optimized image loading

# UI & Theming
flutter_screenutil: ^5.9.0 # Responsive design
flutter_svg: ^2.2.0 # SVG asset support

# Testing Framework
bloc_test: ^9.1.5 # BLoC testing utilities
mockito: ^5.4.2 # Mocking framework
```

### Development Tools

- **Build Runner**: Code generation for Hive adapters
- **Flutter Lints**: Strict code quality enforcement
- **BLoC Observer**: State change monitoring and debugging

## 🎨 Design System

### Visual Identity

- **App Name**: "Valu Movies" - Professional branding
- **Color Palette**: Modern dark theme with accent colors
- **Typography**: IBM Plex Sans font family for readability
- **Icons**: Custom app icons for platform consistency

### UI Components

- **Shared Widgets**: Reusable components across features
- **Custom Search Bar**: Consistent search experience
- **Error States**: User-friendly error handling
- **Loading States**: Smooth loading indicators

## 📊 Project Metrics

- **Features**: 5 complete feature modules
- **Screens**: 4 main screens + navigation
- **Components**: 20+ reusable UI components
- **Test Files**: 18 test files across 3 feature suites
- **API Endpoints**: 3 TMDB API integrations
- **Storage**: Local Hive database with offline support

## 🎯 Architectural Decisions & Trade-offs

### Why Feature-Based Architecture with Clean Principles?

- **Scalability**: Easy to add new features without affecting existing code
- **Testability**: Clear separation allows comprehensive unit testing
- **Maintainability**: Each layer has a single responsibility

### Why BLoC Pattern?

- **Predictable State**: Unidirectional data flow with clear state transitions
- **Reactive Programming**: Efficient handling of user interactions and API responses
- **Testing**: Excellent testability with bloc_test package

### Why Hive for Local Storage?

- **Performance**: Fastest NoSQL database for Flutter
- **Type Safety**: Code-generated adapters prevent runtime errors
- **Offline Support**: Complete functionality without internet dependency

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.35.2)
- Dart SDK (^3.9.0)
- TMDB API Key

### Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/ziadali19/movie_app_valu.git
   cd movie_app_valu
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code**

   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure API Key**

   - Add your TMDB API key to `lib/core/utils/constants.dart`

5. **Run the app**
   ```bash
   flutter run
   ```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🎯 Key Achievements

### ✅ Requirements Fulfilled

- **All Core User Stories**: 100% implementation of required features
- **Clean Architecture**: Proper separation of concerns and layers
- **BLoC State Management**: Reactive, predictable state handling
- **Comprehensive Testing**: Unit tests for all business logic
- **Error Handling**: Robust error management with user feedback
- **Local Persistence**: Offline-capable favorites system

### 🌟 Above and Beyond

- **Advanced Search Debouncing**: RxDart-powered optimization
- **Component Modularity**: Highly reusable UI architecture
- **Sophisticated Error States**: Multiple error scenarios handled gracefully
- **Performance Optimization**: Efficient scrolling and image caching
- **Professional Branding**: Custom app identity and theming

## 🔮 Future Enhancements

While the current implementation exceeds the task requirements, potential improvements include:

- **Dark/Light Theme Toggle**: User preference support
- **Movie Trailers**: YouTube integration for movie previews
- **User Reviews**: TMDB user reviews and ratings
- **Advanced Filtering**: Genre, year, and rating filters
- **Social Features**: Share favorite movies with friends

---

## 🏆 Technical Excellence Demonstrated

This project showcases:

- **🏗️ Enterprise Architecture**: Scalable, maintainable code structure
- **🔬 Testing Excellence**: Comprehensive test coverage with modern testing patterns
- **⚡ Performance**: Optimized for smooth user experience
- **🎨 UI/UX Design**: Modern, intuitive interface design
- **🔧 Code Quality**: Clean, readable, well-documented code
- **📱 Platform Integration**: Proper Android/iOS configuration

**Built with passion for clean code and exceptional user experience.** 🚀
