// ignore_for_file: camel_case_types

import 'package:akla00001/pages/drawer.pages.dart';
import 'package:flutter/material.dart';

class about extends StatelessWidget {
  const about({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar:PreferredSize(preferredSize: Size.copy(AppBar().preferredSize), child: const  menuBarre(bottom: "A  P R O P O S",)),
      body: Center(
        child:
            Container(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: 'À Propos d\'EDU Math : ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Votre Compagnon Mathématique Complet !\n\n',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: 'Bienvenue dans EDU Math, votre allié en mathématiques pour les classes de terminale première et seconde, ainsi que pour la classe de troisième. Notre application a été conçue pour aider les lycéens à améliorer leurs compétences en mathématiques tout en rendant l\'apprentissage agréable et accessible.\n\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Notre Objectif : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Nous sommes déterminés à rendre les mathématiques passionnantes et enrichissantes pour tous les lycéens. Que vous soyez un élève en quête de clarté sur les concepts, un fervent de mathématiques ou quelqu\'un cherchant simplement à obtenir de meilleurs résultats, EDU Math est là pour vous soutenir.\n\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Fonctionnalités Principales :\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '• Tracer des Fonctions Mathématiques : Exprimez-vous graphiquement en créant et en explorant des fonctions mathématiques à l\'aide de notre clavier spécialisé. Voyez instantanément comment différentes équations se traduisent en graphiques.\n\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '• Cours, Exercices et Corrections : Accédez à des cours complets pour chaque niveau, des exercices pratiques conçus pour renforcer votre compréhension et des corrections détaillées pour éclairer vos chemins vers la maîtrise.\n\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '• Quiz Dynamiques : Mettez vos connaissances à l\'épreuve avec nos quiz interactifs. Des questions variées vous permettront de tester vos compétences, de consolider votre compréhension et d\'identifier vos domaines de croissance.\n\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: '• Examens Antérieurs : Préparez-vous pour les examens avec une vaste collection d\'examens antérieurs. Explorez les formats de questions, découvrez les tendances et entraînez-vous à gérer le temps.\n\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Notre Engagement :\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'EDU Math s\'engage à fournir une ressource éducative gratuite de haute qualité aux étudiants. Nous croyons en l\'émancipation par l\'éducation et nous efforçons de créer une expérience d\'apprentissage mathématique qui inspire la confiance et la réussite.\n\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Contactez-Nous :\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Pour toute question, suggestion ou support, n\'hésitez pas à nous contacter par le lien en bas . Nous sommes là pour vous aider dans votre voyage mathématique.\n\n',
                            style: TextStyle(fontSize: 16),
                          ),

                          TextSpan(
                            text: 'Politique de Confidentialité et Conditions d\'Utilisation :\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Pour garantir la transparence et la confiance dans notre engagement envers les utilisateurs, nous vous invitons à consulter notre Politique de Confidentialité et nos Conditions d\'Utilisation en cliquant sur les liens ci-dessous :\n\n',
                            style: TextStyle(fontSize: 16),
                          ),
                          // ... Ajoutez les liens ici ...
                          TextSpan(
                            text: 'Remerciements :\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Nous tenons à exprimer notre profonde gratitude envers nos utilisateurs dévoués, nos contributeurs passionnés et nos testeurs bêta qui ont contribué à façonner et à améliorer EDU Math. Votre engagement et votre feedback sont les piliers de notre succès, et nous sommes reconnaissants de faire partie de votre parcours d\'apprentissage en mathématiques.',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                           text: '\n\nCopyright © 2023 Tous droits réservés\n',
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color: Colors.blueGrey,),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        launchURL('https://www.facebook.com/profile.php?id=100091276988095');
                      },
                      child: const Text(
                        ' BitMaster',
                        style: TextStyle(fontSize: 20,color: Colors.blue,decorationStyle: TextDecorationStyle.solid),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
                ,
              ),
            ),
      ),
    );
  }
}
