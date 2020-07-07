import 'package:flutter/material.dart';

class FormTextAramasiz extends StatefulWidget {
  TextEditingController txtkod;
  String labelicerik;
  VoidCallback onKeyDown;
  bool isPassword = false;
  bool readonly;

  FormTextAramasiz(
      {Key key,
      this.txtkod,
      this.labelicerik,
      this.onKeyDown,
      this.isPassword,
      this.readonly})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormTextAramasizState();
}

class FormTextAramasizState extends State<FormTextAramasiz> {
  @override
  Widget build(BuildContext context) {
    if (widget.isPassword == null) widget.isPassword = false;
    if (widget.readonly == null) widget.readonly = false;
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(widget.labelicerik, textAlign: TextAlign.left),
                  flex: 3,
                ),
                Expanded(
                  flex: 7,
                  child: TextField(
                    readOnly: widget.readonly,
                    obscureText: widget.isPassword,
                    keyboardType: TextInputType.text,
                    controller: widget.txtkod,
                    textDirection: TextDirection.ltr,
                    onEditingComplete: widget.onKeyDown,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(),
                )
              ],
            ),
          ],
        ));
  }
}
