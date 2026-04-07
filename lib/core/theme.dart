import 'package:flutter/material.dart';

/// App color pallete
ColorScheme colorPallete = ColorScheme.fromSeed(seedColor: Colors.amber);

/// Gets app styles
///
/// Return a [ThemeData] with app styles
ThemeData appTheme() {
  return ThemeData(
    //SECTION Font family
    fontFamily: "Outfit",

    //SECTION Scheme
    colorScheme: colorPallete,

    //SECTION Nav rail
    navigationRailTheme: NavigationRailThemeData(
      groupAlignment: 0,
      indicatorColor: colorPallete.primaryFixedDim,
      backgroundColor: colorPallete.primaryFixed,
      selectedLabelTextStyle: TextStyle(color: colorPallete.onPrimaryFixed, fontFamily: "Outfit"),
      selectedIconTheme: IconThemeData(color: colorPallete.onPrimaryFixed),
      labelType: NavigationRailLabelType.selected,
    ),

    //SECTION nav bar
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colorPallete.primaryFixedDim,
      backgroundColor: colorPallete.primaryFixed,
      surfaceTintColor: colorPallete.onPrimaryFixed,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),

    //SECTION Appbar
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: colorPallete.primaryFixed,
      foregroundColor: colorPallete.onPrimaryFixed,
    ),
  );
}
