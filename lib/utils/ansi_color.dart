import 'package:ansicolor/ansicolor.dart';

AnsiPen info = AnsiPen()..black(bold: true);
// ..rgb(r: 0.98, g: 0.98, b: 0.98, bg: true);
AnsiPen success = AnsiPen()..magenta(bold: true);
// ..rgb(r: 0.95, g: 0.95, b: 0.95, bg: true);
AnsiPen warn = AnsiPen()..yellow(bold: true);
AnsiPen error = AnsiPen()..red(bold: true);
