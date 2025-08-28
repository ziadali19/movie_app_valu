# 🏗️ Development Guide & Coding Standards

This guide outlines the architecture, patterns, and coding standards used in this Flutter project. Follow these patterns when working on any feature.

## 📁 Project Structure & Clean Architecture

### **Core Architecture Layers**

```
lib/
│
├── core/                               # Shared core functionality
│   ├── network/                        # Dio setup, interceptors, error handling
│   ├── theming/                        # Colors, text styles, themes
│   ├── widgets/                        # Reusable UI components
│   ├── helpers/                        # Utility functions (formatters, validators)
│   ├── routing/                        # App routes & navigation
│   └── services/                       # Dependency injection (GetIt, etc.)
│
├── features/                           # Feature-based modules
│   ├── [feature_name]/                 # Example: auth, home, profile...
│   │   ├── presentation/               # UI Layer
│   │   │   ├── screens/                # Main screens
│   │   │   └── components/             # Reusable widgets for this feature
│   │   │
│   │   ├── controller/                      # Business Logic Layer
│   │   │   └── cubit/                  # Cubit/Bloc files
│   │   │
│   │   └── data/                       # Data Layer
│   │       ├── models/                 # Data models (from API or local)
│   │       ├── repository/             # Repository pattern
│   │       └── remote_data_source/     # API calls (Dio, http)
│
├
└── main.dart
```

---

## 🎨 UI & Theming Standards

### **Color Management**

```dart
// lib/clubs_and_corporates/core/theming/colors.dart
class ColorsManager {
  static const Color primary = Color(0xFF25532E);
  static const Color secondary = Color.fromARGB(255, 214, 228, 217);
  static const Color trashIconColor = Color.fromARGB(255, 75, 16, 12);
}

// Usage
Container(color: ColorsManager.primary)
```

### **Text Styles**

```dart
// lib/clubs_and_corporates/core/theming/styles.dart
class TextStyles {
  static TextStyle font24Black700 = TextStyle(
    fontSize: 24.sp,
    color: Colors.black,
    fontWeight: FontWeight.w700
  );
  static TextStyle font16Black500 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500
  );
  // ... more styles
}

// Usage
Text('Hello', style: TextStyles.font16Black500)
```

### **Responsive Design**

- Always use `flutter_screenutil` for responsive sizing
- Use `.sp` for font sizes, `.w` for width, `.h` for height, `.r` for radius

```dart
Container(
  width: 200.w,
  height: 100.h,
  padding: EdgeInsets.all(16.w),
  child: Text('Hello', style: TextStyle(fontSize: 14.sp)),
)
```

### **Spacing Helper**

```dart
// lib/clubs_and_corporates/core/helpers/spacing.dart
verticalSpace(16.h)    // SizedBox(height: 16.h)
horizontalSpace(12.w)  // SizedBox(width: 12.w)
```

---

## 🏛️ State Management with Cubit/Bloc Pattern

### **Cubit Structure**

```dart
// controller/cubit/[feature]_cubit.dart
class FeatureCubit extends Cubit<FeatureState> {
  FeatureCubit(this.repository) : super(const FeatureState());

  final BaseFeatureRepository repository;

  // Business logic methods
  Future<void> loadData() async {
    emit(state.copyWith(status: FeatureStatus.loading));

    try {
      final result = await repository.getData();
      result.fold(
        (error) => emit(state.copyWith(
          status: FeatureStatus.error,
          errorMessage: error.message,
        )),
        (data) => emit(state.copyWith(
          status: FeatureStatus.success,
          data: data.responseObject,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: FeatureStatus.error,
        errorMessage: 'Unexpected error occurred',
      ));
    }
  }
}
```

### **State Structure**

```dart
// controller/cubit/[feature]_state.dart
enum FeatureStatus { initial, loading, success, error }

class FeatureState {
  final FeatureStatus status;
  final List<DataModel> data;
  final String? errorMessage;
  final String? successMessage;

  const FeatureState({
    this.status = FeatureStatus.initial,
    this.data = const [],
    this.errorMessage,
    this.successMessage,
  });

  FeatureState copyWith({
    FeatureStatus? status,
    List<DataModel>? data,
    String? errorMessage,
    String? successMessage,
  }) {
    return FeatureState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  // Helper getters
  bool get isLoading => status == FeatureStatus.loading;
  bool get hasError => status == FeatureStatus.error;
  bool get hasData => data.isNotEmpty;
}
```

