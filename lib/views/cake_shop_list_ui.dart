import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/cake_shop_data.dart';
import 'cake_shop_detail_ui.dart';

// หน้ารายการร้านเค้ก: สไลด์รูปด้านบน + รายชื่อร้าน
class CakeShopListUI extends StatefulWidget {
  const CakeShopListUI({super.key});

  @override
  State<CakeShopListUI> createState() => _CakeShopListUIState();
}

class _CakeShopListUIState extends State<CakeShopListUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0000),
        centerTitle: true,
        title: Text(
          'สายด่วนกินเค้ก',
          style: GoogleFonts.kanit(fontSize: 22, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // สไลด์รูปร้านเค้ก เลื่อนอัตโนมัติ
          CarouselSlider(
            options: CarouselOptions(
              height: 185,
              viewportFraction: 0.8,
              autoPlay: true,
            ),
            items: cakeBanners.map((image) {
              return Container(
                margin: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
          // รายชื่อร้าน
          Expanded(
            child: ListView.separated(
              itemCount: cakeShops.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.red[100]),
              itemBuilder: (context, index) {
                final shop = cakeShops[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CakeShopDetailUI(shop: shop),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      shop.image1,
                      width: 72,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(shop.name),
                  subtitle: Text(shop.phone.trim()),
                  trailing: Icon(Icons.info, color: Colors.red[700]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
