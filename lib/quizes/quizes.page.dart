import 'package:akla00001/dataBase/sqfliteBase.dart';
import 'package:akla00001/quizes/quiz.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? _selectedValue;

  late final String userName;

  List<Question> questions = [];
  List<Question> questions2 = [];


  int score = 0;
  int score2 = 0;

  void initialiseQuizesList() async {
    var use = await SQLDB.getUser();
    var user = List.from(use);
    userName = user[0]["nom"];
    score =  user[0]["score1"];
    score2 =  user[0]["score2"];

    var data = await SQLDB.searchQuizes(user[0]['classe']);

    questions = List.from(data);
    var data1 = await SQLDB.searchTFQuizes(user[0]['classe']);
    questions2 = List.from(data1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseQuizesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListTile(
                title: Text(
                  "Let's Play Quiz",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Choisissez le type de Quiz",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Colors.white70,
                          Colors.transparent,
                          Colors.white70,
                          Colors.blueAccent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: RadioListTile(
                      title: const Text("Repondre par Vrai ou Faux"),
                      subtitle: const Text('A un laps de temps'),
                      isThreeLine: true,
                      activeColor: Colors.teal,
                      value: 1,
                      groupValue: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Colors.white70,
                          Colors.transparent,
                          Colors.white70,
                          Colors.blueAccent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: RadioListTile(
                      title: const Text("Question à choix multiple"),
                      subtitle: const Text('A un laps de temps'),
                      isThreeLine: true,
                      activeColor: Colors.teal,
                      value: 2,
                      groupValue: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  if (_selectedValue != null) {
                    _selectedValue == 1
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                  questions: questions2,
                                  score: score2,
                                  userName: userName),
                            ))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                  questions: questions,
                                  score: score,
                                  userName: userName),
                            ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            const Text("Choisissez d'abord le type de Quiz "),
                        duration: const Duration(seconds: 2),
                        elevation: 10,
                        backgroundColor:
                            Colors.deepOrangeAccent, // Couleur d'arrière-plan
                        behavior: SnackBarBehavior
                            .floating, // Comportement du SnackBar
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Forme des coins
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.teal,
                      Colors.tealAccent,
                      Colors.black12
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: const Text(
                    "Commencer",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
