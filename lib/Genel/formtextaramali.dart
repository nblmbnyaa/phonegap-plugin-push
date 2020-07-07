import 'package:flutter/material.dart';

class FormTextAramali extends StatefulWidget {
  TextEditingController txtkod;
  String labelicerik;
  VoidCallback onPressedAra;
  VoidCallback onKeyDown;
  bool readOnly = false;
  bool buttonVisible = true;

  FormTextAramali(
      {Key key,
      this.txtkod,
      this.labelicerik,
      this.onPressedAra,
      this.onKeyDown,
      this.readOnly,
      this.buttonVisible})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormTextAramaliState();
}

class FormTextAramaliState extends State<FormTextAramali> {
  @override
  Widget build(BuildContext context) {
    if (widget.readOnly == null) widget.readOnly = false;
    if (widget.buttonVisible == null) widget.buttonVisible = true;

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
                  readOnly: widget.readOnly,
                  keyboardType: TextInputType.text,
                  controller: widget.txtkod,
                  textDirection: TextDirection.ltr,
                  onEditingComplete: widget.onKeyDown,
                ),
              ),
              Expanded(
                flex: 2,
                child: Visibility(
                    visible: widget.buttonVisible,
                    child: Padding(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text("ARA"),
                          onPressed: widget.onPressedAra,
                        ))),
              )
            ],
          ),
        ],
      ),
    );
  }
}
