import 'package:flutter/material.dart';


const TextStyle categoryTitleStyle =
    TextStyle(fontWeight: FontWeight.w900, fontSize: 18);
    
final textFormFieldDecor = InputDecoration(
  isDense: true,
  contentPadding: const EdgeInsets.all(12.0),
  border: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 1.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue.withOpacity(0.75), width: 0.75),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue.withOpacity(0.75), width: 0.75),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 0.5),
  ),
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 0.5),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 0.5),
  ),
  errorStyle: const TextStyle(fontSize: 12),
);