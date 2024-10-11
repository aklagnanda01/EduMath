import 'package:akla00001/classes/mathExpression.dart';
import 'package:akla00001/classes/stateprovider.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:akla00001/dataBase/sqfliteBase.dart';
import 'package:akla00001/pages/dialogs.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';
import 'package:akla00001/abonnement/dialogueAbonnement.dart';

//fonction de compte

int countOpeningParentheses(String expression) {
  int count = 0;
  for (int i = 0; i < expression.length; i++) {
    if (expression[i] == '(') {
      count++;
    }
  }
  return count;
}

int countClosingParentheses(String expression) {
  int count = 0;
  for (int i = 0; i < expression.length; i++) {
    if (expression[i] == ')') {
      count++;
    }
  }
  return count;
}

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  List<bool> addFct = [false, false, true];
  String expression = '0';
  String expression2 = '0';
  String expression3 = '0';
  final FocusNode _mathFieldFocusNode = FocusNode();
  final FocusNode _mathFieldFocusNode2 = FocusNode();
  final FocusNode _mathFieldFocusNode3 = FocusNode();
  //recuperrer de la saisi dans les zone de mathField
  MathFieldEditingController controller1 = MathFieldEditingController();
  MathFieldEditingController controller2 = MathFieldEditingController();
  MathFieldEditingController controller3 = MathFieldEditingController();

  String message =
      "Vous avez atteint la limite quotidienne de fonctions. Pour tracer davantage de fonctions sans interruption, veuillez vous abonner.";

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }
  //les variable pour les derivers

  List<bool> deri = [false, false, false];

  //histirisation des données des fonctions saissis

  List<Map<String, dynamic>> _list = [];

  void _nbFonctions() async {
    var data = await SQLDB.getFonctions();
    setState(() {
      _list = List.from(data);
    });
  }

