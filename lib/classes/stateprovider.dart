// ignore_for_file: empty_catches
import 'package:flutter/material.dart';
import 'package:akla00001/dataBase/sqfliteBase.dart';

enum ThemeModeType {
  Light,
  Dark,
}

class ThemeModel extends ChangeNotifier {

  ThemeModeType _themeMode = ThemeModeType.Dark;

  ThemeModeType get themeMode => _themeMode;

  set themeMode(ThemeModeType mode) {
    _themeMode = mode;
    notifyListeners();
  }

  ThemeMode get theme => _themeMode == ThemeModeType.Light
      ? ThemeMode.dark
      : ThemeMode.light;

}


// ignore: camel_case_types
class userClass extends ChangeNotifier{

  void updateClass(String classe){
    try{
      SQLDB.updateUserClasse(classe);
    }catch(error){

    }
    notifyListeners();
  }

  Future<int> getUserClass() async{
    int val = 0 ;
    List<Map<String,dynamic>> user = [];
    try{
      user = await SQLDB.getUser();
    }catch(error){

    }

    if(user.isNotEmpty){
      if(user[0]['classe']=='Seconde')
        {
          val =1;
        }
      else if(user[0]['classe']=='Première')
        {
          val =2;
        }
        else{
        val = 3;
      }
    }
    notifyListeners();
    return val ;
  }

  Future<bool> getUserMode() async{
    bool val = false;
    List<Map<String,dynamic>> user = [];
    try{
      user = await SQLDB.getUser();
    }catch(error){

    }

    if(user.isNotEmpty){
      if(user[0]['mode']=="light")
      {
        val = false;
      }
      else
      {
        val =true;
      }
    }
    return val ;
  }

  void updateMode(String mode){
    try{
      SQLDB.updateUserMode(mode);
    }catch(error){

    }
    notifyListeners();
  }


  Future<List<Map<String,dynamic>>> chapitres() async {


    List<Map<String,dynamic>> user = [];
    try{
      user = await SQLDB.getUser();
    }catch(error){

    }
    if(user.isEmpty) {
      return [];
    } else
    {
      return SQLDB.getChapters(user[0]['classe']);

    }

  }

  Future<List<Map<String,dynamic>>> epreuves() async {


    List<Map<String,dynamic>> user = [];
    try{
      user = await SQLDB.getUser();
    }catch(error){

    }
    if(user.isEmpty) {
      return [];
    } else
    {
      return SQLDB.getEpreuves(user[0]['classe']);
    }

  }

}

class AppState extends ChangeNotifier {
  bool isReadingModeEnabled = false;

  void toggleReadingMode(bool val) {
    isReadingModeEnabled = val;
    notifyListeners();
  }
}

class Images  extends ChangeNotifier{


  Widget drawerHeader = Image.asset('lib/images/img4.jpg',
      fit: BoxFit.cover, colorBlendMode: BlendMode.darken);

  Widget acceuilHeader = Image.asset('lib/images/img3.jpg',fit: BoxFit.cover,
  );

}


class Activiter {
  int nFonction;
  int nRecherche;
  int nQuiz1;
  int nQuiz2;
  String day;

 Activiter({required this.nFonction,required this.nQuiz1,required this.nQuiz2,required this.nRecherche, required this.day }) ;

 int getNfonction(){
   return nFonction;
 }

 int getNrecherche(){
   return nRecherche;
 }

 int getNquiz1(){
   return nQuiz1;
 }

  int getNquiz2(){
    return nQuiz2;
  }
  String  getDay(){
    return day;
  }

  void setNfonction(){
    ++nFonction;
    update();
  }

  void setNquiz1(){
    ++nQuiz1;
    update();
  }

  void setNquiz2(){
    ++nQuiz2;
    update();
  }

  void setNrecherche(){
    ++nRecherche;
    update();
  }

  void update(){
   SQLDB.updateActivite(this);
  }

}

class ActiviterDuJour extends ChangeNotifier {
   Activiter dayActivite = Activiter(nFonction: 0,nQuiz1: 0,nQuiz2: 0,nRecherche: 0 , day:  DateTime.now().toString());

