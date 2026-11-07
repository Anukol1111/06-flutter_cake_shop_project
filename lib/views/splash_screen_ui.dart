import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cake_shop_list_ui.dart';

// หน้าแรก: รูปเค้กเต็มจอ แสดง 3 วินาที แล้วไปหน้ารายการร้าน
class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CakeShopListUI()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_welcome.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'สายด่วนกินเค้ก',
                    style: GoogleFonts.kanit(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEE0000),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'CAKE CALL FAST',
                    style: GoogleFonts.kanit(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 17),
                  CircularProgressIndicator(color: Colors.blueGrey[800]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
