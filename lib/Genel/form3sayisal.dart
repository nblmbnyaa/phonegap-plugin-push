import 'package:flutter/material.dart';

typedef void setDeger(String str);

class Form3Sayisal extends StatefulWidget {
  String labelicerik;
  TextEditingController clcdeger1;
  TextEditingController clcdeger2;
  TextEditingController clcdeger3;
  bool readonly1 = false;
  bool readonly2 = false;
  bool readonly3 = false;
  setDeger setIsk1;
  setDeger setIsk2;
  setDeger setIsk3;

  Form3Sayisal(
      {Key key,
      this.labelicerik,
      this.clcdeger1,
      this.clcdeger2,
      this.clcdeger3,
      this.readonly1,
      this.readonly2,
      this.readonly3,
      this.setIsk1,
      this.setIsk2,
      this.setIsk3})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => Form3SayisalState();
}

class Form3SayisalState extends State<Form3Sayisal> {
  @override
  Widget build(BuildContext context) {
    if (widget.readonly1 == null) widget.readonly1 = false;
    if (widget.readonly2 == null) widget.readonly2 = false;
    if (widget.readonly3 == null) widget.readonly3 = false;

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
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                        readOnly: widget.readonly1,
                        keyboardType: TextInputType.number,
                        controller: widget.clcdeger1,
                        textDirection: TextDirection.ltr,
                        onChanged: widget.setIsk1,
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                        readOnly: widget.readonly2,
                        keyboardType: TextInputType.number,
                        controller: widget.clcdeger2,
                        textDirection: TextDirection.ltr,
                        onChanged: widget.setIsk2,
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                        readOnly: widget.readonly3,
                        keyboardType: TextInputType.number,
                        controller: widget.clcdeger3,
                        textDirection: TextDirection.ltr,
                        onChanged: widget.setIsk3,
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}
