import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_display_brightness/device_display_brightness.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prime_video_pro/app/core/theme/text_theme.dart';
import 'package:prime_video_pro/app/core/values/colors.dart';
import 'package:prime_video_pro/app/core/values/font_icon.dart';
import 'package:prime_video_pro/app/core/values/space_data.dart';
import 'package:prime_video_pro/app/core/values/string.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';

import 'commom_slider.dart';
import 'common_basic_slider.dart';


class SpeedText {
  String text;
  double speedValue;
  SpeedText(this.text, this.speedValue);
}

class StoreDuration {
  int currentPosition;
  String totalDuration;
  StoreDuration(this.currentPosition, this.totalDuration);
}

class CommonVideoPlayer extends StatefulWidget {
  final String url;
  late final String? vodName;
  late final String? vodPic;
  late final double? width;
  late final double? height;
  late final ValueChanged<StoreDuration> onStoreDuration;
  final int watchedDuration;

  CommonVideoPlayer(
      {Key? key,
      required this.url,
      this.vodName,
      this.vodPic,
      this.width = double.infinity,
      this.height = double.infinity,
      required this.onStoreDuration,
      this.watchedDuration = 0})
      : super(key: key);

  _CommonVideoPlayerState createState() => _CommonVideoPlayerState();
}

class _CommonVideoPlayerState extends State<CommonVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  Timer? _timer;
  bool _showTagging = false;
  bool _showSpeedSelect = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double defaultAspectRatio = 16 / 9;
  double currentSpeed = 1.0;
  bool isLock = false;
  double currentVolume = 0.5;
  double currentBrightness = 0.0;
  double _dragTop = 0.0;
  double _dragStartY = 0.0;
  bool changeBrightness = false;
  bool changeVolume = false;
  double tempValue = 0.0;

  List<SpeedText> get getSpeedText {
    return [
      SpeedText('0.75X', 0.75),
      SpeedText('正常', 1.0),
      SpeedText('1.25X', 1.25),
      SpeedText('1.5X', 1.5),
      SpeedText('1.75X', 1.75),
      SpeedText('2.0X', 2.0),
    ];
  }

  playByUrl(String url) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((value) {
        _videoPlayerController
            ?.seekTo(Duration(milliseconds: widget.watchedDuration));
      })
      ..addListener(() {
        position = _videoPlayerController?.value.position ??
            Duration(milliseconds: widget.watchedDuration);
        duration = _videoPlayerController?.value.duration ?? Duration.zero;
        widget.onStoreDuration(StoreDuration(
            position.inMilliseconds, StringsHelper.formatDuration(duration)));
        setState(() {});
      })
      ..play();
  }

  /// 记录是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Size get _window => MediaQueryData.fromWindow(window).size;

  bool get _showLocateText {
    return widget.watchedDuration > 0 &&
        position.inMilliseconds - widget.watchedDuration < 3000 &&
        !showLoading;
  }

  @override
  void initState() {
    super.initState();
    playByUrl(widget.url);
    DeviceDisplayBrightness.getBrightness()
        .then((value) => currentBrightness = value);
    VolumeController().getVolume().then((volume) => currentVolume = volume);
  }

  @override
  void didUpdateWidget(covariant CommonVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      playByUrl(widget.url);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.dispose();
    _timer?.cancel();
  }

  void _playOrPause() {
    if (_videoPlayerController!.value.isInitialized) {
      _videoPlayerController!.value.isPlaying
          ? _videoPlayerController!.pause()
          : _videoPlayerController!.play();
    }
  }

  void _togglePlayControl() {
    if (!_showTagging) {
      _startPlayControlTimer();
    }
    setState(() {
      _showTagging = !_showTagging;
    });
  }

  void _startPlayControlTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        Future.delayed(Duration(milliseconds: 300)).whenComplete(() {
          _showTagging = false;
        });
      });
    });
  }

  void _toggleFullScreen() {
    setState(() {
      if (_isFullScreen) {
        // Navigator.push(context, MaterialPageRoute(builder: (context)  {
        //   return Material(child: build(context),);
        // }));
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      }
      _startPlayControlTimer(); // 操作完控件开始计时隐藏
    });
  }

  bool get showLoading {
    return (_videoPlayerController!.value.isInitialized &&
            _videoPlayerController!.value.isBuffering) ||
        !_videoPlayerController!.value.isInitialized;
  }

  // 拦截返回键
  Future<bool> _onWillPop() async {
    if (_isFullScreen) {
      _toggleFullScreen();
      return false;
    }
    return true;
  }

  void backPress() {
    // 如果是全屏，点击返回键则关闭全屏，如果不是，则系统返回键
    if (_isFullScreen) {
      _toggleFullScreen();
    } else {
      Navigator.pop(context);
    }
  }

  void handleChangeSlider(double value) {
    _videoPlayerController?.seekTo(Duration(seconds: value.toInt()));
    _startPlayControlTimer();
  }

  void _handleOnPanDown(DragDownDetails e) {
    double widgetWidth = StringsHelper.getWidgetSize(context).width;
    setState(() {
      _dragStartY = e.globalPosition.dy;
      _dragTop = e.globalPosition.dy;
      tempValue = e.globalPosition.dx < widgetWidth / 2
          ? currentBrightness
          : currentVolume;
    });
  }

  void _handleOnPanUpdate(DragUpdateDetails e) {
    double widgetWidth = StringsHelper.getWidgetSize(context).width;
    setState(() {
      changeBrightness = e.globalPosition.dx < widgetWidth / 2;
      changeVolume = !changeBrightness;
      _dragTop += e.delta.dy;
      double changedHeight = (_dragStartY - _dragTop) / 140;
      double tempChange = tempValue + changedHeight;
      tempChange = tempChange < 0
          ? 0.0
          : tempChange > 1
              ? 1.0
              : tempChange;
      if (changeBrightness) {
        currentBrightness = tempChange;
        DeviceDisplayBrightness.setBrightness(currentBrightness);
      } else {
        currentVolume = tempChange;
        VolumeController().setVolume(currentVolume);
      }
    });
  }

  void _handleOnPanEnd(DragEndDetails e) {
    setState(() {
      changeBrightness = false;
      changeVolume = false;
    });
  }

  Widget _buildShowLoading() {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: showLoading ? 1 : 0,
        duration: Duration(milliseconds: 300),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: !_videoPlayerController!.value.isInitialized
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(widget.vodPic!,
                          errorListener: () {
                        print('图片加载错误');
                      }),
                      alignment: Alignment.topLeft,
                      fit: BoxFit.cover,
                    )
                  : null),
          child: Container(
            color: SystemColors.videoStateBgColor,
            padding: EdgeInsets.all(SpaceData.spaceSizeWidth8),
            child: CircularProgressIndicator(
                strokeWidth: 2.0, color: SystemColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildShowPauseIcon() {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: _videoPlayerController!.value.isPlaying
            ? 0
            : showLoading
                ? 0
                : 1,
        duration: Duration(milliseconds: 300),
        child: Center(
          child: Container(
            color: SystemColors.videoStateBgColor,
            padding: EdgeInsets.all(SpaceData.spaceSizeWidth8),
            child: Icon(
              Icons.play_arrow,
              size: SpaceData.spaceSizeWidth26,
              color: SystemColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOperationIcon(IconData icon, GestureTapCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(
          right: (_isFullScreen && icon == IconFont.icon_quanping_)
              ? SpaceData.spaceSizeWidth20
              : SpaceData.spaceSizeWidth8),
      child: GestureDetector(
        child: Icon(
          icon,
          color: SystemColors.primaryColor,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBackRow() {
    return Visibility(
      visible: !isLock,
      child: Container(
          alignment: Alignment.center,
          height: SpaceData.spaceSizeHeight44,
          color: SystemColors.videoSlideBgColor,
          child: Center(
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: backPress),
                CommonText.text18(
                  widget.vodName ?? '',
                  color: SystemColors.primaryColor,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildLockIcon() {
    return Container(
        alignment: Alignment.centerRight,
        child: IconButton(
            icon: Icon(
              isLock ? IconFont.icon_suofuben : IconFont.icon_jiesuofuben,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isLock = !isLock;
              });
              _startPlayControlTimer();
            }));
  }

  Widget _buildButtonOperateRow() {
    return Visibility(
      visible: !isLock,
      child: Container(
          height: SpaceData.spaceSizeHeight32,
          color: duration == Duration.zero
              ? Colors.transparent
              : SystemColors.videoSlideBgColor,
          child: duration == Duration.zero
              ? SizedBox()
              : Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: SpaceData.spaceSizeWidth8,
                          left: _isFullScreen
                              ? SpaceData.spaceSizeWidth16
                              : SpaceData.spaceSizeWidth8),
                      child: CommonText.text18(
                          StringsHelper.formatDuration(position)),
                    ),
                    Expanded(
                        child: CommonSlider(
                            position: position,
                            duration: duration,
                            onChangeEnd: (value) => handleChangeSlider(value))),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SpaceData.spaceSizeWidth8),
                      child: CommonText.text18(
                          StringsHelper.formatDuration(duration)),
                    ),
                    _buildOperationIcon(
                      IconFont.icon_sudu___,
                      () => setState(() {
                        _showSpeedSelect = !_showSpeedSelect;
                      }),
                    ),
                    _buildOperationIcon(
                      IconFont.icon_quanping_,
                      () {
                        _toggleFullScreen();
                      },
                    ),
                  ],
                )),
    );
  }

  Widget _buildShowTaggingContent() {
    return Positioned.fill(
      child: Offstage(
        offstage: !_showTagging,
        child: AnimatedOpacity(
          opacity: _showTagging ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBackRow(),
              _buildLockIcon(),
              _buildButtonOperateRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowSpeedContent() {
    return Positioned.fill(
      child: Offstage(
        offstage: !_showSpeedSelect,
        child: AnimatedOpacity(
          opacity: _showSpeedSelect ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: Container(
            color: SystemColors.videoStateBgColor,
            padding: EdgeInsets.all(SpaceData.spaceSizeHeight40),
            child: SizedBox(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: SpaceData.spaceSizeWidth16,
                ),
                itemCount: getSpeedText.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  child: Center(
                      child: CommonText.text18(getSpeedText[index].text,
                          color: currentSpeed == getSpeedText[index].speedValue
                              ? SystemColors.hoverThemeBgColor
                              : SystemColors.primaryColor)),
                  onTap: () {
                    setState(() {
                      _showSpeedSelect = false;
                      currentSpeed = getSpeedText[index].speedValue;
                    });
                    Fluttertoast.showToast(
                        msg: "已切换至${getSpeedText[index].text}",
                        timeInSecForIosWeb: 2,
                        gravity: ToastGravity.CENTER);
                    _videoPlayerController!
                        .setPlaybackSpeed(getSpeedText[index].speedValue);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeSlider() {
    return Offstage(
      offstage: !changeVolume,
      child: AnimatedOpacity(
        opacity: changeVolume ? 1 : 0,
        duration: Duration(milliseconds: 300),
        child: Row(
          children: [
            Container(
              width: SpaceData.spaceSizeWidth10,
              child: CommonBasicSlider(
                currentValue: currentVolume,
                onChange: (double value) {
                  VolumeController().setVolume(value);
                  setState(() {
                    currentVolume = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SpaceData.spaceSizeWidth10),
              child: Icon(
                IconFont.icon_yinliang,
                color: SystemColors.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBrightnessSlider() {
    return Offstage(
        offstage: !changeBrightness,
        child: AnimatedOpacity(
            opacity: changeBrightness ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(SpaceData.spaceSizeWidth10),
                  child: Icon(
                    IconFont.icon_liangdu,
                    color: SystemColors.primaryColor,
                  ),
                ),
                Container(
                  width: SpaceData.spaceSizeWidth10,
                  child: CommonBasicSlider(
                    currentValue: currentBrightness,
                    onChange: (double value) {
                      DeviceDisplayBrightness.setBrightness(value);
                      setState(() {
                        currentBrightness = value;
                      });
                    },
                  ),
                ),
              ],
            )));
  }

  Widget _buildPanContent() {
    return Positioned.fill(
        top: SpaceData.spaceSizeHeight40,
        bottom: SpaceData.spaceSizeHeight40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBrightnessSlider(),
            _buildVolumeSlider(),
          ],
        ));
  }

  Widget _buildLocateText() {
    return Positioned(
        left: SpaceData.spaceSizeHeight16,
        top: SpaceData.spaceSizeHeight200,
        child: Offstage(
            offstage: !_showLocateText,
            child: AnimatedOpacity(
                opacity: _showLocateText ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: SpaceData.spaceSizeHeight2, horizontal: SpaceData.spaceSizeWidth16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SpaceData.spaceSizeWidth20),
                      color: SystemColors.videoStateBgColor
                    ),
                    child: CommonText.text12(
                        '已为您定位到${StringsHelper.formatDuration(Duration(milliseconds: widget.watchedDuration))}')))));
  }

  @override
  Widget build(BuildContext context) {
    return widget.url.isEmpty
        ? CommonText.mainTitle('暂无视频资源，尽情期待', color: SystemColors.hoverThemeBgColor)
        : SafeArea(
            top: !_isFullScreen,
            bottom: !_isFullScreen,
            left: !_isFullScreen,
            right: !_isFullScreen,
            child: Container(
              width: _isFullScreen ? _window.width : widget.width,
              height: _isFullScreen ? _window.height : widget.height,
              child: GestureDetector(
                onDoubleTap: _playOrPause,
                onTap: _togglePlayControl,
                onPanDown: _handleOnPanDown,
                onPanUpdate: _handleOnPanUpdate,
                onPanEnd: _handleOnPanEnd,
                child: Container(
                  color: Colors.black,
                  child: Hero(
                    tag: "player",
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController!.value.isInitialized
                          ? _videoPlayerController!.value.aspectRatio
                          : defaultAspectRatio,
                      child: WillPopScope(
                        child: Stack(
                          children: [
                            VideoPlayer(_videoPlayerController!),
                            _buildShowLoading(),
                            _buildShowPauseIcon(),
                            _buildShowTaggingContent(),
                            _buildShowSpeedContent(),
                            _buildPanContent(),
                            _buildLocateText(),
                          ],
                        ),
                        onWillPop: _onWillPop,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
