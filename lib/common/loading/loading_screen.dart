import 'dart:async';

import 'package:calendy_x_project/common/constants/strings.dart';
import 'package:calendy_x_project/common/loading/loading_screen_controller.dart';
import 'package:flutter/material.dart';

class LoadingScreen {
  // a singleton constructor
  // private constructor
  LoadingScreen._sharedInstance();

  // static final private property
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();

  // factory constructor
  factory LoadingScreen.instance() => _shared;

  // private controller
  LoadingScreenController? _controller;

  // show the loading screen
  void show({
    required BuildContext context,
    required Color bgColor,
    required Color textColor,
    required Color cpiColor,
    String text = Strings.loading,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(
        context: context,
        text: text,
        textColor: textColor,
        bgColor: bgColor,
        cpiColor: cpiColor,
      );
    }
  }

  // close the loading screen
  void hide() {
    _controller?.close();
    _controller = null;
  }

  // create a loading screen overlay
  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
    required Color bgColor,
    required Color textColor,
    required Color cpiColor,
  }) {
    // overlay Api
    final state = Overlay.of(context);

    // return null if the overlay state can't be found
    if (state == null) {
      return null;
    }

    // a stream controller listen more than once
    final textController = StreamController<String>();

    // add the text to the textController (text as the default string value)
    textController.add(text);

    // find a the actual size of the display using renderBox
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // create an overlay using OverlayEntry()
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10.0),
                      CircularProgressIndicator(color: cpiColor),
                      const SizedBox(height: 20.0),
                      StreamBuilder<String>(
                        stream: textController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.requireData,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: textColor),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // create an OverlayEntry
    state.insert(overlay);

    // control the LoadingScreenController
    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
