import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:prosis_mobile/Sayfalar/Sistem/pagealtmenu.dart';
import 'package:prosis_mobile/main.dart';

class PageAnaMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageAnaMenuState();
  }
}

class PageAnaMenuState extends State<PageAnaMenu> {
  List<UstMenu> ustmenudekiler = [];

  void onload() async {
    String x = await DefaultAssetBundle.of(context)
        .loadString("assets/data/ustmenudekiler.json");
    List ustmenudekilerx = json.decode(x);
    ustmenudekiler.clear();
    for (int i = 0; i < ustmenudekilerx.length; i++) {
      ustmenudekiler.add(UstMenu.fromJson(ustmenudekilerx[i]));
    }
    setState(() {});
  }

  Future<bool> backpressed() async {
    return false;
  }

  void cikis() async {
    Future<bool> cevap = Mesajlar().yesno(
        context,
        Text("Uygulamadan çıkmak istediğinizden emin misiniz?"),
        Text("Uyarı"),
        "Çık",
        "Vazgeç");
    cevap.then((value) {
      if (value) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    });
  }

  IconData icongetir(String isim) {
    switch (isim) {
      case "Evraklar":
        return Icons.edit;
      case "Operasyonlar":
        return Icons.widgets;
      case "Genel Raporlar":
        return Icons.equalizer;
      case "Kasa":
        return Icons.business_center;
      case "CRM":
        return Icons.contact_phone;
      case "Sera":
        return Icons.wb_sunny;
      default:
        return Icons.email;
    }
  }

  @override
  void initState() {
    super.initState();

    onload();
  }

  //////////////////////TASARIM/////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(MyApp.oturum.sirketkodu),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.menu, color: Colors.white, size: 100.0),
                      Text(
                        "Prosis Yazılım",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(color: Colors.blue[200]),
              ),
              ListTile(
                leading: Icon(Icons.print),
                title: Text('Yazıcı Ayarı'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Şifre Değiştir'),
                leading: Icon(Icons.vpn_key),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Çıkış'),
                onTap: () {
                  cikis();
                },
              ),
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: backpressed,
          child: Center(
              child: GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: ustmenudekiler.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
            itemBuilder: (BuildContext ctxt, int index) {
              return new GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, '/altmenu',
                    //     arguments: ustmenudekiler[Index].baslik);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageAltMenu(
                            ustmenu: ustmenudekiler[index].paneladi)));
                  },
                  child: Container(
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: NetworkImage(ustmenudekiler[Index].resim),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          // Image(
                          //     image: AssetImage(ustmenudekiler[index].resim),
                          //     fit: BoxFit.cover),

                          Icon(icongetir(ustmenudekiler[index].baslik),size: 70,),
                          Transform(
                            alignment: Alignment.bottomCenter,
                            transform: Matrix4.skewY(0.0)..rotateZ(0.0),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8.0),
                              color: Color(0xFFFFEEDD),
                              child: Text(
                                ustmenudekiler[index].baslik,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      )));
            },
          )),
        ));
  }
}
