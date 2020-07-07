import 'package:flutter/material.dart';

class FormEvrakSeriSira extends StatefulWidget {
  String labelicerik;
  TextEditingController txtseri;
  TextEditingController clcsira;
  bool readonlyseri;
  bool readonlysira;

  FormEvrakSeriSira(
      {Key key,
      this.labelicerik,
      this.txtseri,
      this.clcsira,
      this.readonlyseri,
      this.readonlysira})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormEvrakSeriSiraState();
}

class FormEvrakSeriSiraState extends State<FormEvrakSeriSira> {
  @override
  Widget build(BuildContext context) {
    if (widget.readonlyseri == null) widget.readonlyseri = false;
    if (widget.readonlysira == null) widget.readonlysira = false;
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
                        keyboardType: TextInputType.text,
                        controller: widget.txtseri,
                        textDirection: TextDirection.ltr,
                        readOnly: widget.readonlyseri,
                      ),
                    )),
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: widget.clcsira,
                        textDirection: TextDirection.ltr,
                        readOnly: widget.readonlysira,
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}
