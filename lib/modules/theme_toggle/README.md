# THEME TOGGLE

This module provides a robust and reusable structure for changing the application's theme. It uses a class to change the application's visual appearance based on the user's chosen light or dark theme.

# How would you use it in your project?

# 1. Define the **ThemeToggle** class, which will hold all the **ThemeData** settings:

🔗 **[Link](./presentation/theme/theme_toggle.dart)**

Copy and paste the **ThemeToggle** class into a Dart file (theme_toggle.dart) and import material.dart.

Note: 💡The ThemeToggle class only provides the light or dark theme settings for the following widgets: OutlinedButton.icon, scaffoldBackgroundColor, appBarTheme, textTheme(displayLarge, titleMedium), iconTheme, and floatingActionButtonTheme.

# 2. Create a **CustomSharedPreference** class to save the user's chosen Theme Mode preference on the device.

🔗 **[Link](./infrastructure/custom_shared_preference.dart)**

For this purpose, we will use the SharedPreference plugin to persistently store simple data, in this case, a boolean value.

When creating the class, you must also install the SharedPreference dependency in your project's pubspec.yaml file:

```pubspec.yaml

shared_preferences: ^2.5.3

```

# 3. Use the **CustomSharedPreference** class in your business logic: In a Cubit, Bloc, or even a simple StatefulWidget, you use instances of these classes to manage the state of your fields.

Here's an example using Cubit, if you want to use this example, Copy and paste the `PrefsThemeAppCubit` class into a Dart file (`prefs_theme_app_cubit.dart`),  
🔗 **[Link](./presentation/bloc/prefs_theme_app_cubit.dart)**

Also you need to add `flutter_bloc` and `equatable` dependencies to your pubspec.yaml file.

```pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7

```

# 4. Initial Setup in main.dart

For the theme to work throughout the app:
- Initialize local storage and read the theme before rendering the UI.
- Pass the initial theme directly to the widget tree.
- Wrap your MaterialApp with BlocProvider and use BlocBuilder to listen for state changes.

🔗 **[Link](./presentation/screen/theme_toggle_screen.dart)**

# 5. Widget to Change the Application Theme

Create a widget that, when pressed by the user, change the state of Cubit.

🔗 **[Link](./presentation/screen/theme_toggle_screen.dart)**