### **Screen Implementation**

```dart
class FeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FeatureCubit>()..loadData(),
      child: _FeatureView(),
    );
  }
}

class _FeatureView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeatureCubit, FeatureState>(
      listenWhen: (previous, current) =>
        previous.status != current.status,
      listener: (context, state) {
        if (state.hasError) {
          showSnackBar(state.errorMessage ?? 'Error occurred', context, false);
        }
      },
      buildWhen: (previous, current) =>
        previous.status != current.status ||
        previous.data != current.data,
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (state.hasError) {
          return _buildErrorState(state.errorMessage);
        }

        return _buildSuccessState(state.data);
      },
    );
  }
}
```

---

## 🌐 Network Layer & API Integration

### **Dio Helper (HTTP Client)**

```dart
// lib/clubs_and_corporates/core/network/dio_helper.dart
class DioHelper {
  static final DioHelper _dioHelper = DioHelper._internal();
  late Dio dio;

  static DioHelper get instance => _dioHelper;

  Future<Response> post(String path, {
    Object? body,
    String? token,
    Map<String, dynamic>? queryParameters
  }) async {
    Response res = await dio.post(path,
      data: body ?? {},
      queryParameters: queryParameters ?? {},
      options: Options(headers: token == null ? {} : {'Authorization': 'Bearer $token'})
    );
    return res;
  }

  // Similar methods for get, put, delete
}
```

### **Generic API Response**

```dart
// lib/clubs_and_corporates/core/network/generic_response.dart
class ApiResponse<T> {
  final String? responseTextArabic;
  final String? responseText;
  final T? responseObject;
  final int? responseCode;
  final int? status;

  ApiResponse({
    this.responseTextArabic,
    this.responseText,
    this.responseObject,
    this.responseCode,
    this.status,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T fromJsonT) {
    return ApiResponse<T>(
      responseTextArabic: json['responseTextArabic'] as String?,
      responseText: json['responseText'] as String?,
      responseObject: fromJsonT,
      responseCode: json['responseCode'] as int?,
      status: json['status'] as int?,
    );
  }
}
```

### **Error Handling**

```dart
// lib/clubs_and_corporates/core/network/failure.dart
class ApiErrorModel {
  final String? message;
  final int? code;

  ApiErrorModel({this.code, required this.message});

  factory ApiErrorModel.fromJson(Map<String, dynamic> map) {
    return ApiErrorModel(
      message: map['message'] ?? map['responseText'] ?? map['responseObject'],
      code: map['code'] as int?,
    );
  }
}

// lib/clubs_and_corporates/core/network/exceptions.dart
class FailException implements Exception {
  final dynamic exception;
  FailException({required this.exception});
}
```

### **Remote Data Source Pattern**

```dart
// data/remote_data_source/[feature]_remote_data_source.dart
abstract class BaseFeatureRemoteDataSource {
  Future<ApiResponse<List<DataModel>>> getData();
  Future<ApiResponse<DataModel>> createData(Map<String, dynamic> data);
}

class FeatureRemoteDataSource implements BaseFeatureRemoteDataSource {
  final DioHelper dioHelper;
  FeatureRemoteDataSource(this.dioHelper);

  @override
  Future<ApiResponse<List<DataModel>>> getData() async {
    try {
      final response = await dioHelper.get('endpoint/path');

      if (response.data['status'] == 0) {
        final List<dynamic> dataList = response.data['responseObject'] ?? [];
        final List<DataModel> models = dataList
            .map((json) => DataModel.fromJson(json))
            .toList();

        return ApiResponse.fromJson(response.data, models);
      } else {
        throw FailException(
          exception: response.data['responseText'] ?? 'Request failed',
        );
      }
    } catch (e) {
      throw FailException(exception: e);
    }
  }
}
```

### **Repository Pattern**

