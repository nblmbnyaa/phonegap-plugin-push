import 'package:flutter/material.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';

typedef void SetGenelEnum(GenelEnum foo);

class FormCombobox extends StatefulWidget {
  String labelicerik;
  List<GenelEnum> datasource;
  GenelEnum selectedValue;
  SetGenelEnum setGenelEnum;
  bool readonly;

  FormCombobox(
      {Key key,
      this.labelicerik,
      this.datasource,
      this.selectedValue,
      this.setGenelEnum,
      this.readonly})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FormComboboxState();
}

class FormComboboxState extends State<FormCombobox> {
  @override
  Widget build(BuildContext context) {
    if (widget.readonly == null) widget.readonly = false;
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
                      child: DropdownButton<GenelEnum>(
                        isDense: true,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        items: widget.datasource.map((e) {
                          return DropdownMenuItem<GenelEnum>(
                              value: e, child: Text(e.adi));
                        }).toList(),
                        value: widget.selectedValue,
                        onChanged: (GenelEnum value) {
                          widget.setGenelEnum(value);
                          setState(() {});
                        },
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Center(),
                )
              ],
            ),
          ],
        ));
  }
}
