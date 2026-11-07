import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/cake_shop.dart';

// หน้ารายละเอียดร้านเค้ก
class CakeShopDetailUI extends StatefulWidget {
  const CakeShopDetailUI({super.key, required this.shop});

  final CakeShop shop;

  @override
  State<CakeShopDetailUI> createState() => _CakeShopDetailUIState();
}

class _CakeShopDetailUIState extends State<CakeShopDetailUI> {
  // แปลงแผนที่เป็นสีเทาให้เหมือน Figma
  static const ColorFilter _greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  // เปิดเบอร์โทร / เว็บไซต์ / Facebook ด้วยแอปของเครื่อง
  Future<void> _open(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _image(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(path, width: 120, height: 80, fit: BoxFit.cover),
    );
  }

  // หัวข้อตัวหนา + ข้อความ เช่น "ชื่อร้าน 🏪" / Larna House
  Widget _info(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  // แถวลิงก์ เช่น เว็บไซต์ / Facebook
  Widget _link(Widget icon, String url) {
    return ListTile(
      leading: icon,
      title: Text(url),
      trailing: const Icon(Icons.link),
      onTap: () => _open(Uri.parse(url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;
    final location = LatLng(
      double.parse(shop.latitude),
      double.parse(shop.longitude),
    );
    final phone = shop.phone.trim();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          shop.name,
          style: GoogleFonts.kanit(fontSize: 22, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _image(shop.image1)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image(shop.image2),
                const SizedBox(width: 20),
                _image(shop.image3),
              ],
            ),
            const SizedBox(height: 20),
            _info('ชื่อร้าน 🏪', shop.name),
            const SizedBox(height: 20),
            _info('เวลาเปิดปิด ⏰', shop.openCloseTime),
            const SizedBox(height: 20),
            _info('รายละเอียดของร้าน 🍵', shop.description),
            const SizedBox(height: 20),
            _info('ที่อยู่ของร้าน 🚩', shop.address),
            const SizedBox(height: 20),
            // ปุ่มโทรหาร้าน
            Center(
              child: ElevatedButton(
                onPressed: () => _open(Uri(scheme: 'tel', path: phone)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('📞 $phone'),
              ),
            ),
            _link(
              const FaIcon(FontAwesomeIcons.globe, color: Colors.amber),
              shop.website,
            ),
            _link(
              const FaIcon(FontAwesomeIcons.facebook, color: Colors.blueAccent),
              shop.facebook,
            ),
            // แผนที่ตำแหน่งร้าน
            SizedBox(
              height: 400,
              child: FlutterMap(
                options: MapOptions(initialCenter: location, initialZoom: 16),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                        'com.example.flutter_cake_shop_project',
                    tileBuilder: (context, tileWidget, tile) => ColorFiltered(
                      colorFilter: _greyscale,
                      child: tileWidget,
                    ),
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: location,
                        width: 40,
                        height: 40,
                        alignment: Alignment.topCenter,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => _open(
                          Uri.parse('https://openstreetmap.org/copyright'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