```dart
// data/repository/[feature]_repository.dart
abstract class BaseFeatureRepository {
  Future<Either<ApiErrorModel, ApiResponse<List<DataModel>>>> getData();
}

class FeatureRepository implements BaseFeatureRepository {
  final BaseFeatureRemoteDataSource remoteDataSource;
  FeatureRepository(this.remoteDataSource);

  @override
  Future<Either<ApiErrorModel, ApiResponse<List<DataModel>>>> getData() async {
    try {
      final ApiResponse<List<DataModel>> result =
          await remoteDataSource.getData();
      return Right(result);
    } on FailException catch (e) {
      return Left(FailHandler.instance.handleError(e.exception));
    }
  }
}
```

---

## 🎯 Dependency Injection with GetIt

### **Service Locator Setup**

```dart
// lib/clubs_and_corporates/core/services/service_locator.dart
class ServiceLocator {
  static void init() {
    // Register Cubits
    getIt.registerFactory<FeatureCubit>(() => FeatureCubit(getIt()));

    // Register Repositories
    getIt.registerLazySingleton<BaseFeatureRepository>(
      () => FeatureRepository(getIt())
    );

    // Register Remote Data Sources
    getIt.registerLazySingleton<BaseFeatureRemoteDataSource>(
      () => FeatureRemoteDataSource(DioHelper.instance)
    );
  }
}

// Usage in screens
BlocProvider(
  create: (context) => getIt<FeatureCubit>(),
  child: FeatureScreen(),
)
```

---

## 🧭 Navigation & Routing

### **Routes Definition**

```dart
// lib/clubs_and_corporates/core/routing/routes.dart
class Routes {
  static const String landing = '/landing';
  static const String featureScreen = '/feature';
  static const String featureDetails = '/feature/details';
}
```

### **App Router Implementation**

```dart
// lib/clubs_and_corporates/core/routing/app_router.dart
class AppRouter {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    Object? arguments = settings.arguments;

    switch (settings.name) {
      case Routes.featureScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<FeatureCubit>(),
            child: FeatureScreen(),
          ),
        );

      case Routes.featureDetails:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: arguments as FeatureCubit, // Reuse existing cubit
            child: FeatureDetailsScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        );
    }
  }
}

// Navigation usage
context.pushNamed(Routes.featureScreen);
context.pushNamed(Routes.featureDetails, arguments: cubitInstance);
```

---

## 📱 UI Patterns & Components

### **Custom Reusable Widgets**

```dart
// lib/clubs_and_corporates/core/widgets/semi-corporate_custom_button.dart
class SemiCorporateCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SemiCorporateCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Text(text, style: TextStyles.font18Black500.copyWith(color: Colors.white)),
      ),
    );
  }
}
```

### **Screen Templates**

```dart
// Standard screen structure
class FeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.secondary,
      appBar: AppBar(
        title: Text('Feature', style: TextStyles.font18Black500),
        backgroundColor: ColorsManager.secondary,
      ),
      body: BlocConsumer<FeatureCubit, FeatureState>(
        listener: _handleStateChanges,
        builder: _buildContent,
      ),
    );
  }

  void _handleStateChanges(BuildContext context, FeatureState state) {
    if (state.hasError) {
      showSnackBar(state.errorMessage!, context, false);
    }
    if (state.status == FeatureStatus.success) {
      showSnackBar('Success!', context, true);
    }
  }

  Widget _buildContent(BuildContext context, FeatureState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<FeatureCubit>().refreshData(),
      child: CustomScrollView(
        slivers: [
          // Your slivers here
        ],
      ),
    );
  }
}
```

---

## 📋 Form Handling & Validation

### **Form Structure**

```dart
class FormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormCubit, FormState>(
      builder: (context, state) {
        final cubit = context.read<FormCubit>();

        return Form(
          key: cubit.formKey,
          child: Column(
            children: [
              CustomTextFieldForSemiCorporate(
                controller: cubit.nameController,
                label: 'Name',
                hintText: 'Enter your name',
                validator: ValidationHelpers.validateName,
                prefixIcon: const Icon(Icons.person),
              ),

              verticalSpace(16.h),

              SemiCorporateCustomButton(
                text: 'Submit',
                isLoading: state.isLoading,
                onPressed: cubit.submitForm,
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### **Validation Helpers**

```dart
// lib/clubs_and_corporates/core/helpers/validation_helpers.dart
class ValidationHelpers {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEgyptianNationalId(String? value) {
    if (value == null || value.length != 14) {
      return 'National ID must be 14 digits';
    }
    // Additional validation logic...
    return null;
  }
}
```

---

## 🔧 Data Models

### **Model Structure**

```dart
// data/models/[model_name].dart
class DataModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final bool isActive;

  DataModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.isActive,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  DataModel copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return DataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
