import 'dart:async';
import 'package:akla00001/abonnement/dialogueAbonnement.dart';
import 'package:akla00001/classes/stateprovider.dart';
import 'package:flutter/material.dart';
import 'package:latext/latext.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class QuizScreen extends StatefulWidget {
  List<Question> questions;
  final String userName;
  final int score;
  QuizScreen(
      {required this.userName,
      required this.score,
      required this.questions,
      super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  //All list of quiz about the class selected

  List<Question> questions = [];

  String userName = '';

  int score = 0;

  int numbreQuestion = 0;

  int? selectedAnswerIndex;
  int questionIndex = 0;

  Timer? _timer;

  String message = "Vous avez atteint la limite quotidienne de quiz. Pour jouer de manière illimitée, veuillez souscrire à un abonnement.";

  void pickAnswer(int value) {
    _timer!.cancel();
    selectedAnswerIndex = value;
    final question = questions[questionIndex];
    if (selectedAnswerIndex == question.correctAnswerIndex) {
      score++;
    }
    setState(() {});
  }

  void noPickAnswer(int value) {
    _timer!.cancel();
    selectedAnswerIndex = value;
    _showExplanation(context, questions[questionIndex].getExplication());
    setState(() {});
  }

  int _totalSeconds = 0;
  int _secondsElapsed = 0;

  void goToNextQuestion() {
   if(questions[0].options.length !=2)
     {
       if(Provider.of<ActiviterDuJour>(context,listen: false).dayActivite.getNquiz2() < 10 || Provider.of<EtatAbonnement>(context).abonner.etatAbonne ){
         numbreQuestion++;
         if (questionIndex < questions.length - 1) {
           questionIndex++;
           selectedAnswerIndex = null;
           _secondsElapsed = 0; // Réinitialisez le compteur de temps écoulé à zéro
           _totalSeconds = questions[questionIndex].times;

           startTimer();
         }
         setState(() {});
       }else{
         showSubscriptionDialog(context,message);
       }
     }
   else{
     if(Provider.of<ActiviterDuJour>(context,listen: false).dayActivite.getNquiz1() < 10 || Provider.of<EtatAbonnement>(context).abonner.etatAbonne ){
       numbreQuestion++;
       if (questionIndex < questions.length - 1) {
         questionIndex++;
         selectedAnswerIndex = null;
         _secondsElapsed = 0; // Réinitialisez le compteur de temps écoulé à zéro
         _totalSeconds = questions[questionIndex].times;

         startTimer();
       }
       setState(() {});
     }else{
       showSubscriptionDialog(context,message);
     }
   }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsElapsed < _totalSeconds) {
          _secondsElapsed++;
        } else {
          _secondsElapsed = _totalSeconds;
          noPickAnswer(questions[questionIndex].correctAnswerIndex);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();

    questions = widget.questions;

    questions.shuffle();

    userName = widget.userName;
    _totalSeconds = questions[questionIndex].times;
    score = widget.score;
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[questionIndex];
    bool isLastquestion = questionIndex == questions.length - 1;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => _ResultScreen(
                  quizLength: numbreQuestion,
                  score: score,
                )));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[300],
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text("Math Quiz"),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Column(
                  children: [
                    joueur(widget.userName, score.toString()),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '${_totalSeconds - _secondsElapsed} s',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: (_secondsElapsed >= _totalSeconds * .5)
                                  ? ((_secondsElapsed >= _totalSeconds * .75)
                                      ? Colors.pink
                                      : Colors.deepOrange)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => _ResultScreen(
                          quizLength: numbreQuestion,
                          score: score,
                        )));
              },
            )),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white24,
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: Offset(2, 2))
                      ],
                      border: Border.all(
                        color: Colors.black12,
                      )),
                  child: !(question.question.contains("\\"))
                      ? RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(children: [
                            TextSpan(
                              text: question.question,
                              style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                          ]),
                        )
                      : LaTexT(
                          laTeXCode: Text(
                            question.getQuestion(),
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                            softWrap: false,
                            overflow: TextOverflow
                                .ellipsis, // Définit le comportement d'overflow
                            maxLines: 100,
                          ),
                          delimiter: '\$',
                          displayDelimiter: '\$',
                        ),
                ),
              ),
              ListView.builder(
                physics:
                    const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                shrinkWrap: true,
                itemCount: question.getOption().length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: selectedAnswerIndex == null
                        ? () => pickAnswer(index)
                        : null,
                    child: Column(
                      children: [
                        AnswerCard(
                          currentIndex: index,
                          question: question.getOption()[index],
                          isSelected: selectedAnswerIndex == index,
                          selectedAnswerIndex: selectedAnswerIndex,
                          correctAnswerIndex: question.correctAnswerIndex,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            (index == question.correctAnswerIndex &&
                                    selectedAnswerIndex != null)
                                ? CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    child: IconButton(
                                        onPressed: () {
                                          _showExplanation(context,
                                              question.getExplication());
                                        },
                                        icon: const Icon(
                                          Icons.question_mark_rounded,
                                          color: Colors.white,
                                        )))
                                : const SizedBox.shrink(),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
              isLastquestion
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(''),
                          const Text(''),
                          const Text(''),
                          ElevatedButton(
                            style: selectedAnswerIndex != null
                                ? ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.deepPurple),
                                    animationDuration:
                                        const Duration(milliseconds: 500),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            left: 25,
                                            right: 25,
                                            top: 10,
                                            bottom: 10)))
                                : ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black38),
                                    animationDuration:
                                        const Duration(milliseconds: 200),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            left: 25,
                                            right: 25,
                                            top: 10,
                                            bottom: 10))),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (_) => _ResultScreen(
                                            quizLength: questions.length,
                                            score: score,
                                          )));
                            },
                            child: const Text('Finish'),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(''),
                          const Text(''),
                          const Text(''),
                          ElevatedButton(
                            style: selectedAnswerIndex != null
                                ? ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.cyan),
                                    animationDuration:
                                        const Duration(milliseconds: 500),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            left: 25,
                                            right: 25,
                                            top: 10,
                                            bottom: 10)))
                                : ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black38),
                                    animationDuration:
                                        const Duration(milliseconds: 200),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            left: 25,
                                            right: 25,
                                            top: 10,
                                            bottom: 10))),
                            onPressed: () {
                              selectedAnswerIndex != null
                                  ? goToNextQuestion()
                                  :  ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                  content: const Text("Veillez selectionner votre reponse"),
                                  duration: const Duration(seconds: 2),
                                  elevation: 10,
                                  backgroundColor: Colors.pink[100], // Couleur d'arrière-plan
                                  behavior: SnackBarBehavior.floating, // Comportement du SnackBar
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Forme des coins
                                  ),
                                ),
                              );
                            },
                            child: const Text('N e x t'),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnswerCard extends StatelessWidget {
  final String question;
  final bool isSelected;
  final int? correctAnswerIndex;
  final int? selectedAnswerIndex;
  final int currentIndex;

  const AnswerCard(
      {required this.correctAnswerIndex,
      required this.question,
      required this.currentIndex,
      required this.isSelected,
      required this.selectedAnswerIndex,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCorrectAnswer = currentIndex == correctAnswerIndex;
    bool isWrongAnswer = !isCorrectAnswer && isSelected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: selectedAnswerIndex != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCorrectAnswer
                        ? Colors.green
                        : isWrongAnswer
                            ? Colors.red
                            : Colors.white24,
                    width: 2,
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: !(question.contains("\\"))
                        ? Text(
                            question,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          )
                        : LaTexT(
                            laTeXCode: Text(
                              question,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                              softWrap: false,
                              overflow: TextOverflow
                                  .ellipsis, // Définit le comportement d'overflow
                              maxLines: 100,
                            ),
                            delimiter: '\$',
                            displayDelimiter: '\$',
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isCorrectAnswer
                      ? buildCorrectIcon()
                      : isWrongAnswer
                          ? buildWrongIcon()
                          : const SizedBox.shrink(),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white24,
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: LaTexT(
                      laTeXCode: Text(
                        question,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                        softWrap: false,
                        overflow: TextOverflow
                            .ellipsis, // Définit le comportement d'overflow
                        maxLines: 100,
                      ),
                      delimiter: '\$',
                      displayDelimiter: '\$',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final int score;
  final int quizLength;

  const _ResultScreen({required this.quizLength, required this.score, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Couleur de fond de l'écran
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Votre Score",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Couleur du texte
              ),
            ),
            const SizedBox(height: 20), // Espace entre le texte et le cercle
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      score.toString(),
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Couleur du score
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
                height: 20), // Espace entre le cercle et le pourcentage
            Text(
              "${(score / (quizLength == 0 ? 1 : quizLength * 100)).round()}%",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Couleur du pourcentage
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCorrectIcon() => const CircleAvatar(
      radius: 15,
      backgroundColor: Colors.green,
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );

Widget buildWrongIcon() => const CircleAvatar(
      radius: 15,
      backgroundColor: Colors.red,
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );

class Question {
  final String explication;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final int times;

  Question(
      {required this.question,
      required this.options,
      required this.correctAnswerIndex,
      required this.explication,
      required this.times});

  String getQuestion() {
    String first = question.replaceAll("\\(", "(");
    String second = first.replaceAll("\\)", ")");

    return second;
  }

  String getExplication() {
    String first = explication.replaceAll("\\(", "(");
    String second = first.replaceAll("\\)", ")");

    return second;
  }

  List<String> getOption() {
    List<String> opts = [];

    for (var option in options) {
      String first = option.replaceAll("\\(", "(");
      String second = first.replaceAll("\\)", ")");
      opts.add(second);
    }
    return opts;
  }
}

void _showExplanation(BuildContext context, String explanation) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Explication de la réponse'),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            child: LaTexT(
              laTeXCode: Text(
                explanation,
                style: const TextStyle(
                  color: Colors.black54,
                ),
                softWrap: false,
                overflow:
                    TextOverflow.ellipsis, // Définit le comportement d'overflow
                maxLines: 100,
              ),
              delimiter: '\$',
              displayDelimiter: '\$',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fermer'),
          ),
        ],
      );
    },
  );
}

Widget joueur(String playerName, String score) {
  return Container(
    color: Colors.blue, // Couleur d'arrière-plan du conteneur de l'en-tête
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Icon(
          Icons.account_circle, // Icône pour représenter le joueur
          color: Colors.white, // Couleur de l'icône
          size: 40.0, // Taille de l'icône
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              playerName,
              style: const TextStyle(
                color: Colors.white, // Couleur du texte
                fontSize: 20.0, // Taille de la police
                fontWeight: FontWeight.bold, // Texte en gras
              ),
            ),
          ],
        ),
        const Icon(
          Icons.star, // Icône pour représenter le score
          color: Colors.yellow, // Couleur de l'icône
          size: 30.0, // Taille de l'icône
        ),
        const Text(
          'Score:',
          style: TextStyle(
            color: Colors.white, // Couleur du texte
            fontSize: 16.0, // Taille de la police
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            score,
            style: const TextStyle(
              color: Colors.white, // Couleur du texte
              fontSize: 20.0, // Taille de la police
              fontWeight: FontWeight.bold, // Texte en gras
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