   ActiviterDuJour(){
     getDayActivite();
   }
    void  getDayActivite() async {

      Activiter act = await SQLDB.searchActivity() ;

      DateTime dateTime = DateTime.parse(act.getDay()) ;

      String temps = await SQLDB.tempsDb();

      DateTime now = DateTime.parse(temps) ;

      if(now.day == dateTime.day && now.month == dateTime.month )
        {
          dayActivite = act ;
        }
      else{
        await SQLDB.updateActivite(Activiter(nFonction: 0,nQuiz1: 0,nQuiz2: 0,nRecherche: 0,day:  DateTime.now().toString()));
        dayActivite =  await SQLDB.searchActivity();
      }
  }
}

class Abonner{
  bool etatAbonne ;
  String temps ;
  Abonner({required this.etatAbonne,required this.temps});

  bool getetatAbonne(){
    return etatAbonne;
  }

   DateTime getTemps(){

    DateTime date = DateTime.parse(temps);

    return date;
  }
  void setEtatAbonne(bool bl){
    etatAbonne = bl;
  }

  void updateAbonnementState(int state) async {

    await SQLDB.updateAbonnement(state);
     setEtatAbonne(state == 0 ? false : true);
  }

}

class EtatAbonnement extends ChangeNotifier{
  Abonner abonner = Abonner(etatAbonne: false, temps: "") ;

  EtatAbonnement(){
    initAbonner();
  }

  void initAbonner() async {
    Abonner abonner1 = await SQLDB.searchAbonner();

    String time = await SQLDB.tempsDb();

    DateTime now = DateTime.parse(time);

    int durer = (abonner1.getTemps().add( const Duration(days: 45))).compareTo(now);

    bool ok =  durer == 1 ? true : false;

    if( abonner1.getetatAbonne() && ok ){
      abonner = abonner1;
    }
    else{
        abonner1.updateAbonnementState(0);

       abonner = await SQLDB.searchAbonner();
    }
  }

}

class CodeAbonnement extends ChangeNotifier{
  String dayCode ="";

  CodeAbonnement()
  {
     initCode();
  }

