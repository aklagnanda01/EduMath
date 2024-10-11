import 'package:akla00001/abonnement/dialogueAbonnement.dart';
import 'package:akla00001/classes/stateprovider.dart';
import 'package:akla00001/pages/drawer.pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ExamensPage extends StatefulWidget {
  const ExamensPage({super.key});

  @override
  State<ExamensPage> createState() => _ExamensPageState();
}

class _ExamensPageState extends State<ExamensPage> {
  List<Map<String, dynamic>> _list = [];

  void _nbFonctions() async {
    var data = await Provider.of<userClass>(context, listen: false).epreuves();
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

  String message =
      "Pour accéder aux corrections des épreuves, veuillez d'abord vous abonner. Merci !";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.copy(AppBar().preferredSize),
          child: const menuBarre(
            bottom: 'E P R E U V E S ',
          )),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (_list[index]["type"] == 1) {
                if (Provider.of<EtatAbonnement>(context, listen: false)
                    .abonner
                    .etatAbonne) {
                  Navigator.push(context, _createRoute(index));
                } else {
                  showSubscriptionDialog(context, message);
                }
              } else {
                Navigator.push(context, _createRoute(index));
              }
            },
            child: Card(
              color: Colors.black45,
              child: Center(
                child: _list[index]['type'] == 0
                    ? GridTile(
                        footer: GridTileBar(
                            title: RichText(
                              text: TextSpan(text: _list[index]['title']),
                            ),
                            backgroundColor: Colors.blueAccent),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Icon(
                            Icons.lightbulb_circle_rounded,
                            size: MediaQuery.of(context).size.width * 0.40,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : GridTile(
                        footer: GridTileBar(
                            title: RichText(
                              text: TextSpan(text: _list[index]['title']),
                            ),
                            backgroundColor: Colors.green),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Icon(
                            Icons.live_help,
                            size: MediaQuery.of(context).size.width * 0.40,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  PageRouteBuilder _createRoute(int index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DetailPage(doc: "assets/${_list[index]['lien']}"),
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
                child: DetailPage(doc: "assets/${_list[index]['lien']}")));
      },
    );
  }
}

class DetailPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final doc;
  const DetailPage({required this.doc, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.copy(AppBar().preferredSize),
          child: const menuBarre(
            bottom: 'EDU MATH',
          )),
      body: Center(
        child: SfPdfViewer.asset(
          widget.doc,
          enableTextSelection: false,
          scrollDirection: PdfScrollDirection.vertical,
          pageLayoutMode: PdfPageLayoutMode.continuous,
          pageSpacing: 20,
        ),
      ),
    );
  }
}
