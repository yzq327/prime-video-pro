import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mine_about_controller.dart';

class MineAboutView extends GetView<MineAboutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MineAboutView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MineAboutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
