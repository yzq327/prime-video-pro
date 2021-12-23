import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/font_icon.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';

class CreateCollectDialog extends StatefulWidget {
  final TextEditingController userEtController;
  final VoidCallback handleClear;
  CreateCollectDialog(
      {required this.userEtController, required this.handleClear});

  @override
  _CreateCollectDialogState createState() => _CreateCollectDialogState();
}

class _CreateCollectDialogState extends State<CreateCollectDialog> {
  String inputValue = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: SpaceData.spaceSizeHeight16,
        left: SpaceData.spaceSizeWidth32,
        right: SpaceData.spaceSizeWidth32,
      ),
      child: TextField(
        controller: widget.userEtController,
        maxLength: 20,
        textInputAction: TextInputAction.next,
        onSubmitted: (value) {},
        onChanged: (value) {
          setState(() {
            inputValue = value;
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: SpaceData.spaceSizeWidth8,
              vertical: SpaceData.spaceSizeWidth4),
          hintStyle: TextStyle(color: SystemColors.textDefaultColor),
          filled: true,
          fillColor: SystemColors.inputBgColor,
          hintText: "请输入收藏夹名称",
          border: OutlineInputBorder(
            borderSide: BorderSide.none, //
            borderRadius: BorderRadius.all(
              Radius.circular(SpaceData.spaceSizeHeight6), //边角为30
            ),
          ),
          suffixIcon: inputValue.isEmpty
              ? null
              : IconButton(
                  icon: Icon(IconFont.icon_closefill,
                      color: SystemColors.subTextColor,
                      size: SpaceData.spaceSizeWidth20),
                  onPressed: () {
                    widget.handleClear();
                    setState(() {
                      inputValue = '';
                    });
                  }),
        ),
      ),
    );
  }
}
