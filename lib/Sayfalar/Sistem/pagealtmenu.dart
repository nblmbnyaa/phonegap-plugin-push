import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/main.dart';

class PageAltMenu extends StatefulWidget {
  final String ustmenu;

  PageAltMenu({
    @required this.ustmenu,
  });

  @override
  State<StatefulWidget> createState() {
    return PageAltMenuState();
  }
}

class PageAltMenuState extends State<PageAltMenu> {
  List<Menu> altmenudekiler = [];

  void onload(String ustmenu) async {


    String x = await DefaultAssetBundle.of(context)
        .loadString("assets/data/menuler.json");
    List altmenudekilerx = json.decode(x);
    altmenudekiler.clear();

    for (int i = 0; i < altmenudekilerx.length; i++) {
      var mn = Menu.fromJson(altmenudekilerx[i]);

      if (mn.paneladi == ustmenu) {
        if (MyApp.oturum.menuler
                .where((element) => element.menuno == mn.menuno)
                .length >
            0 || MyApp.oturum.kullanicikodu=="ADMIN") altmenudekiler.add(mn);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    onload(widget.ustmenu);
  }

  //////////////////////TASARIM/////////////////
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.oturum.sirketkodu),
      ),
      body: new Center(
          child: GridView.builder(
        itemCount: altmenudekiler.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext ctxt, int Index) {
          return new GestureDetector(
              onTap: () {
                print(altmenudekiler[Index].viewname);
                Navigator.pushNamed(context, altmenudekiler[Index].viewname);
                //Navigator.pushNamed(context, "/201003");
              },
              child: Container(
                  margin: const EdgeInsets.all(5.0),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                          width: double.infinity,
                          height: 70,
                          padding: EdgeInsets.all(8.0),
                          
                          child: Text(
                            altmenudekiler[Index].baslik,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                  ),
                          width: double.infinity,
                          padding: EdgeInsets.all(8.0),
                          
                          child: Text(
                            "${altmenudekiler[Index].menuno}",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)
                          ),
                        ),
                      )
                    ],
                  )));
        },
      )),
    );
  }
}
