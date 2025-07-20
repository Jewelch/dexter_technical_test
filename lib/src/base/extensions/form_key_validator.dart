import 'package:flutter/material.dart';

extension Validator on GlobalKey<FormState> {
  bool get isValid => currentState?.validate() ?? false;
}
