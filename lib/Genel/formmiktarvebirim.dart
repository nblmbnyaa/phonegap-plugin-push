import 'package:flutter/material.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';

typedef void SetBirim(Birim foo);
typedef void MiktaronChanged(String str);

class FormMiktarveBirim extends StatefulWidget {
  String labelicerik;
  TextEditingController clcmiktar;
  List<Birim> birimler;
  Birim selectedValue;
  SetBirim setBirim;
  MiktaronChanged onChanged;
  FocusNode focusnode;

  FormMiktarveBirim(
      {Key key,
      this.labelicerik,
      this.clcmiktar,
      this.birimler,
      this.selectedValue,
      this.setBirim,
      this.onChanged,
      this.focusnode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormMiktarveBirimState();
}

class FormMiktarveBirimState extends State<FormMiktarveBirim> {
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
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextField(
                        autofocus: true,
                        focusNode: widget.focusnode,
                        onChanged: widget.onChanged,
                        keyboardType: TextInputType.number,
                        controller: widget.clcmiktar,
                        textDirection: TextDirection.ltr,
                      ),
                    )),
                Expanded(flex: 1, child: Center()),
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: DropdownButton<Birim>(
                        isDense: true,
                        //items: birimler,
                        items: widget.birimler.map((e) {
                          return DropdownMenuItem<Birim>(
                              value: e, child: Text(e.birimAdi));
                        }).toList(),
                        value: widget.selectedValue,
                        onChanged: (Birim value) {
                          widget.selectedValue = value;
                          widget.setBirim(value);
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
