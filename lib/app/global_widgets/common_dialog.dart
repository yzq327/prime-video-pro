import 'package:flutter/material.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';

class CommonDialog {
  static Widget? showAlertDialog(
    BuildContext context, {
    Key? key,
    barrierDismissible = false,
    onConfirm,
    onCancel,
    String? title,
    var contentPadding,
    var content,
    double? contentFontSize,
    String positiveBtnText = '确认',
    Color? positiveBtnColor,
    String negativeBtnText = '取消',
    bool showNegativeBtn = true,
    bool showPositiveBtn = true,
    bool willPop = true,
    bool onTapCloseDialog = true,
    Function? onDismiss,
  }) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return WillPopScope(
              child: SimpleDialog(
                key: key,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: contentPadding ??
                    EdgeInsets.only(top: SpaceData.spaceSizeWidth16),
                children: <Widget>[
                  Offstage(
                      offstage: title == null,
                      child: Container(
                        margin: EdgeInsets.only(top: SpaceData.spaceSizeHeight12),
                        child: CommonText.mainTitle(title,
                            color: SystemColors.blackColor),
                      )),
                  Offstage(
                      offstage: content == null,
                      child: content is String
                          ? Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SpaceData.spaceSizeWidth20),
                              margin: EdgeInsets.symmetric(
                                  vertical: SpaceData.spaceSizeWidth16),
                              child: CommonText.text18(content,
                                  textAlign: TextAlign.center,
                                  color: SystemColors.blackColor),
                            )
                          : content),
                  Offstage(
                      offstage: !showPositiveBtn && !showNegativeBtn,
                      child: Container(
                        margin: EdgeInsets.only(top: SpaceData.spaceSizeWidth16),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: SystemColors.phTextColor, width: 0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Visibility(
                                visible: showPositiveBtn,
                                child: Expanded(
                                  child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: Container(
                                        height: SpaceData.spaceSizeHeight44,
                                        alignment: Alignment.center,
                                        child: CommonText.text18(
                                            positiveBtnText,
                                            color: positiveBtnColor ??
                                                SystemColors.blackColor),
                                      ),
                                      onTap: () {
                                        if (onTapCloseDialog)
                                          Navigator.pop(context);
                                        if (onConfirm != null) onConfirm();
                                      }),
                                )),
                            Visibility(
                              visible: showNegativeBtn && showPositiveBtn,
                              child: Container(
                                width: 1.0,
                                height: SpaceData.spaceSizeHeight44,
                                color: SystemColors.phTextColor,
                              ),
                            ),
                            Visibility(
                                visible: showNegativeBtn,
                                child: Expanded(
                                  child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: Container(
                                        height: SpaceData.spaceSizeHeight44,
                                        alignment: Alignment.center,
                                        child: CommonText.text18(
                                            negativeBtnText,
                                            color: positiveBtnColor ??
                                                SystemColors.subTextColor),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        if (onCancel != null) onCancel();
                                      }),
                                )),
                          ],
                        ),
                      )),
                ],
              ),
              onWillPop: () async {
                return Future.value(willPop);
              });
        }).then((data) {
      if (onDismiss != null) onDismiss();
    });
    return null;
  }
}
