import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mine_collection_controller.dart';

class MineCollectionView extends GetView<MineCollectionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MineCollectionView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MineCollectionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
