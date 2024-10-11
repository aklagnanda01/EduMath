import 'package:flutter/material.dart';
import 'package:akla00001/Citation/generato.index.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Exemple de liste de notifications
  List<NotificationItem> notifications = [];
  List<NotificationItemSave> notificationsSave = [];
  Future<void> initCitation() async {
    var dataCitations = await Generator.generate();
    setState(() {
      notifications = List.from(dataCitations);
    });
  }

  Future<void> initCitationSave() async {
    var dataCitationsSave = await Generator.motivSave();
    setState(() {
      notificationsSave = List.from(dataCitationsSave);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCitation();
    initCitationSave();
  }
  bool ok = false ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

          body: DefaultTabController(
        length: 2, // Nombre d'onglets
        child: Scaffold(

          appBar: AppBar(
            title: const Text('Motivation'),
            bottom:  const TabBar(
              tabs: [
                Tab(text: 'Motivations Du Jour'),
                Tab(text: 'Motivations Enregistrées'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {

                  return
                    Card(
                      elevation: 2,
                      color: Colors.white,
                      shadowColor: Colors.black,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ' ${notifications[index].author}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0, // Taille de la police
                                color: Colors.blue, // Couleur du texte
                                fontStyle: FontStyle.italic, // Style de la police (italique)
                                letterSpacing: 1.2, // Espace entre les caractères
                                wordSpacing: 2.0, // Espace entre les mots
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 0.5,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ], // Ombre du texte
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            notifications[index].content.toString() != 'Inconnu'
                                ? Text(
                              ' ${notifications[index].content}',
                              style: const TextStyle(
                                fontSize: 18.0, // Taille de la police
                                color: Colors.black54, // Couleur du texte
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle
                                    .normal, // Style de la police (normal dans cet exemple)
                                decoration: TextDecoration.none, // Pas de décoration
                                letterSpacing: 0.5, // Espace entre les caractères
                                wordSpacing: 1.0, // Espace entre les mots
                                shadows: [
                                  Shadow(
                                    color: Colors.grey,
                                    blurRadius: 1.0,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ], // Ombre du texte
                              ),
                            )
                                : const Icon(Icons.person, color: Colors.green, size: 40),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Generator.saveCitation(notifications[index].content, notifications[index].author);
                                    setState(() {
                                      initCitationSave();
                                    });
                                  },
                                  child: const Text("Enregistrer"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                },
              ),
              ListView.builder(
                itemCount:
                    notificationsSave.isEmpty ? 1 : notificationsSave.length,
                itemBuilder: (BuildContext context, int index) {
                  return notificationsSave.isNotEmpty
                      ? Card(
                          elevation: 2,
                          color: Colors.grey[200],
                          shadowColor: Colors.black26,
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  ' ${notificationsSave[index].content}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0, // Taille de la police
                                    color: Colors.blue, // Couleur du texte
                                    fontStyle: FontStyle
                                        .italic, // Style de la police (italique)
                                    letterSpacing:
                                        1.2, // Espace entre les caractères
                                    wordSpacing: 2.0, // Espace entre les mots
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 0.5,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ], // Ombre du texte
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                notificationsSave[index].author.toString() !=
                                        'Inconnu'
                                    ? Text(
                                        ' ${notificationsSave[index].author}',
                                        style: const TextStyle(
                                          fontSize: 18.0, // Taille de la police
                                          color:
                                              Colors.black54, // Couleur du texte
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle
                                              .normal, // Style de la police (normal dans cet exemple)
                                          decoration: TextDecoration
                                              .none, // Pas de décoration
                                          letterSpacing:
                                              0.5, // Espace entre les caractères
                                          wordSpacing:
                                              1.0, // Espace entre les mots
                                          shadows: [
                                            Shadow(
                                              color: Colors.grey,
                                              blurRadius: 1.0,
                                              offset: Offset(1.0, 1.0),
                                            ),
                                          ], // Ombre du texte
                                        ),
                                      )
                                    : const Icon(Icons.person,
                                        color: Colors.green, size: 40),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      notificationsSave[index].createAte,
                                      style: const TextStyle(
                                        fontSize: 14.0, // Taille de la police
                                        color: Colors.grey, // Couleur du texte
                                        fontStyle: FontStyle
                                            .italic, // Style de la police (italique dans cet exemple)
                                        fontWeight: FontWeight
                                            .normal, // Poids de la police (normal dans cet exemple)
                                      ),
                                    ),
                                    MaterialButton(
                                        onPressed: () {
                                          Generator.delCitationSave(
                                              notificationsSave[index].getId());
                                          setState(() {
                                            notificationsSave.removeAt(index);
                                          });
                                        },
                                        color: Colors.red[200],
                                        textColor: Colors.white,
                                        elevation: 4,
                                        child: const Text(
                                          'Supprimer',
                                          style: TextStyle(fontSize: 14),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 60,
                                  color: Colors.yellow,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Aucune Citation de motivation n'a été enregistrée",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}