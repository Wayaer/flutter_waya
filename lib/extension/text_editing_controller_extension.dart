import 'package:flutter/material.dart';

extension ExtensionTextEditingController on TextEditingController {
  void addTextAfterCursor(String text) {
    String value = this.text;
    int start = selection.start;
    int end = selection.end;
    String newValue = value.substring(0, start) + text + value.substring(end);
    int newSelection = start + text.length;
    this.value = this.value.copyWith(
        text: newValue,
        selection: TextSelection.collapsed(offset: newSelection));
  }

  void addTextBeforeCursor(String text) {
    String value = this.text;
    int start = selection.start;
    String newValue = value.substring(0, start) + text + value.substring(start);
    int newSelection = start + text.length;
    this.value = this.value.copyWith(
        text: newValue,
        selection: TextSelection.collapsed(offset: newSelection));
  }
}
