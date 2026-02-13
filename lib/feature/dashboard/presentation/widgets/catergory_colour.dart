import 'dart:ui';

import 'package:flutter/material.dart';

Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'food': return Colors.orange;
    case 'transport': return Colors.blue;
    case 'shopping': return Colors.pink;
    case 'rent': return Colors.purple;
    default: return Colors.green;
  }
}