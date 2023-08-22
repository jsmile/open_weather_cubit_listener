import 'dart:developer' as developer;

// developer.log('[ANSI color code][your text][ANSI reset code]');

// Black text
void logBlack(String msg) {
  developer.log('\x1B[30m$msg\x1B[0m');
}

// Blue text
void logBlue(String msg) {
  developer.log('\x1B[34m$msg\x1B[0m');
}

// Green text
void logGreen(String msg) {
  developer.log('\x1B[32m$msg\x1B[0m');
}

// Yellow text
void logYellow(String msg) {
  developer.log('\x1B[33m$msg\x1B[0m');
}

// Red text
void logRed(String msg) {
  developer.log('\x1B[31m$msg\x1B[0m');
}
