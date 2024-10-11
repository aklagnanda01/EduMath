import 'package:akla00001/classes/stateprovider.dart';
import 'package:akla00001/pages/livre.pages.dart';
import 'package:akla00001/pages/page/chatBotPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class livres extends StatefulWidget {
  const livres({Key? key}) : super(key: key);

  @override
  State<livres> createState() => _livresState();
}

class _livresState extends State<livres> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipPath(
              clipper: MyDesign(),
              child: Container(

                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        spreadRadius: 5,
                        offset: Offset(2, 2),
                        blurRadius: 5)
                  ],
                ),
                child: GridTile(
                  footer: Container(
                    height: 25,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(112, 38, 33, 33),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        ("p r a c t i c e  m a k e s  p e r f e c t")
                            .toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ),
                  ),
                  child: Provider.of<Images>(context).acceuilHeader,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // margin: const EdgeInsets.symmetric( vertical: 15),
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/CoursExos');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size:
                                        MediaQuery.of(context).size.width * 0.3,
                                    shadows: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 0,
                                        spreadRadius: 5,
                                        blurStyle: BlurStyle.outer,
                                      )
                                    ],
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    "COURS ET EXOS",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/examens');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.school,
                                    size:
                                        MediaQuery.of(context).size.width * 0.3,
                                    shadows: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 0,
                                        spreadRadius: 5,
                                        blurStyle: BlurStyle.outer,
                                      )
                                    ],
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    "EXAMENS ANTÉRIEURS",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/function');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.auto_graph_outlined,
                                    size:
                                        MediaQuery.of(context).size.width * 0.3,
                                    shadows: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 0,
                                        spreadRadius: 5,
                                        blurStyle: BlurStyle.outer,
                                      )
                                    ],
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    "ETUDE FONCTION",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/quiz');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.question_mark,
                                    size:
                                        MediaQuery.of(context).size.width * 0.3,
                                    shadows: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 0,
                                        spreadRadius: 5,
                                        blurStyle: BlurStyle.outer,
                                      )
                                    ],
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    "MATH QUIZ",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class accueil extends StatefulWidget {
  const accueil({Key? key}) : super(key: key);

  @override
  State<accueil> createState() => _accueilState();
}

class _accueilState extends State<accueil> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black54,
                    spreadRadius: 5,
                    offset: Offset(2, 2),
                    blurRadius: 5)
              ],
            ),
            child: GridTile(
              footer: Container(
                height: 25,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(112, 38, 33, 33),
                ),
                child: Text(
                  ("p r a t i c e  m a k e s  p e r f e c t").toUpperCase(),
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),
              child: Provider.of<Images>(context).acceuilHeader,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15),
            height: MediaQuery.of(context).size.height * 0.60,
            child: Livres(MediaQuery.of(context).size.height * 0.60),
          ),
        ],
      ),
    );
  }
}

class chatBot extends StatefulWidget {
  const chatBot({Key? key}) : super(key: key);

  @override
  State<chatBot> createState() => _chatBotState();
}

class _chatBotState extends State<chatBot> {
  bool isTipping = false;
  final controler = TextEditingController();

  double _textFieldHeight = 30.0;
  @override

  void textZoneHeight(String? value , [ BoxConstraints constraints= const BoxConstraints(maxWidth: 250)]){
    final maxWidth = constraints.maxWidth -
        10.0; // Largeur disponible moins le padding
    final textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: const TextStyle(
          fontSize:
          18.0, // Ajustez la taille de la police si nécessaire
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    setState(() {
      _textFieldHeight =
          (textPainter.height + 26.0).clamp(25.0, 150);
    });
    if (value!.isNotEmpty) {
      setState(() {
        isTipping = true;
      });
    } else {
      setState(() {
        isTipping = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return  ChatBotPage();
    // Scaffold(
    //   body: SafeArea(
    //       child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       const SizedBox(
    //         height: 20,
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 15.0),
    //         child: Container(
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //             color: const Color.fromARGB(255, 24, 28, 33),
    //             borderRadius: BorderRadius.circular(5),
    //           ),
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               IconButton(
    //                 onPressed: () {},
    //                 icon: const Icon(
    //                   Icons.person_outline,
    //                   color: Colors.white54,
    //                   size: 35,
    //                 ),
    //               ),
    //               Expanded(
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 5.0),
    //                   child: LayoutBuilder(
    //                     builder: (context, constraints) => AnimatedContainer(
    //                       duration: const Duration(milliseconds: 100),
    //                       height: _textFieldHeight,
    //                       child: TextFormField(
    //                         decoration: const InputDecoration(
    //                             hintText: "Votre Question",
    //                             hintStyle: TextStyle(
    //                               color: Colors.white70,
    //                             ),
    //                             border: InputBorder.none),
    //                         maxLines: null,
    //                         expands: true,
    //                         keyboardType: TextInputType.multiline,
    //                         style: const TextStyle(color: Colors.white, fontSize: 18),
    //                         cursorColor: Colors.white,
    //                         cursorRadius: const Radius.circular(25),
    //                         controller: controler,
    //                         onChanged: (value) {
    //                           textZoneHeight(value,constraints);
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               isTipping
    //                   ? IconButton(
    //                       onPressed: () {},
    //                       icon: const Icon(
    //                         Icons.send,
    //                         color: Colors.teal,
    //                         size: 35,
    //
    //                       ),
    //                     )
    //                   : Row(
    //                       children: [
    //                         IconButton(
    //                           onPressed: () async {
    //                            final path = await pickImage(ImageSource.gallery);
    //                            if(!context.mounted);
    //                            final cropperPath = await CropperImage(context,path);
    //                              final texte =await extract(cropperPath);
    //                            controler.text =texte;
    //                            textZoneHeight(controler.text);
    //                           },
    //                           icon: const Icon(
    //                             Icons.photo_size_select_actual_outlined,
    //                             color: Colors.white70,
    //                             size: 30,
    //
    //                           ),
    //                         ),
    //                         IconButton(
    //                           onPressed: () async{
    //                             final path = await pickImage(ImageSource.camera);
    //                             if(!context.mounted);
    //                             final cropperPath = await CropperImage(context,path);
    //                             final texte =await extract(cropperPath);
    //                            setState(() {
    //                              controler.text =texte;
    //                            });
    //                           },
    //                           icon: const Icon(
    //                             Icons.camera_alt_outlined,
    //                             color: Colors.white70,
    //                             size: 30,
    //
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //             ],
    //           ),
    //         ),
    //       )
    //     ],
    //   )),
    // );
  }
}

class MyDesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
    path.moveTo(0, size.height * .8);
    path.cubicTo(size.width / 8, 3 * (size.height / 2), 3 * (size.width / 3),
        size.height / 1.8, size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
