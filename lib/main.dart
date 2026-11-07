import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/splash_screen_ui.dart';

void main() {
  runApp(const FlutterCakeShopProject());
}

class FlutterCakeShopProject extends StatelessWidget {
  const FlutterCakeShopProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สายด่วนกินเค้ก',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ฟอนต์หลักของแอป: Kanit
        textTheme: GoogleFonts.kanitTextTheme(),
        // ระยะห่างแบบกระชับตาม Figma (รายการสูง 64, ปุ่มสูง 32)
        visualDensity: VisualDensity.compact,
      ),
      // หน้าแรกของแอป
      home: const SplashScreenUI(),
    );
  }
}
