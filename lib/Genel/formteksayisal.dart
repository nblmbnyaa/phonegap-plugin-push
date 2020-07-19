import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormTekSayisal extends StatefulWidget {
  String labelicerik;
  TextEditingController clcdeger1;

  bool readonly1 = false;

  FormTekSayisal(
      {Key key,
      this.labelicerik,
      this.clcdeger1,
      this.readonly1})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormTekSayisalState();
}

class FormTekSayisalState extends State<FormTekSayisal> {
  @override
  Widget build(BuildContext context) {
    if (widget.readonly1 == null) widget.readonly1 = false;

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
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                        readOnly: widget.readonly1,
                        keyboardType: TextInputType.number,
                        controller: widget.clcdeger1,
                        textDirection: TextDirection.ltr,
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}
