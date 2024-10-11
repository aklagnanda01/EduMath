import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

//la de la recherche appeller lors du click sur le boutton de recherche de la barre de menu
class RechercheFormule extends SearchDelegate {
  List<Item> items;

  RechercheFormule({required this.items});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  Future<List<Item>> _searchItems(String query) async {

    List<Item> formulesSearch = [];

    if (query.length >= 3) {
      for (Item formule in items) {
        if (formule.getName().toLowerCase().contains(query.toLowerCase()) ||
            formule
                .getDescription()
                .toLowerCase()
                .contains(query.toLowerCase())) {
          formulesSearch.add(formule);
        }
      }
    }

    return formulesSearch;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: _searchItems(query),
      builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de progression en attendant les résultats
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Afficher un message d'erreur en cas d'erreur
          return Center(
            child: Text("Erreur: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Aucun résultat trouvé
          return const Center(
            child: Text("Aucun résultat trouvé"),
          );
        } else {
          // Afficher les résultats
          return formuleItem(elements: snapshot.data!);
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.toString().isNotEmpty && query.length >= 3) {
      return FutureBuilder<List<Item>>(
        future: _searchItems(query),
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Afficher un indicateur de progression en attendant les résultats
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Afficher un message d'erreur en cas d'erreur
            return Center(
              child: Text("Erreur: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Aucun résultat trouvé
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 60,
                    color: Colors.orange,
                  ),
                  Center(
                    child: ListTile(
                      title: Text(
                        "Aucun résultat trouvé",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        "S'il vous plaît revérifier vos entrées",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Afficher les résultats
            return formuleItem(elements: snapshot.data!);
          }
        },
      );
    } else {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 60,
              color: Colors.yellow,
            ),
            SizedBox(height: 20),
            Text(
              "Vous pouvez ici chercher des formules mathématiques ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}

//la class qui mapp les formules provenant de la base de donnee

class Item {
  final String name;
  final String formule;
  final String description;
  bool isExpanded;
  Item(
      {required this.name,
      required this.formule,
      required this.description,
      this.isExpanded = false});

  String getFormule() {
    String first = formule.replaceAll("\\(", "(");
    String second = first.replaceAll("\\)", ")");

    return second;
  }

  String getName() {
    String first = name.replaceAll("\\(", "(");
    String second = first.replaceAll("\\)", ")");
    return second;
  }

  String getDescription() {
    String first = description.replaceAll("\\(", "(");
    String second = first.replaceAll("\\)", ")");

    return second;
  }
}

//class d affichage des items
// ignore: camel_case_types, must_be_immutable
class formuleItem extends StatefulWidget {
  List<Item> elements = [];
  formuleItem({required this.elements, Key? key}) : super(key: key);

  @override
  State<formuleItem> createState() => _formuleItemState();
}

// ignore: camel_case_types
class _formuleItemState extends State<formuleItem> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        elevation: 1,
        expandedHeaderPadding: const EdgeInsets.all(0),
        initialOpenPanelValue: 0,
        // You can adjust the initial value if needed
        animationDuration: const Duration(milliseconds: 100),

        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            widget.elements[panelIndex].isExpanded = !widget.elements[panelIndex].isExpanded;
          });
        },
        children:
            widget.elements.asMap().entries.map<ExpansionPanelRadio>((entry) {
          widget.elements[0].isExpanded = true;
          final int index = entry.key;
          final Item item = entry.value;
          return ExpansionPanelRadio(
            value: index, // valeur unique pour chaque panel
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    children: [
                      Text(
                        item.getName(),
                        style: const TextStyle(shadows: [
                          Shadow(
                              color: Colors.black26,
                              blurRadius: 1,
                              offset: Offset(2, 2))
                        ]),
                      ),
                    ],
                  ),
                ),
              );
            },
            body:item.isExpanded
                ? Column(
                    children: [
                      item.getFormule().contains("\\")
                          ? ListTile(
                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child:Wrap(
                                  children: [
                                    Math.tex(
                                      item.getFormule(),
                                      textStyle: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ) ,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15),
                              child: Wrap(
                                children: [
                                  RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: item.getFormule(),
                                              style:const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54),
                                            ),
                                          ]),
                                        ),
                                ],
                              ),

                            ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: item.getDescription(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  )
                : const Text("ello"),
            canTapOnHeader: true,
          );
        }).toList(),
      ),
    );
  }
}
