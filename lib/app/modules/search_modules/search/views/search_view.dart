import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SearchView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Obx(
              () {
                return Text(controller.count.value.toString(),
                    style: TextStyle(fontSize: 20));
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.increment(4);
            },
            child: Container(
              child: Text(
                '修改值',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
