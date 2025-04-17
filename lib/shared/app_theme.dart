import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  // Modern color palette
  static const Color primaryColor = Color(0xFF536DFE);
  static const Color secondaryColor = Color(0xFF42A5F5);
  static const Color accentColor = Color(0xFF64FFDA);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardBackgroundLight = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF2C2C2E);
  static const Color textColorLight = Color(0xFF1A1A1A);
  static const Color textColorDark = Color(0xFFF2F2F7);
  static const Color disabledColor = Color(0xFFABB3BB);

  // Note card colors
  static const Color favoriteColor = Color(0xFFFF4081);
  static const Color archivedColor = Color(0xFF66BB6A);
  static const Color combinedColor = Color(0xFFFFAB40);
  static const Color defaultColorLight = Color(0xFFEEF2F5);
  static const Color defaultColorDark = Color(0xFF3A3A3C);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    )
  ];

  static List<BoxShadow> darkShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 10,
      offset: const Offset(0, 4),
    )
  ];

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 250);

  // Opacity values
  static const double activeCardOpacity = 1.0;
  static const double inactiveOpacity = 0.7;

  // Get theme based on dark mode
  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? _darkTheme : _lightTheme;
  }

  // Global theme data
  static ThemeData _getBaseTheme(bool isDark) {
    final ColorScheme colorScheme = isDark
        ? const ColorScheme.dark(
            primary: primaryColor,
            secondary: secondaryColor,
            tertiary: accentColor,
            surface: cardBackgroundDark,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: textColorDark,
          )
        : const ColorScheme.light(
            primary: primaryColor,
            secondary: secondaryColor,
            tertiary: accentColor,
            surface: cardBackgroundLight,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: textColorLight,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: isDark ? textColorDark : textColorLight,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        toolbarHeight: 64,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? cardBackgroundDark : cardBackgroundLight,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shadowColor: isDark ? Colors.black : Colors.black.withOpacity(0.3),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: isDark ? textColorDark : textColorLight,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: isDark ? textColorDark : textColorLight,
          letterSpacing: -0.25,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? textColorDark : textColorLight,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? textColorDark : textColorLight,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: isDark ? textColorDark : textColorLight,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: isDark
              ? textColorDark.withOpacity(0.9)
              : textColorLight.withOpacity(0.9),
          letterSpacing: 0.25,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
          letterSpacing: 0.4,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        textStyle: TextStyle(
          color: isDark ? textColorDark : textColorLight,
          fontSize: 14,
        ),
      ),
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black87,
        size: 24,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        labelStyle: TextStyle(
          color: isDark ? textColorDark : textColorLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        buttonColor: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFF5F7FA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[700],
          fontSize: 16,
        ),
        floatingLabelStyle: const TextStyle(
          color: primaryColor,
          fontSize: 16,
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 1,
        color: Colors.grey,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isDark ? cardBackgroundDark : cardBackgroundLight,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return isDark ? Colors.grey[700] : Colors.grey[300];
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[700],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
        circularTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
      ),
    );
  }

  // Light theme
  static final ThemeData _lightTheme = _getBaseTheme(false);

  // Dark theme
  static final ThemeData _darkTheme = _getBaseTheme(true);

  // Get color for note card based on its status
  static Color getNoteCardColor(
      bool isFavorite, bool isArchived, bool isDarkMode) {
    if (isFavorite && isArchived) {
      return combinedColor.withOpacity(activeCardOpacity);
    } else if (isFavorite) {
      return favoriteColor.withOpacity(activeCardOpacity);
    } else if (isArchived) {
      return archivedColor.withOpacity(activeCardOpacity);
    } else {
      return isDarkMode ? defaultColorDark : defaultColorLight;
    }
  }

  // Get uniform app bar
  static AppBar getAppBar(String title,
      {List<Widget>? actions, bool automaticallyImplyLeading = true}) {
    return AppBar(
      title: Text(title),
      centerTitle: false,
      elevation: 0,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  // Get gradient app bar
  static AppBar getGradientAppBar(String title,
      {List<Widget>? actions, bool automaticallyImplyLeading = true}) {
    return AppBar(
      title: Text(title),
      centerTitle: false,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: primaryGradient,
        ),
      ),
      foregroundColor: Colors.white,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  // Get uniform floating action button
  static FloatingActionButton getFloatingActionButton({
    required VoidCallback onPressed,
    required Icon icon,
    String? label,
  }) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
        elevation: 4,
      );
    } else {
      return FloatingActionButton(
        onPressed: onPressed,
        elevation: 4,
        child: icon,
      );
    }
  }

  // Get uniform snackbar
  static SnackbarController showSnackBar({
    required String title,
    required String message,
    bool isError = false,
  }) {
    return Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          isError ? Colors.red.withOpacity(0.9) : Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }

  // Get container with gradient background
  static Container gradientContainer(
      {required Widget child, BorderRadius? borderRadius}) {
    return Container(
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