```

---

## 🎛️ Advanced Patterns

### **MultiBlocListener for Complex State Handling**

```dart
MultiBlocListener(
  listeners: [
    BlocListener<FeatureCubit, FeatureState>(
      listenWhen: (previous, current) =>
        previous.dataStatus != current.dataStatus,
      listener: (context, state) {
        // Handle data status changes
      },
    ),
    BlocListener<FeatureCubit, FeatureState>(
      listenWhen: (previous, current) =>
        previous.uploadStatus != current.uploadStatus,
      listener: (context, state) {
        // Handle upload status changes
      },
    ),
  ],
  child: YourWidget(),
)
```

### **BlocProvider.value for Cubit Reuse**

```dart
// Pass existing cubit to new screen
Navigator.pushNamed(
  context,
  Routes.detailsScreen,
  arguments: context.read<FeatureCubit>(),
);

// In the new screen
BlocProvider.value(
  value: arguments as FeatureCubit,
  child: DetailsScreen(),
)
```

### **Collapsible UI Patterns**

```dart
// For space-efficient UIs
Container(
  child: Column(
    children: [
      // Compact header with toggle
      CompactFilterBar(
        hasActiveFilters: state.hasActiveFilters,
        onToggleExpansion: cubit.toggleExpansion,
      ),

      // Expandable content
      if (state.isExpanded)
        ExpandedContent(),

      // Main scrollable content
      Expanded(child: MainContent()),
    ],
  ),
)
```

---

## ⚡ Performance Best Practices

### **Optimized BlocBuilder**

```dart
BlocBuilder<FeatureCubit, FeatureState>(
  buildWhen: (previous, current) =>
    previous.relevantField != current.relevantField, // Only rebuild when needed
  builder: (context, state) => YourWidget(),
)
```

### **Efficient List Building**

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ItemWidget(
      key: ValueKey(item.id), // Add keys for efficient updates
      item: item,
    );
  },
)
```

---

## 🛠️ Development Tools & Utilities

### **Constants Management**

```dart
// lib/clubs_and_corporates/core/utils/constants.dart
class AppConstants {
  static const String baseURL = kDebugMode
    ? 'https://iistest.premiumcard.net:1319/api/'
    : 'https://iis.premiumcard.net:3214/api/';

  static String? userToken;
  static String? corporateId;
  // Other app constants
}
```

### **Number Formatting Utilities**

```dart
// lib/clubs_and_corporates/core/helpers/numbers_formatter.dart
String formatNumberWithCommas(String number) {
  return NumberFormat('#,###').format(int.parse(number));
}

String removeNumberFormatting(String formattedNumber) {
  return formattedNumber.replaceAll(',', '');
}
```

---

## 🚨 Error Handling Best Practices

1. **Always use Either for repository methods**
2. **Handle both network and unexpected errors**
3. **Provide meaningful error messages to users**
4. **Use FailException for consistent error propagation**
5. **Show loading states during API calls**
6. **Implement retry mechanisms for failed operations**

---

## 📝 Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Folders**: `kebab-case`

---

## 🎯 Key Principles

1. **Separation of Concerns**: UI, Business Logic, and Data layers are separate
2. **Single Responsibility**: Each class has one clear purpose
3. **Dependency Injection**: Use GetIt for loose coupling
4. **Error Handling**: Always handle both success and error cases
5. **State Management**: Use Cubit/Bloc for all business logic
6. **Reusability**: Create reusable widgets and utilities
7. **Responsive Design**: Use flutter_screenutil consistently
8. **Performance**: Optimize rebuilds with proper buildWhen conditions

Follow these patterns consistently, and you'll maintain a clean, scalable, and maintainable codebase! 🚀
