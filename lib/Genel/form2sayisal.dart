import 'package:flutter/material.dart';

class Form2Sayisal extends StatefulWidget {
  String labelicerik;
  TextEditingController clcdeger1;
  TextEditingController clcdeger2;

  bool readonly1 = false;
  bool readonly2 = false;

  Form2Sayisal(
      {Key key,
      this.labelicerik,
      this.clcdeger1,
      this.clcdeger2,
      this.readonly1,
      this.readonly2})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => Form2SayisalState();
}

class Form2SayisalState extends State<Form2Sayisal> {
  @override
  Widget build(BuildContext context) {
    if (widget.readonly1 == null) widget.readonly1 = false;
    if (widget.readonly2 == null) widget.readonly2 = false;

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
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                        readOnly: widget.readonly1,
                        keyboardType: TextInputType.number,
                        controller: widget.clcdeger1,
                        textDirection: TextDirection.ltr,
                      ),
                    )),
                Expanded(flex: 1, child: Center()),
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                        readOnly: widget.readonly2,
                        keyboardType: TextInputType.number,
                        controller: widget.clcdeger2,
                        textDirection: TextDirection.ltr,
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}
