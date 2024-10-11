
import 'package:akla00001/pages/coursDownload.page.dart';
import 'package:flutter/material.dart';

class CoursExo{

  CoursExo();

  static Widget produire(BuildContext context, List<Map<String,dynamic>> chapitre){
    return Container(
      padding: const EdgeInsets.only(top: 5),
      foregroundDecoration: const BoxDecoration(
        color: Colors.white10,
      ),
      child: ListView.builder(
        itemCount: chapitre.length,
        itemBuilder: (context, index) {
          return  Card(
            shape: ShapeBorder.lerp(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), RoundedRectangleBorder(borderRadius: BorderRadius.circular(10,)), 10),
            elevation: 1,
            color: Colors.grey[100],
            shadowColor: Colors.blueGrey[500],
            margin: const EdgeInsets.only(top:10,left: 10,right: 10,bottom: 10),
            child: ListTile(
              onTap: () async{
                // final File file = await PDFApi.loadAsset('imgAsset/DESCRIPTION.pdf');
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CoursDownload(
                    cours: chapitre[index]['cours'],
                    exo: chapitre[index]['exercise'],
                    corri: chapitre[index]['correction'],
                  ),
                ));
              },
              title: Text(chapitre[index]['title'],style: const TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.normal,),),
              leading: const CircleAvatar(
                maxRadius: 10,
                backgroundColor: Colors.pink,

                child:Icon(Icons.functions,color: Colors.indigoAccent,size: 40,shadows: [Shadow(color:Colors.black,blurRadius: 5,offset: Offset(4,4))]),
              ),
              trailing:const Icon(Icons.chrome_reader_mode_outlined,size: 30,shadows: [Shadow(color: Colors.black26 ,blurRadius: 25,offset: Offset(2, 15),)]),
              subtitle: Text(chapitre[index]['description'],style: const TextStyle(fontSize:12,fontWeight: FontWeight.w300,color: Colors.black),),
              visualDensity: VisualDensity.comfortable,
            ),
          );
        },

      ),
    );

  }


}