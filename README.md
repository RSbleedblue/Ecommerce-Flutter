# ECommerce

Welcome to the **ECommerce** Flutter project! This project serves as a starting point for building a Flutter application focused on eCommerce.

## Getting Started

To get started with this project, follow these steps:

### Prerequisites

Ensure you have the following installed on your development machine:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- An IDE with Flutter support, such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/ecommerce-flutter.git
   ```

2. **Navigate into the project directory:**
   ```bash
   cd ecommerce-flutter
   ```

3. **Get dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Project Structure

- `lib/` - Contains the main source code of the application.
  - `main.dart` - Entry point of the application.
  - `components/` - Contains reusable widgets and components.
  - `pages/` - Contains different pages/screens of the app.
  - `utils/` - Contains utility classes and functions.
  - `models/` - Contains data models used in the app.
  - `l10n/` - Contains localization files for multiple languages.

### Features

- Product listing with grid and list view options.
- Category navigation.
- Product detail pages.
- Localization support for multiple languages.
- Responsive design for various screen sizes.

### Localization

The app supports localization for multiple languages. To add a new language:

1. **Create a new `.arb` file** in the `lib/l10n/` directory with translations for the new language.
2. **Update the `pubspec.yaml` file** to include the new `.arb` file.
3. **Generate Dart localization files** by running:
   ```bash
   flutter pub run intl_utils:generate
   ```

### Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

### Contributing

If you would like to contribute to this project, please follow these steps:

1. **Fork the repository** on GitHub.
2. **Create a new branch** for your feature or fix:
   ```bash
   git checkout -b feature/your-feature
   ```
3. **Commit your changes** and push to your branch:
   ```bash
   git commit -am 'Add new feature'
   git push origin feature/your-feature
   ```
4. **Open a Pull Request** on GitHub.

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Feel free to modify the content based on your specific needs and project details!
