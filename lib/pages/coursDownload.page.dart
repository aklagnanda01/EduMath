import 'package:akla00001/abonnement/abonnement.page.dart';
import 'package:akla00001/classes/stateprovider.dart';
import 'package:akla00001/pages/drawer.pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class CoursDownload extends StatefulWidget {
  final String cours;
  final String exo;
  final String corri;
  const CoursDownload({
    required this.cours,
    required this.exo,
    required this.corri,
    Key? key,
  }) : super(key: key);

  @override
  State<CoursDownload> createState() => _CoursDownloadState();
}

class _CoursDownloadState extends State<CoursDownload> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // Restaure les préférences d'orientation par défaut

  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
      appBar:PreferredSize(preferredSize: Size.copy(AppBar().preferredSize), child: const menuBarre(bottom: 'M E S  C O U R S' ,)),
      body:  Column(
            children: [
              TabBar(tabs: [
                Tab(
                  child:  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.book_rounded,color: Colors.blue,),
                        Text("COURS",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.indigoAccent),)
                      ],
                    ),
                  ),
                ),Tab(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.border_color_outlined,color: Colors.green,),
                        Text("EXERCICES",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.indigoAccent),)
                      ],
                    ),
                  ),
                ),Tab(
                  child:  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.check,color: Colors.redAccent,),
                        Text("CORRIGÉS",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.indigoAccent),)
                      ],
                    ),
                  ),
                ),
              ]),

                Expanded(child: TabBarView(
                  children: [
                    // PDFView(
                    //   filePath: widget.file.path,
                    // ),
                  Container(
                  color: Colors.white70,
                  child:Center(
                    child: SfPdfViewer.asset("assets/${widget.cours}",
                      enableTextSelection: false,
                      scrollDirection: PdfScrollDirection.vertical,
                      pageLayoutMode: PdfPageLayoutMode.continuous,
                      pageSpacing: 20,
                    ),
                  ),
                  ),
                    Container(
                      color: Colors.white70,
                      child: Center(
                        child: SfPdfViewer.asset("assets/${widget.exo}",
                          enableTextSelection: false,
                          scrollDirection: PdfScrollDirection.vertical,
                          pageLayoutMode: PdfPageLayoutMode.continuous,
                          pageSpacing: 20,
                        ),
                      ),
                    ), Provider.of<EtatAbonnement>(context).abonner.etatAbonne ? Container(
                      color: Colors.black26,
                      child:Center(
                        child: SfPdfViewer.asset("assets/${widget.corri}",
                          enableTextSelection: false,
                          scrollDirection: PdfScrollDirection.vertical,
                          pageLayoutMode: PdfPageLayoutMode.continuous,
                          pageSpacing: 20,

                        ),
                      ),
                    ) : Container(
                      color: Colors.white70,
                      child: Center(
                        child
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Pour accéder aux corrigés des exercices, veuillez vous abonner.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const Abonnement()));
                              },
                              child: const Text(
                                "S'abonner",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    ,
                ],))


            ]),
      ),
    );
  }
}