  void initCode() async {
     String jour = await SQLDB.tempsDb();
     DateTime time = DateTime.parse(jour);
      int day = time.day;
      int month = time.month;
      int year = time.year;

      String c = (day % 15).toString();

     Map<String, Map<String, String>> dics = {
       "0": {
         "0": "g1",
         "1": "jj",
         "2": "3f",
         "3": "2h",
         "4": "sh",
         "5": "Ma",
         "6": "a6",
         "7": "Sw",
         "8": "wJ",
         "9": "3r",
         "10": "bv",
         "11": "d9",
         "12": "eu",
         "13": "r5",
         "14": "xZ"
       },
       "1": {
         "0": "r7",
         "1": "Gq",
         "2": "fT",
         "3": "4y",
         "4": "Ps",
         "5": "4k",
         "6": "mN",
         "7": "1d",
         "8": "k2",
         "9": "Jk",
         "10": "zw",
         "11": "6t",
         "12": "s5",
         "13": "mr",
         "14": "j8"
       },
       "2": {
         "0": "tY",
         "1": "p6",
         "2": "a7",
         "3": "Ak",
         "4": "gH",
         "5": "3p",
         "6": "cV",
         "7": "9e",
         "8": "eW",
         "9": "2z",
         "10": "uF",
         "11": "5h",
         "12": "uI",
         "13": "5a",
         "14": "bT"
       },
       "3": {
         "0": "nB",
         "1": "q2",
         "2": "qV",
         "3": "w3",
         "4": "kL",
         "5": "4e",
         "6": "dF",
         "7": "6r",
         "8": "wX",
         "9": "7y",
         "10": "vX",
         "11": "9p",
         "12": "eR",
         "13": "1d",
         "14": "zC"
       },
       "4": {
         "0": "oP",
         "1": "5t",
         "2": "yH",
         "3": "2q",
         "4": "sQ",
         "5": "4r",
         "6": "gT",
         "7": "9e",
         "8": "lK",
         "9": "1s",
         "10": "sB",
         "11": "1v",
         "12": "vB",
         "13": "7x",
         "14": "xZ"
       },
       "5": {
         "0": "fG",
         "1": "9h",
         "2": "iJ",
         "3": "5p",
         "4": "xN",
         "5": "6m",
         "6": "hU",
         "7": "2i",
         "8": "aY",
         "9": "3r",
         "10": "qT",
         "11": "4p",
         "12": "pW",
         "13": "7r",
         "14": "rM"
       },
       "6": {
         "0": "cN",
         "1": "zq",
         "2": "iH",
         "3": "Gm",
         "4": "Tk",
         "5": "kL",
         "6": "Ur",
         "7": "iy",
         "8": "qS",
         "9": "ae",
         "10": "aE",
         "11": "wT",
         "12": "qr",
         "13": "uP",
         "14": "vY"
       },
       "7": {
         "0": "mB",
         "1": "A2",
         "2": "wV",
         "3": "k3",
         "4": "vQ",
         "5": "pL",
         "6": "sF",
         "7": "6r",
         "8": "mX",
         "9": "7y",
         "10": "jX",
         "11": "kR",
         "12": "zG",
         "13": "1w",
         "14": "eC"
       },
       "8": {
         "0": "cG",
         "1": "5n",
         "2": "sJ",
         "3": "9q",
         "4": "yW",
         "5": "pN",
         "6": "zU",
         "7": "4h",
         "8": "rY",
         "9": "wL",
         "10": "dA",
         "11": "pD",
         "12": "iO",
         "13": "1d",
         "14": "tZ"
       },
       "9": {
         "0": "lB",
         "1": "vC",
         "2": "cM",
         "3": "qF",
         "4": "zI",
         "5": "yV",
         "6": "bH",
         "7": "mE",
         "8": "nS",
         "9": "lG",
         "10": "aU",
         "11": "rK",
         "12": "zP",
         "13": "6o",
         "14": "pL"
       },
       "10": {
         "0": "gD",
         "1": "5q",
         "2": "sT",
         "3": "wN",
         "4": "9g",
         "5": "uY",
         "6": "eF",
         "7": "dZ",
         "8": "fR",
         "9": "2k",
         "10": "hO",
         "11": "lV",
         "12": "oU",
         "13": "tM",
         "14": "1v"
       },
       "11": {
         "0": "cA",
         "1": "rX",
         "2": "tK",
         "3": "2l",
         "4": "uG",
         "5": "8t",
         "6": "vH",
         "7": "7z",
         "8": "jF",
         "9": "oN",
         "10": "qW",
         "11": "pJ",
         "12": "mV",
         "13": "zS",
         "14": "4p"
       },
       "12": {
         "0": "sC",
         "1": "nO",
         "2": "5a",
         "3": "hW",
         "4": "rJ",
         "5": "iU",
         "6": "yE",
         "7": "fV",
         "8": "7k",
         "9": "eB",
         "10": "gQ",
         "11": "tD",
         "12": "xI",
         "13": "mL",
         "14": "zX"
       },
       "13": {
         "0": "bK",
         "1": "1u",
         "2": "oG",
         "3": "vZ",
         "4": "lA",
         "5": "wQ",
         "6": "pP",
         "7": "nH",
         "8": "cT",
         "9": "kR",
         "10": "tN",
         "11": "5v",
         "12": "yS",
         "13": "gC",
         "14": "9b"
       },
       "14": {
         "0": "mU",
         "1": "pG",
         "2": "oX",
         "3": "cD",
         "4": "lZ",
         "5": "iV",
         "6": "aH",
         "7": "6f",
         "8": "eA",
         "9": "wO",
         "10": "yT",
         "11": "8p",
         "12": "jL",
         "13": "sI",
         "14": "tQ"
       }
     };


     String code = "";
      String date = day.toString() + month.toString() + year.toString();

      for (int i = 0; i < date.length; i++) {
        code += dics[c]![date[i]]!;
      }
     dayCode = code;

  }


}

