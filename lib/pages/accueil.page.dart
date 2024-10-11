import 'package:akla00001/abonnement/dialogueAbonnement.dart';
import 'package:akla00001/classes/stateprovider.dart';
import 'package:akla00001/dataBase/sqfliteBase.dart';
import 'package:akla00001/pages/drawer.pages.dart';
import 'package:akla00001/pages/page.recherche.dart';
import 'package:akla00001/pages/page/pages.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  int _currentIndex = 0;

  List<Widget> pages = [const livres(), const chatBot(), const accueil()];

  void _indexHome(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> items = [
    const Column(
      children: [
        Icon(
          Icons.home,
        ),
        Text(
          "Acceuil",
          textAlign: TextAlign.center,
        )
      ],
    ),
    const Column(
      children: [
        Icon(
          Icons.chat,
        ),
        Text(
          "ChatBot",
          textAlign: TextAlign.center,
        )
      ],
    ),
    const Column(
      children: [
        Icon(
          Icons.content_cut,
        ),
        Text(
          "LIVRES",
          textAlign: TextAlign.center,
        )
      ],
    ),
  ];

  Future<bool> _onBackPressed() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              maxRadius: 10,
              backgroundColor: Colors.pink,
              child: Icon(Icons.functions,
                  color: Colors.indigoAccent,
                  size: 35,
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(4, 4))
                  ]),
            ),
            SizedBox(width: 16.0),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Edu_Boost',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            )
          ],
        ),
        content: Container(
          foregroundDecoration: const BoxDecoration(),
          child: const Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // CircleAvatar en arrière-plan
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.2,
                    child: CircleAvatar(
                      maxRadius: 50,
                      backgroundColor: Colors.pinkAccent,
                      child: Opacity(
                        opacity: 0.6,
                        child: Icon(
                          Icons.functions,
                          color: Colors.indigoAccent,
                          size: 200,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                blurRadius: 5,
                                offset: Offset(4, 4))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Conteneur avec texte au-dessus du CircleAvatar

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'Voulez-vous vraiment quitter l\'application ?',
                    style: TextStyle(fontSize: 18.0, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Annuler',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[200],
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: const Text('Quitter'),
              ),
            ],
          )
        ],
      ),
    ).then((value) => value ?? false);
  }

  List<Item> _items = [];

  void values() async {
    var data = await SQLDB.searchFormulas();

    setState(() {
      _items = List.from(data);
    });
  }

  String message =
      "Vous avez atteint la limite quotidienne de recherches. Pour effectuer plus de recherches, veuillez vous abonner.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    values();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: const DrawerMenu(),
        appBar: PreferredSize(
            preferredSize: Size.copy(AppBar().preferredSize),
            child: const menuBarre(
              bottom: 'E D U   M A T H',
            ),),
        body: pages[_currentIndex],
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButton:  _currentIndex !=1? FloatingActionButton.extended(
          onPressed: () {
            if (Provider.of<ActiviterDuJour>(context, listen: false)
                        .dayActivite
                        .getNrecherche() <
                    4 ||
                Provider.of<EtatAbonnement>(context, listen: false)
                    .abonner
                    .etatAbonne) {
              Provider.of<ActiviterDuJour>(context, listen: false)
                  .dayActivite
                  .setNrecherche();
              showSearch(
                context: context,
                delegate: RechercheFormule(items: _items),
              );
            } else {
              showSubscriptionDialog(context, message);
            }
            // Navigator.push(context, MaterialPageRoute(builder: (context) =>  SubscriptionContainer(),));
          },
          elevation: 5,
          backgroundColor: Colors.blueGrey[600],
          label: const Text("Search"),
          icon: const Icon(Icons.search, size: 30, color: Colors.white),
          isExtended: true,
        ) : null ,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.blueGrey,
          animationDuration: const Duration(milliseconds: 300),
          items: items,
          onTap: _indexHome,
          buttonBackgroundColor: Colors.transparent,
          height: 50,
          index: _currentIndex,
          animationCurve: Curves.easeOutCirc,
        ),
      ),
    );
  }
}
