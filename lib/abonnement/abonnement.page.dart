
import 'package:akla00001/classes/stateprovider.dart';
import 'package:akla00001/pages/drawer.pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:sim_data_plus/sim_data.dart';
import 'package:telephony/telephony.dart';

double prix = 1000;

class Abonnement extends StatefulWidget {
  const Abonnement({Key? key}) : super(key: key);

  @override
  State<Abonnement> createState() => _AbonnementState();
}

class _AbonnementState extends State<Abonnement> {
  int selectedValue = 0;
  String code = "\$";
  late SimData simData;
  @override
  void initState() {
    super.initState();
    code = Provider.of<CodeAbonnement>(context, listen: false).dayCode;
    subscribId2();
    // Activez l'écoute des SMS
  }
  void showProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche la fermeture du dialogue en cliquant à l'extérieur
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(), // Cercle de progression
              SizedBox(height: 16.0), // Espacement
              Text("Patienter, abonnement en cours, ne quittez pas",textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  }
  void handleIncomingSms(SmsMessage message) {
      Navigator.of(context).pop();
      String? sms = message.body;
      if (sms != null) {
       if(message.address!.toLowerCase().contains("tmoney") || message.address!.toLowerCase().contains("flooz")){
         if ((sms.toLowerCase().contains(prix.toString()) ||
             sms.toLowerCase().contains("1,000") ||
             sms.toLowerCase().contains("1.000") ||
             sms.toLowerCase().contains("1.000") ||
             sms.toLowerCase().contains("envoyé") ||
             sms.toLowerCase().contains("envoye") ||
             sms.toLowerCase().contains("reussi") ||
             sms.toLowerCase().contains("reussie"))) {
           done();
           _cnt.clear();
           // ignore: use_build_context_synchronously
           //Navigator.of(context).pop();
           showErrorDialog("Abonnement effectué avec succès");
         } else {
           showErrorDialog( "Erreur, abonnement non effectué, contactez-nous si vous avez eu un problème d'abonnement");
         }
       }
      } else {
        // ignore: use_build_context_synchronously
        //Navigator.of(context).pop();
        showErrorDialog(
            "Erreur, abonnement non effectué, contactez-nous si vous avez eu un problème d'abonnement"   );   }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController _cnt = TextEditingController();

  void showPassword(String errorMessage, int index, int subcriid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Saisissez votre ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: ' code de sécurité $errorMessage',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const TextSpan(
                      text: ' pour votre Abonnement à Edu_Math ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    const TextSpan(
                      text: '\nMontant : 1 000 fcfa ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.pink),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextFormField(
                  controller: _cnt,
                ),
              ),
            ]),
          ),
          actions: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ANNULER',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_cnt.text.isNotEmpty) {
                      if (simData.cards.length == 2) {
                        abonnementEffectuer(index, _cnt.text,
                            subcribId: subcriid);
                      } else {
                        abonnementEffectuer(index, _cnt.text);
                      }
                    } else {
                      return;
                    }
                  },
                  child: const Text(
                    'ENVOYER',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void subscribId2() async {
    try {
      simData = await SimDataPlugin.getSimData();
    } on PlatformException catch (_) {
      showErrorDialog(
          "Une erreur inattendue a été rencontrée. Veuillez réessayer ultérieurement.");
    }
  }

  Future<void> subscribId(int index) async {
    int Id =-1 ;
    try {
      if (simData.cards.length == 2 &&
          ((simData.cards[0].carrierName.toLowerCase() == "moov" &&
                  simData.cards[1].carrierName.toLowerCase() == "moov") ||
              (simData.cards[0].carrierName.toLowerCase() == "togocel" &&
                  simData.cards[1].carrierName.toLowerCase() == "togocel"))) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sélectionner la carte sim"),
              content: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  ListTile(
                    title: Text(simData.cards[0].displayName,
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                    onTap: () {
                      Id = simData.cards[0].subscriptionId!;
                      Navigator.of(context).pop();
                      if(index==1) {
                        showPassword("Moov", 1, Id);
                      }else{
                        showPassword("Tmoney", 2, Id);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(simData.cards[1].displayName,
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                    onTap: () {
                      Id = simData.cards[0].subscriptionId!;
                      Navigator.of(context).pop();
                      if(index==1) {
                        showPassword("Moov", 1, Id);
                      }else{
                        showPassword("Tmoney", 2, Id);
                      }

                    },
                  ),
                ]),
              ),
            );
          },
        );
      } else {
        for (var s in simData.cards) {
          if (index == 1) {
            if (s.carrierName.toLowerCase() == "moov") {
              Id = s.subscriptionId!;
              break;
            }
          } else {
            if (s.carrierName.toLowerCase() == "togocel") {
              Id = s.subscriptionId!;
              break;
            }
          }
        }
        if(index==1) {
          showPassword("Moov", 1, Id);
        }else{
          showPassword("Tmoney", 2, Id);
        }
      }
    } on PlatformException catch (_) {
      showErrorDialog(
          "Une erreur inattendue a été rencontrée. Veuillez réessayer ultérieurement.");
    }
  }

  void abonnementEffectuer(int index, String code, {int subcribId = -1}) async {
    Navigator.of(context).pop();
      showProgressDialog() ;

    Telephony.instance.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        handleIncomingSms(message); //  Appel de la fonction de gestion des SMS
      },
    );
    if (index == 1) {
       await UssdAdvanced.sendAdvancedUssd(
          code: "*155*1*1*96894697*${prix.toInt().toString()}*1*$code#",
          subscriptionId: subcribId);

    } else {
      await UssdAdvanced.sendAdvancedUssd(
          code: "*145*1*${prix.toInt().toString()}*93202676*2*1*$code#",
          subscriptionId: subcribId);

    }
    //
    // if (res!.isNotEmpty && res.length>2 )  {
    //   if ((res.toLowerCase().contains(prix.toString()) ||
    //       res.toLowerCase().contains("1,000") ||
    //       res.toLowerCase().contains("1.000") ||
    //       res.toLowerCase().contains("1000") ||
    //       res.toLowerCase().contains("envoyé") ||
    //       res.toLowerCase().contains("envoye") ||
    //       res.toLowerCase().contains("reussi") ||
    //       res.toLowerCase().contains("reussie"))) {
    //     done();
    //     showErrorDialog("Abonnement effectué avec succès");
    //   } else {
    //     showErrorDialog("Erreur , abonnement non effectué");
    //   }
    // } else {
    //   showErrorDialog("Erreur , abonnement non effectué");
    // }
  }

  void done() {
    Provider.of<EtatAbonnement>(context, listen: false)
        .abonner
        .updateAbonnementState(1);
  }

  void _showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text("Veuillez sélectionner d'abord votre opérateur réseau."),
        duration: const Duration(seconds: 2),
        elevation: 10,
        backgroundColor: Colors.redAccent, // Couleur d'arrière-plan
        behavior: SnackBarBehavior.floating, // Comportement du SnackBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Forme des coins
        ),
      ),
    );
  }

  //Animation of the dialogue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('Abonnement Mobile'),
        backgroundColor: Colors.blue, // Couleur de la barre d'applications
        bottom: PreferredSize(
          preferredSize: Size.copy(const Size.fromHeight(20)),
          child: const Text(
            'Pour un accès illimité ',
            style: TextStyle(
              fontSize: 18.0, // Taille de la police du titre
              fontWeight: FontWeight.w700, // Texte en gras
              color: Colors.white, // Couleur du texte
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RadioListTile(
                    title: const Text('Tmoney'),
                    value: 2,
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    secondary: const Icon(
                      Icons.monetization_on_outlined,
                      size: 25,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  RadioListTile(
                    title: const Text('Flooz'),
                    value: 1,
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    secondary: const Icon(
                      Icons.monetization_on_outlined,
                      size: 25,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child: Text(
                      'Ou ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue, // Couleur de l'arrière-plan du bouton
                      borderRadius: BorderRadius.circular(10), // Coins arrondis
                    ),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String textFieldValue = "";

                            return AlertDialog(
                              title: const Text(
                                'Entrez le code d\'abonnement ',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: TextField(
                                onChanged: (value) {
                                  textFieldValue = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Entrez le code ...',
                                  labelStyle: TextStyle(
                                    color: Colors.green,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      child: const Text(
                                        'Annuler',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'Confirmer',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        // Navigator.of(context).pop(); // Fermez la première boîte de dialogue

                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 16.0),
                                                  Text(
                                                      'Vérification en cours...'),
                                                ],
                                              ),
                                            );
                                          },
                                        );

                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          Navigator.of(context)
                                              .pop(); // Fermez le deuxième dialogue

                                          if (textFieldValue.isNotEmpty &&
                                              textFieldValue == code) {
                                            done();
                                            //
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: const Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        maxRadius: 50,
                                                        backgroundColor:
                                                            Colors.blue,
                                                        child: Icon(
                                                          Icons.done,
                                                          color: Colors.white,
                                                          size: 50,
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.0),
                                                      Text(
                                                        'Abonnement effectué avec succès ...',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text("Ok"))
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: const Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.close,
                                                        color:
                                                            Colors.deepOrange,
                                                        size: 40,
                                                      ),
                                                      SizedBox(height: 8.0),
                                                      Text(
                                                        'Echec d\'abonnement vérifier votre code ou contactez-nous ...',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .pinkAccent),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Fermer"))
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Saisir un code D\'abonnement ',
                        style: TextStyle(
                          color: Colors.white, // Couleur du texte
                          fontSize: 18, // Taille du texte
                          fontWeight: FontWeight.bold, // Poids de la police
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 20.0,
                  left: 20,
                  top: 20,
                  bottom: 10), // Espacement autour des éléments
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Votre mot de passe  Flooz ou Tmoney vous sera demandez pour confirmer l\'opération de transfert',
                    style:
                        TextStyle(fontSize: 14.0, color: Colors.blueGrey),
                    textAlign: TextAlign.center,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: [
                        const Text(
                            "En payant vous nous encouragez à améliorer d'avantage l'application pour vous ",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            color: Colors.indigo,
                            child: Center(
                                child: Text(
                              prix.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            )),
                          ),
                        ),
                        const Text(

                            "Si vous avez des problèmes lors du payement contactez-nous sur ",
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: 15, color: Colors.blueGrey)),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("96894697 /93202676 ",
                            style: TextStyle(fontSize: 17, color: Colors.grey),
                            textAlign: TextAlign.center),
                        GestureDetector(
                          onTap: (){
                            launchURL("https://wa.me/+22893202676");
                          },
                          child: Card(
                            elevation: 1,
                            shadowColor: Colors.black45,
                            color: Colors.blueAccent[200],
                            child:  const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Contactez-nous ',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(50)),
          child: TextButton(
            onPressed: (selectedValue != 0)
                ? (selectedValue == 1
                    ? () async {
                         (await subscribId(1)) ;
                      }
                    : () async {
                         (await subscribId(2));
                      })
                : () {
                    _showSnack();
                  },
            child: const Text(
              "P A Y E R",
              style: TextStyle(fontSize: 18, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
