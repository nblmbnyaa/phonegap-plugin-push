import 'package:flutter/material.dart';

class FormTextAramaliCiftBtn extends StatefulWidget {
  TextEditingController txtkod;
  String labelicerik;
  VoidCallback onPressedAra;
  VoidCallback onPressedBar;
  VoidCallback onKeyDown;
  bool readOnly;
  FocusNode focusnode;

  FormTextAramaliCiftBtn(
      {Key key,
      this.txtkod,
      this.labelicerik,
      this.onPressedAra,
      this.onPressedBar,
      this.onKeyDown,
      this.readOnly,
      this.focusnode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormTextAramaliCiftBtnState();
}

class FormTextAramaliCiftBtnState extends State<FormTextAramaliCiftBtn> {
  @override
  Widget build(BuildContext context) {
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
                flex: 5,
                child: TextField(
                  autofocus: true,
                  focusNode: widget.focusnode,
                  readOnly: widget.readOnly,
                  keyboardType: TextInputType.text,
                  controller: widget.txtkod,
                  textDirection: TextDirection.ltr,
                  onEditingComplete: widget.onKeyDown,
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2, right: 2),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text("ARA"),
                      onPressed: widget.onPressedAra,
                    ),
                  )),
              Expanded(
                flex: 2,
                child: Padding(
                    padding: EdgeInsets.only(left: 2, right: 2),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text("BAR"),
                      onPressed: widget.onPressedBar,
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
