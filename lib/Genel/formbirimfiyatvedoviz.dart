import 'package:flutter/material.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';

typedef void SetDoviz(Doviz foo);
typedef void setFiyat(String str);

class FormBirimFiyatveDoviz extends StatefulWidget {
  String labelicerik;
  TextEditingController clcmiktar;
  List<Doviz> dovizler;
  Doviz selectedValue;
  SetDoviz setDoviz;
  bool readonlyfiyat;
  setFiyat setfiyat;

  FormBirimFiyatveDoviz(
      {Key key,
      this.labelicerik,
      this.clcmiktar,
      this.dovizler,
      this.selectedValue,
      this.setDoviz,
      this.readonlyfiyat,
      this.setfiyat})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormBirimFiyatveDovizState();
}

class FormBirimFiyatveDovizState extends State<FormBirimFiyatveDoviz> {
  @override
  Widget build(BuildContext context) {
    if (widget.readonlyfiyat == null) widget.readonlyfiyat = false;
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
                        readOnly: widget.readonlyfiyat,
                        keyboardType: TextInputType.number,
                        controller: widget.clcmiktar,
                        textDirection: TextDirection.ltr,
                        onChanged: widget.setfiyat,
                      ),
                    )),
                Expanded(flex: 1, child: Center()),
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: DropdownButton<Doviz>(
                        isDense: true,
                        //items: Dovizler,
                        items: widget.dovizler.map((e) {
                          return DropdownMenuItem<Doviz>(
                              value: e, child: Text(e.dovizSembol));
                        }).toList(),
                        value: widget.selectedValue,
                        onChanged: (Doviz value) {
                          widget.setDoviz(value);
                          setState(() {});
                        },
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}