//pour deplacer le bouton flottant

  void showHistory() {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          color: Colors.black87,
          height: MediaQuery.of(context).size.height / 1.8,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: ListView.builder(
            itemCount: _list.isEmpty ? 1 : _list.length,
            itemBuilder: (context, index) => _list.isNotEmpty
                ? ListTile(
                    title: Math.tex(_list[index]["function"],
                        mathStyle: MathStyle.text,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Colors.white)),
                    subtitle: Text(
                      "${_list[index]['createdAt']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.blue),
                    ),
                    trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.deepOrange,
                          size: 30,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white70,
                                title: const Text(
                                  "Suppression",
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      "Voulez-vous supprimer ?",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    const SizedBox(height: 16),
                                    Math.tex(
                                      _list[index]['function'],
                                      textStyle: const TextStyle(
                                          fontSize: 30, color: Colors.blue),
                                    )
                                  ],
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Ferme la boîte de dialogue
                                        },
                                        child: const Text("Non",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.indigo)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          SQLDB.deleteFonction(
                                              _list[index]["id"]);
                                          setState(() {
                                            _list.removeAt(index);
                                          });
                                          Navigator.of(context)
                                              .pop(); // Ferme la boîte de dialogue
                                        },
                                        child: Text("Oui",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red[500])),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                    onTap: () {
                      controller1.clear();
                      controller1.addLeaf(_list[index]["function"]);
                    },
                  )
                : Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        color: Colors.red[200],
                        size: 40,
                      ),
                      const Text(
                        "  Pas de sauvergardes",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
          ),
          // Math.tex(r'\frac{25}{2}', mathStyle: MathStyle.text,textStyle: TextStyle()),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nbFonctions();
  }

  int _nFonctionEntrer = 0;
  int _nFonctionEntrer2 = 0;
  int _nFonctionEntrer3 = 0;
  int nDayFonction = 12;
  int _backButtonPressCount = 0;

  //systeme de zoom

  double _zoomLevel = 1.0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _mathFieldFocusNode.unfocus();
        _mathFieldFocusNode2.unfocus();
        _mathFieldFocusNode3.unfocus();
        if (_backButtonPressCount == 1) {
          // L'utilisateur a appuyé deux fois sur le bouton de retour, vous pouvez quitter l'écran ici.
          return true;
        } else {
          // L'utilisateur a appuyé une fois, affichez un message ou une confirmation.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Appuyez de nouveau pour quitter"),
              duration: const Duration(seconds: 1),
              elevation: 10,
              backgroundColor: Colors.blue, // Couleur d'arrière-plan
              behavior: SnackBarBehavior.floating, // Comportement du SnackBar
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Forme des coins
              ),
            ),
          );

          // Incrémentation du compteur
          _backButtonPressCount++;

          // Attendre un peu avant de réinitialiser le compteur
          await Future.delayed(const Duration(seconds: 2));

          // Réinitialiser le compteur après un certain délai
          _backButtonPressCount = 0;

          // Empêcher le retour
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('EDU MATH '),
          titleTextStyle: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              fontFamily: AutofillHints.nickname,
              fontStyle: FontStyle.italic,
              color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          elevation: 1,
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showHelpDialog(context);
                        },
                        child: const ListTile(
                          title: Text(
                            "AIDE ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: Icon(Icons.help),
                        ),
                      ),
                    ),

                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          showHistory();
                        },
                        title: const Text(
                          "Historique",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: const Icon(Icons.history_edu_outlined,
                            color: Colors.blueGrey),
                      ),
                    ),
                    // Ajoutez d'autres éléments de menu ici si nécessaire
                  ],
                  child: const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Icon(
                        Icons.hiking_sharp,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            _mathFieldFocusNode.unfocus();
            _mathFieldFocusNode2.unfocus();
            _mathFieldFocusNode3.unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                MathKeyboardViewInsets(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: MathField(
                          focusNode: _mathFieldFocusNode,
                          controller: controller1,
                          decoration: const InputDecoration(
                              label: Text(
                                "F(x)",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(),
                                gapPadding: 10,
                              )),
                          variables: const ['x'],
                          onChanged: (value) {
                            try {
                              if (countClosingParentheses(value) ==
                                  countOpeningParentheses(value)) {
                                setState(() {
                                  if (Provider.of<ActiviterDuJour>(context,
                                                  listen: false)
                                              .dayActivite
                                              .getNfonction() <
                                          nDayFonction ||
                                      Provider.of<EtatAbonnement>(context,
                                              listen: false)
                                          .abonner
                                          .etatAbonne) {
                                    expression = '${TeXParser(value).parse()}';
                                    deri[0] = true;
                                    if (_nFonctionEntrer < value.length) {
                                      Provider.of<ActiviterDuJour>(context,
                                              listen: false)
                                          .dayActivite
                                          .setNfonction();
                                      _nFonctionEntrer = value.length;
                                    } else {
                                      _nFonctionEntrer =value.length;
                                    }
                                  } else {
                                    showSubscriptionDialog(context, message);
                                  }
                                });
                              } else {
                                expression = '0';
                                deri[0] = false;
                              }
                            } catch (_) {
                              setState(() {
                                expression = '0';
                                deri[0] = false;
                              });
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: addFct[0],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: MathField(
                            controller: controller2,
                            focusNode: _mathFieldFocusNode2,
                            decoration: const InputDecoration(
                                label: Text(
                                  "G(x)",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.pinkAccent),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(),
                                  gapPadding: 10,
                                )),
                            variables: const ['x'],
                            onChanged: (value) {
                              try {
                                if (countClosingParentheses(value) ==
                                    countOpeningParentheses(value)) {
                                  setState(() {
                                    if (Provider.of<ActiviterDuJour>(context,
                                                    listen: false)
                                                .dayActivite
                                                .getNfonction() <
                                            nDayFonction ||
                                        Provider.of<EtatAbonnement>(context,
                                                listen: false)
                                            .abonner
                                            .etatAbonne) {
                                      expression2 =
                                          '${TeXParser(value).parse()}';
                                      deri[1] = true;
                                      if (_nFonctionEntrer2 < value.length) {
                                        Provider.of<ActiviterDuJour>(context,
                                                listen: false)
                                            .dayActivite
                                            .setNfonction();
                                        _nFonctionEntrer2 = value.length;
                                      } else {
                                        _nFonctionEntrer2 = value.length;
                                      }
                                    } else {
                                      showSubscriptionDialog(context, message);
                                    }
                                  });
                                } else {
                                  expression2 = '0';
                                  deri[1] = false;
                                }
                              } catch (_) {
                                setState(() {
                                  expression2 = '0';
                                  deri[1] = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: addFct[1],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: MathField(
                            controller: controller3,
                            focusNode: _mathFieldFocusNode3,
                            decoration: const InputDecoration(
                                label: Text(
                                  "H(x)",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.teal),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(),
                                  gapPadding: 10,
                                )),
                            variables: const ['x'],
                            onChanged: (value) {
                              try {
                                if (countClosingParentheses(value) ==
                                    countOpeningParentheses(value)) {
                                  setState(() {
                                    if (Provider.of<ActiviterDuJour>(context,
                                                    listen: false)
                                                .dayActivite
                                                .getNfonction() <
                                            nDayFonction ||
                                        Provider.of<EtatAbonnement>(context,
                                                listen: false)
                                            .abonner
                                            .etatAbonne) {
                                      expression3 =
                                          '${TeXParser(value).parse()}';
                                      deri[2] = true;
                                      if(_nFonctionEntrer3 < value.length)
                                      {
                                        Provider.of<ActiviterDuJour>(context,listen: false).dayActivite.setNfonction();
                                        _nFonctionEntrer3 = value.length ;
                                      }else{
                                        _nFonctionEntrer3 = value.length;
                                      }
                                    }else{
                                      showSubscriptionDialog(context,message);
                                    }
                                  });
                                } else {
                                  deri[2] = false;
                                }
                              } catch (_) {
                                setState(() {
                                  expression3 = '0';
                                  deri[2] = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: addFct[0],
                              child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      if (addFct[1] == true) {
                                        addFct[1] = false;
                                        expression3 = '0';
                                        addFct[2] = true;
                                      } else {
                                        expression2 = '0';
                                        addFct[0] = false;
                                      }
                                    });
                                  },
                                  elevation: 5,
                                  color: Colors.redAccent,
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      Icon(
                                        Icons.auto_graph_sharp,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )),
                            ),
                            Visibility(
                                visible: addFct[2],
                                child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        if (addFct[0] == false) {
                                          addFct[0] = true;
                                        } else {
                                          addFct[1] = true;
                                          addFct[2] = false;
                                        }
                                      });
                                    },
                                    elevation: 5,
                                    color: Colors.indigo,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        Icon(
                                          Icons.auto_graph_sharp,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onDoubleTap: (){
                    setState(() {
                      if(_zoomLevel<4)
                        {
                          _zoomLevel *=2;
                        }else{
                        _zoomLevel=1;
                      }
                    });
                  },
                  child: Transform.scale(
                    scale: _zoomLevel,
                    child: Container(
                      color: Colors.pink[50],
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: InteractiveViewer(
                        boundaryMargin: const EdgeInsets.all(300),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Obtenez la largeur et la hauteur disponibles pour le LineChart

                            double chartWidth = constraints.maxWidth;
                            double chartHeight = constraints.maxHeight;

                            return LineChart(
                              LineChartData(
                                backgroundColor: Colors.white,
                                minX: -30,
                                maxX: 30,
                                minY: -30,
                                maxY: 30,
                                titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: SideTitles(
                                      textDirection: TextDirection.ltr,
                                      rotateAngle: 0,
                                      margin: -chartHeight + 5,
                                      interval: 1,
                                      reservedSize: 5,
                                      getTextStyles: (context, value) =>
                                          const TextStyle(
                                              fontSize: 7,
                                              color: Colors.black,
                                              textBaseline: TextBaseline.alphabetic,
                                              fontWeight: FontWeight.w400,
                                              decorationStyle:
                                                  TextDecorationStyle.wavy),
                                      showTitles: true,
                                      getTitles: (value) {
                                        // Vous pouvez personnaliser les étiquettes de l'axe des abscisses ici
                                        // Par exemple, retourner une chaîne différente pour chaque valeur.
                                        return value != 1
                                            ? ((value).toInt()).toString()
                                            : "i";
                                      },
                                    ),
                                    leftTitles: SideTitles(
                                      rotateAngle: 0,
                                      margin: -chartWidth + 25,
                                      interval: 1,
                                      reservedSize: 20,
                                      getTextStyles: (context, value) =>
                                          const TextStyle(
                                              fontSize: 7,
                                              color: Colors.black,
                                              textBaseline: TextBaseline.alphabetic,
                                              fontWeight: FontWeight.w400,
                                              decorationStyle:
                                                  TextDecorationStyle.wavy),
                                      showTitles: true,
                                      getTitles: (value) {
                                        // Vous pouvez personnaliser les étiquettes de l'axe des abscisses ici
                                        // Par exemple, retourner une chaîne différente pour chaque valeur.
                                        return value != 0
                                            ? (value != 1
                                                ? ((value).toInt()).toString()
                                                : "j")
                                            : "";
                                      },
                                    ),
                                    topTitles:  SideTitles(
                                      showTitles: false,
                                    ),
                                    rightTitles:  SideTitles(
                                      showTitles: false,
                                    )),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine:
                                      true, // Affiche les lignes verticales
                                  drawHorizontalLine:
                                      true, // Affiche les lignes horizontales
                                  verticalInterval:
                                      1, // Espacement vertical entre les lignes
                                  horizontalInterval:
                                      1, // Espacement horizontal entre les lignes

                                  getDrawingHorizontalLine: (value) {
                                    // Personnaliser les propriétés de la ligne horizontale
                                    return value != 0
                                        ?  FlLine(
                                            color:
                                                Colors.grey, // Couleur de la ligne
                                            strokeWidth:
                                                0.4, // Epaisseur de la ligne
                                          )
                                        :  FlLine(
                                            color:
                                                Colors.red, // Couleur de la ligne
                                            strokeWidth: 1, // Epaisseur de la ligne
                                          );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    // Personnaliser les propriétés de la ligne verticale
                                    return value != 0
                                        ?  FlLine(
                                            color:
                                                Colors.grey, // Couleur de la ligne
                                            strokeWidth:
                                                0.4, // Epaisseur de la ligne
                                          )
                                        :  FlLine(
                                            color: Colors
                                                .purple, // Couleur de la ligne
                                            strokeWidth: 1, // Epaisseur de la ligne
                                          );
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border:
                                      Border.all(color: Colors.white, width: 0.2),
                                  // Ajoutez des marges pour décaler le graphique et les annotations vers l'intérieur
                                  // Vous pouvez ajuster ces valeurs selon vos besoins
                                ),
                                axisTitleData: FlAxisTitleData(show: false),
                                rangeAnnotations: null,
                                betweenBarsData: null,
                                extraLinesData: null,
                                showingTooltipIndicators: null,
                                clipData:  FlClipData(
                                    bottom: false,
                                    right: false,
                                    top: false,
                                    left: false),
                                lineTouchData:  LineTouchData(enabled: false),
                                lineBarsData: [
                                  //draw first function
                                  LineChartBarData(
                                    spots: _generateSpots(expression, context),
                                    isCurved: true,
                                    colors: [Colors.blue],
                                    dotData:  FlDotData(
                                      show: false,
                                    ),
                                    show: true,
                                  ),

                                  //draw second function

                                  LineChartBarData(
                                    spots: _generateSpots(expression2, context),
                                    isCurved: true,
                                    colors: [Colors.pinkAccent],
                                    dotData:  FlDotData(show: false),
                                  ),

                                  //draw third function

                                  LineChartBarData(
                                    spots: _generateSpots(expression3, context),
                                    isCurved: true,
                                    colors: [Colors.teal],
                                    dotData:  FlDotData(show: false),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Column(
                      children: [
                        Visibility(
                          visible: deri[0],
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "F(x)= ",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue),
                                        ),
                                        Math.tex(
                                          controller1.currentEditingValue(),
                                          mathStyle: MathStyle.text,
                                          textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "F'(x)= ",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue),
                                        ),
                                        Math.tex(
                                          Fonction.derive(expression),
                                          mathStyle: MathStyle.text,
                                          textStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: deri[1],
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "G(x)= ",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.pinkAccent),
                                        ),
                                        Math.tex(
                                          controller2.currentEditingValue(),
                                          textStyle: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.pinkAccent),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "G'(x)= ",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.pinkAccent),
                                        ),
                                        Math.tex(
                                          Fonction.derive(expression2),
                                          mathStyle: MathStyle.text,
                                          textStyle: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.pinkAccent),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: deri[2],
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "H(x)= ",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.teal),
                                    ),
                                    Math.tex(
                                      controller3.currentEditingValue(),
                                      textStyle: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.teal),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "H'(x)= ",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.teal),
                                    ),
                                    Math.tex(
                                      Fonction.derive(expression3),
                                      mathStyle: MathStyle.text,
                                      textStyle: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.teal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(

                onTap: (deri[0] || deri[1] || deri[2])
                    ? () {
                        if (deri[0] &&
                            controller1
                                    .currentEditingValue()
                                    .toString()
                                    .length !=
                                4) {
                          SQLDB.createFct(
                              controller1.currentEditingValue().toString());
                        }
                        if (deri[1] &&
                            controller2
                                    .currentEditingValue()
                                    .toString()
                                    .length !=
                                4) {
                          SQLDB.createFct(
                              controller2.currentEditingValue().toString());
                        }
                        if (deri[
                                2] /* &&
                      controller3.currentEditingValue().toString().length >= 4*/
                            ) {
                          SQLDB.createFct(
                              controller3.currentEditingValue().toString());
                        }
                        _nbFonctions();
                        showSuccessBottomSheet(
                            context,
                            'Enregistrement effectué avec succès',
                            Icons.check_circle);
                      }
                    : () {
                        showSuccessBottomSheet(
                            context,
                            "Erreur de sauvegarde : aucune fonction saisie ",
                            Icons.question_mark);
                      },
                child: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  maxRadius: 25,
                  child: Icon(Icons.save,
                      color: Colors.white, size: 30, semanticLabel: "save"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//first function

List<FlSpot> _generateSpots(String expression, BuildContext context) {
  List<FlSpot> spots = [];
  double maxY = 755328631491748400000.0;
  if (expression != '0') {
    final parser = Parser();
    final parsedExpression = parser.parse(expression);

    try {
      for (double x = -30; x <= 30; x += 0.01) {
        ContextModel cm = ContextModel();
        cm.bindVariable(Variable('x'), Number(x));
        double y = parsedExpression.evaluate(EvaluationType.REAL, cm);

        if (!y.isNaN && !y.isInfinite) {
          if (y >= maxY) {
            y = maxY;
          }
          spots.add(FlSpot(x, y));
        } else {
          spots.add(FlSpot.nullSpot);
          continue;
        }
      }
      return spots;
    } catch (e) {
      return spots;
    }
  } else {
    return spots;
  }
}
