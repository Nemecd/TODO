import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import 'TodoList.dart';
import 'adHelper.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key, required this.item});
  final TodoItem item;
  

  @override
  State<ViewScreen> createState() => _ViewScreenState();
  
}
class _ViewScreenState extends State<ViewScreen> {
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMEEEEd();
    final timeFormat = DateFormat.jm();
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Task',style: TextStyle( color: Colors.white),),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.item.description,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'At: ${dateFormat.format(widget.item.deadline)} at ${timeFormat.format(widget.item.deadline)}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: _bannerAd?.size.width.toDouble() ?? 0,
        height: _bannerAd?.size.height.toDouble() ?? 0,
        child: _bannerAd != null ? AdWidget(ad: _bannerAd!) : const Placeholder(),
      ),
    );
  }
}