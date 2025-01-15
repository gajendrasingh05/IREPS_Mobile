import 'package:flutter/material.dart';

mixin LoggingMixin {
  void log(String message) {
    debugPrint('[LOG] $message');
  }
}

class DebugLog with LoggingMixin{
  void printLog(String action) {
    log('Doing something...');
    // Other functionality...
  }
}