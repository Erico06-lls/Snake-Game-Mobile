
import 'package:flutter/material.dart';

import 'screens/menu_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuPage(),
    ),
  );
}
