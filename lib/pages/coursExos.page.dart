import 'package:akla00001/classes/stateprovider.dart';
import 'package:akla00001/pages/drawer.pages.dart';
import 'package:flutter/material.dart';
import 'package:akla00001/classes/CoursExos.classes.dart';
import 'package:provider/provider.dart';
class CoursExos extends StatefulWidget {
  const CoursExos({Key? key}) : super(key: key);

  @override
  State<CoursExos> createState() => _CoursExosState();
}

class _CoursExosState extends State<CoursExos> {

  List<Map<String, dynamic>> _list = [];

  void _nbFonctions() async {
    var data = await Provider.of<userClass>(context,listen: false).chapitres();
    setState(() {
      _list = List.from(data);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nbFonctions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(preferredSize: Size.copy(AppBar().preferredSize), child: const menuBarre(bottom: 'M E S  C O U R S' ,)),

      body: Consumer<userClass>(
        builder: (context, value, child) =>  Center(
          child: CoursExo.produire(context, _list),
        ),
      ),
    );
  }
}
