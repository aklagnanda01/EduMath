import 'dart:math';
import 'dart:async';
import 'package:akla00001/dataBase/sqfliteBase.dart';

class Generator {

  static Future<List<NotificationItem>> generate(
      {int min = 0, int max = 364}) async {
    bool newDay = true;
    List<NotificationItem> index = [];
    List<Map<String, dynamic>> data = await SQLDB.getDayCitation();
    List<Map<String, dynamic>> citations = List.from(data);

    DateTime dateTime ;

    DateTime now ;

    bool  difference ;

    if (citations.isEmpty) {
      newDay = true;
      difference = true;
    } else {
      now = DateTime.now();
      dateTime = DateTime.parse(citations[0]['day']);
      difference = isDayPassed(now, dateTime);
      newDay = false;
    }

    if (difference || newDay) {
      await SQLDB.deleteDayCitationSave();
      for (int i = 0; i < 3; i++) {
        final nbr = min + Random().nextInt(max - min + 1);
        List<Map<String, dynamic>> data = await SQLDB.getCitation(nbr);
        List<Map<String, dynamic>> citation = List.from(data);
        final item = NotificationItem(
            citation[0]['contenue'], citation[0]['auteur']);
        SQLDB.insertDayCitation(citation[0]['contenue'], citation[0]['auteur']);

        index.add(item);
      }
    } else{
      for (var citation in citations) {
        index.add(NotificationItem(citation['contenue'], citation['auteur']));
      }
    }
    return index;
  }

  static  Future<List<NotificationItemSave>> motivSave()async{

    List<NotificationItemSave> index = [];
    List<Map<String, dynamic>> data = await SQLDB.getCitationSave();
    List<Map<String, dynamic>> citations = List.from(data);

     if(citations.isNotEmpty){
       for(var citation in citations)
       {
         final item = NotificationItemSave(citation['contenue'], citation['auteur'],citation['createdAt'],citation['id']);
         index.add(item);
       }
     }
    return index;
  }

  static void delCitationSave (int index)async{

    await SQLDB.deleteCitationSave(index);
  }

  static void saveCitation (String contenue,String  auteur)async{

    await SQLDB.insertCitationSave(contenue,auteur);
  }

}


class NotificationItem {
  final String author;
  final String content;

  NotificationItem(this.author, this.content);
}

class NotificationItemSave{
  final int id;
  final String author;
  final String content;
  final String createAte;

  NotificationItemSave(this.author, this.content, this.createAte,this.id);
  int getId()=> id;
}

bool isDayPassed(DateTime date1, DateTime date2) {
  // Utilisez la méthode `isSameDay` de la classe DateFormat pour comparer les jours
   Duration day1 = date1.difference(date2);
   int durer = day1.inDays;

  return durer.abs() >= 1;
}