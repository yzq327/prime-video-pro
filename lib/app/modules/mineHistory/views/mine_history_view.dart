import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mine_history_controller.dart';

class MineHistoryView extends GetView<MineHistoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MineHistoryView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MineHistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
