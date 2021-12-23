import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mine_collection_detail_controller.dart';

class MineCollectionDetailView extends GetView<MineCollectionDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MineCollectionDetailView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MineCollectionDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
