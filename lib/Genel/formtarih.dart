import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

typedef void SetTarih(DateTime foo);

class FormTarih extends StatefulWidget {
  TextEditingController dttarih;
  String labelicerik;
  DateTime tarih;
  SetTarih setTarih;
  bool readonlytarih;

  FormTarih(
      {Key key,
      this.dttarih,
      this.labelicerik,
      this.tarih,
      this.setTarih,
      this.readonlytarih})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormTarihState();
}

class FormTarihState extends State<FormTarih> {
  @override
  Widget build(BuildContext context) {
    if (widget.readonlytarih == null) widget.readonlytarih = false;
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
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    controller: widget.dttarih,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Visibility(
                      visible: !widget.readonlytarih,
                      child: Padding(
                          padding: EdgeInsets.only(left: 2, right: 2),
                          child: RaisedButton(
                              color: Colors.red,
                              child: Text("SEÇ"),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: widget.tarih == null
                                            ? DateTime.now()
                                            : widget.tarih,
                                        firstDate: DateTime(2000, 1, 1),
                                        lastDate: DateTime(2099, 12, 31))
                                    .then((value) {
                                  setState(() {
                                    widget.setTarih(value);
                                    widget.dttarih.text =
                                        intl.DateFormat("dd.MM.yyyy")
                                            .format(value);
                                  });
                                });
                              }))),
                )
              ],
            ),
          ],
        ));
  }
}
