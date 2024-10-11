import 'package:akla00001/abonnement/dialogueAbonnement.dart';
import 'package:akla00001/classes/stateprovider.dart';
import 'package:akla00001/pages/examensEpreuve.page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<CourseDocument> documents = [
  CourseDocument(
    title: "Document de Science Physique Terminale",
    description:
        "Les exercices  corrigés de physique et de chimie de la classe de Terminale.",
    lien: "anal_physique_terminalD.pdf",
  ),
  CourseDocument(
    title: "Document de Mathématique Terminale",
    description: "Exercice corrigése , epreuves corrigées de Math terminale.",
    lien: "anal_Math_terminalD.pdf",
  ),
  CourseDocument(
    title: "Document de la SVT Terminale",
    description: "Des exercices corrigés classés par chapitre.",
    lien: "svtTerminale.pdf",
  ),
  CourseDocument(
    title: "Algorithme et programmation",
    description:
        "Livre pour ceux qui désirent plus tard se lancer dans la programmation.",
    lien: "algo.pdf",
  ),
  CourseDocument(
    title: "Document pour classe de Troisième",
    description: "Des exercices corrigés classés par chapitre sous format APC.",
    lien: "doc_troisieme.pdf",
  ),
];

class CourseDocument {
  final String title;
  final String description;
  final String lien;

  CourseDocument(
      {required this.title, required this.description, required this.lien});
  Icon imageURL() => const Icon(
        Icons.menu_book_sharp,
        color: Colors.cyan,
        size: 50,
        shadows: [
          Shadow(
              color: Colors.black26,
              offset: Offset(2, 15),
              blurRadius: 50)
        ],
      );
}

Widget Livres(double taille) {
  String message =
      "Pour accéder aux corrections des épreuves, veuillez d'abord vous abonner. Merci !";

  return ListView.builder(
    itemCount: documents.length,
    itemBuilder: (context, index) {
      final document = documents[index];
      return Card(
        margin: const EdgeInsets.all(8),
        elevation: 1,
        shadowColor: Colors.black87,
        color: Colors.white,
        shape: const Border.fromBorderSide(
          BorderSide(
              width: 1,
              color: Colors.black26,
              strokeAlign: BorderSide.strokeAlignOutside),
        ),
        child: ListTile(
          onTap: () {
            if (Provider.of<EtatAbonnement>(context, listen: false)
                .abonner
                .etatAbonne) {
              Navigator.push(context, _createRoute(index));
            } else {
              showSubscriptionDialog(context, message);
            }
          },
          title: Text(
            document.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          leading: document.imageURL(),
          subtitle: Text(
            document.description,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ),
      );
    },
  );
}

PageRouteBuilder _createRoute(int index) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        DetailPage(doc: "assets/${documents[index].lien}"),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutQuart;

      var offsetAnimation = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve))
          .animate(animation);
      var scaleAnimation =
          Tween<double>(begin: 0.8, end: 1.0).animate(animation);

      return SlideTransition(
          position: offsetAnimation,
          child: ScaleTransition(
              scale: scaleAnimation,
              child: DetailPage(doc: "assets/${documents[index].lien}")));
    },
  );
}
