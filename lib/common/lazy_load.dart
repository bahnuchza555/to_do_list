import 'package:flutter/material.dart';

class LazyLoad extends StatefulWidget {
  final Function onBottom;
  final Widget child;
  const LazyLoad({Key? key, required this.onBottom, required this.child})
      : super(key: key);
  @override
  _LazyLoadState createState() => _LazyLoadState();
}

class _LazyLoadState extends State<LazyLoad> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              widget.onBottom.call();
            }
          }
          return false;
        },
        child: widget.child);
  }
}
