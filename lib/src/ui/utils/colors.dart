import 'package:flutter/widgets.dart' show Color, LinearGradient, Alignment;

const Map<int, Color> swatch = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

// Primary Colors - Green Theme
const lightColor = Color(0xfff0f0f0);
const lightColor2 = Color(0xfff9f9f9);
const lightColor3 = Color(0xffffffff);
const darkColor = Color(0xff1b5e20);
const darkColor2 = Color(0xff0d3d11);
const acentColor = Color(0xff4caf50);
const accentColor2 = Color(0xff388e3c);

// Enhanced Gradients - Green Theme
const lightGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xffffffff),
    Color(0xfff1f8f4),
    Color(0xffe8f5e9),
  ],
);

const darkGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xff2e7d32),
    Color(0xff1b5e20),
    Color(0xff0d3d11),
  ],
);

// Background Gradients - Green Theme
const lightBackgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xfff1f8f4),
    Color(0xffe8f5e9),
  ],
);

const darkBackgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff1b5e20),
    Color(0xff0d3d11),
  ],
);

// Accent Gradients - Green Theme
const accentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xff66bb6a),
    Color(0xff4caf50),
    Color(0xff388e3c),
  ],
);
