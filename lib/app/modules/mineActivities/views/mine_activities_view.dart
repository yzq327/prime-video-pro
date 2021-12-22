import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mine_activities_controller.dart';

class MineActivitiesView extends GetView<MineActivitiesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MineActivitiesView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MineActivitiesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
