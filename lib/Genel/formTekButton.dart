import 'package:flutter/material.dart';


class FormTekButton extends StatefulWidget {
  TextEditingController dttarih;
  String icerik;
  VoidCallback islem;
  Color renk;

  FormTekButton({Key key, this.icerik, this.islem, this.renk})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormTekButtonState();
}

class FormTekButtonState extends State<FormTekButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: RaisedButton(
                  child: Text(widget.icerik),
                  onPressed: widget.islem,
                  color: widget.renk,
                ),
              )),
        ],
      ),
    );
  }
}
