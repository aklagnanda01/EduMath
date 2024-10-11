// ignore_for_file: empty_catches
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'package:akla00001/pages/createCompte.page.dart';
import 'package:flutter/material.dart';
import 'package:akla00001/pages/accueil.page.dart';
import 'package:akla00001/dataBase/sqfliteBase.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Map<String,dynamic>> classFetched=[];

  Future<void> _demanderAutorisations() async {
    final statusSMS = await Permission.sms.request();
    final statusPhone = await Permission.phone.request();

    if (statusSMS.isGranted && statusPhone.isGranted) {
      _initApp();

      // Les autorisations ont été accordées, vous pouvez maintenant accéder aux SMS et au téléphone.
    } else {
      _demanderAutorisations();
    }
  }

  @override
  void initState() {
    super.initState();
    _demanderAutorisations();
  }

  void _initApp() async {
    // Effectuez la requête pour récupérer la classe depuis SQLite
    try{
      classFetched = await SQLDB.getUser();
    }catch(e){

    }


       if (classFetched.isNotEmpty) {
         Timer(const Duration(milliseconds: 1500), () {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Accueil()));
         });
       } else{
         Timer(const Duration(seconds:1), () {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
         });
       }


   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            const SizedBox(height: 20,),
            Column(
              children: [
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      maxRadius: 50,
                      backgroundColor: Colors.pink,

                      child:Icon(Icons.functions,color: Colors.indigoAccent,size: 250,shadows: [Shadow(color:Colors.black,blurRadius: 5,offset: Offset(4,4))]),
                    ),
                  ],
                ),
                const SizedBox(height: 120,),
                const Text("Lancement en cours ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: Colors.black45),),
                const SizedBox(height: 20,),
                CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                  backgroundColor: Colors.green[100],
                  strokeWidth: 5,

                ), //
              ],
            )
          ],
        ),
      ),
    );
  }
}
