import 'package:flutter/material.dart';

class FormCiftButton extends StatefulWidget {
  String button1icerik;
  VoidCallback button1islem;
  Color button1renk;
  int button1flex;
  String button2icerik;
  VoidCallback button2islem;
  Color button2renk;
  int button2flex;

  FormCiftButton(
      {Key key,
      this.button1icerik,
      this.button1islem,
      this.button1renk,
      this.button1flex,
      this.button2icerik,
      this.button2islem,
      this.button2renk,
      this.button2flex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormCiftButtonState();
}

class FormCiftButtonState extends State<FormCiftButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: widget.button1flex,
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20.0),
                color: widget.button1renk,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: widget.button1islem,
                  child: Text(widget.button1icerik,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.normal)),
                ),
              )),
          Expanded(
              flex: widget.button2flex,
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20.0),
                color: widget.button2renk,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: widget.button2islem,
                  child: Text(widget.button2icerik,
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
