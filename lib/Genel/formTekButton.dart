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
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20.0),
                color: widget.renk,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: widget.islem,
                  child: Text(widget.icerik,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.normal)),
                ),
              )),
        ],
      ),
    );
  }
}
