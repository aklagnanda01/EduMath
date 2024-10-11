import 'package:akla00001/Citation/todayCitation.page.dart';
import 'package:akla00001/abonnement/dialogueAbonnement.dart';
import 'package:akla00001/classes/stateprovider.dart';
import 'package:akla00001/constants/constant.dart';
import 'package:akla00001/pages/page.recherche.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:share/share.dart';
import 'package:akla00001/dataBase/sqfliteBase.dart';
class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool mode = false;
  int selected = 0;
  void showdialog() async {
    selected =
        await Provider.of<userClass>(context, listen: false).getUserClass();
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text("Selectionner Votre Classe"),
            contentPadding: const EdgeInsets.all(10),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                      RadioListTile(
                        title: const Text(
                          "Seconde ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        secondary: Icon(
                          Icons.school_sharp,
                          color: Colors.purpleAccent[100],
                        ),
                        activeColor: Colors.teal,
                        value: 1,
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text(
                          "Première ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        secondary: Icon(
                          Icons.school_sharp,
                          color: Colors.purpleAccent[100],
                        ),
                        activeColor: Colors.teal,
                        value: 2,
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text(
                          "Terminale ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        secondary: Icon(
                          Icons.school_sharp,
                          color: Colors.purpleAccent[100],
                        ),
                        activeColor: Colors.teal,
                        value: 3,
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                      ),
                  // Add more RadioListTile widgets for other classes if needed
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    String? clss;
                    Navigator.of(context).pop();
                    if (selected == 1) {
                      clss = 'Seconde';
                    } else {
                      clss = selected == 2 ? 'Première' : 'Terminale';
                    }

                    Provider.of<userClass>(context, listen: false)
                        .updateClass(clss);
                  },
                  child: const Text("Ok"))
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    mode =
        Provider.of<ThemeModel>(context, listen: false).theme == ThemeMode.dark;
    return Drawer(
      width: MediaQuery.of(context).size.width * .70,
      elevation: 5,
      backgroundColor: Colors.white70,
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.white70,
        child: ListView(
          children: [
            DrawerHeader(
              margin: const EdgeInsets.only(bottom: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 1,
                      offset: Offset(1, 1),
                      blurRadius: 1)
                ],
              ),
              child: Provider.of<Images>(context).drawerHeader,
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              title: const Text(
                "COURS ET EXOS",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              leading: const Icon(
                Icons.menu_book,
                size: 20,
                color: Colors.deepPurple,
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/CoursExos');
              },
            ),
            const Divider(
              height: 10,
              color: Colors.black12,
            ),
            ListTile(
              title: const Text(
                "EXAMENS ",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              leading: const Icon(
                Icons.school,
                size: 20,
                color: Colors.deepPurple,
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/examens');
              },
            ),
            const Divider(
              height: 5,
              color: Colors.black12,
            ),
            ListTile(
              title: const Text(
                "LES FONCTIONS ",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              leading: const Icon(
                Icons.auto_graph,
                size: 20,
                color: Colors.deepPurple,
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/function');
              },
            ),
            const Divider(
              height: 10,
              color: Colors.black12,
            ),
            ListTile(
              title: const Text(
                "QUIZ MATH",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              leading: const Icon(
                Icons.question_mark,
                size: 20,
                color: Colors.deepPurple,
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/quiz');
              },
            ),
            const Divider(
              height: 4,
              color: Colors.black12,
            ),
            ListTile(
              title: const Text(
                "A PROPOS",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              leading: const Icon(
                Icons.perm_device_information_outlined,
                size: 20,
                color: Colors.deepPurple,
              ),
              onTap: () {
                Navigator.of(context).pushNamed("/about");
              },
            ),
            const Divider(
              height: 4,
              color: Colors.black12,
            ),
            ListTile(
              title: const Text(
                "Abonnement",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              leading: const Icon(
                Icons.monetization_on_outlined,
                size: 20,
                color: Colors.deepPurple,
              ),
              onTap: () {
                Navigator.of(context).pushNamed("/abonnement");
              },
            ),
            const Divider(
              height: 4,
              color: Colors.black38,
            ),
            Column(
              children: [
                const ListTile(
                  title: Text(
                    "PARAMÉTRES",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black38),
                  ),
                  onTap: null,
                ),
                ListTile(
                  title: const Text(
                    "Votre Classe",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                  leading: Icon(Icons.change_circle_outlined,
                      color: Colors.indigo[300]),
                  onTap: () {
                    showdialog();
                  },
                ),
                Consumer<AppState>(
                  builder: (context, appState, child) {
                    return SwitchListTile(
                      title: const Text(" Mode Apprentissage",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue)),
                      activeTrackColor: Colors.lightBlue,
                      activeColor: Colors.white70,
                      value: Provider.of<AppState>(context, listen: false)
                          .isReadingModeEnabled,
                      onChanged: (value) {
                        Provider.of<AppState>(context, listen: false)
                            .toggleReadingMode(value);
                        Provider.of<AppState>(context, listen: false)
                                .isReadingModeEnabled
                            ? VolumeController().setVolume(0.0)
                            : VolumeController().setVolume(0.6);
                      },
                    );
                  },
                ),
                SwitchListTile(
                  title: const Text("Mode",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue)),
                  activeTrackColor: Colors.lightBlue,
                  activeColor: Colors.white70,
                  secondary: mode
                      ? Icon(
                          Icons.nightlight_rounded,
                          color: Colors.indigo[300],
                        )
                      : Icon(
                          Icons.light_mode,
                          color: Colors.indigo[300],
                        ),
                  value: mode,
                  onChanged: (value) {
                    if (mode) {
                      Provider.of<userClass>(context, listen: false)
                          .updateMode("dart");
                    } else {
                      Provider.of<userClass>(context, listen: false)
                          .updateMode("light");
                    }
                    setState(() {
                      mode = value;
                    });
                    ThemeModel themeModel =
                        Provider.of<ThemeModel>(context, listen: false);
                    themeModel.themeMode =
                        themeModel.themeMode == ThemeModeType.Light
                            ? ThemeModeType.Dark
                            : ThemeModeType.Light;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class menuBarre extends StatefulWidget {
  final String bottom;
  const menuBarre({required this.bottom, Key? key}) : super(key: key);

  @override
  State<menuBarre> createState() => _menuBarreState();
}

// ignore: camel_case_types
class _menuBarreState extends State<menuBarre> {
  void _shareApp() {
    const String text =
        "Découvrez cette superbe application de Math ! Voici le lien : https://t.me/eduboost_tg";
    Share.share(
        text); // Utilisation de la méthode Share.share pour ouvrir le menu d'intention
  }

  List<Item> _items = [];

  void values() async {
    var data = await SQLDB.searchFormulas();

    setState(() {
      _items = List.from(data);
    });
  }
  String message = "Vous avez atteint la limite quotidienne de recherches. Pour effectuer plus de recherches, veuillez vous abonner.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    values();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SingleChildScrollView(scrollDirection: Axis.vertical,child: Text(widget.bottom.toString(),)),
      titleTextStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          fontFamily: AutofillHints.nickname,
          fontStyle: FontStyle.italic,
          color: Colors.white),
      centerTitle: true,
      backgroundColor: primary,
      elevation: 10,
      actions: [
        InkWell(
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NotificationPage();
          },),);

        } ,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child:  Stack(

                alignment: Alignment.center,
                children: [
                Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton(

                itemBuilder: (context) => [
                  // ignore: prefer_const_constructors
                  PopupMenuItem(
                    child: ListTile(
                      title: const Text("Share"),
                      leading: const Icon(Icons.share),
                      onTap: () {
                        _shareApp();
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      title: const Text("A propos de nous"),
                      leading:
                          const Icon(Icons.perm_device_information_outlined),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Ajoutez d'autres éléments de menu ici si nécessaire
                ],
                padding: const EdgeInsets.all(0),
                elevation: 1,
                shape: Border(bottom: BorderSide(width: 1,color: Colors.green)),
                child: const Icon(
                  Icons.more_vert,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text('A propos de nous'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Version : 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Créé par : ',
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    launchURL(
                        'https://www.facebook.com/profile.php?id=100091276988095');
                  },
                  child: const Text(
                    ' BitMaster ',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        decorationStyle: TextDecorationStyle.solid),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Copyright © 2023 Tous droits réservés',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

void launchURL(String url) async {

  if (await launchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Impossible d\'ouvrir l\'URL : $url';
  }
}


