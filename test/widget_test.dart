import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_cake_shop_project/data/cake_shop_data.dart';
import 'package:flutter_cake_shop_project/main.dart';
import 'package:flutter_cake_shop_project/views/cake_shop_detail_ui.dart';
import 'package:flutter_cake_shop_project/views/cake_shop_list_ui.dart';

void main() {
  // ไม่ให้ google_fonts โหลดฟอนต์จากอินเทอร์เน็ตตอนรันเทสต์
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  // ขนาดจอ iPhone 16 Pro Max (440 x 956)
  void useIphone16ProMax(WidgetTester tester) {
    tester.view.physicalSize = const Size(1320, 2868);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  test('there are 7 cake shops and all images exist', () {
    expect(cakeShops.length, 7);
    expect(cakeBanners.length, 7);
    final images = [
      ...cakeBanners,
      for (final shop in cakeShops) ...[shop.image1, shop.image2, shop.image3],
    ];
    for (final image in images) {
      expect(File(image).existsSync(), isTrue, reason: image);
    }
  });

  test('phone numbers and map positions are valid', () {
    for (final shop in cakeShops) {
      expect(
        shop.phone.trim(),
        matches(RegExp(r'^0\d{8,9}$')),
        reason: shop.name,
      );
      expect(double.parse(shop.latitude), inInclusiveRange(13.5, 14.0));
      expect(double.parse(shop.longitude), inInclusiveRange(100.3, 100.8));
      expect(Uri.parse(shop.website).hasScheme, isTrue);
      expect(Uri.parse(shop.facebook).host, 'www.facebook.com');
    }
  });

  testWidgets('Splash → list after 3 seconds', (tester) async {
    useIphone16ProMax(tester);
    await tester.pumpWidget(const FlutterCakeShopProject());
    expect(find.text('สายด่วนกินเค้ก'), findsOneWidget);
    expect(find.text('CAKE CALL FAST'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byType(CakeShopListUI), findsOneWidget);
    expect(find.text('CAKE CALL FAST'), findsNothing);
    expect(find.text('Yellow Spoon Pastry'), findsOneWidget);
    expect(find.text('0854822842'), findsOneWidget);
  });

  testWidgets('tap a shop → detail page → back', (tester) async {
    useIphone16ProMax(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(visualDensity: VisualDensity.compact),
        home: const CakeShopListUI(),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Larna House'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Larna House'));
    await tester.pumpAndSettle();

    expect(find.byType(CakeShopDetailUI), findsOneWidget);
    // ชื่อร้านอยู่ทั้งบน AppBar และในหัวข้อ "ชื่อร้าน"
    expect(find.text('Larna House'), findsNWidgets(2));
    expect(find.text('ชื่อร้าน 🏪'), findsOneWidget);
    expect(find.text('ทุกวัน 09.00-21.00 น.'), findsOneWidget);
    expect(find.text('พัฒนาการ 61'), findsOneWidget);
    expect(find.text('📞 023215995'), findsOneWidget);
    expect(find.text('https://larnahouse.com/'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();
    expect(find.byType(CakeShopDetailUI), findsNothing);
  });
}
