import 'package:flutter/material.dart';

class Validator {
  Validator._();

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidEmail(String email) {
    const String emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
        r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
    return RegExp(emailRegExpString, caseSensitive: false).hasMatch(email);
  }

  static bool isValidUserName(String userName) {
    return userName.length >= 3;
  }
}

class ValidationItem extends StatefulWidget {
  const ValidationItem(this.title, this.valid, {Key key}) : super(key: key);

  final String title;
  final bool valid;

  @override
  _ValidationItemState createState() => _ValidationItemState();
}

class _ValidationItemState extends State<ValidationItem> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _animatedStrike;
  Animation<double> _animatedWidth;
  Animation<double> _animStrikeWidthAnim;

  @override
  void didUpdateWidget(ValidationItem oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (oldWidget.valid != widget.valid) {
      if (widget.valid) {
        __startAnimation(true);
      } else {
        __startAnimation(false);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _animatedStrike = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _animatedWidth = Tween<double>(begin: 8, end: 12)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _animStrikeWidthAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animatedStrike, curve: Curves.easeOut));

    _animatedWidth.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _animStrikeWidthAnim.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> __startAnimation(bool animationDone) async {
    try {
      if (animationDone) {
        _animatedStrike.forward().orCancel;
      } else {
        _animatedStrike.reverse().orCancel;
      }

      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[400],
        ),
        padding: const EdgeInsets.only(top: 10.0, bottom: 12, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            CustomPaint(
              foregroundPainter: AnimStrikeWidth(_animStrikeWidthAnim.value),
              child: Text(
                widget.title,
                style: _adjustStyle(widget.valid),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _adjustStyle(bool validation) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: (validation) ? Colors.white30 : Colors.white,
        fontSize: 10,
        decoration: null);
  }
}

class AnimStrikeWidth extends CustomPainter {
  var value;
  AnimStrikeWidth(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.drawRect(Rect.fromLTWH(0, (size.height / 2), (size.width * value), 3.5),
        Paint()..color = Colors.grey);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
