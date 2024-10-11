import 'package:flutter/material.dart';
import 'dart:async';
void showHelpDialog (BuildContext context){
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: Colors.white24,
      contentPadding: const EdgeInsets.all(10),
      contentTextStyle: const TextStyle(fontSize: 20),
      title: const ListTile( leading: Icon(Icons.help_outline_rounded,color: Colors.white,size: 40,), title:  Text("AIDE D'UTILISATION",style: TextStyle(textBaseline: TextBaseline.ideographic,fontSize: 25,decoration: TextDecoration.underline,color: Colors.lightBlueAccent),)),
      content:  SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: const [
              TextSpan(
                text: 'Bienvenue dans EDU Math : ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Votre Créateur de Fonctions Mathématiques Personnel !\n\n',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: 'Création Simplifiée : ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                'EDU Math vous permet de donner vie à vos idées mathématiques en un instant. Utilisez notre clavier spécialisé pour créer jusqu\'à trois fonctions différentes et uniques. Chaque touche est conçue pour vous aider à composer sans tracas.\n\n',
                style: TextStyle(fontSize: 16),
              ),
              TextSpan(
                text: 'Validation en Temps Réel : ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                'Lorsque vous créez une fonction, notre validation en temps réel garantit sa précision. Si la fonction est correcte, elle se trace automatiquement sur le graphique. Sinon, aucune trace n\'apparaît, ce qui vous aide à éviter les erreurs.\n\n',
                style: TextStyle(fontSize: 16),
              ),
              TextSpan(
                text: 'Historique à Portée de Main : ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                'Accédez à l\'historique pour revoir vos fonctions tracées. Cliquez simplement sur une fonction pour la voir à nouveau sur le graphique. Pour supprimer, un simple clic sur l\'icône de la poubelle à gauche suffit.\n\n',
                style: TextStyle(fontSize: 16),
              ),
              TextSpan(
                text: 'Découvrez les Dérivées : ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                'Les dérivées de chaque fonction sont calculées et affichées en bas du repère. Souvenez-vous,' ,
                  style: TextStyle(fontSize: 16),),

            TextSpan(
              text: 'elles ne sont pas simplifiées automatiquement. ',
              style: TextStyle(
                decorationStyle: TextDecorationStyle.solid,
                color: Colors.lightBlueAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text:'C\'est une opportunité pour vous d\'approfondir votre compréhension mathématique.\n\n',
              style: TextStyle(
                fontSize: 16,
              ),
            ),


              TextSpan(
                text: 'Ce n\'est pas parce que les choses sont difficiles que nous n\'osons pas,',
              ),
              TextSpan(
                text: ' c\'est parce que nous n\'osons pas qu\'elles sont difficiles.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),


        actions: [
        TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },

            child: const Text("Fermer",style: TextStyle(color: Colors.white),))
      ],
    );}
    ,);
}

void showSuccessBottomSheet(BuildContext context,String text,IconData icon) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      Timer(const Duration(milliseconds: 800), () {
        Navigator.of(context).pop(); // Ferme automatiquement le BottomSheet après 2 secondes
      });

      return Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:  <Widget>[
             Icon(icon, color: Colors.green, size: 40),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height:5),
          ],
        ),
      );
    },
  );
}
