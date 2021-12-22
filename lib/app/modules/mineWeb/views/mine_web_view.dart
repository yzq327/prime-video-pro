import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mine_web_controller.dart';

class MineWebView extends GetView<MineWebController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MineWebView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MineWebView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
