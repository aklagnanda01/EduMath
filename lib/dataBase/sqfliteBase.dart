import 'package:akla00001/classes/stateprovider.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:akla00001/pages/page.recherche.dart' show Item;
import 'package:akla00001/quizes/quiz.dart' show Question;

class SQLDB {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbfct',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTableUser(database);
        await createTable(database);
        await createTableCours(database);
        await createTableEpreuves(database);
        await createTableCitation(database);
        await createTableCitationSave(database);
        await createTableDayCitation(database);
        await createTableFormula(database);
        await createTableQuizes(database);
        await createTableActiver(database);
        await createTableAbonnement(database);
        await createTableTFQuizes(database);

        await insertInToDatabase(database);
      },
    );
  }

  //formule mathematique et physique les expression et les explication

  static Future<void> createTableFormula(sql.Database database) async {
    await database.execute("""CREATE TABLE formulas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        equation TEXT NOT NULL,
        description TEXT,
        category TEXT
      )
    """);
  }

  static Future<void> createTableQuizes(sql.Database database) async {
    await database.execute("""CREATE TABLE quiz(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        explication TEXT NOT NULL,
        correctAnswerIndex INTEGER ,
        times INTEGER ,
        classe TEXT ,
        option1 TEXT,
        option2 TEXT,
        option3 TEXT,
        option4 TEXT
      )
    """);
  }

  static Future<List<Question>> searchQuizes(String classe) async {
    final db = await SQLDB.db();
    List<Map<String, dynamic>> maps = await db.query("quiz",
        where: "classe = ?", whereArgs: [classe], orderBy: "question ASC");

    return List.generate(maps.length, (i) {
      return Question(
        question: maps[i]['question'],
        explication: maps[i]['explication'],
        correctAnswerIndex: maps[i]['correctAnswerIndex'],
        options: [
          maps[i]['option1'],
          maps[i]['option2'],
          maps[i]['option3'],
          maps[i]['option4'],
        ],
        times: maps[i]['times'],
      );
    });
  }

  //quiz about false and true

  static Future<void> createTableTFQuizes(sql.Database database) async {
    await database.execute("""CREATE TABLE quiztv(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        explication TEXT NOT NULL,
        correctAnswerIndex INTEGER ,
        times INTEGER ,
        classe TEXT ,
        option1 TEXT,
        option2 TEXT
      )
    """);
  }

  static Future<String> tempsDb() async {
    final db = await SQLDB.db();

    final List<Map<String, dynamic>> results =
        await db.rawQuery('SELECT CURRENT_TIMESTAMP');
    String timestampText = results[0]['CURRENT_TIMESTAMP'];

    return timestampText;
  }

  static Future<List<Question>> searchTFQuizes(String classe) async {
    final db = await SQLDB.db();
    List<Map<String, dynamic>> maps = await db.query("quiztv",
        where: "classe = ?", whereArgs: [classe], orderBy: "question ASC");

    return List.generate(maps.length, (i) {
      return Question(
        question: maps[i]['question'],
        explication: maps[i]['explication'],
        correctAnswerIndex: maps[i]['correctAnswerIndex'],
        options: [
          maps[i]['option1'],
          maps[i]['option2'],
        ],
        times: maps[i]['times'],
      );
    });
  }

  static Future<List<Item>> searchFormulas() async {
    final db = await SQLDB.db();
    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT name, equation, description FROM formulas ORDER BY name ASC',
    );

    return List.generate(maps.length, (i) {
      return Item(
        name: maps[i]['name'],
        formule: maps[i]['equation'],
        description: maps[i]['description'],
      );
    });
  }

  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE fonctions(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    function TEXT UNIQUE  NOT NULL,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

//table for citation saved

  static Future<void> createTableCitationSave(sql.Database database) async {
    await database.execute("""CREATE TABLE citationSave(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    contenue TEXT NOT NULL,
    auteur TEXT NOT NULL,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<List<Map<String, dynamic>>> getCitationSave() async {
    final db = await SQLDB.db();
    return db.query('citationSave', orderBy: 'createdAt DESC ');
  }

  static Future<void> deleteCitationSave(int id) async {
    final db = await SQLDB.db();
    try {
      await db.delete('citationSave', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("error deleting function");
    }
  }

  static Future<int> insertCitationSave(String name, String prenom) async {
    final db = await SQLDB.db();

    final data = {
      'contenue': name,
      'auteur': prenom,
    };
    final id = await db.insert('citationSave', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Day citations
  static Future<void> createTableDayCitation(sql.Database database) async {
    await database.execute("""CREATE TABLE daycitations(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    contenue TEXT NOT NULL,
    auteur TEXT NOT NULL,
    day TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<List<Map<String, dynamic>>> getDayCitation() async {
    final db = await SQLDB.db();
    return db.query('daycitations');
  }

  static Future<void> deleteDayCitationSave() async {
    final db = await SQLDB.db();
    try {
      await db.rawDelete('DELETE FROM daycitations');
    } catch (err) {
      debugPrint("error deleting function");
    }
  }

  static Future<int> insertDayCitation(String name, String prenom) async {
    final db = await SQLDB.db();

    final data = {
      'contenue': name,
      'auteur': prenom,
    };
    final id = await db.insert('daycitations', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //table for citation
  static Future<void> createTableCitation(sql.Database database) async {
    await database.execute("""CREATE TABLE citations(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    contenue TEXT NOT NULL,
    auteur TEXT NOT NULL
    )
    """);
  }

  static Future<List<Map<String, dynamic>>> getCitation(int id) async {
    final db = await SQLDB.db();
    return db.query('citations', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // table des activités journalière
  static Future<void> createTableActiver(sql.Database database) async {
    await database.execute("""CREATE TABLE activite(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nfonction INTEGER NOT NULL DEFAULT 0,
    nquiz1 INTEGER NOT NULL DEFAULT 0,     
    nquiz2 INTEGER NOT NULL DEFAULT 0,
    nrecherche INTEGER NOT NULL DEFAULT 0 ,
    day TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<Activiter> searchActivity() async {
    final db = await SQLDB.db();
    List<Map<String, dynamic>> maps = await db.query('activite', limit: 1);
    int i = 0;
    return Activiter(
      nFonction: maps[i]['nfonction'],
      nRecherche: maps[i]['nrecherche'],
      nQuiz2: maps[i]['nquiz2'],
      nQuiz1: maps[i]['nquiz1'],
      day: maps[i]['day'],
    );
  }

  static Future<void> deleteActivite() async {
    final db = await SQLDB.db();
    try {
      await db.rawDelete('DELETE FROM activite');
    } catch (err) {
      debugPrint("error deleting function");
    }
  }

  static Future<int> updateActivite(Activiter activiter) async {
    final db = await SQLDB.db();
    final data = {
      'nfonction': activiter.getNfonction(),
      'nquiz1': activiter.getNquiz1(),
      'nquiz2': activiter.getNquiz2(),
      'nrecherche': activiter.getNrecherche(),
      'day': (await db.rawQuery("SELECT CURRENT_TIMESTAMP"))[0]
          ["CURRENT_TIMESTAMP"]
    };
    var i = await db.update('activite', data);
    return i;
  }

  // abbonement

  // table des activités journalière
  static Future<void> createTableAbonnement(sql.Database database) async {
    await database.execute("""CREATE TABLE abonner(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    state INTEGER NOT NULL DEFAULT 0 ,
    day TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<Abonner> searchAbonner() async {
    final db = await SQLDB.db();
    List<Map<String, dynamic>> maps = await db.query('abonner', limit: 1);
    int i = 0;
    return Abonner(
      etatAbonne: maps[i]['state'] == 0 ? false : true,
      temps: maps[i]['day'],
    );
  }

  static Future<int> updateAbonnement(int state) async {
    final db = await SQLDB.db();
    final data = {
      'state': state,
      'day': (await db.rawQuery("SELECT CURRENT_TIMESTAMP"))[0]
          ["CURRENT_TIMESTAMP"]
    };
    var i = await db.update('abonner', data);
    return i;
  }

//table for user
  static Future<void> createTableUser(sql.Database database) async {
    await database.execute("""CREATE TABLE Users(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nom TEXT  NOT NULL,
    prenom TEXT ,
    numero TEXT UNIQUE  NOT NULL,
    classe TEXT  NOT NULL ,
    mode TEXT DEFAULT "light",
    score1 INTEGER NOT NULL DEFAULT 0,
    score2 INTEGER NOT NULL DEFAULT 0    
    )
    """);
  }

  //table for EpreuveExamen
  static Future<void> createTableEpreuves(sql.Database database) async {
    await database.execute("""CREATE TABLE epreuve(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT  NOT NULL,
    type INTEGER NOT NULL ,
    lien TEXT NOT NULL ,
    classe TEXT  NOT NULL
    )
    """);
  }

  static Future<List<Map<String, dynamic>>> getEpreuves(String classe) async {
    final db = await SQLDB.db();
    return db.query('epreuve',
        where: "classe = ? ", whereArgs: [classe], orderBy: "id");
  }

//table for courses
  static Future<void> createTableCours(sql.Database database) async {
    await database.execute("""CREATE TABLE chapitre(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT UNIQUE  NOT NULL,
    description TEXT ,
    cours TEXT NOT NULL ,
    exercise TEXT,
    correction TEXT,
    classe TEXT NOT NULL,
    isdownloaded INTEGER DEFAULT 0
    )
    """);
  }

//la table de Utilisateur
  static Future<int> createUser(
      String name, String prenom, String numero, String classe) async {
    final db = await SQLDB.db();

    final data = {
      'nom': name,
      'prenom': prenom,
      'numero': numero,
      'classe': classe,
    };
    final id = await db.insert('Users', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await SQLDB.db();
    return db.query('Users');
  }

  static Future<void> updateUserClasse(String classe) async {
    final db = await SQLDB.db();

    List<Map<String, dynamic>> data = await db.query('Users', limit: 1);
    if (data.isNotEmpty) {
      int userId = data.first['id'];
      await db.update(
        'Users',
        {'classe': classe},
        where: 'id = ?',
        whereArgs: [userId],
      );
    }
  }

  static Future<void> updateUserMode(String classe) async {
    final db = await SQLDB.db();

    List<Map<String, dynamic>> data = await db.query('Users', limit: 1);
    if (data.isNotEmpty) {
      int userId = data.first['id'];
      await db.update(
        'Users',
        {'mode': classe},
        where: 'id = ?',
        whereArgs: [userId],
      );
    }
  }

//functions about de table chapters
  //
  static Future<int> createChapter(String title, String desc, String icon,
      String cours, String exo, String corr, String cls) async {
    final db = await SQLDB.db();

    final data = {
      'title': title,
      'description': desc,
      'cours': cours,
      'exercise': exo,
      'correction': corr,
      'classe': cls
    };
    final id = await db.insert('chapitre', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getChapters(String classe) async {
    final db = await SQLDB.db();
    return db.query('chapitre',
        where: "classe = ? ", whereArgs: [classe], orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getChapter(String title) async {
    final db = await SQLDB.db();
    return db.query('chapitre',
        where: "title = ? ", whereArgs: [title], limit: 1);
  }

  static Future<int> updateChapterDownloaded(
      String title,
      String desc,
      String icon,
      String cours,
      String exo,
      String corr,
      String cls,
      int id) async {
    final db = await SQLDB.db();
    final data = {
      'title': title,
      'description': desc,
      'cours': cours,
      'exercise': exo,
      'correction': corr,
      'classe': cls,
      'isdownloaded': 1
    };
    final result =
        await db.update('chapitre', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  //functions about de table function
  //

  static Future<int> createFct(String fct) async {
    final db = await SQLDB.db();

    final data = {'function': fct};
    final id = await db.insert('fonctions', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getFonction(int id) async {
    final db = await SQLDB.db();
    return db.query('fonctions', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getFonctions() async {
    final db = await SQLDB.db();
    return db.query(
      'fonctions',
      orderBy: "id DESC",
      distinct: true,
    );
  }

  static Future<int> updateFonction(String fonction, int id) async {
    final db = await SQLDB.db();
    final data = {'function': fonction, 'createdAt': DateTime.now()};

    final result =
        await db.update('fonctions', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteFonction(int id) async {
    final db = await SQLDB.db();
    try {
      await db.delete('fonctions', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("error deleting function");
    }
  }

  //code d insertion de donner par defaut dans la base de donnee

  static Future<void> insertInToDatabase(sql.Database database) async {
    // Insertion de données pour la table 'chapitre'
    await database.execute("""
        INSERT INTO chapitre(
          title,
          description,
          cours,
          exercise,
          correction,
          classe,
          isdownloaded
        )
        VALUES(
          'Nombres Complexes ',
          'Les nombres complexes (i^2=-1)',
          'NombresComplexe_cours.pdf',
          'NombresComplexe_exercice.pdf',
          'NombresComplexe_corrige.pdf',
          'Terminale',
          0
        ),
        (
          'Les limites ',
          'Les limites ',
          'limite.pdf',
          'limite_exercice.pdf',
          'limite_corrige.pdf',
          'Terminale',
          0
        ),
         (
          'LIMITE-CONTINUITE-DERIVATION',
          'Les limites,étude de continuité et la dérivabilité des fonctions ',
          'cous_limite_der.pdf',
          'exo_der.pdf',
          'corrige_der.pdf',
          'Terminale',
          0
        )
        ,
         (
          'DENOMBREMENT- PROBABILITE',
          'Cours, exercices et corrigés de DENOMBREMENT- PROBABILITE',
          'denon_cours.pdf',
          'denom_exo.pdf',
          'denon_corr.pdf',
          'Terminale',
          0
        )
         ,
         (
          'SUITES NUMERIQUES',
          'Cours, exercices et corrigés du chapitre SUITES NUMERIQUES',
          'suite_cours.pdf',
          'suite_exo.pdf',
          'suite_corrig.pdf',
          'Terminale',
          0
        )
         ,
         (
          'Statistiques',
          'Cours, exercices et corrigés du chapitre Statistiques',
          'stat_cous.pdf',
          'stat_exo.pdf',
          'statistique_corr.pdf',
          'Terminale',
          0
        )
         ,
         (
          'PRIMITIVES – CALCUL INTEGRAL EQUATIONS DIFFERENTIELLES',
          'Cours, exercices et corrigés du chapitre INTEGRAL EQUATIONS DIFFERENTIELLES',
          'inte_cour.pdf',
          'int_exo.pdf',
          'int_corr.pdf',
          'Terminale',
          0
        )
          ,
          
          
          
          
          
          
          
          
          
          
         (
          'GENERALITES SUR LES FONCTIONS',
          'Cours, exercices et corrigés du chapitre GENERALITES SUR LES FONCTIONS',
          'cour_gene.pdf',
          'exo_gene.pdf',
          'corri_gene.pdf',
          'Terminale',
          0
        )
        
        
       
        
        
        
         ,
         (
          'Principaux ensembles de nombres',
          'Ensembles de nombres',
          'ensembe_nombres-compressed.pdf',
          'comparer-image-2.pdf',
          'comparer-image-2-corrige.pdf',
          'Seconde',
          0
        )
          ,
         (
          'Somme, différence, produit, quotient, opposé, inverse(Rappel)',
          'algebre',
          'equation_inequation-compressé.pdf',
          'comparer-image-4.pdf',
          'comparer-image-4-corrige.pdf',
          'Seconde',
          0
        ),
         (
          'Equation de droite ',
          'Equation de droite',
          'equation_de_droite-compressé.pdf',
          'vecteur-1.pdf',
          'vecteur-1-corrige.pdf',
          'Seconde',
          0
        ),
         
         (
          'Equation sens de variation ',
          'Equation et variation',
          'equation_sens_variation_etude-de-signe-compressé.pdf',
          'sens-tableau-variation-1.pdf',
          'sens-tableau-variation-1-corrige.pdf',
          'Seconde',
          0
        ),
         (
          'Etude de divers fonctions ',
          'Etude de fonctions',
          'etudes_de_divers_fonctions-compressé.pdf',
          'sens-tableau-variation-4.pdf',
          'tableau-variation-courbe-4-corrige.pdf',
          'Seconde',
          0
        ),
         (
          'Modelisation de fonctions ',
          'Modelisation de queleques fonctions ',
          'modeliser_par_fonction-compressé.pdf',
          'extremas-locaux-4.pdf',
          'extremas-locaux-4-corrige.pdf',
          'Seconde',
          0
        ),
         (
          'sens de variation de fonctions ',
          'Sens de variations des fonctions ',
          'sens_de_variation-compressé.pdf',
          'extrema-representation-graphique-1.pdf',
          'extrema-representation-graphique-1-corrige.pdf',
          'Seconde',
          0
        ),
         (
          'Vecteur reperage  ',
          'Vecteur et repérage ',
          'vecteur_reperage-compressé.pdf',
          'extremas-locaux-2.pdf',
          'extremas-locaux-2-corrige.pdf',
          'Seconde',
          0
        )
            
        
        ,
         (
          'Barycentre ',
          'Barycentre des points',
          'barycentre-compressé.pdf',
          'exo_bary.pdf',
          'corrige_bary.pdf',
          'Première',
          0
        )
        
        
         ,
         (
          'Dérivabilité des fonctions  ',
          'Dérivabilité ',
          'derivation_fonction-compressé.pdf',
          'derivee-fraction-1.pdf',
          'derivee-fraction-1-corrige.pdf',
          'Première',
          0
        )
         ,
         (
          'Etude des fonctions  ',
          'Généralité sur les fonctions  ',
          'generalite_fonction-compressé.pdf',
          'sens-de-variation-fonction-2.pdf',
          'sens-de-variation-fonction-2-corrige.pdf',
          'Première',
          0
        )
         ,
         (
          'Limites des fonctions  ',
          'Limites des fonctions  ',
          'limite_fontion-compressé.pdf',
          'derivee-fraction-3.pdf',
          'derivee-fraction-3-corrige.pdf',
          'Première',
          0
        )
         ,
         (
          'Polynome du second dégré  ',
          'Polynomes du second degré ',
          'polynome_second_degré-compressé.pdf',
          'equation-2nd-degre-1.pdf',
          'equation-2nd-degre-1-corrige.pdf',
          'Première',
          0
        )
         ,
         (
          'Suites numériques  ',
          'suites numériques ',
          'suite_numerique-compressé.pdf',
          'suite-arithmetique-geometrique-2.pdf',
          'suite-arithmetique-geometrique-2-corrige.pdf',
          'Première',
          0
        )  ,
         (
          'Statistiques ',
          'Les Statistiques ',
          'statistiques-compressé.pdf',
          'statistique_exo.pdf',
          'statistique_exo.pdf',
          'Première',
          0
        ) ,
         (
          'Transformations du plan ',
          'Les Transformations ',
          'transformation_du_plan-compressé.pdf',
          'transform_plan.pdf',
          'transfor_plan.pdf',
          'Première',
          0
        )
         ,
         (
          'Trigonométrie  ',
          'Les Trigonométries ',
          'trigonometrie-compressé.pdf',
          'cercle-trigonometrique-4.pdf',
          'cercle-trigonometrique-4-corrige.pdf',
          'Première',
          0
        ) ,
         (
          'Probabilités   ',
          'Les Probabilités et Dénombrement ',
          'probabilité-compressé.pdf',
          'pro_premiere.pdf',
          'pro_premiere2.pdf',
          'Première',
          0
        )
      """);

    await database.execute("""
        INSERT INTO activite(nfonction,nquiz1,nquiz2,nrecherche)
        VALUES
        (0,0,0,0)
        
        """);
    await database.execute("""
        INSERT INTO abonner(state)
        VALUES
        (0)
       
        """);

    // Premieres 5 épreuves ont le type 1, les autres ont le type 0
    await database.execute("""
        INSERT INTO epreuve(
          title,
          type,
          lien,
          classe
        )
        VALUES
        (
          'BAC_AMN_2012 ',
             0,
             'sujet-bac-s-math-amn-2012.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_AMN_2012 ',
             1,
             'corrige-bac-s-math-amn-2012.pdf',
          'Terminale'
        ),
        
         (
          'BAC_AMN_2017 ',
             0,
             'sujet-bac-s-math-amn-2017.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_AMN_2017 ',
             1,
             'corrige-bac-s-math-amn-2017.pdf',
          'Terminale'
        ),
         (
          'BAC_AMN_2017 ',
             0,
             'sujet-bac-s-math-amn-2019.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_AMN_2019 ',
             1,
             'corrige-bac-s-math-amn-2019.pdf',
          'Terminale'
        ),
         (
          'BAC_AMS_2019 ',
             0,
             'sujet-bac-s-math-ams-2019.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_AMS_2019 ',
             1,
             'corrige-bac-s-math-ams-2019.pdf',
          'Terminale'
        ),
         (
          'BAC_antilles_2019 ',
             0,
             'sujet-bac-s-math-antilles-guyane-1-2017.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_antilles_2017 ',
             1,
             'corrige-bac-s-math-antilles-guyane-1-2017.pdf',
          'Terminale'
        ),
         (
          'BAC_antilles_2020 ',
             0,
             'sujet-bac-s-math-antilles-guyane-1-2020.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_antilles_2020 ',
             1,
             'corrige-bac-s-math-antilles-guyane-1-2020.pdf',
          'Terminale'
        ),
         (
          'BAC_ASIE_2012 ',
             0,
             'sujet-bac-s-math-asie-2012.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_antilles_2012 ',
             1,
             'corrige-bac-s-math-asie-2012.pdf',
          'Terminale'
        ),
        (
          'BAC_ASIE_2015 ',
             0,
             'sujet-bac-s-math-asie-2015.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_antilles_2015 ',
             1,
             'corrige-bac-s-math-asie-2015.pdf',
          'Terminale'
        ),
        (
          'BAC_caledonie_2020 ',
             0,
             'sujet-bac-s-math-caledonie-1-2020.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_caledonie_2020 ',
             1,
             'corrige-bac-s-math-caledonie-1-2020.pdf',
          'Terminale'
        ),
        
        (
          'BAC_caledonie_2016 ',
             0,
             'sujet-bac-s-math-caledonie-2016.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_caledonie_2016 ',
             1,
             'corrige-bac-s-math-caledonie-2016.pdf',
          'Terminale'
        ),
        
        
        (
          'BAC_2019 ',
             0,
             'sujet-bac-s-math-etranger-2019.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_BAC_2019',
             1,
             'corrige-bac-s-math-etranger-2019.pdf',
          'Terminale'
        ),
        
        (
          'BAC_Liban_2012 ',
             0,
             'sujet-bac-s-math-liban-2012.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_liban_2012',
             1,
             'corrige-bac-s-math-liban-2012.pdf',
          'Terminale'
        ),
        (
          'BAC_Liban_2013 ',
             0,
             'sujet-bac-s-math-liban-2013.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_liban_2013',
             1,
             'corrige-bac-s-math-liban-2013.pdf',
          'Terminale'
        ),
        
        (
          'BAC_Liban_2016 ',
             0,
             'sujet-bac-s-math-liban-2016.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_liban_2016',
             1,
             'corrige-bac-s-math-liban-2016.pdf',
          'Terminale'
        ),
        
         (
          'BAC_Liban_2018 ',
             0,
             'sujet-bac-s-math-liban-2018.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_liban_2018',
             1,
             'corrige-bac-s-math-liban-2018.pdf',
          'Terminale'
        ),
        
         (
          'BAC_Liban_2019 ',
             0,
             'sujet-bac-s-math-liban-2019.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_liban_2019',
             1,
             'corrige-bac-s-math-liban-2019.pdf',
          'Terminale'
        ),
        
        
         (
          'BAC_metropole_2012 ',
             0,
             'sujet-bac-s-math-metropole-1-2012.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_metropole_2012',
             1,
             'corrige-bac-s-math-metropole-1-2012.pdf',
          'Terminale'
        ),
        
        
         
         (
          'BAC_metropole_2017 ',
             0,
             'sujet-bac-s-math-metropole-1-2017.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_metropole_2017',
             1,
             'corrige-bac-s-math-metropole-1-2017.pdf',
          'Terminale'
        ),
        
         (
          'BAC_metropole_2018 ',
             0,
             'sujet-bac-s-math-metropole-1-2018.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_metropole_2018',
             1,
             'corrige-bac-s-math-metropole-1-2018.pdf',
          'Terminale'
        ),
        
        (
          'BAC_metropole_2019 ',
             0,
             'sujet-bac-s-math-metropole-1-2019.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_metropole_2019',
             1,
             'corrige-bac-s-math-metropole-1-2019.pdf',
          'Terminale'
        ),
        
        (
          'BAC_metropole_2020 ',
             0,
             'sujet-bac-s-math-metropole-1-2020.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_metropole_2019',
             1,
             'corrige-bac-s-math-metropole-1-2020.pdf',
          'Terminale'
        ),
        
         (
          'BAC_metropole_2_2012 ',
             0,
             'sujet-bac-s-math-metropole-2-2012.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_metropole_2_2012',
             1,
             'corrige-bac-s-math-metropole-2-2012.pdf',
          'Terminale'
        ),
        
         (
          'BAC_metropole_2_2017 ',
             0,
             'sujet-bac-s-math-metropole-2-2017.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_metropole_2_2017',
             1,
             'corrige-bac-s-math-metropole-2-2017.pdf',
          'Terminale'
        ),
        
        
         (
          'BAC_polynesie_1_2012 ',
             0,
             'sujet-bac-s-math-polynesie-1-2012.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_polynesie_1_2012',
             1,
             'corrige-bac-s-math-polynesie-1-2012.pdf',
          'Terminale'
        ),
        
           (
          'BAC_polynesie_1_2016 ',
             0,
             'sujet-bac-s-math-polynesie-1-2016.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_polynesie_1_2016',
             1,
             'corrige-bac-s-math-polynesie-1-2016.pdf',
          'Terminale'
        ),
        
         (
          'BAC_polynesie_1_2018 ',
             0,
             'sujet-bac-s-math-polynesie-1-2018.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_polynesie_1_2018',
             1,
             'corrige-bac-s-math-polynesie-1-2018.pdf',
          'Terminale'
        ),
        
          (
          'BAC_polynesie_1_2019 ',
             0,
             'sujet-bac-s-math-polynesie-1-2019.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_polynesie_1_2019',
             1,
             'corrige-bac-s-math-metropole-1-2019.pdf',
          'Terminale'
        ),
        
          (
          'BAC_polynesie_1_2020 ',
             0,
             'sujet-bac-s-math-polynesie-1-2020.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_polynesie_1_2020',
             1,
             'corrige-bac-s-math-metropole-1-2020.pdf',
          'Terminale'
        ),
         (
          'BAC_pondichery_2013 ',
             0,
             'sujet-bac-s-math-pondichery-2013.pdf',
          'Terminale'
        ) ,
        (
          'Corrigé_pondichery_2013',
             1,
             'corrige-bac-s-math-pondichery-2013.pdf',
          'Terminale'
        )
        
        
        
        
        ,
         (
          'Devoir_1',
             0,
             'devoir-commun-math-6-lycee-jacques-prevert.pdf',
          'Première'
        ) ,
        (
          'Corrigé_Devoir_1',
             1,
             'devoir-commun-math-6-lycee-jacques-prevert-corrige.pdf',
          'Première'
        )
         ,
         (
          'Devoir_2',
             0,
             'devoir-commun-math-3-lycee-pissarro.pdf',
          'Première'
        ) ,
        (
          'Corrigé_Devoir_2',
             1,
             'devoir-commun-math-3-lycee-pissarro-corrige.pdf',
          'Première'
        )
        
         ,
         (
          'Devoir_3',
             0,
             'devoir-commun-math-2-lycee-pissarro.pdf',
          'Première'
        ) ,
        (
          'Corrigé_Devoir_3',
             1,
             'devoir-commun-math-2-lycee-pissarro-corrige.pdf',
          'Première'
        )
        
        ,
         (
          'Devoir_4',
             0,
             'devoir-commun-math-1-lycee-jp-sartre.pdf',
          'Première'
        ) ,
        (
          'Corrigé_Devoir_4',
             1,
             'devoir-commun-math-1-lycee-jp-sartre-corrige.pdf',
          'Première'
        )
        
         ,
         (
          'Devoir_5',
             0,
             'devoir-commun-math-1-lycee-bellevue.pdf',
          'Première'
        ) ,
        (
          'Corrigé_Devoir_5',
             1,
             'devoir-commun-math-1-lycee-bellevue-corrige.pdf',
          'Première'
        )
        
         ,
         (
          'Devoir_6',
             0,
             'devoir-commun-1ere-s-maths-2.pdf',
          'Première'
        ) ,
        (
          'Corrigé_Devoir_6',
             1,
             'devoir-commun-1ere-s-maths-2-corrige.pdf',
          'Première'
        )
        
         ,
         (
          'Devoir_sans-correction',
             0,
             'devoir-commun-1ere-s-maths-8-sans-correction.pdf',
          'Première'
        ) ,
        (
          'Devoir_avec-corrigé',
             1,
             'devoir-commun-math-5-lycee-blanche2-castille-avec-corrige.pdf',
          'Première'
        )
         ,
         (
          'Devoir_sans-correction_2',
             0,
             'devoir-commun-1ere-s-maths-7-sans-correction.pdf',
          'Première'
        )
        
        ,
         (
          'Devoir_sans-correction_3',
             0,
             'devoir-commun-1ere-s-maths-6-sans-correction.pdf',
          'Première'
        )
         ,
         (
          'Devoir_sans-correction_4',
             0,
             'devoir-commun-1ere-s-maths-5-sans-correction.pdf',
          'Première'
        )
         ,
         (
          'Devoir_sans-correction_5',
             0,
             'devoir-commun-1ere-s-maths-3-sans-correction.pdf',
          'Première'
        ) ,
         (
          'Devoir_sans-correction_6',
             0,
             'devoir-commun-1ere-s-maths-4-sans-correction.pdf',
          'Première'
        )
        
        
        
        
         ,
         (
          'Devoir_1',
             0,
             'devoir-commun-math-1-lycee-jacques-prevert.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_1',
             1,
             'devoir-commun-math-1-lycee-jacques-prevert-corrige.pdf',
          'Seconde'
        ),
         (
          'Devoir_2',
             0,
             'devoir-commun-math-4-lycee-jacques-prevert.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_2',
             1,
             'devoir-commun-math-4-lycee-jacques-prevert-corrige.pdf',
          'Seconde'
        )
        ,
         (
          'Devoir_3',
             0,
             'devoir-commun-math-3-lycee-jacques-prevert.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_3',
             1,
             'devoir-commun-math-3-lycee-jacques-prevert-corrige.pdf',
          'Seconde'
        )
        
         ,
         (
          'Devoir_4',
             0,
             'devoir-commun-math-7-lycee-jacques-prevert.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_4',
             1,
             'devoir-commun-math-7-lycee-jacques-prevert-corrige.pdf',
          'Seconde'
        )
        
        ,
         (
          'Devoir_5',
             0,
             'devoir-commun-math-9-lycee-jacques-prevert.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_5',
             1,
             'devoir-commun-math-9-lycee-jacques-prevert-corrige.pdf',
          'Seconde'
        )
        
         ,
         (
          'Devoir_6',
             0,
             'devoir-commun-math-1-lycee-alain-le-vesinet.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_6',
             1,
             'devoir-commun-math-1-lycee-alain-le-vesinet-corrige.pdf',
          'Seconde'
        )
        
         ,
         (
          'Devoir_7',
             0,
             'devoir-commun-math-1-lycee-bellepierre.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_7',
             1,
             'devoir-commun-math-1-lycee-bellepierre-corrige.pdf',
          'Seconde'
        )
        ,
         (
          'Devoir_8',
             0,
             'devoir-commun-math-2-lycee-frederic-mistral.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_8',
             1,
             'devoir-commun-math-2-lycee-frederic-mistral-corrige.pdf',
          'Seconde'
        )
        
         ,
         (
          'Devoir_9',
             0,
             'devoir-commun-math-3-lycee-marie-reynoard.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_9',
             1,
             'devoir-commun-math-3-lycee-marie-reynoard-corrige.pdf',
          'Seconde'
        )
        
         ,
         (
          'Devoir_10',
             0,
             'devoir-commun-2nde-maths-9.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_10',
             1,
             'devoir-commun-2nde-maths-9-corrige.pdf',
          'Seconde'
        )
         ,
         (
          'Devoir_11',
             0,
             'devoir-commun-2nde-maths-6.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_11',
             1,
             'devoir-commun-2nde-maths-6-corrige.pdf',
          'Seconde'
        )
         ,
         (
          'Devoir_12',
             0,
             'devoir-commun-2nde-maths-2.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_12',
             1,
             'devoir-commun-2nde-maths-2-corrige.pdf',
          'Seconde'
        )
         ,
         (
          'Devoir_13',
             0,
             'devoir-commun-2nde-maths-2.pdf',
          'Seconde'
        ) ,
        (
          'Corrigé_Devoir_13',
             1,
             'devoir-commun-2nde-maths-2-corrige.pdf',
          'Seconde'
        )
        
         ,
         (
          'Devoir_sans-corrigé',
             0,
             'devoir-commun-2nde-maths-1-sans-corrige.pdf',
          'Seconde'
        )  ,
         (
          'Devoir_sans-corrigé',
             0,
             'devoir-commun-2nde-maths-7-sans-corrige.pdf',
          'Seconde'
        )  ,
         (
          'Devoir_sans-corrigé',
             0,
             'devoir-commun-2nde-maths-8-sans-corrige.pdf',
          'Seconde'
        )  ,
         (
          'Devoir_sans-corrigé',
             0,
             'devoir-commun-2nde-maths-5-sans-corrige.pdf',
          'Seconde'
        )  ,
         (
          'Devoir_sans-corrigé',
             0,
             'devoir-commun-2nde-maths-4-sans-corrige.pdf',
          'Seconde'
        )  ,
         (
          'Devoir_sans-corrigé',
             0,
             'devoir-commun-2nde-maths-3-sans-corrige.pdf',
          'Seconde'
        )  ,
         (
          'Devoir_sans-corrigé',
             0,
             'devoir-commun-2nde-maths-2-sans-corrige.pdf',
          'Seconde'
        ) 
        
      """);

    await database.execute("""
    INSERT INTO citations (contenue, auteur)
    VALUES
      ("Le succès consiste à aller d'échec en échec sans perdre son enthousiasme.", 'Winston Churchill'),
      ("Ne laissez pas ce que vous ne pouvez pas faire entraver ce que vous pouvez faire.", 'John Wooden'),
      ("L'avenir appartient à ceux qui croient en la beauté de leurs rêves.", 'Eleanor Roosevelt'),
      ("La persévérance est la clé du succès.", 'Albert Einstein'),
      ("Vous êtes plus fort que vous ne le pensez. Croyez en vous.", 'Chantal Sutherland'),
      ("Chaque jour est une nouvelle opportunité de devenir une meilleure version de vous-même.", 'Inconnu'),
      ("Le succès n'est pas final, l'échec n'est pas fatal : c'est le courage de continuer qui compte.", 'Winston Churchill'),
      ("La motivation vous sert de départ. L'habitude vous fait continuer.", 'Jim Rohn'),
      ("Le succès est la somme de petits efforts répétés jour après jour.", 'Robert Collier'),
      ("Visez la lune. Même si vous échouez, vous atterrirez parmi les étoiles.", 'Les Brown'),
      ("La meilleure façon de prédire l'avenir, c'est de le créer.", 'Peter Drucker'),
      ("Le succès, c'est de passer d'échec en échec sans perdre son enthousiasme.", 'Winston Churchill'),
      ("Vous ne trouverez jamais de moment parfait. Commencez là où vous êtes, avec ce que vous avez, et faites de votre mieux.", 'Inconnu'),
      ("L'enthousiasme est le feu qui donne de la vie à l'âme.", 'Henry Ford'),
      ("Si vous voulez accomplir de grandes choses, vous devez d'abord vous convaincre que vous le pouvez.", 'Inconnu'),
      ("Le succès n'est pas la clé du bonheur. Le bonheur est la clé du succès. Si vous aimez ce que vous faites, vous réussirez.", 'Albert Schweitzer'),
      ("La réussite n'est pas un accident. C'est le résultat de l'effort constant, de la persévérance, de l'apprentissage, de la préparation et de l'amour pour ce que vous faites.", 'Colin Powell'),
      ("N'attendez pas l'inspiration. Soyez la motivation.", 'Inconnu'),
      ("La seule façon de faire un excellent travail, c'est d'aimer ce que vous faites.", 'Steve Jobs'),
      ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
      ("Le secret du succès, c'est de savoir quelque chose que personne d'autre ne sait.", 'Aristotle Onassis'),
      ("La persévérance n'est pas une longue course, c'est beaucoup de petites courses jour après jour.", 'Walter Elliot'),
      ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
      ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
      ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
      ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
      ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
      ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
      ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
      ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
      ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
      ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
      ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
      ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
      ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
      ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
      ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
      ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
      ("Lorsque vous croyez en vous, tout est possible.", 'Inconnu'),
      ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
      ("La persévérance est la clé du succès.", 'Albert Einstein'),
      ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
      ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
      ("Soyez la personne qui décide de faire quelque chose, plutôt que celle qui se demande pourquoi quelque chose n'a pas été fait.", 'Inconnu'),
      ("N'attendez pas d'être inspiré pour commencer. Commencez à travailler et l'inspiration viendra.", 'Jim Rohn'),
      ("Le succès est la somme de petits efforts répétés jour après jour.", 'Inconnu'),
      ("Le secret du succès, c'est de savoir quelque chose que personne d'autre ne sait.", 'Aristotle Onassis'),
      ("La persévérance n'est pas une longue course, c'est beaucoup de petites courses jour après jour.", 'Walter Elliot'),
      ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
      ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
      ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
      ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
      ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
      ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
      ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
      ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
      ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
      ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
      ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
      ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
      ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
      ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
      ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
      ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
      ("Lorsque vous croyez en vous, tout est possible.", 'Inconnu'),
      ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
      ("La persévérance est la clé du succès.", 'Albert Einstein'),
      ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
      ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
       ("Le succès, c'est la somme de petits efforts répétés jour après jour.", 'Robert Collier'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Soyez la personne qui décide de faire quelque chose, plutôt que celle qui se demande pourquoi quelque chose n'a pas été fait.", 'Inconnu'),
  ("N'attendez pas d'être inspiré pour commencer. Commencez à travailler et l'inspiration viendra.", 'Jim Rohn'),
  ("Le succès est la somme de petits efforts répétés jour après jour.", 'Inconnu'),
  ("Le secret du succès, c'est de savoir quelque chose que personne d'autre ne sait.", 'Aristotle Onassis'),
  ("La persévérance n'est pas une longue course, c'est beaucoup de petites courses jour après jour.", 'Walter Elliot'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous croyez en vous, tout est possible.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Soyez la personne qui décide de faire quelque chose, plutôt que celle qui se demande pourquoi quelque chose n'a pas été fait.", 'Inconnu'),
  ("N'attendez pas d'être inspiré pour commencer. Commencez à travailler et l'inspiration viendra.", 'Jim Rohn'),
  ("Le succès est la somme de petits efforts répétés jour après jour.", 'Inconnu'),
  ("Le secret du succès, c'est de savoir quelque chose que personne d'autre ne sait.", 'Aristotle Onassis'),
  ("La persévérance n'est pas une longue course, c'est beaucoup de petites courses jour après jour.", 'Walter Elliot'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous croyez en vous, tout est possible.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Soyez la personne qui décide de faire quelque chose, plutôt que celle qui se demande pourquoi quelque chose n'a pas été fait.", 'Inconnu'),
  ("N'attendez pas d'être inspiré pour commencer. Commencez à travailler et l'inspiration viendra.", 'Jim Rohn'),
  ("Le succès est la somme de petits efforts répétés jour après jour.", 'Inconnu'),
  ("Le secret du succès, c'est de savoir quelque chose que personne d'autre ne sait.", 'Aristotle Onassis'),
  ("La persévérance n'est pas une longue course, c'est beaucoup de petites courses jour après jour.", 'Walter Elliot'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous croyez en vous, tout est possible.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
   ("L'éducation est l'arme la plus puissante que vous pouvez utiliser pour changer le monde.", 'Nelson Mandela'),
  ("Le savoir est la clé du succès, l'éducation est la passerelle vers l'avenir.", 'Malcolm X'),
  ("L'apprentissage ne cesse jamais. L'éducation est l'arme la plus puissante que vous pouvez utiliser pour changer le monde.", 'Nelson Mandela'),
  ("Le succès n'est pas la clé du bonheur. Le bonheur est la clé du succès. Si vous aimez ce que vous faites, vous réussirez.", 'Albert Schweitzer'),
  ("L'avenir appartient à ceux qui croient en la beauté de leurs rêves.", 'Eleanor Roosevelt'),
  ("L'éducation coûte de l'argent, mais l'ignorance en coûte davantage.", 'Sir Claus Moser'),
  ("La plus grande gloire dans la vie ne réside pas dans le fait de ne jamais tomber, mais dans celui de se relever à chaque fois que l'on tombe.", 'Nelson Mandela'),
  ("La paresse est un vol, elle vous vole votre temps, votre énergie et votre potentiel.", 'Nanette Mathews'),
  ("Le succès n'est pas la destination, c'est le voyage.", 'Zig Ziglar'),
  ("L'éducation est l'arme la plus puissante que vous puissiez utiliser pour changer le monde.", 'Nelson Mandela'),
  ("L'effort que vous mettez dans votre éducation paiera les plus gros dividendes.", 'Jim Rohn'),
  ("La seule manière de faire du bon travail est d'aimer ce que vous faites.", 'Steve Jobs'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("L'apprentissage est un trésor qui suivra son propriétaire partout.", 'Proverbe chinois'),
  ("La meilleure façon de prédire l'avenir, c'est de le créer.", 'Peter Drucker'),
  ("Le succès, c'est de passer de l'échec en échec sans perdre son enthousiasme.", 'Winston Churchill'),
  ("Le succès ne consiste pas à atteindre la ligne d'arrivée, mais à profiter du voyage.", 'Zig Ziglar'),
  ("L'objectif de l'éducation est de remplacer un esprit vide par un esprit ouvert.", 'Malcolm Forbes'),
  ("L'éducation coûte de l'argent, mais l'ignorance coûte davantage.", 'Sir Claus Moser'),
  ("Le savoir est le pouvoir. L'éducation est la clé.", 'Kofi Annan'),
  ("La persévérance est le secret de la réussite.", 'Calvin Coolidge'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Ne laissez pas l'éducation interférer avec votre apprentissage.", 'Mark Twain'),
  ("L'éducation est la clé pour ouvrir la porte en or de la liberté.", 'George Washington Carver'),
  ("La plus grande gloire dans la vie ne réside pas dans le fait de ne jamais tomber, mais dans celui de se relever à chaque fois que l'on tombe.", 'Nelson Mandela'),
  ("La paresse est un vol, elle vous vole votre temps, votre énergie et votre potentiel.", 'Nanette Mathews'),
  ("Le succès n'est pas la destination, c'est le voyage.", 'Zig Ziglar'),
  ("L'éducation est l'arme la plus puissante que vous puissiez utiliser pour changer le monde.", 'Nelson Mandela'),
  ("L'effort que vous mettez dans votre éducation paiera les plus gros dividendes.", 'Jim Rohn'),
  ("La seule manière de faire du bon travail est d'aimer ce que vous faites.", 'Steve Jobs'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("L'apprentissage est un trésor qui suivra son propriétaire partout.", 'Proverbe chinois'),
  ("La meilleure façon de prédire l'avenir, c'est de le créer.", 'Peter Drucker'),
  ("Le succès, c'est de passer de l'échec en échec sans perdre son enthousiasme.", 'Winston Churchill'),
  ("Le succès ne consiste pas à atteindre la ligne d'arrivée, mais à profiter du voyage.", 'Zig Ziglar'),
  ("L'objectif de l'éducation est de remplacer un esprit vide par un esprit ouvert.", 'Malcolm Forbes'),
  ("L'éducation coûte de l'argent, mais l'ignorance coûte davantage.", 'Sir Claus Moser'),
  ("Le savoir est le pouvoir. L'éducation est la clé.", 'Kofi Annan'),
  ("La persévérance est le secret de la réussite.", 'Calvin Coolidge'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Ne laissez pas l'éducation interférer avec votre apprentissage.", 'Mark Twain'),
  ("L'éducation est la clé pour ouvrir la porte en or de la liberté.", 'George Washington Carver'),
  ("L'éducation est l'arme la plus puissante que vous puissiez utiliser pour changer le monde.", 'Nelson Mandela'),
  ("L'effort que vous mettez dans votre éducation paiera les plus gros dividendes.", 'Jim Rohn'),
  ("La seule manière de faire du bon travail est d'aimer ce que vous faites.", 'Steve Jobs'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("L'apprentissage est un trésor qui suivra son propriétaire partout.", 'Proverbe chinois'),
  ("La meilleure façon de prédire l'avenir, c'est de le créer.", 'Peter Drucker'),
  ("Le succès, c'est de passer de l'échec en échec sans perdre son enthousiasme.", 'Winston Churchill'),
  ("Le succès ne consiste pas à atteindre la ligne d'arrivée, mais à profiter du voyage.", 'Zig Ziglar'),
  ("L'objectif de l'éducation est de remplacer un esprit vide par un esprit ouvert.", 'Malcolm Forbes'),
  ("L'éducation coûte de l'argent, mais l'ignorance coûte davantage.", 'Sir Claus Moser'),
  ("Le savoir est le pouvoir. L'éducation est la clé.", 'Kofi Annan'),
  ("La persévérance est le secret de la réussite.", 'Calvin Coolidge'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Ne laissez pas l'éducation interférer avec votre apprentissage.", 'Mark Twain'),
  ("L'éducation est la clé pour ouvrir la porte en or de la liberté.", 'George Washington Carver'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("N'attendez pas l'occasion, créez-la.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Ben Sweetland'),
  ("L'apprentissage ne cesse jamais. L'éducation est l'arme la plus puissante que vous pouvez utiliser pour changer le monde.", 'Nelson Mandela'),
  ("Le succès n'est pas la clé du bonheur. Le bonheur est la clé du succès. Si vous aimez ce que vous faites, vous réussirez.", 'Albert Schweitzer'),
  ("L'avenir appartient à ceux qui croient en la beauté de leurs rêves.", 'Eleanor Roosevelt'),
  ("L'éducation coûte de l'argent, mais l'ignorance en coûte davantage.", 'Sir Claus Moser'),
  ("La plus grande gloire dans la vie ne réside pas dans le fait de ne jamais tomber, mais dans celui de se relever à chaque fois que l'on tombe.", 'Nelson Mandela'),
  ("La paresse est un vol, elle vous vole votre temps, votre énergie et votre potentiel.", 'Nanette Mathews'),
  ("Le succès n'est pas la destination, c'est le voyage.", 'Zig Ziglar'),
  ("L'éducation est l'arme la plus puissante que vous puissiez utiliser pour changer le monde.", 'Nelson Mandela'),
  ("L'effort que vous mettez dans votre éducation paiera les plus gros dividendes.", 'Jim Rohn'),
  ("La seule manière de faire du bon travail est d'aimer ce que vous faites.", 'Steve Jobs'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("L'apprentissage est un trésor qui suivra son propriétaire partout.", 'Proverbe chinois'),
  ("La meilleure façon de prédire l'avenir, c'est de le créer.", 'Peter Drucker'),
  ("Le succès, c'est de passer de l'échec en échec sans perdre son enthousiasme.", 'Winston Churchill'),
  ("Le succès ne consiste pas à atteindre la ligne d'arrivée, mais à profiter du voyage.", 'Zig Ziglar'),
  ("L'objectif de l'éducation est de remplacer un esprit vide par un esprit ouvert.", 'Malcolm Forbes'),
  ("L'éducation coûte de l'argent, mais l'ignorance coûte davantage.", 'Sir Claus Moser'),
  ("Le savoir est le pouvoir. L'éducation est la clé.", 'Kofi Annan'),
  ("La persévérance est le secret de la réussite.", 'Calvin Coolidge'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Ne laissez pas l'éducation interférer avec votre apprentissage.", 'Mark Twain'),
  ("L'éducation est la clé pour ouvrir la porte en or de la liberté.", 'George Washington Carver'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("N'attendez pas l'occasion, créez-la.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Ben Sweetland'),
  ("Le travail acharné bat le talent quand le talent ne travaille pas dur.", 'Tim Notke'),
  ("La seule limite à notre réalisation du demain sera nos doutes d'aujourd'hui.", 'Franklin D. Roosevelt'),
  ("L'effort que vous mettez aujourd'hui ouvrira les portes pour demain.", 'Inconnu'),
  ("Le travail dur bat le talent lorsque le talent ne travaille pas dur.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Inconnu'),
  ("Ne vous attendez pas à voir un changement si vous n'apportez pas un changement.", 'Inconnu'),
  ("L'avenir dépend de ce que vous faites aujourd'hui.", 'Mahatma Gandhi'),
  ("Le succès n'est pas final, l'échec n'est pas fatal : c'est le courage de continuer qui compte.", 'Winston Churchill'),
  ("La seule manière de faire du bon travail est d'aimer ce que vous faites.", 'Steve Jobs'),
  ("Le secret de progresser est de commencer.", 'Mark Twain'),
  ("L'éducation est la clé du succès dans la vie, et les enseignants ont un impact durable sur l'avenir.", 'Solomon Ortiz'),
  ("Le succès commence par la volonté de réussir.", 'John C. Maxwell'),
  ("Le rêve est le début de toute réalisation.", 'Lailah Gifty Akita'),
  ("Chaque jour est une nouvelle opportunité de devenir la meilleure version de vous-même.", 'Inconnu'),
  ("N'ayez pas peur de la difficulté, c'est souvent là que vous trouverez les plus grandes opportunités.", 'Inconnu'),
  ("Le succès n'est pas donné, il est gagné.", 'Inconnu'),
  ("La persévérance est la clé du succès, peu importe à quel point les choses peuvent être difficiles.", 'Inconnu'),
  ("L'effort que vous mettez aujourd'hui détermine vos réussites de demain.", 'Inconnu'),
  ("Le succès n'est pas un accident. C'est du travail, de la persévérance, de l'apprentissage, de l'étude, du sacrifice et surtout, de l'amour pour ce que vous faites.", 'Pele'),
  ("La réussite n'est pas la clé du bonheur. Le bonheur est la clé de la réussite. Si vous aimez ce que vous faites, vous réussirez.", 'Albert Schweitzer'),
  ("Le plus grand échec est de ne pas avoir essayé.", 'Deirdre Blomfield Brown'),
  ("Soyez prêt à saisir les opportunités qui se présentent, car parfois elles ne se présentent qu'une fois.", 'Inconnu'),
  ("Lorsque tout semble être contre vous, souvenez-vous que l'avion décolle contre le vent, pas avec lui.", 'Henry Ford'),
  ("L'échec est le premier pas vers le succès.", 'Inconnu'),
  ("Le succès est la somme de petits efforts répétés jour après jour.", 'Robert Collier'),
  ("La meilleure façon de prédire l'avenir, c'est de le créer.", 'Peter Drucker'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("N'attendez pas l'occasion, créez-la.", 'Inconnu'),
  ("Le succès est un voyage, pas une destination.", 'Zig Ziglar'),
  ("La persévérance est la clé du succès.", 'Inconnu'),
  ("Soyez la personne qui décide de faire quelque chose, plutôt que celle qui se demande pourquoi quelque chose n'a pas été fait.", 'Inconnu'),
  ("Le succès est la somme de petits efforts répétés jour après jour.", 'Inconnu'),
  ("Le secret du succès, c'est de savoir quelque chose que personne d'autre ne sait.", 'Aristotle Onassis'),
  ("La persévérance n'est pas une longue course, c'est beaucoup de petites courses jour après jour.", 'Walter Elliot'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous croyez en vous, tout est possible.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Soyez la personne qui décide de faire quelque chose, plutôt que celle qui se demande pourquoi quelque chose n'a pas été fait.", 'Inconnu'),
  ("N'attendez pas d'être inspiré pour commencer. Commencez à travailler et l'inspiration viendra.", 'Jim Rohn'),
  ("Le succès est la somme de petits efforts répétés jour après jour.", 'Inconnu'),
  ("Le secret du succès, c'est de savoir quelque chose que personne d'autre ne sait.", 'Aristotle Onassis'),
  ("La persévérance n'est pas une longue course, c'est beaucoup de petites courses jour après jour.", 'Walter Elliot'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous avez une vision claire de ce que vous voulez, il est beaucoup plus facile de l'atteindre.", 'Inconnu'),
  ("Le succès, c'est se relever plus souvent qu'on tombe.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous croyez en vous, tout est possible.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Ne laissez pas l'éducation interférer avec votre apprentissage.", 'Mark Twain'),
  ("L'éducation est la clé pour ouvrir la porte en or de la liberté.", 'George Washington Carver'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("N'attendez pas l'occasion, créez-la.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Ben Sweetland'),
  ("Le travail acharné bat le talent quand le talent ne travaille pas dur.", 'Tim Notke'),
  ("La seule limite à notre réalisation du demain sera nos doutes d'aujourd'hui.", 'Franklin D. Roosevelt'),
  ("L'effort que vous mettez aujourd'hui ouvrira les portes pour demain.", 'Inconnu'),
  ("Le travail dur bat le talent lorsque le talent ne travaille pas dur.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Inconnu'),
  ("Ne vous attendez pas à voir un changement si vous n'apportez pas un changement.", 'Inconnu'),
  ("L'avenir dépend de ce que vous faites aujourd'hui.", 'Mahatma Gandhi'),
  ("Le succès n'est pas final, l'échec n'est pas fatal : c'est le courage de continuer qui compte.", 'Winston Churchill'),
  ("La seule manière de faire du bon travail est d'aimer ce que vous faites.", 'Steve Jobs'),
  ("Le secret de progresser est de commencer.", 'Mark Twain'),
  ("L'éducation est la clé du succès dans la vie, et les enseignants ont un impact durable sur l'avenir.", 'Solomon Ortiz'),
   ("La clé de la réussite est de commencer avant d'être prêt.", 'Marie Forleo'),
  ("L'effort que vous mettez aujourd'hui déterminera votre succès de demain.", 'Inconnu'),
  ("Le succès est la somme de petits efforts répétés jour après jour.", 'Robert Collier'),
  ("La meilleure manière de prédire l'avenir est de le créer.", 'Peter Drucker'),
  ("L'attitude est le pinceau de l'esprit. Elle colore toutes nos pensées.", 'Albert Einstein'),
  ("La persévérance est la clé du succès, peu importe à quel point les choses peuvent être difficiles.", 'Inconnu'),
  ("La vie est un défi, relève-le.", 'Inconnu'),
  ("Soyez la personne qui décide de faire quelque chose, plutôt que celle qui se demande pourquoi quelque chose n'a pas été fait.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("Chaque petit pas vous rapproche de votre objectif.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Zig Ziglar'),
  ("Votre temps est limité, ne le gaspillez pas en vivant la vie de quelqu'un d'autre.", 'Steve Jobs'),
  ("La motivation vous démarre, l'habitude vous fait continuer.", 'Jim Rohn'),
  ("Vous êtes le seul responsable de votre succès et de votre échec.", 'Inconnu'),
  ("Lorsque vous croyez en vous, tout est possible.", 'Inconnu'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Albert Einstein'),
  ("N'arrêtez jamais de croire en vous.", 'Inconnu'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer'),
  ("Ne laissez pas l'éducation interférer avec votre apprentissage.", 'Mark Twain'),
  ("L'éducation est la clé pour ouvrir la porte en or de la liberté.", 'George Washington Carver'),
  ("Le succès ne consiste pas à ne jamais échouer, mais à ne jamais abandonner.", 'Inconnu'),
  ("N'attendez pas l'occasion, créez-la.", 'Inconnu'),
  ("Le succès est un chemin, pas une destination.", 'Ben Sweetland'),
  ("Le travail acharné bat le talent quand le talent ne travaille pas dur.", 'Tim Notke'),
  ("La seule limite à notre réalisation du demain sera nos doutes d'aujourd'hui.", 'Franklin D. Roosevelt'),
  ("L'effort que vous mettez aujourd'hui ouvrira les portes pour demain.", 'Inconnu'),
  ("Le travail dur bat le talent lorsque le talent ne travaille pas dur.", 'Inconnu'),
  ("La persévérance est la clé du succès.", 'Inconnu'),
  ("Ne vous attendez pas à voir un changement si vous n'apportez pas un changement.", 'Inconnu'),
  ("L'avenir dépend de ce que vous faites aujourd'hui.", 'Mahatma Gandhi'),
  ("Le succès n'est pas final, l'échec n'est pas fatal : c'est le courage de continuer qui compte.", 'Winston Churchill'),
  ("La seule manière de faire du bon travail est d'aimer ce que vous faites.", 'Steve Jobs'),
  ("Le secret de progresser est de commencer.", 'Mark Twain'),
  ("L'éducation est la clé du succès dans la vie, et les enseignants ont un impact durable sur l'avenir.", 'Solomon Ortiz'),
  ("Le succès, c'est de faire ce que vous aimez et d'aimer ce que vous faites.", 'Wayne Dyer');
  """);

    await database.execute("""
    
    INSERT INTO formulas (name, equation, description, category)
      VALUES 
      ("Addition", "a + b", "Opération d'addition", "Math"),
      ("Soustraction", "a - b", "Opération de soustraction", "Math"),
      ("Multiplication", "a \\cdot b", "Opération de multiplication", "Math"),
      ("Division", "\\frac{a}{b}", "Opération de division", "Math"),
      ("Table de multiplication", "a \\times b = c", "Table de multiplication pour les nombres", "Math"),
      ("Nombres premiers", "Nombre premier est un nombre divisible par 1 et lui-même", "Nombres premiers et exemples", "Math"),
      ("Cercle", "A = \\pi r^2", "Calcul de l'aire d'un cercle", "Géométrie"),
      ("Triangle", "A = \\frac{1}{2} \\times \\text{base} \\times \\text{hauteur}", "Calcul de l'aire d'un triangle", "Math"),
      ("Rectangle", "A = \\text{longueur} \\times \\text{largeur}", "Calcul de l'aire d'un rectangle", "Math"),
      ("Périmètre", "P =\\(côté1 + côté2 + côté3\\)", "Calcul du périmètre d'un triangle", "Math"),
      
    ("Suite Géométrique", "[
    U_{n+1} = U_n \\cdot r
    ]", "Formule générale de la suite géométrique.", "Mathe"),
    ("Somme des Termes d'une Suite Géométrique \\(finie\\)", "[
    S_n = \\frac{U_0 \\cdot \\(1 - r^n\\)}{1 - r}, \\text{ si } r \\neq 1 
    S_n = n \\cdot U_0, \\text{ si } r = 1
    ]","Suite géometrique", "Mathe"),
    ("Limite de la Suite Géométrique \\(en l'infini\\)", "[
    \\text{Si } -1 < r < 1, \\text{ la limite est 0 : } \\lim_{{n \\to \\infty}} U_n = 0 
    \\text{Si } r > 1, \\text{ la suite diverge vers l'infini : } \\lim_{{n \\to \\infty}} U_n = +\\infty 
    \\text{Si } r < -1, \\text{ la suite alterne et n'a pas de limite réelle.}
    ]","Limite suite geometrie", "Mathe"),
    ("Suite Arithmétique", "[
    U_{n+1} = U_n + d
    ]", "Formule générale de la suite arithmétique.", "Mathe"),
    ("Somme des Termes d'une Suite Arithmétique \\(finie\\)", "[
    S_n = \\frac{n}{2} [2U_0 + \\(n-1\\)d]
    ]","Somme de suite numerique ", "Mathe"),
    ("Limite de la Suite Arithmétique \\(en l'infini\\)", "[
    \\text{La suite arithmétique n'a pas de limite en l'infini car elle continue indéfiniment en suivant une progression linéaire.}
    ]","limite de suite arithmétique", "Mathe"),
   ("Suite Géométrique", "[
      U_{n+1} = U_n \\cdot r
      ]", "Formule générale de la suite géométrique.", "math"),
      ("Somme des Termes d'une Suite Géométrique \\(finie\\)", "[
      S_n = \\frac{U_0 \\cdot \\(1 - r^n\\)}{1 - r}, \\text{ si } r \\neq 1 
      S_n = n \\cdot U_0, \\text{ si } r = 1
      ]","somme des terme d une suite geometrique", "math"),
      
       ("Variables de Décision", "[
      x_1, x_2, \\ldots, x_n
      ]", "Les variables de décision dans un problème de programmation linéaire, qui sont les valeurs que vous cherchez à déterminer pour optimiser la fonction objectif.", "math"),
      ("Forme Standard", "[
      \\text{Minimiser } Z = c_1x_1 + c_2x_2 + \\ldots + c_nx_n 
      \\text{sous les contraintes :} 
      a_{11}x_1 + a_{12}x_2 + \\ldots + a_{1n}x_n \\leq b_1 
      a_{21}x_1 + a_{22}x_2 + \\ldots + a_{2n}x_n \\leq b_2 
      \\vdots 
      a_{m1}x_1 + a_{m2}x_2 + \\ldots + a_{mn}x_n \\leq b_m 
      x_1, x_2, \\ldots, x_n \\geq 0
      ]", "La forme standard d'un problème de programmation linéaire, où l'objectif est de minimiser la fonction objectif sous des contraintes linéaires et des variables de décision non négatives.", "math"),
        ("Suite Géométrique", "[ U_{n+1} = U_n \\cdot r ]", "Formule générale de la suite géométrique.", "Mathe"),
    ("Somme des Termes d'une Suite Géométrique (finie)", "[ S_n = \\frac{U_0 \\cdot \\(1 - r^n\\)}{1 - r}, si r \\neq 1 S_n = n \\cdot U_0, si r = 1 ]", "Calcul de la somme des termes d'une suite géométrique finie.", "Mathe"),
    ("Limite de la Suite Géométrique (en l'infini)", "[ Si -1 < r < 1, la limite est 0 : \\lim_{n \\to \\infty} U_n = 0 Si r > 1, la suite diverge vers l'infini : \\lim_{n \\to \\infty} U_n = +\\infty Si r < -1, la suite alterne et n'a pas de limite réelle. ]", "Calcul de la limite d'une suite géométrique à l'infini.", "Mathe"),
    ("Suite Arithmétique", "[ U_{n+1} = U_n + d ]", "Formule générale de la suite arithmétique.", "Mathe"),
    ("Somme des Termes d'une Suite Arithmétique (finie)", "[ S_n = \\frac{n}{2} [2U_0 + \\(n-1\\)d] ]", "Calcul de la somme des termes d'une suite arithmétique finie.", "Mathe"),
    ("Limite de la Suite Arithmétique (en l'infini)", "[ La suite arithmétique n'a pas de limite en l'infini car elle continue indéfiniment en suivant une progression linéaire. ]", "Calcul de la limite d'une suite arithmétique à l'infini.", "Mathe"),
    ("Suite Géométrique", "[ U_{n+1} = U_n \\cdot r ]", "Formule générale de la suite géométrique.", "math"),
    ("Somme des Termes d'une Suite Géométrique (finie)", "[ S_n = \\frac{U_0 \\cdot \\(1 - r^n\\)}{1 - r}, si r \\neq 1 S_n = n \\cdot U_0, si r = 1 ]", "Calcul de la somme des termes d'une suite géométrique finie.", "math"),
    ("Limite de la Suite Géométrique (en l'infini)", "[ Si -1 < r < 1, la limite est 0 : \\lim_{n \\to \\infty} U_n = 0 Si r > 1, la suite diverge vers l'infini : \\lim_{n \\to \\infty} U_n = +\\infty Si r < -1, la suite alterne et n'a pas de limite réelle. ]", "Calcul de la limite d'une suite géométrique à l'infini.", "math"),
    ("Suite Arithmétique", "[ U_{n+1} = U_n + d ]", "Formule générale de la suite arithmétique.", "math"),
    ("Somme des Termes d'une Suite Arithmétique (finie)", "[ S_n = \\frac{n}{2} [2U_0 + \\(n-1\\)d] ]", "Calcul de la somme des termes d'une suite arithmétique finie.", "math"),
    ("Limite de la Suite Arithmétique (en l'infini)", "[ La suite arithmétique n'a pas de limite en l'infini car elle continue indéfiniment en suivant une progression linéaire. ]", "Calcul de la limite d'une suite arithmétique à l'infini.", "math"),
    ("Suite de Fibonacci", "[ F_{n+2} = F_{n+1} + F_n, avec F_0 = 0, F_1 = 1 ]", "Suite célèbre où chaque terme est la somme des deux précédents.", "math"),
    ("Suite Harmonique", "[ H_n = \\sum_{k=1}^{n} \\frac{1}{k} ]", "Calcul de la somme des inverses des entiers positifs jusqu'à n.", "math"),
    ("Suite Géométrique", "[ U_{n+1} = U_n \\cdot r ]", "Formule générale de la suite géométrique.", "math"),
    ("Somme des Termes d'une Suite Géométrique (finie)", "[ S_n = \\frac{U_0 \\cdot \\(1 - r^n\\)}{1 - r}, si r \\neq 1 S_n = n \\cdot U_0, si r = 1 ]", "Calcul de la somme des termes d'une suite géométrique finie.", "math"),
    ("Limite de la Suite Géométrique (en l'infini)", "[ Si -1 < r < 1, la limite est 0 : \\lim_{n \\to \\infty} U_n = 0 Si r > 1, la suite diverge vers l'infini : \\lim_{n \\to \\infty} U_n = +\\infty Si r < -1, la suite alterne et n'a pas de limite réelle. ]", "Calcul de la limite d'une suite géométrique à l'infini.", "math"),
    ("Suite Arithmétique", "[ U_{n+1} = U_n + d ]", "Formule générale de la suite arithmétique.", "math"),
    ("Somme des Termes d'une Suite Arithmétique (finie)", "[ S_n = \\frac{n}{2} [2U_0 + \\(n-1\\)d] ]", "Calcul de la somme des termes d'une suite arithmétique finie.", "math"),
    ("Limite de la Suite Arithmétique (en l'infini)", "[ La suite arithmétique n'a pas de limite en l'infini car elle continue indéfiniment en suivant une progression linéaire. ]", "Calcul de la limite d'une suite arithmétique à l'infini.", "math"),
    ("Suite Quadratique", "[ U_{n+1} = aU_n^2 + b, avec U_0 = c ]", "Suite où chaque terme dépend du carré du terme précédent.", "math"),
    ("Nombres Complexes", "[ z = a + bi ]", "Forme générale d'un nombre complexe.", "math"),
    ("Partie Réelle d'un Nombre Complex", "[ \\text{Re}\\(z\\) = a ]", "La partie réelle d'un nombre complexe.", "math"),
    ("Partie Imaginaire d'un Nombre Complex", "[ \\text{Im}\\(z\\) = b ]", "La partie imaginaire d'un nombre complexe.", "math"),
    ("Conjugé d'un Nombre Complex", "[ \\overline{z} = a - bi ]", "Le conjugué d'un nombre complexe.", "math"),
    ("Module d'un Nombre Complex", "[ |z| = \\sqrt{a^2 + b^2} ]", "Le module \\(ou valeur absolue\\) d'un nombre complexe.", "math"),
    ("Argument d'un Nombre Complex", "[ \\text{Arg}\\(z\\) = \\arctan\\left\\(\\frac{b}{a}\\right\\) ]", "L'argument d'un nombre complexe en radians.", "math"),
    ("Forme Exponentielle d'un Nombre Complex", "[ z = |z|e^{i\\text{Arg}\\(z\\)} ]", "La forme exponentielle d'un nombre complexe.", "math"),
    ("Addition de Nombres Complexes", "[ \\(a + bi\\) + \\(c + di\\) = \\(a + c\\) + \\(b + d\\)i ]", "L'addition de nombres complexes.", "math"),
    ("Multiplication de Nombres Complexes", "[ \\(a + bi\\) \\cdot \\(c + di\\) = \\(ac - bd\\) + \\(ad + bc\\)i ]", "La multiplication de nombres complexes.", "math"),
    ("Division de Nombres Complexes", "[ \\frac{{a + bi}}{{c + di}} = \\frac{{\\(a + bi\\) \\cdot \\(c - di\\)}}{{c^2 + d^2}} ]", "La division de nombres complexes.", "math"),
    ("Formule de Moivre", "[ \\(r\\cos\\(\\theta\\) + isin\\(\\theta\\)\\)^n = r^n\\cos\\(n\\theta\\) + isin\\(n\\theta\\) ]", "La formule de Moivre pour l'exponentiation de nombres complexes.", "math"),
    ("Nombres Complexes en Forme Polaire", "[ z = re^{i\\theta} ]", "La forme polaire d'un nombre complexe.", "math"),
    ("Racine N-ième d'un Nombre Complex", "[ z^{1/n} = \\sqrt[n]{r}\\(cos\\(\\theta/n\\) + isin\\(\\theta/n\\)\\) ]", "La racine n-ième d'un nombre complexe en forme polaire.", "math"),
    ("Identité d'Euler", "[ e^{i\\theta} = cos\\(\\theta\\) + isin\\(\\theta\\) ]", "L'identité d'Euler, qui relie l'exponentielle complexe aux fonctions trigonométriques.", "math"),
    ("Équation Quadratique Complex", "[ az^2 + bz + c = 0, avec a, b, c, z \\in \\mathbb{C} ]", "L'équation quadratique avec des coefficients complexes.", "math"),
    ("Transformée de Fourier", "[ F\\(k\\) = \\int_{-\\infty}^{\\infty} f\\(x\\)e^{-2\\pi i kx}dx ]", "La transformée de Fourier d'une fonction.", "math"),
    ("Identités Trigonométriques Complexes", "[ \\sin\\(ix\\) = i\\sinh\\(x\\), \\quad \\cos\\(ix\\) = \\cosh\\(x\\) ]", "Les identités trigonométriques pour les fonctions trigonométriques complexes.", "math"),
    ("Formule d'Euler pour les Polyèdres", "[ V - E + F = 2 ]", "La formule d'Euler pour les polyèdres convexes.", "math"),
    ("Symétrie Axiale", "[ z' = -z ]", "Symétrie axiale \\(ou symétrie par rapport à l'origine\\) d'un nombre complexe.", "math"),
    ("Rotation de θ degrés", "[ z' = z \\cdot e^{iθ} ]", "Rotation d'un nombre complexe de θ degrés dans le sens trigonométrique.", "math"),
    ("Rotation de π/2 (90 degrés)", "[ z' = iz ]", "Rotation d'un nombre complexe de 90 degrés dans le sens trigonométrique.", "math"),
    ("Rotation de 180 degrés", "[ z' = -z ]", "Rotation d'un nombre complexe de 180 degrés dans le sens trigonométrique.", "math"),
    ("Rotation de 270 degrés", "[ z' = -iz ]", "Rotation d'un nombre complexe de 270 degrés dans le sens trigonométrique.", "math"),
    ("Transformation de Dilatation", "[ z' = kz, où k \\in \\mathbb{R} ]", "Transformation de dilatation \\(agrandissement ou réduction\\) d'un nombre complexe.", "math"),
    ("Transformation de Translation", "[ z' = z + a, où a \\in \\mathbb{C} ]", "Transformation de translation d'un nombre complexe.", "math"),
    ("Transformation de Rotation Générale", "[ z' = \\(z - a\\) \\cdot e^{iθ} + b, où a, b, θ \\in \\mathbb{C} ]", "Transformation de rotation générale suivie d'une translation et d'une dilatation.", "math"),
    ("Nombres Complexes en Coordonnées Polaires", "[ z = re^{i\\theta} ]", "La forme polaire d'un nombre complexe en coordonnées polaires.", "math"),
    ("Multiplication de Nombres Complexes en Forme Polaire", "[ z_1 \\cdot z_2 = r_1r_2e^{i\\(\\theta_1 + \\theta_2\\)} ]", "La multiplication de nombres complexes en forme polaire.", "math"),
    ("Racines N-ièmes en Forme Polaire", "[ z^{1/n} = \\sqrt[n]{r}e^{i\\(\\theta/n\\)} ]", "La racine n-ième d'un nombre complexe en forme polaire.", "math"),
    ("Logarithme de Nombres Complexes", "[ \\log\\(z\\) = \\log\\(r\\) + i\\theta ]", "Le logarithme d'un nombre complexe en forme polaire.", "math"),
    ("Nombres Complexes en Coordonnées Cartésiennes", "[ z = x + yi ]", "La forme cartésienne d'un nombre complexe en coordonnées cartésiennes.", "math"),
    ("Multiplication de Nombres Complexes en Coordonnées Cartésiennes", "[ \\(x_1 + iy_1\\) \\cdot \\(x_2 + iy_2\\) = \\(x_1x_2 - y_1y_2\\) + i\\(x_1y_2 + x_2y_1\\) ]", "La multiplication de nombres complexes en coordonnées cartésiennes.", "math"),
    ("Conjugaison de Nombres Complexes en Coordonnées Cartésiennes", "[ \\overline{z} = x - yi ]", "Le conjugué d'un nombre complexe en coordonnées cartésiennes.", "math"),
    ("Division de Nombres Complexes en Coordonnées Cartésiennes", "[ \\frac{x_1 + iy_1}{x_2 + iy_2} = \\frac{x_1x_2 + y_1y_2}{x_2^2 + y_2^2} + i\\frac{x_2y_1 - x_1y_2}{x_2^2 + y_2^2} ]", "La division de nombres complexes en coordonnées cartésiennes.", "math"),
    ("Fonction Objectif", "[ Z = c_1x_1 + c_2x_2 + \\ldots + c_nx_n ]", "La fonction objectif dans un problème de programmation linéaire, où Z est la valeur à maximiser ou minimiser, c_i sont les coefficients de l'objectif, et x_i sont les variables de décision.", "math"),
    ("Contraintes Linéaires", "[ a_{11}x_1 + a_{12}x_2 + \\ldots + a_{1n}x_n \\leq b_1 a_{21}x_1 + a_{22}x_2 + \\ldots + a_{2n}x_n \\leq b_2 \\vdots a_{m1}x_1 + a_{m2}x_2 + \\ldots + a_{mn}x_n \\leq b_m ]", "Les contraintes linéaires dans un problème de programmation linéaire, où a_{ij} sont les coefficients des contraintes, b_i sont les valeurs limites des contraintes, et x_i sont les variables de décision.", "math"),
    ("Variables de Décision", "[ x_1, x_2, \\ldots, x_n ]", "Les variables de décision dans un problème de programmation linéaire, qui sont les valeurs que vous cherchez à déterminer pour optimiser la fonction objectif.", "math"),
    ("Forme Standard", "[ \\text{Minimiser } Z = c_1x_1 + c_2x_2 + \\ldots + c_nx_n \\text{sous les contraintes :} a_{11}x_1 + a_{12}x_2 + \\ldots + a_{1n}x_n \\leq b_1 a_{21}x_1 + a_{22}x_2 + \\ldots + a_{2n}x_n \\leq b_2 \\vdots a_{m1}x_1 + a_{m2}x_2 + \\ldots + a_{mn}x_n \\leq b_m x_1, x_2, \\ldots, x_n \\geq 0 ]", "La forme standard d'un problème de programmation linéaire, où l'objectif est de minimiser une fonction linéaire sous des contraintes linéaires et avec des variables de décision non négatives.", "math"),
    ("Système d'Équations Linéaires", "[ a_{11}x_1 + a_{12}x_2 + \\ldots + a_{1n}x_n = b_1 a_{21}x_1 + a_{22}x_2 + \\ldots + a_{2n}x_n = b_2 \\vdots a_{m1}x_1 + a_{m2}x_2 + \\ldots + a_{mn}x_n = b_m ]", "Un système d'équations linéaires avec n variables et m équations.", "math"),
    ("Matrice des Coefficients", "[ \\begin{bmatrix} a_{11} & a_{12} & \\ldots & a_{1n} \\\\ a_{21} & a_{22} & \\ldots & a_{2n} \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ a_{m1} & a_{m2} & \\ldots & a_{mn} \\end{bmatrix} ]", "La matrice des coefficients d'un système d'équations linéaires.", "math"),
    ("Vecteur des Solutions", "[ \\begin{bmatrix} b_1 \\\\ b_2 \\\\ \\vdots \\\\ b_m \\end{bmatrix} ]", "Le vecteur des solutions d'un système d'équations linéaires.", "math"),
    ("Vecteur des Variables de Décision", "[ \\begin{bmatrix} x_1 \\\\ x_2 \\\\ \\vdots \\\\ x_n \\end{bmatrix} ]", "Le vecteur des variables de décision dans un système d'équations linéaires.", "math"),
    ("Matrice Identité", "[ I_n = \\begin{bmatrix} 1 & 0 & \\ldots & 0 \\\\ 0 & 1 & \\ldots & 0 \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ 0 & 0 & \\ldots & 1 \\end{bmatrix} ]", "La matrice identité de taille n x n.", "math"),
    ("Matrice Inverse", "[ A^{-1} ]", "La matrice inverse d'une matrice A, si elle existe.", "math"),
    ("Produit Matriciel", "[ C = AB ]", "Le produit matriciel de deux matrices A et B, où C est le résultat.", "math"),
    ("Déterminant de Matrice", "[ |A| ou \\det\\(A\\) ]", "Le déterminant d'une matrice carrée A.", "math"),
    ("Système d'Équations Linéaires", "[ a_{11}x_1 + a_{12}x_2 + \\ldots + a_{1n}x_n = b_1 a_{21}x_1 + a_{22}x_2 + \\ldots + a_{2n}x_n = b_2 \\vdots a_{m1}x_1 + a_{m2}x_2 + \\ldots + a_{mn}x_n = b_m ]", "Un système d'équations linéaires avec n variables et m équations.", "math"),
    ("Matrice des Coefficients", "[ \\begin{bmatrix} a_{11} & a_{12} & \\ldots & a_{1n} \\\\ a_{21} & a_{22} & \\ldots & a_{2n} \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ a_{m1} & a_{m2} & \\ldots & a_{mn} \\end{bmatrix} ]", "La matrice des coefficients d'un système d'équations linéaires.", "math"),
    ("Vecteur des Solutions", "[ \\begin{bmatrix} b_1 \\\\ b_2 \\\\ \\vdots \\\\ b_m \\end{bmatrix} ]", "Le vecteur des solutions d'un système d'équations linéaires.", "math"),
    ("Vecteur des Variables de Décision", "[ \\begin{bmatrix} x_1 \\\\ x_2 \\\\ \\vdots \\\\ x_n \\end{bmatrix} ]", "Le vecteur des variables de décision dans un système d'équations linéaires.", "math"),
    ("Matrice Identité", "[ I_n = \\begin{bmatrix} 1 & 0 & \\ldots & 0 \\\\ 0 & 1 & \\ldots & 0 \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ 0 & 0 & \\ldots & 1 \\end{bmatrix} ]", "La matrice identité de taille n x n.", "math"),
    ("Matrice Inverse", "[ A^{-1} ]", "La matrice inverse d'une matrice A, si elle existe.", "math"),
    ("Produit Matriciel", "[ C = AB ]", "Le produit matriciel de deux matrices A et B, où C est le résultat.", "math"),
    ("Déterminant de Matrice", "[ |A| ou \\det\\(A\\) ]", "Le déterminant d'une matrice carrée A.", "math"),
    ("Matrice Symétrique", "[ A = A^T ]", "Une matrice qui est égale à sa transposée.", "math"),
    ("Matrice Orthogonale", "[ A^T A = AA^T = I ]", "Une matrice carrée A dont la transposée est également son inverse.", "math"),
    ("Décomposition LU", "[ A = LU ]", "La décomposition d'une matrice A en une matrice inférieure L et une matrice supérieure U.", "math"),
    ("Système d'Équations Linéaires", "[ a_{11}x_1 + a_{12}x_2 + \\ldots + a_{1n}x_n = b_1 a_{21}x_1 + a_{22}x_2 + \\ldots + a_{2n}x_n = b_2 \\vdots a_{m1}x_1 + a_{m2}x_2 + \\ldots + a_{mn}x_n = b_m ]", "Un système d'équations linéaires avec n variables et m équations.", "math"),
    ("Matrice des Coefficients", "[ \\begin{bmatrix} a_{11} & a_{12} & \\ldots & a_{1n} \\\\ a_{21} & a_{22} & \\ldots & a_{2n} \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ a_{m1} & a_{m2} & \\ldots & a_{mn} \\end{bmatrix} ]", "La matrice des coefficients d'un système d'équations linéaires.", "math"),
    ("Vecteur des Solutions", "[ \\begin{bmatrix} b_1 \\\\ b_2 \\\\ \\vdots \\\\ b_m \\end{bmatrix} ]", "Le vecteur des solutions d'un système d'équations linéaires.", "math"),
    ("Vecteur des Variables de Décision", "[ \\begin{bmatrix} x_1 \\\\ x_2 \\\\ \\vdots \\\\ x_n \\end{bmatrix} ]", "Le vecteur des variables de décision dans un système d'équations linéaires.", "math"),
    ("Matrice Identité", "[ I_n = \\begin{bmatrix} 1 & 0 & \\ldots & 0 \\\\ 0 & 1 & \\ldots & 0 \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ 0 & 0 & \\ldots & 1 \\end{bmatrix} ]", "La matrice identité de taille n x n.", "math"),
    ("Matrice Inverse", "[ A^{-1} ]", "La matrice inverse d'une matrice A, si elle existe.", "math"),
    ("Produit Matriciel", "[ C = AB ]", "Le produit matriciel de deux matrices A et B, où C est le résultat.", "math"),
    ("Déterminant de Matrice", "[ |A| ou \\det\\(A\\) ]", "Le déterminant d'une matrice carrée A.", "math"),
    ("Matrice Symétrique", "[ A = A^T ]", "Une matrice qui est égale à sa transposée.", "math"),
    ("Matrice Orthogonale", "[ A^T A = AA^T = I ]", "Une matrice carrée A dont la transposée est également son inverse.", "math"),
    ("Décomposition LU", "[ A = LU ]", "La décomposition d'une matrice A en une matrice inférieure L et une matrice supérieure U.", "math"),
    ("Décomposition QR", "[ A = QR ]", "La décomposition d'une matrice A en une matrice orthogonale Q et une matrice triangulaire supérieure R.", "math"),
    ("Valeur Propre d'une Matrice", "[ Av = \\lambda v ]", "Une valeur propre \\(λ\\) d'une matrice A et le vecteur propre correspondant \\(v\\) qui satisfait cette équation.", "math"),
    ("Diagonalisation d'une Matrice", "[ A = PDP^{-1} ]", "La diagonalisation d'une matrice A en une matrice diagonale D et une matrice de passage P.", "math"),
    ("Décomposition en Valeurs Singulières", "[ A = UΣV^T ]", "La décomposition en valeurs singulières d'une matrice A en trois matrices U, Σ \\(sigma\\), et V^T \\(la transposée de V\\).", "math"),
    ("Calcul Matriciel", "[ f\\(A\\) ]", "L'application d'une fonction f à une matrice A, ce qui donne une nouvelle matrice.", "math"),
    ("Transformation Linéaire", "[ T\\(x\\) = Ax ]", "Une transformation qui associe chaque vecteur d'entrée x à un vecteur de sortie Ax en utilisant une matrice A.", "math"),
    ("Espace Vectoriel", "[ V ]", "Un ensemble d'objets appelés vecteurs, qui sont fermés sous l'addition et la multiplication par un scalaire.", "math"),
    ("Combinaison Linéaire", "[ c_1v_1 + c_2v_2 + \\ldots + c_nv_n ]", "Une somme de vecteurs v_1, v_2, ..., v_n, chaque vecteur multiplié par un scalaire c_1, c_2, ..., c_n.", "math"),
    ("Indépendance Linéaire", "[ c_1v_1 + c_2v_2 + \\ldots + c_nv_n = 0 \\Rightarrow c_1 = c_2 = \\ldots = c_n = 0 ]", "Un ensemble de vecteurs est linéairement indépendant s'il n'existe pas de combinaison linéaire non triviale qui égalise zéro.", "math"),
    ("Base d'un Espace Vectoriel", "[ \\text{span}\\(v_1, v_2, \\ldots, v_n\\) ]", "Un ensemble de vecteurs v_1, v_2, ..., v_n forme une base d'un espace vectoriel s'ils sont linéairement indépendants et s'ils engendrent tout l'espace vectoriel.", "math"),
    ("Dimension d'un Espace Vectoriel", "[ \\dim\\(V\\) ]", "Le nombre de vecteurs dans une base d'un espace vectoriel V.", "math"),
    ("Espace Vectoriel des Polynômes", "[ P_n\\(x\\) ]", "L'espace vectoriel de tous les polynômes de degré n ou moins avec des coefficients réels ou complexes.", "math"),
    ("Transformée de Laplace", "[ F\\(s\\) = \\int_{0}^{\\infty} f\\(t\\)e^{-st}dt ]", "La transformée de Laplace d'une fonction f\\(t\\), qui la transforme en une fonction F\\(s\\) de la variable complexe s.", "math"),
    ("Transformée de Fourier", "[ F\\(k\\) = \\int_{-\\infty}^{\\infty} f\\(x\\)e^{-2\\pi i kx}dx ]", "La transformée de Fourier d'une fonction f\\(x\\), qui la transforme en une fonction F\\(k\\) de la variable k.", "math"),
    ("Série de Fourier", "[ f\\(x\\) = \\frac{a_0}{2} + \\sum_{n=1}^{\\infty} \\(a_n\\cos\\(nx\\) + b_n\\sin\\(nx\\)\\) ]", "La représentation d'une fonction périodique f\\(x\\) comme une somme infinie de fonctions sinusoïdales.", "math"),
    ("Théorème de Parseval", "[ \\int_{-\\infty}^{\\infty} |f\\(x\\)|^2 dx = \\frac{1}{2\\pi} \\int_{-\\infty}^{\\infty} |F\\(k\\)|^2 dk ]", "Le théorème de Parseval relie les normes de la fonction et de sa transformée de Fourier.", "math"),
    ("Transformée en Z", "[ X\\(z\\) = \\sum_{n=0}^{\\infty} x[n]z^{-n} ]", "La transformée en Z d'une séquence discrète x[n], qui la transforme en une fonction X\\(z\\) de la variable complexe z.", "math"),
    ("Fonction de Transfert", "[ H\\(s\\) = \\frac{Y\\(s\\)}{X\\(s\\)} ]", "La relation entre la sortie Y\\(s\\) et l'entrée X\\(s\\) d'un système linéaire invariant dans le temps en utilisant la transformée de Laplace.", "math"),
    ("Diagramme de Bode", "[ H\\(j\\omega\\) = |H\\(j\\omega\\)|e^{j\\angle H\\(j\\omega\\)} ]", "La représentation de la fonction de transfert H\\(jω\\) en utilisant son gain absolu |H\\(jω\\)| et sa phase ϕ\\(jω\\) en fonction de la fréquence ω.", "math"),
    ("Matrice de Rotation", "[ R\\(\\theta\\) = \\begin{bmatrix} \\cos\\(\\theta\\) & -\\sin\\(\\theta\\) \\\\ \\sin\\(\\theta\\) & \\cos\\(\\theta\\) \\end{bmatrix} ]", "Une matrice utilisée pour effectuer une rotation dans un espace bidimensionnel.", "math"),
    ("Matrice de Transformation 2D", "[ T = \\begin{bmatrix} a & b \\\\ c & d \\end{bmatrix} ]", "Une matrice utilisée pour effectuer des transformations linéaires 2D.", "math"),
    ("Matrice de Transformation 3D", "[ T = \\begin{bmatrix} a & b & c \\\\ d & e & f \\\\ g & h & i \\end{bmatrix} ]", "Une matrice utilisée pour effectuer des transformations linéaires 3D.", "math"),
    ("Espace Euclidien", "[ \\mathbb{R}^n ]", "Un espace vectoriel réel de dimension n avec un produit scalaire.", "math"),
    ("Produit Scalaire", "[ \\mathbf{u} \\cdot \\mathbf{v} = \\sum_{i=1}^{n} u_iv_i ]", "Le produit scalaire de deux vecteurs u et v dans un espace euclidien.", "math"),
    ("Norme Euclidienne", "[ \\|\\mathbf{v}\\| = \\sqrt{\\mathbf{v} \\cdot \\mathbf{v}} ]", "La norme euclidienne \\(norme L2\\) d'un vecteur v dans un espace euclidien.", "math"),
    ("Distance Euclidienne", "[ d\\(\\mathbf{u}, \\mathbf{v}\\) = \\|\\mathbf{u} - \\mathbf{v}\\| ]", "La distance euclidienne entre deux vecteurs u et v dans un espace euclidien.", "math"),
    ("Orthogonalité", "[ \\mathbf{u} \\perp \\mathbf{v} \\text{ si } \\mathbf{u} \\cdot \\mathbf{v} = 0 ]", "Deux vecteurs u et v sont orthogonaux s'ils ont un produit scalaire nul.", "math"),
    ("Base Orthogonale", "[ \\text{Une base où les vecteurs sont mutuellement orthogonaux.} ]", "Une base orthogonale est une base d'un espace vectoriel où les vecteurs de base sont mutuellement orthogonaux.", "math"),
    ("Base Orthonormale", "[ \\text{Une base où les vecteurs sont mutuellement orthogonaux et ont une norme de 1.} ]", "Une base orthonormale est une base d'un espace vectoriel où les vecteurs de base sont mutuellement orthogonaux et ont une norme de 1.", "math"),
    ("Matrice Orthogonale", "[ A^T A = AA^T = I ]", "Une matrice carrée A dont la transposée est également son inverse.", "math"),
    ("Projection Orthogonale", "[ \\text{proj}_\\mathbf{v}\\(\\mathbf{u}\\) = \\frac{\\mathbf{u} \\cdot \\mathbf{v}}{\\|\\mathbf{v}\\|^2} \\mathbf{v} ]", "La projection orthogonale du vecteur u sur le vecteur v.", "math"),
    ("Décomposition en Valeurs Singulières", "[ A = U\\Sigma V^T ]", "La décomposition en valeurs singulières d'une matrice A en trois matrices U, Σ \\(sigma\\), et V^T \\(la transposée de V\\).", "math"),
    ("Analyse en Composantes Principales (ACP)", "[ X = T + E ]", "La décomposition d'une matrice de données X en une matrice de transformation T et une matrice d'erreur E en ACP.", "math"),
    ("Fonction de Répartition", "[ F\\(x\\) = P\\(X \\leq x\\) ]", "La fonction de répartition d'une variable aléatoire X, qui donne la probabilité que X prenne une valeur inférieure ou égale à x.", "math"),
    ("Fonction de Probabilité Continue", "[ f\\(x\\) ]", "La fonction de densité de probabilité d'une variable aléatoire continue X.", "math"),
    ("Fonction de Masse de Probabilité Discrète", "[ P\\(X = x\\) ]", "La probabilité que la variable aléatoire discrète X prenne une valeur particulière x.", "math"),
    ("Espérance (Valeur Attendue)", "[ E\\(X\\) ]", "L'espérance mathématique ou valeur attendue d'une variable aléatoire X, qui mesure la tendance centrale de X.", "math"),
    ("Variance", "[ \\text{Var}\\(X\\) ]", "La variance d'une variable aléatoire X, qui mesure la dispersion ou l'écart-type de X.", "math"),
    ("Écart-Type", "[ \\sigma\\(X\\) ou \\sqrt{\\text{Var}\\(X\\)} ]", "L'écart-type d'une variable aléatoire X, qui est la racine carrée de sa variance.", "math"),
    ("Covariance", "[ \\text{Cov}\\(X, Y\\) ]", "La covariance entre deux variables aléatoires X et Y, qui mesure comment elles varient ensemble.", "math"),
    ("Corrélation", "[ \\text{Corr}\\(X, Y\\) ]", "La corrélation entre deux variables aléatoires X et Y, qui mesure leur relation linéaire.", "math"),
    ("Loi Normale (Gaussienne)", "[ N\\(\\mu, \\sigma^2\\) ]", "La loi normale, une distribution de probabilité continue caractérisée par ses paramètres de moyenne \\(μ\\) et de variance \\(σ^2\\).", "math"),
    ("Équation de droite", "y = mx + b", "Équation d'une droite", "Math"),
      ("Nombres pairs et impairs", "Un nombre pair est divisible par 2, un nombre impair ne l'est pas.", "Pairs et impairs", "Math"),
      ("Calcul de pourcentage", "\\text{pourcentage} = \\frac{\\text{partie}}{\\text{total}} \\times 100", "Calcul de pourcentages", "Math"),
      ("Conversion de fractions en décimales", "Ex: \\frac{3}{4} = 0.75", "Conversion de fractions en décimales", "Math"),
      ("Ordre des opérations", "Parenthèses, Exposants, Multiplication/Division, Addition/Soustraction \\(PEMDAS\\)", "Ordre des opérations", "Math"),
      ("Propriétés des formes géométriques", "Ex: Les carrés ont des côtés égaux", "Formes géométriques", "Math"),
      ("Multiples et diviseurs", "Ex: Les multiples de 5 sont 5, 10, 15, 20, ...", "Multiples et diviseurs", "Math"),
      ("Notation des angles", "Ex: \\angle ABC représente un angle nommé ABC", "Notation des angles", "Math"),
      ("Les heures et les minutes", "Conversion entre heures, minutes et secondes", "Heures et minutes", "Math"),
      ("Addition avec retenue", "Méthode d'addition avec retenue", "Addition avec retenue", "Math"),
      ("Système métrique", "Unités de mesure métriques \\(mètres, litres, grammes\\)", "Système métrique", "Math"),
       ("Calcul de périmètre du carré", "P = 4 \\times côté", "Calcul du périmètre d'un carré", "Math"),
      ("Calcul de périmètre du rectangle", "P = 2 \\times \\(longueur + largeur\\)", "Calcul du périmètre d'un rectangle", "Math"),
      ("Calcul de périmètre du triangle", "P = côté1 + côté2 + côté3", "Calcul du périmètre d'un triangle", "Math"),
      ("Calcul de l'aire du carré", "A = côté^2", "Calcul de l'aire d'un carré", "Math"),
      ("Calcul de l'aire du rectangle", "A = longueur \\times largeur", "Calcul de l'aire d'un rectangle", "Math"),
      ("Calcul de l'aire du triangle", "A = \\frac{1}{2} \\times base \\times hauteur", "Calcul de l'aire d'un triangle", "Math"),
      ("Cercle - Rayon et Diamètre", "D = 2 \\times r", "Relation entre le rayon et le diamètre d'un cercle", "Math"),
      ("Cercle - Circonférence", "C = 2\\pi r", "Calcul de la circonférence d'un cercle", "Math"),
      ("Cercle - Aire", "A = \\pi r^2", "Calcul de l'aire d'un cercle", "Math"),
      ("Conversion de longueurs", "Conversion entre mètres, centimètres et millimètres", "Conversion de longueurs", "Math"),
      ("Conversion de capacité", "Conversion entre litres et millilitres", "Conversion de capacité", "Math"),
      ("Conversion de poids", "Conversion entre kilogrammes et grammes", "Conversion de poids", "Math"),
       ("Calcul de la surface d'un carré", "\\text{A = côté} \\times \\text{côté}", "Calcul de la surface d'un carré", "Math"),
      ("Calcul de la surface d'un rectangle", "\\text{A = longueur} \\times \\text{largeur}", "Calcul de la surface d'un rectangle", "Math"),
      ("Calcul de la surface d'un triangle", "\\text{A = }\\frac{1}{2} \\times \\text{base} \\times \\text{hauteur}", "Calcul de la surface d'un triangle", "Math"),
      ("Calcul de la circonférence d'un cercle", "\\text{C = }2\\pi r", "Calcul de la circonférence d'un cercle", "Math"),
      ("Calcul de l'aire d'un cercle", "\\text{A = }\\pi r^2", "Calcul de l'aire d'un cercle", "Math"),
      ("Calcul du volume d'un cube", "\\text{V = côté}^3", "Calcul du volume d'un cube", "Math"),
      ("Calcul du volume d'un parallélépipède rectangle", "\\text{V = longueur} \\times \\text{largeur} \\times \\text{hauteur}", "Calcul du volume d'un parallélépipède rectangle", "Math"),
      ("Calcul du volume d'un cylindre", "\\text{V = }\\pi r^2 h", "Calcul du volume d'un cylindre", "Math"),
      ("Calcul du volume d'une sphère", "\\text{V = }\\frac{4}{3}\\pi r^3", "Calcul du volume d'une sphère", "Math"),
      ("Théorème de Pythagore", "a^2 + b^2 = c^2", "Calcul des côtés d'un triangle droit", "Math"),
      ("Théorème de l'aire", "\\text{A = }\\frac{1}{2} \\times \\text{base} \\times \\text{hauteur}", "Calcul de l'aire d'un triangle", "Math"),
      ("Théorème de l'aire du trapèze", "\\text{A = }\\frac{1}{2}\\(a + b\\) \\times h", "Calcul de l'aire d'un trapèze", "Math"),
      ("Multiples de 2", "\\text{Nombres pairs sont multiples de 2}", "Nombres pairs", "Math"),
      ("Multiples de 3", "\\text{Nombres divisibles par 3}", "Multiples de 3", "Math"),
      ("Multiples de 4", "\\text{Nombres divisibles par 4}", "Multiples de 4", "Math"),
      ("Multiples de 5", "\\text{Nombres divisibles par 5}", "Multiples de 5", "Math"),
      ("Multiples de 10", "\\text{Nombres divisibles par 10}", "Multiples de 10", "Math"),
      ("Addition de fractions", "\\frac{a}{b} + \\frac{c}{d} = \\frac{ad + bc}{bd}", "Addition de fractions", "Math"),
      ("Soustraction de fractions", "\\frac{a}{b} - \\frac{c}{d} = \\frac{ad - bc}{bd}", "Soustraction de fractions", "Math"),
      ("Multiplication de fractions", "\\frac{a}{b} \\cdot \\frac{c}{d} = \\frac{ac}{bd}", "Multiplication de fractions", "Math"),
      ("Division de fractions", "\\frac{a}{b} / \\frac{c}{d} = \\frac{a}{b} \\cdot \\frac{d}{c}", "Division de fractions", "Math"),
      ("Théorème de la somme des angles d'un triangle", "La somme des angles d'un triangle est égale à 180 degrés", "Théorème des angles d'un triangle", "Math"),
      ("Conversion d'unités de mesure de longueur", "Conversion entre mètres, centimètres et millimètres", "Conversion de longueurs", "Math"),
      ("Conversion d'unités de mesure de capacité", "Conversion entre litres et millilitres", "Conversion de capacité", "Math"),
      ("Conversion d'unités de mesure de poids", "Conversion entre kilogrammes et grammes", "Conversion de poids", "Math"),
      ("Théorème de Pythagore", "\\text{Dans un triangle rectangle, } a^2 + b^2 = c^2", "Calcul des côtés d'un triangle droit", "Math"),
      ("Équation du second degré", "\\text{L'équation du second degré } ax^2 + bx + c = 0 \\text{ a deux solutions : } x = \\frac{-b + \\sqrt{b^2 - 4ac}}{2a} \\text{ et } x = \\frac{-b - \\sqrt{b^2 - 4ac}}{2a}", "Solutions d'une équation quadratique", "Math"),
      ("Théorème de Thalès", "\\text{Dans un triangle, si deux droites sont parallèles, alors elles créent des segments proportionnels}", "Théorème de Thalès en géométrie", "Math"),
      ("Théorème de l'angle inscrit", "\\text{Dans un cercle, l'angle inscrit est égal à la moitié de l'angle au centre correspondant}", "Théorème de l'angle inscrit en géométrie", "Math"),
      ("Théorème de la hauteur", "\\text{Dans un triangle, la hauteur divise le triangle en deux triangles similaires}", "Théorème de la hauteur en géométrie", "Math"),
      ("Théorème de la médiane", "\\text{Dans un triangle, la médiane divise le triangle en deux triangles de même aire}", "Théorème de la médiane en géométrie", "Math"),
      ("Théorème de l'angle au centre", "\\text{Dans un cercle, l'angle au centre est le double de l'angle inscrit correspondant}", "Théorème de l'angle au centre en géométrie", "Math"),
      ("Théorème de la tangente", "\\text{Dans un cercle, la tangente est perpendiculaire au rayon au point de tangence}", "Théorème de la tangente en géométrie", "Math"),
      ("Loi des cosinus", "\\text{Dans un triangle quelconque, } c^2 = a^2 + b^2 - 2ab \\cos\\(C\\)", "Loi des cosinus pour résoudre des triangles", "Math"),
      ("Loi des sinus", "\\frac{a}{\\sin\\(A\\)} = \\frac{b}{\\sin\\(B\\)} = \\frac{c}{\\sin\\(C\\)}", "Loi des sinus pour résoudre des triangles", "Math"),
   ("Équation de la droite", "\\text{Équation de la droite : } y = mx + b", "Équation d'une droite en mathématiques", "Math"),
      ("Théorème de l'aire d'un trapèze", "\\text{Aire d'un trapèze : } A = \\frac{1}{2}h\\(b_1 + b_2\\)", "Calcul de l'aire d'un trapèze en géométrie", "Math"),
      ("Volume d'un cône", "\\text{Volume d'un cône : } V = \\frac{1}{3}\\pi r^2 h", "Calcul du volume d'un cône en géométrie", "Math"),
      ("Volume d'un prisme", "\\text{Volume d'un prisme : } V = \\text{aire de la base} \\times h", "Calcul du volume d'un prisme en géométrie", "Math"),
      ("Propriétés des fonctions linéaires", "\\text{Fonction linéaire : } f\\(x\\) = ax + b", "Propriétés des fonctions linéaires en mathématiques", "Math"),
      ("Théorème de l'angle inscrit", "\\text{Dans un cercle, l'angle inscrit est égal à la moitié de l'angle au centre correspondant}", "Théorème de l'angle inscrit en géométrie", "Math"),
      ("Loi des exposants", "\\text{Loi des exposants : } a^{m+n} = a^ma^n", "Loi des exposants en mathématiques", "Math"),
      ("Identités trigonométriques", "\\text{Identités trigonométriques : } \\sin^2\\(\\theta\\) + \\cos^2\\(\\theta\\) = 1", "Identités trigonométriques en mathématiques", "Math"),
      ("Calcul de la dérivée", "\\text{Calcul de la dérivée : } f'\\(x\\) = \\lim_{h\\to 0}\\frac{f\\(x+h\\)-f\\(x\\)}{h}", "Calcul de la dérivée en mathématiques", "Math"),
      ("Équation de la parabole", "\\text{Équation de la parabole : } y = ax^2 + bx + c", "Équation de la parabole en mathématiques", "Math"),
      ("Calcul de l'aire d'un secteur circulaire", "\\text{Aire d'un secteur circulaire : } A = \\frac{\\theta}{360^\\circ}\\pi r^2", "Calcul de l'aire d'un secteur circulaire en géométrie", "Math"),
       ("Calcul du milieu de deux points", "\\text{Le milieu d'un segment de droite entre deux points } A\\(x_1, y_1\\) \\text{ et } B\\(x_2, y_2\\) \\text{ est donné par : } M\\left\\(\\frac{x_1 + x_2}{2}, \\frac{y_1 + y_2}{2}\\right\\)", "Calcul du milieu d'un segment de droite", "Math"),
      ("Équation de la droite passant par deux points", "\\text{Équation de la droite passant par les points } A\\(x_1, y_1\\) \\text{ et } B\\(x_2, y_2\\) \\text{ est donnée par : } y - y_1 = \\frac{y_2 - y_1}{x_2 - x_1}\\(x - x_1\\)", "Équation de la droite passant par deux points", "Math"),
      ("Distance entre deux points", "\\text{La distance entre deux points } A\\(x_1, y_1\\) \\text{ et } B\\(x_2, y_2\\) \\text{ est donnée par : } d = \\sqrt{\\(x_2 - x_1\\)^2 + \\(y_2 - y_1\\)^2}", "Calcul de la distance entre deux points", "Math"),
      ("Formule de l'aire d'un triangle", "\\text{L'aire d'un triangle avec les côtés } a, b, \\text{ et } c \\text{ est donnée par la formule de Heron : } A = \\sqrt{s\\(s-a\\)\\(s-b\\)\\(s-c\\)} \\text{ où } s = \\frac{a+b+c}{2}", "Calcul de l'aire d'un triangle", "Math"),
      ("Théorème de Thalès", "\\text{Dans un triangle, si deux droites sont parallèles, alors elles créent des segments proportionnels}", "Théorème de Thalès en géométrie", "Math"),
      ("Théorème de l'angle inscrit", "\\text{Dans un cercle, l'angle inscrit est égal à la moitié de l'angle au centre correspondant}", "Théorème de l'angle inscrit en géométrie", "Math"),
      ("Théorème de la tangente", "\\text{Dans un cercle, la tangente est perpendiculaire au rayon au point de tangence}", "Théorème de la tangente en géométrie", "Math"),
      ("Loi des cosinus", "\\text{Dans un triangle quelconque, } c^2 = a^2 + b^2 - 2ab \\cos\\(C\\)", "Loi des cosinus pour résoudre des triangles", "Math"),
      ("Loi des sinus", "\\frac{a}{\\sin\\(A\\)} = \\frac{b}{\\sin\\(B\\)} = \\frac{c}{\\sin\\(C\\)}", "Loi des sinus pour résoudre des triangles", "Math"),
      ("Formule du binôme de Newton", "\\text{Formule du binôme de Newton : } \\(a + b\\)^n = \\sum_{k=0}^{n} \\binom{n}{k} a^{n-k} b^k", "Expansion de \\(a + b\\)^n en mathématiques", "Math"),
      ("Équation de la droite en forme générale", "\\text{Équation de la droite en forme générale : } Ax + By + C = 0", "Équation générale d'une droite en mathématiques", "Math"),
      ("Équation de la parabole en forme générale", "\\text{Équation de la parabole en forme générale : } Ax^2 + By^2 + Cx + Dy + E = 0", "Équation générale d'une parabole en mathématiques", "Math"),
      ("Théorème de Pythagore généralisé", "\\text{Dans un triangle, le carré de la longueur de l'hypoténuse est égal à la somme des carrés des longueurs des autres côtés.}", "Théorème de Pythagore généralisé en géométrie", "Math"),
      ("Équation de la sphère", "\\text{Équation de la sphère : } \\(x - h\\)^2 + \\(y - k\\)^2 + \\(z - l\\)^2 = r^2", "Équation d'une sphère en géométrie", "Math"),
      ("Calcul de la probabilité", "\\text{Probabilité d'un événement : } P\\(E\\) = \\frac{\\text{Nombre de cas favorables}}{\\text{Nombre de cas possibles}}", "Calcul de probabilité en mathématiques", "Math"),
      ("Loi de Gauss \\(loi normale\\)", "\\text{Loi de Gauss : } f\\(x\\) = \\frac{1}{\\sigma\\sqrt{2\\pi}}e^{-\\(x-\\mu\\)^2/\\(2\\sigma^2\\)}", "Loi de distribution normale en statistiques", "Math"),
      ("Volume d'une pyramide", "\\text{Volume d'une pyramide : } V = \\frac{1}{3}A_bh", "Calcul du volume d'une pyramide en géométrie", "Math"),
      ("Identité remarquable \\(carré de la somme\\)", "\\(a + b\\)^2 = a^2 + 2ab + b^2", "Identité remarquable : carré de la somme en mathématiques", "Math"),
      ("Identité remarquable \\(carré de la différence\\)", "\\(a - b\\)^2 = a^2 - 2ab + b^2", "Identité remarquable : carré de la différence en mathématiques", "Math"),
      ("Loi des logarithmes \\(produit\\)", "\\log\\(ab\\) = \\log\\(a\\) + \\log\\(b\\)", "Loi des logarithmes : produit en mathématiques", "Math"),
      ("Théorème de Thalès", "\\text{Dans un triangle, si deux droites sont parallèles, alors elles créent des segments proportionnels}", "Théorème de Thalès en géométrie", "Math"),
      ("Théorème de l'angle inscrit", "\\text{Dans un cercle, l'angle inscrit est égal à la moitié de l'angle au centre correspondant}", "Théorème de l'angle inscrit en géométrie", "Math"),
      ("Théorème de la tangente", "\\text{Dans un cercle, la tangente est perpendiculaire au rayon au point de tangence}", "Théorème de la tangente en géométrie", "Math"),
      ("Loi des cosinus", "\\text{Dans un triangle quelconque, } c^2 = a^2 + b^2 - 2ab \\cos\\(C\\)", "Loi des cosinus pour résoudre des triangles", "Math"),
      ("Loi des sinus", "\\frac{a}{\\sin\\(A\\)} = \\frac{b}{\\sin\\(B\\)} = \\frac{c}{\\sin\\(C\\)}", "Loi des sinus pour résoudre des triangles", "Math"),
      ("Formule de l'aire d'un triangle", "\\text{L'aire d'un triangle avec les côtés } a, b, \\text{ et } c \\text{ est donnée par la formule de Heron : } A = \\sqrt{s\\(s-a\\)\\(s-b\\)\\(s-c\\)} \\text{ où } s = \\frac{a+b+c}{2}", "Calcul de l'aire d'un triangle", "Math"),
      ("Théorème de Thalès généralisé", "\\text{Dans un triangle, si deux droites sont parallèles, alors elles créent des segments proportionnels}", "Théorème de Thalès généralisé en géométrie", "Math"),
      ("Loi de la somme des angles d'un polygone", "\\text{La somme des angles intérieurs d'un polygone à } n \\text{ côtés est donnée par } \\(n-2\\) \\times 180^\\circ", "Loi de la somme des angles d'un polygone en géométrie", "Math"),
      ("Équation du cercle", "\\text{Équation d'un cercle de centre }\\(h, k\\) \\text{ et de rayon } r : \\(x-h\\)^2 + \\(y-k\\)^2 = r^2", "Équation d'un cercle en géométrie", "Math"),
      ("Loi de la médiane", "\\text{Dans un triangle, la médiane divise le triangle en deux triangles de même aire}", "Loi de la médiane en géométrie", "Math"),
      ("Théorème de l'angle au centre", "\\text{Dans un cercle, l'angle au centre est le double de l'angle inscrit correspondant}", "Théorème de l'angle au centre en géométrie", "Math"),
      ("Équation de la droite parallèle à un vecteur", "\\text{Équation de la droite parallèle à un vecteur } \\mathbf{v} = \\(a, b\\) \\text{ et passant par le point } \\(x_0, y_0\\) : \\(a\\(x-x_0\\) + b\\(y-y_0\\) = 0", "Équation de la droite parallèle à un vecteur en mathématiques", "Math"),
      ("Calcul de la moyenne", "\\text{La moyenne arithmétique d'un ensemble de nombres } x_1, x_2, \\ldots, x_n \\text{ est donnée par : } \\bar{x} = \\frac{1}{n}\\sum_{i=1}^{n} x_i", "Calcul de la moyenne en statistiques", "Math"),
      ("Calcul de la médiane", "\\text{La médiane d'un ensemble de nombres triés est la valeur centrale \\(ou la moyenne des deux valeurs centrales\\) : } \\text{si } n \\text{ est impair : } \\text{Médiane} = x_{\\(n+1\\)/2} \\text{ ; si } n \\text{ est pair : } \\text{Médiane} = \\frac{x_{n/2} + x_{n/2+1}}{2}", "Calcul de la médiane en statistiques", "Math"),
      ("Calcul du mode", "\\text{Le mode d'un ensemble de nombres est la valeur qui apparaît le plus fréquemment.}", "Calcul du mode en statistiques", "Math"),
      ("Formule de la variance", "\\text{La variance d'un ensemble de nombres } x_1, x_2, \\ldots, x_n \\text{ est donnée par : } \\sigma^2 = \\frac{1}{n}\\sum_{i=1}^{n} \\(x_i - \\bar{x}\\)^2", "Calcul de la variance en statistiques", "Math"),
      ("Formule de l'écart-type", "\\text{L'écart-type d'un ensemble de nombres } x_1, x_2, \\ldots, x_n \\text{ est donné par : } \\sigma = \\sqrt{\\frac{1}{n}\\sum_{i=1}^{n} \\(x_i - \\bar{x}\\)^2}", "Calcul de l'écart-type en statistiques", "Math"),
      ("Formule de la corrélation", "\\text{Le coefficient de corrélation entre deux ensembles de données } x \\text{ et } y \\text{ est donné par : } r = \\frac{\\sum{\\(x_i-\\bar{x}\\)\\(y_i-\\bar{y}\\)}}{\\sqrt{\\sum{\\(x_i-\\bar{x}\\)^2}\\sum{\\(y_i-\\bar{y}\\)^2}}}", "Calcul de la corrélation en statistiques", "Math"),
      ("Calcul de la probabilité conditionnelle", "\\text{La probabilité conditionnelle de l'événement } A \\text{ sachant l'événement } B \\text{ est donnée par : } P\\(A|B\\) = \\frac{P\\(A \\cap B\\)}{P\\(B\\)}", "Calcul de la probabilité conditionnelle en probabilités", "Math"),
      ("Équation de la droite normale à une courbe", "\\text{Équation de la droite normale à une courbe en un point donné } \\(x_0, f\\(x_0\\)\\) \\text{ : } y - f\\(x_0\\) = f'\\(x_0\\)\\(x - x_0\\)", "Équation de la droite normale à une courbe en mathématiques", "Math"),
      ("Formule de l'aire du trapèze", "\\text{Aire d'un trapèze : } A = \\frac{1}{2}\\(a + b\\)h", "Calcul de l'aire d'un trapèze en géométrie", "Math"),
      ("Formule du volume d'un cylindre", "\\text{Volume d'un cylindre : } V = \\pi r^2 h", "Calcul du volume d'un cylindre en géométrie", "Math"),
      ("Théorème de l'angle extérieur d'un triangle", "\\text{L'angle extérieur d'un triangle est égal à la somme des deux angles intérieurs non adjacents.}", "Théorème de l'angle extérieur d'un triangle en géométrie", "Math"),
      ("Théorème de la bissectrice d'un angle", "\\text{La bissectrice d'un angle divise cet angle en deux angles égaux.}", "Théorème de la bissectrice d'un angle en géométrie", "Math"),
      ("Équation de la droite normale à un cercle", "\\text{Équation de la droite normale à un cercle en un point donné } \\(x_0, y_0\\) \\text{ : } \\(x - x_0\\)^2 + \\(y - y_0\\)^2 = r^2", "Équation de la droite normale à un cercle en géométrie", "Math"),
      ("Théorème de la médiane d'un trapèze", "\\text{La médiane d'un trapèze est égale à la moitié de la somme des bases.}", "Théorème de la médiane d'un trapèze en géométrie", "Math"),
      ("Formule de la régression linéaire", "\\text{Équation de régression linéaire : } y = a + bx", "Formule de la régression linéaire en statistiques", "Math"),
      ("Théorème de la droite des milieux", "\\text{La droite des milieux d'un triangle relie les milieux des côtés et est parallèle à la base.}", "Théorème de la droite des milieux en géométrie", "Math"),
      ("Équation du cercle dans un système de coordonnées", "\\text{Équation d'un cercle de rayon } r \\text{ centré à l'origine } \\(0,0\\) \\text{ : } x^2 + y^2 = r^2", "Équation du cercle dans un système de coordonnées en géométrie", "Math"),
      ("Calcul de la dérivée seconde", "\\text{Calcul de la dérivée seconde : } f''\\(x\\) = \\frac{d^2f}{dx^2}", "Calcul de la dérivée seconde en mathématiques", "Math"),
      ("Calcul de l'aire d'un parallélogramme", "\\text{Aire d'un parallélogramme : } A = \\text{base} \\times \\text{hauteur}", "Calcul de l'aire d'un parallélogramme en géométrie", "Math"),
      ("Formule de l'aire d'un losange", "\\text{Aire d'un losange : } A = \\frac{d_1 \\times d_2}{2}", "Calcul de l'aire d'un losange en géométrie", "Math"),
      ("Formule de la loi binomiale", "\\text{Loi binomiale : } P\\(X = k\\) = \\binom{n}{k}p^k\\(1-p\\)^{n-k}", "Formule de la loi binomiale en statistiques", "Math"),
      ("Calcul de la médiane d'un triangle", "\\text{La médiane d'un triangle est une droite qui relie un sommet à un point sur le côté opposé.}", "Calcul de la médiane d'un triangle en géométrie", "Math"),
      ("Théorème de l'angle inscrit dans un demi-cercle", "\\text{Dans un demi-cercle, tout angle inscrit est un angle droit.}", "Théorème de l'angle inscrit dans un demi-cercle en géométrie", "Math"),
      ("Formule de la loi des grands nombres", "\\text{Loi des grands nombres : } \\lim_{n\\to\\infty} P\\left\\(\\left|\\frac{S_n}{n} - \\mu\\right| < \\epsilon\\right\\) = 1", "Formule de la loi des grands nombres en probabilités", "Math"),
      ("Formule du produit scalaire", "\\text{Produit scalaire entre deux vecteurs } \\mathbf{u} = \\(a, b\\) \\text{ et } \\mathbf{v} = \\(c, d\\) : \\mathbf{u} \\cdot \\mathbf{v} = ac + bd", "Formule du produit scalaire en mathématiques", "Math"),
      ("Formule de la médiane d'un polygone", "\\text{La médiane d'un polygone est une ligne droite reliant un sommet à un point sur le côté opposé.}", "Formule de la médiane d'un polygone en géométrie", "Math"),
      ("Équation de la droite sécante à deux cercles", "\\text{Équation de la droite sécante à deux cercles centrés à }\\(x_1, y_1\\) \\text{ et }\\(x_2, y_2\\) \\text{ avec des rayons } r_1 \\text{ et } r_2 : \\(x - x_1\\)^2 + \\(y - y_1\\)^2 = r_1^2 \\text{ et } \\(x - x_2\\)^2 + \\(y - y_2\\)^2 = r_2^2", "Équation de la droite sécante à deux cercles en géométrie", "Math"),
      ("Calcul de l'aire d'un secteur circulaire", "\\text{Aire d'un secteur circulaire : } A = \\frac{\\theta}{360^\\circ}\\pi r^2", "Calcul de l'aire d'un secteur circulaire en géométrie", "Math"),
      ("Théorème de la droite perpendiculaire", "\\text{Si deux droites sont perpendiculaires, alors leurs pentes sont négatives inverses l'une de l'autre.}", "Théorème de la droite perpendiculaire en géométrie", "Math"),
      ("Formule de la médiane d'un losange", "\\text{La médiane d'un losange est une ligne droite reliant un sommet à un point sur le côté opposé.}", "Formule de la médiane d'un losange en géométrie", "Math"),
      ("Calcul de l'aire d'un hexagone", "\\text{Aire d'un hexagone : } A = \\frac{3\\sqrt{3}}{2}s^2", "Calcul de l'aire d'un hexagone en géométrie", "Math"),
      ("Formule de la loi de Poisson", "\\text{Loi de Poisson : } P\\(X = k\\) = \\frac{e^{-\\lambda}\\lambda^k}{k!}", "Formule de la loi de Poisson en probabilités", "Math"),
      ("Théorème de la droite parallèle", "\\text{Si deux droites sont parallèles, alors leurs pentes sont égales.}", "Théorème de la droite parallèle en géométrie", "Math"),
      ("Calcul de la médiane d'un losange", "\\text{La médiane d'un losange est une ligne droite reliant un sommet à un point sur le côté opposé.}", "Calcul de la médiane d'un losange en géométrie", "Math"),
      ("Formule de la loi de Bernoulli", "\\text{Loi de Bernoulli : } P\\(X = k\\) = \\(nCk\\) p^k \\(1-p\\)^{n-k}", "Formule de la loi de Bernoulli en probabilités", "Math"),
      ("Formule du volume d'une pyramide", "\\text{Volume d'une pyramide : } V = \\frac{1}{3}A_bh", "Calcul du volume d'une pyramide en géométrie", "Math"),
      ("Formule de la loi hypergéométrique", "\\text{Loi hypergéométrique : } P\\(X = k\\) = \\frac{{mCk \\cdot \\(N-m\\)C\\(n-k\\)}}{{NCn}}", "Formule de la loi hypergéométrique en probabilités", "Math"),
      ("Calcul de l'aire d'un secteur annulaire", "\\text{Aire d'un secteur annulaire : } A = \\frac{\\theta}{360^\\circ}\\(\\pi R^2 - \\pi r^2\\)", "Calcul de l'aire d'un secteur annulaire en géométrie", "Math"),
      ("Formule de la loi exponentielle", "\\text{Loi exponentielle : } f\\(x\\) = \\begin{cases} \\lambda e^{-\\lambda x} & \\text{si } x \\geq 0 \\\\ 0 & \\text{si } x < 0 \\end{cases}", "Formule de la loi exponentielle en probabilités", "Math"),
      ("Formule du volume d'un cône", "\\text{Volume d'un cône : } V = \\frac{1}{3}\\pi r^2 h", "Calcul du volume d'un cône en géométrie", "Math"),
      ("Formule de la loi uniforme", "\\text{Loi uniforme : } f\\(x\\) = \\frac{1}{b-a} \\text{ pour } a \\leq x \\leq b, \\text{ sinon } f\\(x\\) = 0", "Formule de la loi uniforme en probabilités", "Math"),
      ("Formule de la loi normale standard", "\\text{Loi normale standard : } f\\(x\\) = \\frac{1}{\\sqrt{2\\pi}}e^{-x^2/2}", "Formule de la loi normale standard en probabilités", "Math"),
      ("Formule de la loi de Poisson", "\\text{Loi de Poisson : } P\\(X = k\\) = \\frac{e^{-\\lambda}\\lambda^k}{k!}", "Formule de la loi de Poisson en probabilités", "Math"),
      ("Calcul de l'aire d'un segment circulaire", "\\text{Aire d'un segment circulaire : } A = \\frac{\\theta}{360^\\circ}\\pi r^2 - \\frac{1}{2}r^2\\sin\\(\\theta\\)", "Calcul de l'aire d'un segment circulaire en géométrie", "Math"),
      ("Formule du volume d'une sphère", "\\text{Volume d'une sphère : } V = \\frac{4}{3}\\pi r^3", "Calcul du volume d'une sphère en géométrie", "Math"),
      ("Formule du volume d'un prisme", "\\text{Volume d'un prisme : } V = \\text{aire de la base} \\times \\text{hauteur}", "Calcul du volume d'un prisme en géométrie", "Math"),
      ("Formule du produit vectoriel", "\\text{Produit vectoriel entre deux vecteurs } \\mathbf{u} = \\(a, b, c\\) \\text{ et } \\mathbf{v} = \\(d, e, f\\) : \\mathbf{u} \\times \\mathbf{v} = \\(bf-ce, cd-af, ae-bd\\)", "Formule du produit vectoriel en mathématiques", "Math"),
      ("Formule du déterminant d'une matrice 2x2", "\\text{Déterminant d'une matrice 2x2 : } \\text{det}\\(A\\) = ad - bc", "Formule du déterminant en mathématiques", "Math"),
      ("Formule du déterminant d'une matrice 3x3", "\\text{Déterminant d'une matrice 3x3 : } \\text{det}\\(A\\) = a\\(ei - fh\\) - b\\(di - fg\\) + c\\(dh - eg\\)", "Formule du déterminant en mathématiques", "Math"),
      ("Formule du discriminant", "\\text{Le discriminant d'une équation quadratique } ax^2 + bx + c = 0 \\text{ est donné par : } \\Delta = b^2 - 4ac", "Formule du discriminant en mathématiques", "Math"),
      ("Formule du binôme de Newton", "\\(a + b\\)^n = \\sum_{k=0}^{n} \\binom{n}{k} a^{n-k}b^k", "Formule du binôme de Newton en mathématiques", "Math"),
      ("Formule de la dérivée d'une fonction composée", "\\text{Dérivée d'une fonction composée } \\(f\\(g\\(x\\)\\)\\)' = f'\\(g\\(x\\)\\)g'\\(x\\)", "Formule de la dérivée d'une fonction composée en mathématiques", "Math"),
      ("Formule de la dérivée de ln\\(x\\)", "\\frac{d}{dx}\\(\\ln\\(x\\)\\) = \\frac{1}{x}", "Formule de la dérivée de ln\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale définie", "\\int_{a}^{b} f\\(x\\) dx", "Formule de l'intégrale définie en mathématiques", "Math"),
      ("Formule de la somme des termes d'une série arithmétique", "\\text{Somme des } n \\text{ premiers termes d'une série arithmétique : } S_n = \\frac{n}{2}[2a + \\(n-1\\)d]", "Formule de la somme des termes d'une série arithmétique en mathématiques", "Math"),
      ("Formule de la somme des termes d'une série géométrique", "\\text{Somme des } n \\text{ premiers termes d'une série géométrique : } S_n = \\frac{a\\(1-r^n\\)}{1-r}", "Formule de la somme des termes d'une série géométrique en mathématiques", "Math"),
      ("Formule de la loi des gaz parfaits", "PV = nRT", "Formule de la loi des gaz parfaits en physique", "Math"),
      ("Formule du théorème de Pythagore en 3D", "\\text{Dans l'espace, pour un triangle droit : } c^2 = a^2 + b^2", "Théorème de Pythagore en trois dimensions en géométrie", "Math"),
      ("Formule de la dérivée de cos\\(x\\)", "\\frac{d}{dx}\\(\\cos\\(x\\)\\) = -\\sin\\(x\\)", "Formule de la dérivée de cos\\(x\\) en mathématiques", "Math"),
      ("Formule de la dérivée de sin\\(x\\)", "\\frac{d}{dx}\\(\\sin\\(x\\)\\) = \\cos\\(x\\)", "Formule de la dérivée de sin\\(x\\) en mathématiques", "Math"),
      ("Formule de la dérivée de tan\\(x\\)", "\\frac{d}{dx}\\(\\tan\\(x\\)\\) = \\sec^2\\(x\\)", "Formule de la dérivée de tan\\(x\\) en mathématiques", "Math"),
      ("Formule de la dérivée de cot\\(x\\)", "\\frac{d}{dx}\\(\\cot\\(x\\)\\) = -\\csc^2\\(x\\)", "Formule de la dérivée de cot\\(x\\) en mathématiques", "Math"),
      ("Formule de la dérivée de sec\\(x\\)", "\\frac{d}{dx}\\(\\sec\\(x\\)\\) = \\sec\\(x\\)\\tan\\(x\\)", "Formule de la dérivée de sec\\(x\\) en mathématiques", "Math"),
      ("Formule de la dérivée de csc\\(x\\)", "\\frac{d}{dx}\\(\\csc\\(x\\)\\) = -\\csc\\(x\\)\\cot\\(x\\)", "Formule de la dérivée de csc\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de ln\\(x\\)", "\\int \\ln\\(x\\) dx = x\\ln\\(x\\) - \\int x\\frac{1}{x}dx = x\\ln\\(x\\) - x + C", "Formule de l'intégrale de ln\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de e^x", "\\int e^x dx = e^x + C", "Formule de l'intégrale de e^x en mathématiques", "Math"),
      ("Formule de l'intégrale de sin\\(x\\)", "\\int \\sin\\(x\\) dx = -\\cos\\(x\\) + C", "Formule de l'intégrale de sin\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de cos\\(x\\)", "\\int \\cos\\(x\\) dx = \\sin\\(x\\) + C", "Formule de l'intégrale de cos\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de tan\\(x\\)", "\\int \\tan\\(x\\) dx = -\\ln|\\cos\\(x\\)| + C", "Formule de l'intégrale de tan\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de cot\\(x\\)", "\\int \\cot\\(x\\) dx = \\ln|\\sin\\(x\\)| + C", "Formule de l'intégrale de cot\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de sec\\(x\\)", "\\int \\sec\\(x\\) dx = \\ln|\\sec\\(x\\) + \\tan\\(x\\)| + C", "Formule de l'intégrale de sec\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de csc\\(x\\)", "\\int \\csc\\(x\\) dx = -\\ln|\\csc\\(x\\) + \\cot\\(x\\)| + C", "Formule de l'intégrale de csc\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction inverse", "\\int \\frac{1}{x} dx = \\ln|x| + C", "Formule de l'intégrale de la fonction inverse en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction inverse carrée", "\\int \\frac{1}{x^2} dx = -\\frac{1}{x} + C", "Formule de l'intégrale de la fonction inverse carrée en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction racine carrée", "\\int \\sqrt{x} dx = \\frac{2}{3}x^{3/2} + C", "Formule de l'intégrale de la fonction racine carrée en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction exponentielle", "\\int e^x dx = e^x + C", "Formule de l'intégrale de la fonction exponentielle en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction logarithmique", "\\int \\ln\\(x\\) dx = x\\(\\ln\\(x\\) - 1\\) + C", "Formule de l'intégrale de la fonction logarithmique en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction arcsin\\(x\\)", "\\int \\arcsin\\(x\\) dx = x\\arcsin\\(x\\) + \\sqrt{1-x^2} + C", "Formule de l'intégrale de la fonction arcsin\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction arccos\\(x\\)", "\\int \\arccos\\(x\\) dx = x\\arccos\\(x\\) - \\sqrt{1-x^2} + C", "Formule de l'intégrale de la fonction arccos\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction arctan\\(x\\)", "\\int \\arctan\\(x\\) dx = x\\arctan\\(x\\) - \\frac{1}{2}\\ln\\(1+x^2\\) + C", "Formule de l'intégrale de la fonction arctan\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction sinh\\(x\\)", "\\int \\sinh\\(x\\) dx = \\cosh\\(x\\) + C", "Formule de l'intégrale de la fonction sinh\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction cosh\\(x\\)", "\\int \\cosh\\(x\\) dx = \\sinh\\(x\\) + C", "Formule de l'intégrale de la fonction cosh\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction tanh\\(x\\)", "\\int \\tanh\\(x\\) dx = \\ln|\\cosh\\(x\\)| + C", "Formule de l'intégrale de la fonction tanh\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction sech\\(x\\)", "\\int \\sech\\(x\\) dx = \\arctan\\(e^x\\) + C", "Formule de l'intégrale de la fonction sech\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction csch\\(x\\)", "\\int \\csch\\(x\\) dx = \\arctan\\(e^x\\) + C", "Formule de l'intégrale de la fonction csch\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction coth\\(x\\)", "\\int \\coth\\(x\\) dx = \\ln|\\sinh\\(x\\)| + C", "Formule de l'intégrale de la fonction coth\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction arcsinh\\(x\\)", "\\int \\text{arcsinh}\\(x\\) dx = x\\text{arcsinh}\\(x\\) - \\sqrt{x^2+1} + C", "Formule de l'intégrale de la fonction arcsinh\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de la fonction arccosh\\(x\\)", "\\int \\text{arccosh}\\(x\\) dx = x\\text{arccosh}\\(x\\) - \\sqrt{x^2-1} + C", "Formule de l'intégrale de la fonction arccosh\\(x\\) en mathématiques", "Math"),
      ("Formule de la loi des cosinus", "\\text{Loi des cosinus : } c^2 = a^2 + b^2 - 2ab\\cos\\(C\\)", "Formule de la loi des cosinus en trigonométrie", "Math"),
      ("Formule de la loi des sinus", "\\text{Loi des sinus : } \\frac{a}{\\sin\\(A\\)} = \\frac{b}{\\sin\\(B\\)} = \\frac{c}{\\sin\\(C\\)}", "Formule de la loi des sinus en trigonométrie", "Math"),
      ("Formule de l'aire du triangle", "\\text{Aire d'un triangle : } A = \\frac{1}{2}ab\\sin\\(C\\)", "Formule de l'aire d'un triangle en géométrie", "Math"),
      ("Formule de l'aire d'un trapèze", "\\text{Aire d'un trapèze : } A = \\frac{1}{2}\\(a+b\\)h", "Formule de l'aire d'un trapèze en géométrie", "Math"),
      ("Formule de l'aire d'un parallélogramme", "\\text{Aire d'un parallélogramme : } A = bh", "Formule de l'aire d'un parallélogramme en géométrie", "Math"),
      ("Formule de l'aire d'un cercle", "\\text{Aire d'un cercle : } A = \\pi r^2", "Formule de l'aire d'un cercle en géométrie", "Math"),
      ("Formule de l'aire d'un triangle équilatéral", "\\text{Aire d'un triangle équilatéral : } A = \\frac{\\sqrt{3}}{4}a^2", "Formule de l'aire d'un triangle équilatéral en géométrie", "Math"),
      ("Formule de l'aire d'un losange", "\\text{Aire d'un losange : } A = \\frac{d_1d_2}{2}", "Formule de l'aire d'un losange en géométrie", "Math"),
      ("Formule de l'aire d'un rectangle", "\\text{Aire d'un rectangle : } A = lw", "Formule de l'aire d'un rectangle en géométrie", "Math"),
      ("Formule de l'aire d'un cube", "\\text{Aire d'un cube : } A = 6s^2", "Formule de l'aire d'un cube en géométrie", "Math"),
      ("Formule du volume d'un prisme droit", "\\text{Volume d'un prisme droit : } V = Ah", "Formule du volume d'un prisme droit en géométrie", "Math"),
      ("Formule du volume d'un cylindre", "\\text{Volume d'un cylindre : } V = \\pi r^2h", "Formule du volume d'un cylindre en géométrie", "Math"),
      ("Formule du volume d'un cône", "\\text{Volume d'un cône : } V = \\frac{1}{3}\\pi r^2h", "Formule du volume d'un cône en géométrie", "Math"),
      ("Formule du volume d'une pyramide", "\\text{Volume d'une pyramide : } V = \\frac{1}{3}Bh", "Formule du volume d'une pyramide en géométrie", "Math"),
      ("Formule du volume d'une sphère", "\\text{Volume d'une sphère : } V = \\frac{4}{3}\\pi r^3", "Formule du volume d'une sphère en géométrie", "Math"),
      ("Formule de la distance entre deux points dans l'espace", "\\text{Distance entre deux points } P_1\\(x_1, y_1, z_1\\) \\text{ et } P_2\\(x_2, y_2, z_2\\) : d = \\sqrt{\\(x_2-x_1\\)^2 + \\(y_2-y_1\\)^2 + \\(z_2-z_1\\)^2}", "Formule de la distance entre deux points dans l'espace en géométrie", "Math"),
        ("Formule de la dérivée d'une fonction en fraction", "\\frac{d}{dx}\\left\\(\\frac{f\\(x\\)}{g\\(x\\)}\\right\\) = \\frac{f'\\(x\\)g\\(x\\) - f\\(x\\)g'\\(x\\)}{\\(g\\(x\\)\\)^2}", "Formule de la dérivée d'une fonction en fraction en mathématiques", "Math"),
      ("Formule de la limite d'une fonction", "\\lim_{x \\to a} f\\(x\\) = L", "Formule de la limite d'une fonction en mathématiques", "Math"),
      ("Formule de l'asymptote horizontale", "y = L \\text{ est une asymptote horizontale à la courbe de } f\\(x\\) \\text{ si } \\lim_{x \\to \\infty} f\\(x\\) = L", "Formule de l'asymptote horizontale en mathématiques", "Math"),
      ("Formule de l'asymptote verticale", "x = a \\text{ est une asymptote verticale à la courbe de } f\\(x\\) \\text{ si } \\lim_{x \\to a^+} f\\(x\\) = \\infty \\text{ ou } \\lim_{x \\to a^-} f\\(x\\) = \\infty", "Formule de l'asymptote verticale en mathématiques", "Math"),
      ("Formule du discriminant d'un polynôme de degré deux", "\\text{Le discriminant d'un polynôme } ax^2 + bx + c = 0 \\text{ est donné par : } \\Delta = b^2 - 4ac", "Formule du discriminant en mathématiques", "Math"),
      ("Formule de la solution d'un polynôme de degré deux", "\\text{Les solutions d'un polynôme de degré deux } ax^2 + bx + c = 0 \\text{ sont données par : } x = \\frac{-b \\pm \\sqrt{\\Delta}}{2a}", "Formule de la solution d'un polynôme de degré deux en mathématiques", "Math"),
      ("Formule de la dérivée de e^u", "\\frac{d}{dx}\\(e^u\\) = u'e^u", "Formule de la dérivée de e^u en mathématiques", "Math"),
      ("Formule de la dérivée de ln\\(u\\)", "\\frac{d}{dx}\\(\\ln\\(u\\)\\) = \\frac{u'}{u}", "Formule de la dérivée de ln\\(u\\) en mathématiques", "Math"),
      ("Formule de la dérivée de sin\\(ax\\)", "\\frac{d}{dx}\\(\\sin\\(ax\\)\\) = a\\cos\\(ax\\)", "Formule de la dérivée de sin\\(ax\\) en mathématiques", "Math"),
      ("Formule de la dérivée de cos\\(ax\\)", "\\frac{d}{dx}\\(\\cos\\(ax\\)\\) = -a\\sin\\(ax\\)", "Formule de la dérivée de cos\\(ax\\) en mathématiques", "Math"),
      ("Formule de la dérivée de tan\\(ax\\)", "\\frac{d}{dx}\\(\\tan\\(ax\\)\\) = a\\sec^2\\(ax\\)", "Formule de la dérivée de tan\\(ax\\) en mathématiques", "Math"),
      ("Formule de la dérivée de cot\\(ax\\)", "\\frac{d}{dx}\\(\\cot\\(ax\\)\\) = -a\\csc^2\\(ax\\)", "Formule de la dérivée de cot\\(ax\\) en mathématiques", "Math"),
      ("Formule de la dérivée de sec\\(ax\\)", "\\frac{d}{dx}\\(\\sec\\(ax\\)\\) = a\\sec\\(ax\\)\\tan\\(ax\\)", "Formule de la dérivée de sec\\(ax\\) en mathématiques", "Math"),
      ("Formule de la dérivée de csc\\(ax\\)", "\\frac{d}{dx}\\(\\csc\\(ax\\)\\) = -a\\csc\\(ax\\)\\cot\\(ax\\)", "Formule de la dérivée de csc\\(ax\\) en mathématiques", "Math"),
      ("Dérivée de u^n", "\\frac{d}{dx}\\(u^n\\) = nu^{n-1}", "Dérivée de puissances en mathématiques", "Math"),
      ("Dérivée de e^u", "\\frac{d}{dx}\\(e^u\\) = u'e^u", "Dérivée de la fonction exponentielle en mathématiques", "Math"),
      ("Dérivée de ln\\(u\\)", "\\frac{d}{dx}\\(\\ln\\(u\\)\\) = \\frac{u'}{u}", "Dérivée de la fonction logarithme naturel en mathématiques", "Math"),
      ("Dérivée de sin\\(u\\)", "\\frac{d}{dx}\\(\\sin\\(u\\)\\) = u'\\cos\\(u\\)", "Dérivée de la fonction sinus en mathématiques", "Math"),
      ("Dérivée de cos\\(u\\)", "\\frac{d}{dx}\\(\\cos\\(u\\)\\) = -u'\\sin\\(u\\)", "Dérivée de la fonction cosinus en mathématiques", "Math"),
      ("Dérivée de tan\\(u\\)", "\\frac{d}{dx}\\(\\tan\\(u\\)\\) = u'\\sec^2\\(u\\)", "Dérivée de la fonction tangente en mathématiques", "Math"),
      ("Dérivée de cot\\(u\\)", "\\frac{d}{dx}\\(\\cot\\(u\\)\\) = -u'\\csc^2\\(u\\)", "Dérivée de la fonction cotangente en mathématiques", "Math"),
      ("Dérivée de sec\\(u\\)", "\\frac{d}{dx}\\(\\sec\\(u\\)\\) = u'\\sec\\(u\\)\\tan\\(u\\)", "Dérivée de la fonction sécante en mathématiques", "Math"),
      ("Dérivée de csc\\(u\\)", "\\frac{d}{dx}\\(\\csc\\(u\\)\\) = -u'\\csc\\(u\\)\\cot\\(u\\)", "Dérivée de la fonction cosécante en mathématiques", "Math"),
      ("Intégrale de u^n", "\\int u^n du = \\frac{u^{n+1}}{n+1} + C", "Intégrale de puissances en mathématiques", "Math"),
      ("Intégrale de e^u", "\\int e^u du = e^u + C", "Intégrale de la fonction exponentielle en mathématiques", "Math"),
      ("Intégrale de ln\\(u\\)", "\\int \\ln\\(u\\) du = u\\(\\ln\\(u\\) - 1\\) + C", "Intégrale de la fonction logarithme naturel en mathématiques", "Math"),
      ("Intégrale de sin\\(u\\)", "\\int \\sin\\(u\\) du = -\\cos\\(u\\) + C", "Intégrale de la fonction sinus en mathématiques", "Math"),
      ("Intégrale de cos\\(u\\)", "\\int \\cos\\(u\\) du = \\sin\\(u\\) + C", "Intégrale de la fonction cosinus en mathématiques", "Math"),
      ("Intégrale de tan\\(u\\)", "\\int \\tan\\(u\\) du = -\\ln|\\cos\\(u\\)| + C", "Intégrale de la fonction tangente en mathématiques", "Math"),
      ("Équation différentielle du premier ordre", "\\frac{dy}{dx} = f\\(x, y\\)", "Équation différentielle du premier ordre en mathématiques", "Math"),
      ("Équation différentielle linéaire", "\\frac{d^2y}{dx^2} + p\\(x\\)\\frac{dy}{dx} + q\\(x\\)y = f\\(x\\)", "Équation différentielle linéaire en mathématiques", "Math"),
       ("Formule de l'intégrale de cos^2\\(x\\)", "\\int \\cos^2\\(x\\) dx = \\frac{1}{2}\\(x + \\sin\\(x\\)\\cos\\(x\\)\\) + C", "Formule de l'intégrale de cos^2\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de sin^2\\(x\\)", "\\int \\sin^2\\(x\\) dx = \\frac{1}{2}\\(x - \\sin\\(x\\)\\cos\\(x\\)\\) + C", "Formule de l'intégrale de sin^2\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de cos^n\\(x\\)", "\\int \\cos^n\\(x\\) dx = \\frac{1}{n}\\cos^{n-1}\\(x\\)\\sin\\(x\\) + \\frac{n-1}{n}\\int \\cos^{n-2}\\(x\\) dx", "Formule de l'intégrale de cos^n\\(x\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de sin^n\\(x\\)", "\\int \\sin^n\\(x\\) dx = -\\frac{1}{n}\\sin^{n-1}\\(x\\)\\cos\\(x\\) + \\frac{n-1}{n}\\int \\sin^{n-2}\\(x\\) dx", "Formule de l'intégrale de sin^n\\(x\\) en mathématiques", "Math"),
      ("Équation différentielle du second ordre homogène", "\\frac{d^2y}{dx^2} + p\\(x\\)\\frac{dy}{dx} + q\\(x\\)y = 0", "Équation différentielle du second ordre homogène en mathématiques", "Math"),
      ("Équation différentielle du second ordre non homogène", "\\frac{d^2y}{dx^2} + p\\(x\\)\\frac{dy}{dx} + q\\(x\\)y = f\\(x\\)", "Équation différentielle du second ordre non homogène en mathématiques", "Math"),
      ("Formule du produit vectoriel", "\\vec{u} \\times \\vec{v} = \\(u_2v_3 - u_3v_2\\)\\hat{i} + \\(u_3v_1 - u_1v_3\\)\\hat{j} + \\(u_1v_2 - u_2v_1\\)\\hat{k}", "Formule du produit vectoriel en mathématiques", "Math"),
      ("Formule du produit scalaire", "\\vec{u} \\cdot \\vec{v} = u_1v_1 + u_2v_2 + u_3v_3", "Formule du produit scalaire en mathématiques", "Math"),
      ("Formule de la dérivée de arctan\\(u\\)", "\\frac{d}{dx}\\(\\arctan\\(u\\)\\) = \\frac{u'}{1 + u^2}", "Formule de la dérivée de arctan\\(u\\) en mathématiques", "Math"),
      ("Formule de la dérivée de arcsin\\(u\\)", "\\frac{d}{dx}\\(\\arcsin\\(u\\)\\) = \\frac{u'}{\\sqrt{1 - u^2}}", "Formule de la dérivée de arcsin\\(u\\) en mathématiques", "Math"),
      ("Formule de la dérivée de arccos\\(u\\)", "\\frac{d}{dx}\\(\\arccos\\(u\\)\\) = -\\frac{u'}{\\sqrt{1 - u^2}}", "Formule de la dérivée de arccos\\(u\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de arctan\\(u\\)", "\\int \\arctan\\(u\\) du = u\\arctan\\(u\\) - \\frac{1}{2}\\ln\\(1 + u^2\\) + C", "Formule de l'intégrale de arctan\\(u\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de arcsin\\(u\\)", "\\int \\arcsin\\(u\\) du = u\\arcsin\\(u\\) + \\sqrt{1 - u^2} + C", "Formule de l'intégrale de arcsin\\(u\\) en mathématiques", "Math"),
      ("Formule de l'intégrale de arccos\\(u\\)", "\\int \\arccos\\(u\\) du = u\\arccos\\(u\\) - \\sqrt{1 - u^2} + C", "Formule de l'intégrale de arccos\\(u\\) en mathématiques", "Math"),
       ("Équation de Bernoulli", "\\frac{dy}{dx} + p\\(x\\)y = q\\(x\\)y^n", "Équation de Bernoulli en mathématiques", "Math"),
      ("Équation de Riccati", "\\frac{dy}{dx} = p\\(x\\)y^2 + q\\(x\\)y + r\\(x\\)", "Équation de Riccati en mathématiques", "Math"),
      ("Équation de Bessel", "x^2\\frac{d^2y}{dx^2} + x\\frac{dy}{dx} + \\(x^2 - n^2\\)y = 0", "Équation de Bessel en mathématiques", "Math"),
      ("Équation de Legendre", "\\(1-x^2\\)\\frac{d^2y}{dx^2} - 2x\\frac{dy}{dx} + n\\(n+1\\)y = 0", "Équation de Legendre en mathématiques", "Math"),
      ("Équation de Laplace", "\\nabla^2u = 0", "Équation de Laplace en mathématiques", "Math"),
      ("Équation de la chaleur", "\\frac{\\partial u}{\\partial t} = k\\nabla^2u", "Équation de la chaleur en mathématiques", "Math"),
      ("Équation des ondes", "\\frac{\\partial^2u}{\\partial t^2} = c^2\\nabla^2u", "Équation des ondes en mathématiques", "Math"),
      ("Équation de Schrödinger", "i\\hbar\\frac{\\partial\\Psi}{\\partial t} = -\\frac{\\hbar^2}{2m}\\nabla^2\\Psi + V\\Psi", "Équation de Schrödinger en physique quantique", "Math"),
      ("Équation de diffusion", "\\frac{\\partial\\rho}{\\partial t} = D\\nabla^2\\rho", "Équation de diffusion en sciences de la matière condensée", "Math"),
      ("Équation de Navier-Stokes", "\\rho\\left\\(\\frac{\\partial\\mathbf{v}}{\\partial t} + \\mathbf{v}\\cdot\\nabla\\mathbf{v}\\right\\) = -\\nabla P + \\eta\\nabla^2\\mathbf{v} + \\rho\\mathbf{g}", "Équation de Navier-Stokes en mécanique des fluides", "Math"),
      ("Équation de Maxwell", "\\nabla\\cdot\\mathbf{E} = \\frac{\\rho}{\\varepsilon_0}", "Équation de Gauss en électromagnétisme", "Math"),
      ("Équation de Maxwell", "\\nabla\\cdot\\mathbf{B} = 0", "Équation de Gauss du magnétisme en électromagnétisme", "Math"),
      ("Équation de Maxwell", "\\nabla\\times\\mathbf{E} = -\\frac{\\partial\\mathbf{B}}{\\partial t}", "Équation de Faraday en électromagnétisme", "Math"),
      ("Équation de Maxwell", "\\nabla\\times\\mathbf{B} = \\mu_0\\mathbf{J} + \\mu_0\\varepsilon_0\\frac{\\partial\\mathbf{E}}{\\partial t}", "Équation d'Ampère-Maxwell en électromagnétisme", "Math"),
       ("Équation différentielle du premier ordre", "\\frac{dy}{dx} = f\\(x, y\\)", "Équation différentielle du premier ordre en mathématiques", "Math"),
      ("Équation différentielle linéaire", "\\frac{d^2y}{dx^2} + p\\(x\\)\\frac{dy}{dx} + q\\(x\\)y = f\\(x\\)", "Équation différentielle linéaire en mathématiques", "Math"),
       ("Méthode de Gauss", "Ax = b", "Méthode de résolution de systèmes linéaires par élimination gaussienne", "Math"),
      ("Décomposition LU", "A = LU", "Décomposition d'une matrice en produit de matrices inférieure et supérieure", "Math"),
      ("Inversion de matrice", "A^{-1}", "Calcul de l'inverse d'une matrice A", "Math"),
      ("Déterminant de matrice", "|A|", "Calcul du déterminant d'une matrice A", "Math"),
      ("Calcul du rang d'une matrice", "rank\\(A\\)", "Détermination du rang d'une matrice A", "Math"),
      ("Vecteurs propres et valeurs propres", "Av = λv", "Calcul des vecteurs propres et des valeurs propres d'une matrice A", "Math"),
      ("Diagonalisation de matrice", "P^{-1}AP = D", "Transformation d'une matrice A en une forme diagonale D", "Math"),
      ("Méthode des moindres carrés", "Ax \\approx b", "Méthode de résolution de systèmes surdéterminés", "Math"),
      ("Factorisation QR", "A = QR", "Factorisation d'une matrice A en produit de matrice orthogonale Q et triangulaire supérieure R", "Math"),
       ("Probabilité d'un événement", "P\\(A\\)", "Calcul de la probabilité d'un événement A", "Math"),
      ("Probabilité conjointe", "P\\(A ∩ B\\)", "Calcul de la probabilité conjointe de deux événements A et B", "Math"),
      ("Probabilité conditionnelle", "P\\(A | B\\)", "Calcul de la probabilité de l'événement A sachant que l'événement B s'est produit", "Math"),
      ("Règle de Bayes", "P\\(A | B\\) = \\frac{P\\(B | A\\)P\\(A\\)}{P\\(B\\)}", "Utilisation de la règle de Bayes pour inverser les probabilités conditionnelles", "Math"),
      ("Loi de probabilité", "P\\(X = x\\)", "Calcul de la probabilité qu'une variable aléatoire X prenne une valeur particulière x", "Math"),
      ("Espérance mathématique", "E\\(X\\)", "Calcul de l'espérance mathématique d'une variable aléatoire X", "Math"),
      ("Variance", "Var\\(X\\)", "Calcul de la variance d'une variable aléatoire X", "Math"),
      ("Écart-type", "σ\\(X\\)", "Calcul de l'écart-type d'une variable aléatoire X", "Math"),
      ("Loi normale", "N\\(μ, σ^2\\)", "Distribution de probabilité continue suivant une loi normale avec moyenne μ et variance σ^2", "Math"),
      ("Loi binomiale", "B\\(n, p\\)", "Distribution de probabilité discrète suivant une loi binomiale avec paramètres n \\(nombre d'essais\\) et p \\(probabilité de succès\\)", "Math"),
      ("Loi de Poisson", "P\\(λ\\)", "Distribution de probabilité discrète suivant une loi de Poisson avec paramètre λ", "Math"),
      ("Test d'hypothèse", "H0 : μ = μ0 vs. H1 : μ ≠ μ0", "Utilisation de tests statistiques pour évaluer des hypothèses sur les paramètres de la population", "Math"),
      ("Loi exponentielle", "f\\(x | λ\\) = λe^{-λx}", "Distribution de probabilité continue suivant une loi exponentielle avec paramètre λ", "Math"),
      ("Loi uniforme", "U\\(a, b\\)", "Distribution de probabilité continue suivant une loi uniforme entre les bornes a et b", "Math"),
      ("Loi de Bernoulli", "B\\(p\\)", "Distribution de probabilité discrète suivant une loi de Bernoulli avec paramètre p \\(probabilité de succès\\)", "Math"),
      ("Loi de Weibull", "f\\(x | λ, k\\) = \\(λ/k\\)\\(x/λ\\)^\\(k-1\\)e^{-\\(x/λ\\)^k}", "Distribution de probabilité continue suivant une loi de Weibull avec paramètres λ et k", "Math"),
      ("Loi de Student", "t\\(n\\)", "Distribution de probabilité continue suivant une loi de Student avec n degrés de liberté", "Math"),
      ("Loi de Fisher", "F\\(m, n\\)", "Distribution de probabilité continue suivant une loi de Fisher avec m et n degrés de liberté", "Math"),
      ("Loi de Poisson", "P\\(X = k\\) = \\frac{e^{-λ}λ^k}{k!}", "Distribution de probabilité discrète suivant une loi de Poisson avec paramètre λ", "Math"),
      ("Loi géométrique", "P\\(X = k\\) = \\(1-p\\)^\\(k-1\\)p", "Distribution de probabilité discrète suivant une loi géométrique avec paramètre p", "Math"),
      ("Loi hypergéométrique", "P\\(X = k\\) = \\frac{\\binom{K}{k}\\binom{N-K}{n-k}}{\\binom{N}{n}}", "Distribution de probabilité discrète suivant une loi hypergéométrique", "Math"),
      ("Loi de Binomiale négative", "P\\(X = k\\) = \\binom{k+r-1}{k}p^r\\(1-p\\)^k", "Distribution de probabilité discrète suivant une loi de Binomiale négative avec paramètres r et p", "Math"),
      ("Loi multinomiale", "P\\(X1 = x1, X2 = x2, ..., Xk = xk\\) = \\frac{n!}{x1!x2!...xk!}p1^x1p2^x2...pk^xk", "Distribution de probabilité discrète suivant une loi multinomiale", "Math"),
       ("Loi de Bayes pour deux événements", "P\\(A | B\\) = \\frac{P\\(B | A\\)P\\(A\\)}{P\\(B | A\\)P\\(A\\) + P\\(B | ¬A\\)P\\(¬A\\)}", "Utilisation de la règle de Bayes pour deux événements A et B", "Math"),
      ("Intervalles de confiance", "[\\bar{x} - z_{α/2}\\frac{σ}{√n}, \\bar{x} + z_{α/2}\\frac{σ}{√n}]", "Calcul des intervalles de confiance pour la moyenne d'une population", "Math"),
      ("Test de chi carré", "χ² = Σ\\(\\frac{\\(O - E\\)²}{E}\\)", "Test statistique pour évaluer l'indépendance entre deux variables catégorielles", "Math"),
      ("Régression linéaire", "y = β₀ + β₁x + ε", "Modèle de régression linéaire pour ajuster une droite aux données", "Math"),
      ("Coefficient de corrélation", "r = \\frac{Σ\\(\\(x-\\bar{x}\\)\\(y-\\bar{y}\\)\\)}{√{Σ\\(x-\\bar{x}\\)²}√{Σ\\(y-\\bar{y}\\)²}}", "Calcul du coefficient de corrélation entre deux variables", "Math"),
      ("Test d'hypothèse pour la moyenne", "H0 : μ = μ0 vs. H1 : μ ≠ μ0", "Test statistique pour évaluer si la moyenne d'une population est égale à une valeur donnée", "Math"),
      ("Test d'hypothèse pour la variance", "H0 : σ² = σ0² vs. H1 : σ² ≠ σ0²", "Test statistique pour évaluer si la variance d'une population est égale à une valeur donnée", "Math"),
      ("Loi de probabilité conjointe", "P\\(X = x, Y = y\\)", "Calcul de la probabilité conjointe de deux variables aléatoires X et Y", "Math"),
      ("Loi de probabilité marginale", "P\\(X = x\\)", "Calcul de la probabilité marginale d'une variable aléatoire X à partir de la probabilité conjointe", "Math"),
      ("Covariance", "Cov\\(X, Y\\) = E\\(\\(X - E\\(X\\)\\)\\(Y - E\\(Y\\)\\)\\)", "Calcul de la covariance entre deux variables aléatoires X et Y", "Math"),
      ("Régression logistique", "P\\(Y = 1 | X\\) = \\frac{1}{1 + e^{-\\(β₀ + β₁X\\)}}", "Modèle de régression logistique pour la classification binaire", "Math"),
       ("Écart-type", "σ\\(X\\)", "Calcul de l'écart-type d'une variable aléatoire X", "Math"),
      ("Variance échantillonnelle", "s²", "Calcul de la variance échantillonnelle d'un échantillon", "Math"),
      ("Moyenne échantillonnelle", "x̄", "Calcul de la moyenne échantillonnelle d'un échantillon", "Math"),
      ("Coefficient de variation", "CV = \\frac{σ}{μ}", "Calcul du coefficient de variation pour mesurer la variabilité relative", "Math"),
      ("Médiane", "Med\\(X\\)", "Calcul de la médiane d'un ensemble de données", "Math"),
      ("Mode", "Mode\\(X\\)", "Identification du mode \\(valeur la plus fréquente\\) d'un ensemble de données", "Math"),
      ("Quantiles", "Q\\(p\\)", "Calcul des quantiles pour diviser les données en percentiles", "Math"),
      ("Écart interquartile", "IQR = Q3 - Q1", "Calcul de l'écart interquartile pour mesurer la dispersion au sein des données", "Math"),
      ("Skewness", "Skew\\(X\\)", "Calcul du coefficient de skewness pour mesurer l'asymétrie des données", "Math"),
      ("Kurtosis", "Kurt\\(X\\)", "Calcul du coefficient de kurtosis pour mesurer la forme de la distribution des données", "Math"),
      ("Régression linéaire multiple", "Y = β₀ + β₁X₁ + β₂X₂ + ... + ε", "Modèle de régression linéaire pour plusieurs variables explicatives", "Math"),
      ("Analyse de variance \\(ANOVA\\)", "H0 : μ₁ = μ₂ = ... = μk vs. H1 : au moins une moyenne est différente", "Test statistique pour comparer les moyennes de plusieurs groupes", "Math"),
      ("Régression non linéaire", "y = f\\(x, β\\) + ε", "Modèle de régression pour ajuster des fonctions non linéaires aux données", "Math"),
       ("Coefficient de corrélation de Pearson", "r = \\frac{Σ\\(\\(x-\\bar{x}\\)\\(y-\\bar{y}\\)\\)}{√{Σ\\(x-\\bar{x}\\)²}√{Σ\\(y-\\bar{y}\\)²}}", "Mesure de la relation linéaire entre deux variables continues", "Math"),
      ("Coefficient de détermination \\(R²\\)", "R² = \\frac{Σ\\(yi - ŷ\\)²}{Σ\\(yi - ȳ\\)²}", "Mesure de l'ajustement d'un modèle de régression linéaire", "Math"),
      ("Test t de Student", "t = \\frac{\\bar{x} - μ}{s/√n}", "Test statistique pour comparer la moyenne d'un échantillon à une valeur de population", "Math"),
      ("Test de Kolmogorov-Smirnov", "D = max|F\\(X\\) - G\\(X\\)|", "Test statistique pour comparer deux distributions de probabilité", "Math"),
      ("Régression logistique multinomiale", "P\\(Y = j | X\\) = \\frac{e^\\(βj0 + βj1X1 + βj2X2 + ...\\)}{Σe^\\(βk0 + βk1X1 + βk2X2 + ...\\)}", "Modèle de régression logistique pour la classification multiclasse", "Math"),
      ("Méthode de Monte Carlo", "Estimation d'intégrales ou de probabilités en utilisant des échantillons aléatoires", "Technique numérique pour résoudre des problèmes complexes en probabilité et statistiques", "Math"),
      ("Théorème central limite", "La distribution des moyennes d'échantillons suit une loi normale pour des échantillons suffisamment grands", "Principe fondamental de la statistique reliant les échantillons à la distribution normale", "Math"),
      ("Test de chi carré d'indépendance", "χ² = Σ\\(\\frac{\\(O - E\\)²}{E}\\)", "Test statistique pour évaluer l'indépendance entre deux variables catégorielles", "Math"),
      ("Loi de Student à n degrés de liberté", "t\\(n\\)", "Distribution de probabilité continue suivant la loi de Student avec n degrés de liberté", "Math"),
      ("Loi de Fisher à m et n degrés de liberté", "F\\(m, n\\)", "Distribution de probabilité continue suivant la loi de Fisher avec m et n degrés de liberté", "Math"),
       ("Moyenne pondérée", "\\bar{x} = \\frac{Σ\\(wx\\)}{Σw}", "Calcul de la moyenne pondérée d'un ensemble de données pondérées", "Math"),
      ("Écart-type pondéré", "σ_w\\(X\\) = √{\\frac{Σ\\(w\\(x-\\bar{x}\\)²\\)}{Σw}}", "Calcul de l'écart-type pondéré d'un ensemble de données pondérées", "Math"),
      ("Coefficient de corrélation pondéré", "r_w = \\frac{Σ\\(w\\(x-\\bar{x}\\)\\(y-\\bar{y}\\)\\)}{√{Σw\\(x-\\bar{x}\\)²}√{Σw\\(y-\\bar{y}\\)²}}", "Calcul du coefficient de corrélation pondéré entre deux variables continues", "Math"),
      ("Régression linéaire pondérée", "y = β₀ + β₁x + ε", "Modèle de régression linéaire pondérée pour ajuster une droite aux données pondérées", "Math"),
      ("Coefficient de corrélation de Spearman", "ρ = 1 - \\frac{6Σd²}{n\\(n²-1\\)}", "Calcul du coefficient de corrélation de Spearman pour des données ordinales ou non paramétriques", "Math"),
      ("Régression logistique multinomiale pondérée", "P\\(Y = j | X\\) = \\frac{e^\\(βj0 + βj1X1 + βj2X2 + ...\\)}{Σe^\\(βk0 + βk1X1 + βk2X2 + ...\\)}", "Modèle de régression logistique multinomiale pondérée pour la classification multiclasse avec données pondérées", "Math"),
      ("Analyse des séries chronologiques", "Étude des données sur une période de temps pour détecter des tendances, des saisons et des modèles", "Technique d'analyse statistique pour les données temporelles", "Math"),
      ("Échantillonnage aléatoire simple", "Sélection aléatoire d'échantillons à partir d'une population pour estimer des statistiques", "Méthode d'échantillonnage statistique pour obtenir des données représentatives", "Math"),
      ("Loi de Pareto", "Loi empirique de distribution des revenus et de nombreuses autres quantités économiques", "Distribution statistique qui suit la règle des 80/20", "Math"),
      ("Méthode des moments", "Estimation des paramètres d'une distribution en égalant les moments théoriques aux moments empiriques", "Technique d'estimation statistique des paramètres", "Math"),
      ("Droite de régression linéaire", "y = β₀ + β₁x + ε", "Modèle de régression linéaire pour ajuster une droite aux données", "Math"),
      ("Coefficient de régression \\(pente\\)", "β₁ = \\frac{Σ\\(x - \\bar{x}\\)\\(y - \\bar{y}\\)}{Σ\\(x - \\bar{x}\\)²}", "Calcul du coefficient de régression \\(pente\\) dans le modèle de régression linéaire", "Math"),
      ("Coefficient d'interception", "β₀ = \\bar{y} - β₁\\bar{x}", "Calcul du coefficient d'interception dans le modèle de régression linéaire", "Math"),
      ("Erreur de régression \\(résiduelle\\)", "ε = y - \\(β₀ + β₁x\\)", "Calcul de l'erreur de régression \\(résiduelle\\) dans le modèle de régression linéaire", "Math"),
      ("Coefficient de détermination \\(R²\\)", "R² = \\frac{Σ\\(yi - ŷ\\)²}{Σ\\(yi - ȳ\\)²}", "Mesure de l'ajustement d'un modèle de régression linéaire", "Math"),
      ("Régression linéaire multiple", "y = β₀ + β₁x₁ + β₂x₂ + ... + ε", "Modèle de régression linéaire pour plusieurs variables explicatives", "Math"),
      ("Méthode des moindres carrés", "Minimisation de la somme des carrés des erreurs pour estimer les paramètres du modèle", "Technique d'estimation des coefficients de régression", "Math"),
      ("Analyse de variance \\(ANOVA\\) de régression", "Analyse de la variation dans la réponse expliquée par le modèle de régression", "Méthode pour évaluer la pertinence du modèle de régression", "Math"),
      ("Évaluation de la qualité du modèle", "Utilisation de résidus et de statistiques pour évaluer la qualité de l'ajustement du modèle", "Méthodes pour évaluer si le modèle de régression est approprié", "Math"),
        ("Test d'hypothèse", "H0 : μ = μ0 vs. H1 : μ ≠ μ0", "Test statistique pour évaluer si la moyenne d'un échantillon est différente d'une valeur de population spécifiée", "Math"),
      ("Test de proportion", "H0 : p = p0 vs. H1 : p ≠ p0", "Test statistique pour évaluer si la proportion d'une caractéristique dans un échantillon est différente d'une valeur spécifiée", "Math"),
      ("Test de normalité", "Test de Kolmogorov-Smirnov, test de Shapiro-Wilk, etc.", "Tests statistiques pour évaluer si les données suivent une distribution normale", "Math"),
      ("Test de chi carré", "χ² = Σ\\(\\frac{\\(O - E\\)²}{E}\\)", "Test statistique pour évaluer l'indépendance entre deux variables catégorielles", "Math"),
      ("Test ANOVA", "Analyse de variance pour comparer les moyennes de trois groupes ou plus", "Test statistique pour comparer les moyennes de plusieurs groupes", "Math"),
      ("Test de corrélation", "Test de corrélation de Pearson, test de corrélation de Spearman, etc.", "Tests statistiques pour évaluer la corrélation entre deux variables", "Math"),
      ("Régression logistique", "Modèle de régression pour la prédiction binaire ou multiclasse", "Technique d'analyse pour prédire une variable binaire ou catégorielle", "Math"),
      ("Analyse de données multivariées", "Exploration des relations entre plusieurs variables simultanément", "Méthodes d'analyse pour comprendre les relations complexes entre les variables", "Math"),
      ("Analyse en composantes principales \\(ACP\\)", "Réduction de la dimensionnalité des données tout en conservant l'information", "Technique pour simplifier les données multivariées", "Math"),
      ("Régression non linéaire", "y = f\\(x, β\\) + ε", "Modèle de régression pour ajuster des fonctions non linéaires aux données", "Math"),
       
   ("Continuité en x0", "\\lim_{{x \\to x_0}} f\\(x\\) = f\\(x_0\\)", "Continuité d'une fonction en x0", "Math"),
  ("Dérivabilité en x0", "\\lim_{{h \\to 0}} \\frac{{f\\(x_0 + h\\) - f\\(x_0\\)}}{h} = f'\\(x_0\\)", "Dérivabilité d'une fonction en x0", "Math"),
  ("Théorème fondamental de l'intégration", "\\int_{{a}}^{{b}} f\\(x\\) \\, dx = F\\(b\\) - F\\(a\\)", "Relation entre intégration et dérivation", "Math"),
  ("Intégration par parties", "\\int u \\, dv = uv - \\int v \\, du", "Méthode d'intégration pour le produit de fonctions", "Math"),
  ("Intégration de sin\\(x\\)", "\\int \\sin\\(x\\) \\, dx = -\\cos\\(x\\) + C", "Intégration de la fonction sinus", "Math"),
  ("Intégration de cos\\(x\\)", "\\int \\cos\\(x\\) \\, dx = \\sin\\(x\\) + C", "Intégration de la fonction cosinus", "Math"),
  ("Intégration de e^x", "\\int e^x \\, dx = e^x + C", "Intégration de la fonction exponentielle", "Math"),
  ("Intégration de ln\\(x\\)", "\\int \\ln\\(x\\) \\, dx = x\\ln\\(x\\) - x + C", "Intégration de la fonction logarithmique", "Math"),
  ("Changement de variable dans l'intégration", "Méthode de substitution pour simplifier les intégrales", "Changement de variable", "Math"),
  ("Limite en x0", "\\lim_{{x \\to x_0}} f\\(x\\)", "Calcul de la limite en x0 d'une fonction", "Math"),
  ("Continuité à gauche", "\\lim_{{x \\to x_0^-}} f\\(x\\) = f\\(x_0\\)", "Continuité à gauche en x0", "Math"),
  ("Continuité à droite", "\\lim_{{x \\to x_0^+}} f\\(x\\) = f\\(x_0\\)", "Continuité à droite en x0", "Math"),
  ("Dérivée première", "f'\\(x\\)", "Dérivée première d'une fonction", "Math"),
  ("Dérivée seconde", "f''\\(x\\)", "Dérivée seconde d'une fonction", "Math"),
  ("Règle de L'Hôpital", "\\lim_{{x \\to x_0}} \\frac{{f\\(x\\)}}{{g\\(x\\)}} = \\lim_{{x \\to x_0}} \\frac{{f'\\(x\\)}}{{g'\\(x\\)}}", "Règle de L'Hôpital pour les limites indéterminées", "Math"),
  ("Dérivée de fonctions composées", "\\frac{{d}}{{dx}}\\(f\\(g\\(x\\)\\)\\) = f'\\(g\\(x\\)\\) \\cdot g'\\(x\\)", "Dérivée de fonctions composées", "Math"),
  ("Dérivée de ln\\(x\\)", "\\frac{{d}}{{dx}}\\(\\ln\\(x\\)\\) = \\frac{{1}}{{x}}", "Dérivée de la fonction logarithmique naturelle", "Math"),
  ("Dérivée de e^x", "\\frac{{d}}{{dx}}\\(e^x\\) = e^x", "Dérivée de la fonction exponentielle", "Math"),
  ("Dérivée de la somme", "\\frac{{d}}{{dx}}\\(f\\(x\\) + g\\(x\\)\\) = f'\\(x\\) + g'\\(x\\)", "Dérivée de la somme de deux fonctions", "Math"),
  ("Dérivée du produit", "\\frac{{d}}{{dx}}\\(f\\(x\\) \\cdot g\\(x\\)\\) = f'\\(x\\) \\cdot g\\(x\\) + f\\(x\\) \\cdot g'\\(x\\)", "Dérivée du produit de deux fonctions", "Math"),
  ("Dérivée du quotient", "\\frac{{d}}{{dx}}\\left\\(\\frac{{f\\(x\\)}}{{g\\(x\\)}}\\right\\) = \\frac{{f'\\(x\\) \\cdot g\\(x\\) - f\\(x\\) \\cdot g'\\(x\\)}}{{\\(g\\(x\\)\\)^2}}", "Dérivée du quotient de deux fonctions", "Math"),
  ("Dérivée de la fonction inverse", "\\frac{{d}}{{dx}}\\left\\(\\frac{{1}}{{f\\(x\\)}}\\right\\) = -\\frac{{f'\\(x\\)}}{{\\(f\\(x\\)\\)^2}}", "Dérivée de la fonction inverse", "Math"),
  ("Règle de la chaîne", "\\frac{{d}}{{dx}}\\(f\\(g\\(x\\)\\)\\) = f'\\(g\\(x\\)\\) \\cdot g'\\(x\\)", "Règle de la chaîne pour les dérivées", "Math"),
  ("Dérivée de ln|x|", "\\frac{{d}}{{dx}}\\(\\ln|x|\\) = \\frac{{1}}{{x}}", "Dérivée de la fonction logarithmique naturelle absolue", "Math"),
  ("Dérivée de arcsin\\(x\\)", "\\frac{{d}}{{dx}}\\(\\arcsin\\(x\\)\\) = \\frac{{1}}{{\\sqrt{1 - x^2}}}", "Dérivée de la fonction arcsin", "Math"),
  ("Dérivée de arccos\\(x\\)", "\\frac{{d}}{{dx}}\\(\\arccos\\(x\\)\\) = -\\frac{{1}}{{\\sqrt{1 - x^2}}}", "Dérivée de la fonction arccos", "Math"),
  ("Dérivée de arctan\\(x\\)", "\\frac{{d}}{{dx}}\\(\\arctan\\(x\\)\\) = \\frac{{1}}{{1 + x^2}}", "Dérivée de la fonction arctan", "Math"),
  ("Dérivée de ln|f\\(x\\)|", "\\frac{{d}}{{dx}}\\(\\ln|f\\(x\\)|\\) = \\frac{{f'\\(x\\)}}{{|f\\(x\\)|}}", "Dérivée de la fonction logarithmique absolue", "Math"),
  ("Dérivée de sinh\\(x\\)", "\\frac{{d}}{{dx}}\\(\\sinh\\(x\\)\\) = \\cosh\\(x\\)", "Dérivée de la fonction sinus hyperbolique", "Math"),
  ("Dérivée de cosh\\(x\\)", "\\frac{{d}}{{dx}}\\(\\cosh\\(x\\)\\) = \\sinh\\(x\\)", "Dérivée de la fonction cosinus hyperbolique", "Math"),
  ("Dérivée de tanh\\(x\\)", "\\frac{{d}}{{dx}}\\(\\tanh\\(x\\)\\) = \\sech^2\\(x\\)", "Dérivée de la fonction tangente hyperbolique", "Math"),
  ("Intégrale de arcsin\\(x\\)", "\\int \\arcsin\\(x\\) \\, dx = x \\arcsin\\(x\\) + \\sqrt{1 - x^2} + C", "Intégrale de la fonction arcsin", "Math"),
  ("Intégrale de arccos\\(x\\)", "\\int \\arccos\\(x\\) \\, dx = x \\arccos\\(x\\) - \\sqrt{1 - x^2} + C", "Intégrale de la fonction arccos", "Math"),
  ("Intégrale de arctan\\(x\\)", "\\int \\arctan\\(x\\) \\, dx = x \\arctan\\(x\\) - \\frac{1}{2} \\ln\\(1 + x^2\\) + C", "Intégrale de la fonction arctan", "Math"),
  ("Intégrale de e^\\(ax\\)", "\\int e^{ax} \\, dx = \\frac{1}{a} e^{ax} + C", "Intégrale de la fonction exponentielle avec une constante", "Math"),
  ("Intégrale de sin^2\\(x\\)", "\\int \\sin^2\\(x\\) \\, dx = \\frac{1}{2} \\(x - \\sin\\(x\\) \\cos\\(x\\)\\) + C", "Intégrale de la fonction sinus carré", "Math"),
  ("Intégrale de cos^2\\(x\\)", "\\int \\cos^2\\(x\\) \\, dx = \\frac{1}{2} \\(x + \\sin\\(x\\) \\cos\\(x\\)\\) + C", "Intégrale de la fonction cosinus carré", "Math"),
  ("Théorème des valeurs intermédiaires", "Si f\\(a\\) < 0 < f\\(b\\) ou f\\(a\\) > 0 > f\\(b\\), alors il existe au moins un c dans l'intervalle [a, b] tel que f\\(c\\) = 0.", "Théorème des valeurs intermédiaires", "Math"),
  ("Dérivée de ln\\(f\\(x\\)\\)", "\\frac{{d}}{{dx}}\\(\\ln\\(f\\(x\\)\\)\\) = \\frac{{f'\\(x\\)}}{{f\\(x\\)}}", "Dérivée de la fonction logarithmique de f\\(x\\)", "Math"),
  ("Intégrale de u-substitution", "\\int f\\(g\\(x\\)\\)g'\\(x\\) \\, dx = \\int f\\(u\\) \\, du", "Méthode de substitution pour les intégrales", "Math"),
  ("Intégrale de arcsinh\\(x\\)", "\\int \\arcsinh\\(x\\) \\, dx = x \\arcsinh\\(x\\) - \\sqrt{x^2+1} + C", "Intégrale de la fonction arcsinh", "Math"),
  ("Intégrale de arccosh\\(x\\)", "\\int \\arccosh\\(x\\) \\, dx = x \\arccosh\\(x\\) - \\sqrt{x^2-1} + C", "Intégrale de la fonction arccosh", "Math"),
  ("Intégrale de arctanh\\(x\\)", "\\int \\arctanh\\(x\\) \\, dx = x \\arctanh\\(x\\) - \\frac{1}{2} \\ln\\(1 - x^2\\) + C", "Intégrale de la fonction arctanh", "Math"),
  ("Intégrale de sec\\(x\\)", "\\int \\sec\\(x\\) \\, dx = \\ln|\\sec\\(x\\) + \\tan\\(x\\)| + C", "Intégrale de la fonction secante", "Math"),
  ("Intégrale de csc\\(x\\)", "\\int \\csc\\(x\\) \\, dx = -\\ln|\\csc\\(x\\) + \\cot\\(x\\)| + C", "Intégrale de la fonction cosecante", "Math"),
  ("Intégrale de cot\\(x\\)", "\\int \\cot\\(x\\) \\, dx = -\\ln|\\sin\\(x\\)| + C", "Intégrale de la fonction cotangente", "Math"),
  ("Intégrale de e^\\(f\\(x\\)\\)f'\\(x\\)", "\\int e^{f\\(x\\)}f'\\(x\\) \\, dx = e^{f\\(x\\)} + C", "Intégrale de e^\\(f\\(x\\)\\)f'\\(x\\)", "Math"),
 ("Intégrale de la fonction gamma", "\\int \\Gamma\\(x\\) \\, dx = \\Gamma\\(x+1\\) + C", "Intégrale de la fonction gamma", "Math"),
  ("Intégrale de Bessel J\\(x\\)", "\\int J\\(x\\) \\, dx = -J\\(x-1\\) + C", "Intégrale de la fonction de Bessel J\\(x\\)", "Math"),
  ("Intégrale de la fonction error", "\\int \\text{erf}\\(x\\) \\, dx = \\frac{2}{\\sqrt{\\pi}} \\int e^{-t^2} \\, dt", "Intégrale de la fonction erreur", "Math"),
  ("Intégrale de la fonction sinc", "\\int \\text{sinc}\\(x\\) \\, dx = \\frac{\\sin\\(x\\)}{x} + C", "Intégrale de la fonction sinc", "Math"),
  ("Intégrale de la fonction logistique", "\\int \\text{Logistic}\\(x\\) \\, dx = \\frac{e^x}{1+e^x} + C", "Intégrale de la fonction logistique", "Math"),
  ("Dérivée de la fonction erf", "\\frac{d}{dx} \\text{erf}\\(x\\) = \\frac{2}{\\sqrt{\\pi}}e^{-x^2}", "Dérivée de la fonction erreur", "Math"),
  ("Dérivée de la fonction sinc", "\\frac{d}{dx} \\text{sinc}\\(x\\) = \\frac{\\cos\\(x\\)}{x} - \\frac{\\sin\\(x\\)}{x^2}", "Dérivée de la fonction sinc", "Math"),
  ("Dérivée de la fonction logistique", "\\frac{d}{dx} \\text{Logistic}\\(x\\) = \\text{Logistic}\\(x\\)\\(1 - \\text{Logistic}\\(x\\)\\)", "Dérivée de la fonction logistique", "Math"),
   ("Intégrale de la fonction hyperbolique inverse", "\\int \\sinh^{-1}\\(x\\) \\, dx = x \\sinh^{-1}\\(x\\) - \\sqrt{x^2 + 1} + C", "Intégrale de la fonction sinus hyperbolique inverse", "Math"),
  ("Intégrale de la fonction cosh inverse", "\\int \\cosh^{-1}\\(x\\) \\, dx = x \\cosh^{-1}\\(x\\) - \\sqrt{x^2 - 1} + C", "Intégrale de la fonction cosinus hyperbolique inverse", "Math"),
  ("Intégrale de la fonction tanh inverse", "\\int \\tanh^{-1}\\(x\\) \\, dx = x \\tanh^{-1}\\(x\\) - \\frac{1}{2} \\ln\\(1 - x^2\\) + C", "Intégrale de la fonction tangente hyperbolique inverse", "Math"),
  ("Intégrale de la fonction sec inverse", "\\int \\sec^{-1}\\(x\\) \\, dx = \\ln|\\sec\\(x\\) + \\tan\\(x\\)| + C", "Intégrale de la fonction sécante inverse", "Math"),
  ("Intégrale de la fonction csc inverse", "\\int \\csc^{-1}\\(x\\) \\, dx = -\\ln|\\csc\\(x\\) + \\cot\\(x\\)| + C", "Intégrale de la fonction cosécante inverse", "Math"),
  ("Intégrale de la fonction cot inverse", "\\int \\cot^{-1}\\(x\\) \\, dx = -\\ln|\\sin\\(x\\)| + C", "Intégrale de la fonction cotangente inverse", "Math"),
  ("Dérivée de sinh^-1\\(x\\)", "\\frac{d}{dx} \\sinh^{-1}\\(x\\) = \\frac{1}{\\sqrt{x^2+1}}", "Dérivée de la fonction sinus hyperbolique inverse", "Math"),
  ("Dérivée de cosh^-1\\(x\\)", "\\frac{d}{dx} \\cosh^{-1}\\(x\\) = \\frac{1}{\\sqrt{x^2-1}}", "Dérivée de la fonction cosinus hyperbolique inverse", "Math"),
  ("Dérivée de tanh^-1\\(x\\)", "\\frac{d}{dx} \\tanh^{-1}\\(x\\) = \\frac{1}{1 - x^2}", "Dérivée de la fonction tangente hyperbolique inverse", "Math"),
   ("Équation quadratique", "ax^2 + bx + c = 0", "Forme générale d'une équation quadratique", "Math"),
  ("Discriminant", "\\Delta = b^2 - 4ac", "Calcul du discriminant d'une équation quadratique", "Math"),
  ("Racines de l'équation", "x = \\frac{-b \\pm \\sqrt{\\Delta}}{2a}", "Calcul des racines d'une équation quadratique", "Math"),
  ("Somme des racines", "x_1 + x_2 = -\\frac{b}{a}", "Calcul de la somme des racines d'une équation quadratique", "Math"),
  ("Produit des racines", "x_1 \\cdot x_2 = \\frac{c}{a}", "Calcul du produit des racines d'une équation quadratique", "Math"),
  ("Signe du discriminant", "Si \\Delta > 0, l'équation a deux racines réelles distinctes. Si \\Delta = 0, il y a une racine réelle double. Si \\Delta < 0, il n'y a pas de racines réelles.", "Détermination du signe du discriminant", "Math"),
  ("Système d'équations linéaires", "ax + by = c, dx + ey = f", "Forme générale d'un système d'équations linéaires", "Math"),
  ("Résolution de systèmes", "x = \\frac{ce-bf}{ae-bd}, y = \\frac{af-cd}{ae-bd}", "Résolution d'un système d'équations linéaires par la méthode de Cramer", "Math"),
  ("Système d'inéquations", "ax + by \\leq c, dx + ey \\geq f", "Forme générale d'un système d'inéquations linéaires", "Math"),
  ("Résolution d'inéquations", "Résoudre les inéquations pour trouver les intervalles de solutions", "Résolution de systèmes d'inéquations", "Math"),
   ("Équation linéaire", "ax + b = 0", "Forme générale d'une équation linéaire", "Math"),
  ("Racine de l'équation linéaire", "x = -\\frac{b}{a}", "Calcul de la racine d'une équation linéaire", "Math"),
  ("Inéquation linéaire", "ax + b < 0", "Forme générale d'une inéquation linéaire", "Math"),
  ("Résolution d'inéquations linéaires", "x > -\\frac{b}{a} \\(si a > 0\\), x < -\\frac{b}{a} \\(si a < 0\\)", "Résolution d'inéquations linéaires", "Math"),
  ("Système d'inéquations quadratiques", "ax^2 + bx + c < 0, dx^2 + ex + f > 0", "Forme générale d'un système d'inéquations quadratiques", "Math"),
  ("Résolution de systèmes d'inéquations", "Trouver les intervalles de solutions qui satisfont toutes les inéquations", "Résolution de systèmes d'inéquations", "Math"),
  ("Inéquation quadratique", "ax^2 + bx + c < 0", "Forme générale d'une inéquation quadratique", "Math"),
  ("Résolution d'inéquations quadratiques", "Trouver les intervalles de solutions pour lesquels l'inéquation est satisfaite", "Résolution d'inéquations quadratiques", "Math"),
  ("Propriétés des racines", "Les racines d'une équation quadratique sont réelles si le discriminant est non négatif et non réelles si le discriminant est négatif.", "Caractéristiques des racines d'une équation quadratique", "Math"),
   ("Théorème de Pythagore", "c^2 = a^2 + b^2", "Relation entre les côtés d'un triangle rectangle", "Math"),
  ("Théorème de l'aire d'un triangle", "A = \\frac{1}{2} \\cdot base \\cdot hauteur", "Calcul de l'aire d'un triangle", "Math"),
  ("Théorème de l'aire d'un trapèze", "A = \\frac{1}{2} \\cdot \\(a + b\\) \\cdot h", "Calcul de l'aire d'un trapèze", "Math"),
  ("Théorème de l'aire d'un cercle", "A = \\pi r^2", "Calcul de l'aire d'un cercle", "Math"),
  ("Théorème de l'aire d'un rectangle", "A = longueur \\cdot largeur", "Calcul de l'aire d'un rectangle", "Math"),
  ("Théorème de l'aire d'un parallélogramme", "A = base \\cdot hauteur", "Calcul de l'aire d'un parallélogramme", "Math"),
  ("Théorème de l'aire d'un losange", "A = \\frac{1}{2} \\cdot d_1 \\cdot d_2", "Calcul de l'aire d'un losange", "Math"),
  ("Théorème de l'aire d'un carré", "A = côté^2", "Calcul de l'aire d'un carré", "Math"),
  ("Théorème de l'aire d'un polygone régulier", "A = \\frac{1}{2} \\cdot apothème \\cdot périmètre", "Calcul de l'aire d'un polygone régulier", "Math"),
  ("Théorème de l'aire d'un secteur circulaire", "A = \\frac{\\theta}{360} \\cdot \\pi r^2", "Calcul de l'aire d'un secteur circulaire", "Math"),
   ("Théorème de Pythagore", "c^2 = a^2 + b^2", "Relation entre les côtés d'un triangle rectangle", "Math"),
  ("Théorème de l'aire d'un triangle", "A = \\frac{1}{2} \\cdot base \\cdot hauteur", "Calcul de l'aire d'un triangle", "Math"),
  ("Théorème de l'aire d'un trapèze", "A = \\frac{1}{2} \\cdot \\(a + b\\) \\cdot h", "Calcul de l'aire d'un trapèze", "Math"),
  ("Théorème de l'aire d'un cercle", "A = \\pi r^2", "Calcul de l'aire d'un cercle", "Math"),
  ("Théorème de l'aire d'un rectangle", "A = longueur \\cdot largeur", "Calcul de l'aire d'un rectangle", "Math"),
  ("Théorème de l'aire d'un parallélogramme", "A = base \\cdot hauteur", "Calcul de l'aire d'un parallélogramme", "Math"),
  ("Théorème de l'aire d'un losange", "A = \\frac{1}{2} \\cdot d_1 \\cdot d_2", "Calcul de l'aire d'un losange", "Math"),
  ("Théorème de l'aire d'un carré", "A = côté^2", "Calcul de l'aire d'un carré", "Math"),
  ("Théorème de l'aire d'un polygone régulier", "A = \\frac{1}{2} \\cdot apothème \\cdot périmètre", "Calcul de l'aire d'un polygone régulier", "Math"),
  ("Théorème de l'aire d'un secteur circulaire", "A = \\frac{\\theta}{360} \\cdot \\pi r^2", "Calcul de l'aire d'un secteur circulaire", "Math"),
  ("Nombre complexe", "z = a + bi", "Représentation générale d'un nombre complexe", "Math"),
  ("Nombre imaginaire pur", "i = \\sqrt{-1}", "Représentation de l'unité imaginaire", "Math"),
  ("Forme polaire d'un nombre complexe", "z = r\\(cos\\(θ\\) + i sin\\(θ\\)\\)", "Représentation en forme polaire d'un nombre complexe", "Math"),
  ("Conjugé d'un nombre complexe", "\\overline{z} = a - bi", "Conjugé d'un nombre complexe", "Math"),
  ("Module d'un nombre complexe", "|z| = \\sqrt{a^2 + b^2}", "Calcul du module d'un nombre complexe", "Math"),
  ("Argument d'un nombre complexe", "θ = \\arctan\\left\\(\\frac{b}{a}\\right\\)", "Calcul de l'argument d'un nombre complexe", "Math"),
  ("Multiplication de nombres complexes", "z_1 \\cdot z_2 = r_1r_2\\(cos\\(θ_1 + θ_2\\) + i sin\\(θ_1 + θ_2\\)\\)", "Multiplication de nombres complexes en forme polaire", "Math"),
  ("Puissance d'un nombre complexe", "z^n = r^n\\(cos\\(nθ\\) + i sin\\(nθ\\)\\)", "Calcul de la puissance d'un nombre complexe en forme polaire", "Math"),
  ("Racine carrée d'un nombre complexe", "\\sqrt{z} = \\sqrt{r}\\(cos\\(θ/2\\) + i sin\\(θ/2\\)\\)", "Calcul de la racine carrée d'un nombre complexe en forme polaire", "Math"),
  ("Symétrie par rapport à l'axe réel", "z' = \\overline{z}", "Symétrie d'un nombre complexe par rapport à l'axe réel", "Math"),
  ("Symétrie par rapport à l'axe imaginaire", "z' = -z", "Symétrie d'un nombre complexe par rapport à l'axe imaginaire", "Math"),
  ("Translation dans le plan complexe", "z' = z + c", "Translation d'un nombre complexe dans le plan complexe", "Math"),
  ("Rotation dans le plan complexe", "z' = ze^\\(iθ\\)", "Rotation d'un nombre complexe dans le plan complexe", "Math"),
  ("Somme de deux nombres complexes", "z_1 + z_2 = \\(a_1 + a_2\\) + \\(b_1 + b_2\\)i", "Addition de deux nombres complexes", "Math"),
  ("Différence de deux nombres complexes", "z_1 - z_2 = \\(a_1 - a_2\\) + \\(b_1 - b_2\\)i", "Soustraction de deux nombres complexes", "Math"),
  ("Division de deux nombres complexes", "\\frac{z_1}{z_2} = \\frac{a_1 + b_1i}{a_2 + b_2i}", "Division de deux nombres complexes", "Math"),
  ("Forme exponentielle d'un nombre complexe", "z = re^\\(iθ\\)", "Représentation en forme exponentielle d'un nombre complexe", "Math"),
  ("Identités d'Euler", "e^\\(iθ\\) = cos\\(θ\\) + i sin\\(θ\\)", "Les identités d'Euler pour les fonctions trigonométriques", "Math"),
  ("Transformation de Moivre", "\\(r\\(cos\\(θ\\) + i sin\\(θ\\)\\)\\)^n = r^n\\(cos\\(nθ\\) + i sin\\(nθ\\)\\)", "La transformation de Moivre pour les puissances de nombres complexes", "Math"),
  ("Nombres complexes conjugués", "z\\overline{z} = |z|^2", "Relation entre un nombre complexe et son conjugué", "Math"),
  ("Coordonnées polaires et cartésiennes", "\\(a, b\\) = \\(r cos\\(θ\\), r sin\\(θ\\)\\)", "Conversion entre les coordonnées polaires et cartésiennes", "Math"),
  ("Rotation de vecteurs", "Rotation d'un vecteur dans le plan", "Rotation de vecteurs dans le plan complexe", "Math"),
  ("Multiplication de nombres complexes en forme cartésienne", "\\(a + bi\\)\\(c + di\\) = \\(ac - bd\\) + \\(ad + bc\\)i", "Multiplication de nombres complexes en forme cartésienne", "Math"),
  ("Théorème fondamental de l'algèbre", "Tout polynôme non constant a au moins une racine complexe.", "Théorème fondamental de l'algèbre", "Math"),
  ("Formule de De Moivre pour les racines", "\\(r\\(cos\\(θ\\) + i sin\\(θ\\)\\)\\)^\\(1/n\\) = r^\\(1/n\\)\\(cos\\(θ/n\\) + i sin\\(θ/n\\)\\)", "Formule de De Moivre pour les racines de nombres complexes", "Math"),
  ("Polynômes de Chebyshev", "T_n\\(x\\) = cos\\(n \\cos^{-1}\\(x\\)\\)", "Polynômes de Chebyshev de première espèce", "Math"),
  ("Séries de Taylor", "f\\(x\\) = f\\(a\\) + f'\\(a\\)\\(x-a\\) + \\frac{f''\\(a\\)}{2!}\\(x-a\\)^2 + \\frac{f'''\\(a\\)}{3!}\\(x-a\\)^3 + \\ldots", "Séries de Taylor pour l'approximation de fonctions", "Math"),
  ("Transformée de Fourier", "F\\(k\\) = \\int_{-\\infty}^{\\infty} f\\(x\\)e^{-2\\pi i kx}dx", "Transformée de Fourier pour l'analyse des signaux", "Math"),
  ("Théorème de Parseval", "L'énergie d'un signal est conservée dans le domaine fréquentiel.", "Théorème de Parseval en analyse de Fourier", "Math"),
  ("Matrices de rotation", "Matrices utilisées pour effectuer des rotations dans l'espace", "Matrices de rotation en géométrie", "Math"),
  ("Théorème de Cauchy-Riemann", "Conditions pour qu'une fonction soit holomorphe", "Théorème de Cauchy-Riemann en analyse complexe", "Math"),
  ("Loi de Gauss pour l'électricité", "La somme des charges électriques dans une région est égale au flux électrique sortant de cette région.", "Loi de Gauss en électromagnétisme", "Physique"),
   ("Barycentre de deux points pondérés", "G\\(x, y\\) = \\left\\(\\frac{m_1x_1 + m_2x_2}{m_1 + m_2}, \\frac{m_1y_1 + m_2y_2}{m_1 + m_2}\\right\\)", "Calcul du barycentre de deux points pondérés", "Math"),
  ("Barycentre de trois points pondérés", "G\\(x, y\\) = \\left\\(\\frac{m_1x_1 + m_2x_2 + m_3x_3}{m_1 + m_2 + m_3}, \\frac{m_1y_1 + m_2y_2 + m_3y_3}{m_1 + m_2 + m_3}\\right\\)", "Calcul du barycentre de trois points pondérés", "Math"),
  ("Barycentre de plusieurs points pondérés", "G\\(x, y\\) = \\left\\(\\frac{\\sum_{i=1}^{n} m_ix_i}{\\sum_{i=1}^{n} m_i}, \\frac{\\sum_{i=1}^{n} m_iy_i}{\\sum_{i=1}^{n} m_i}\\right\\)", "Calcul du barycentre de plusieurs points pondérés", "Math"),
  ("Rotation autour d'un cercle", "x' = x\\cos\\(θ\\) - y\\sin\\(θ\\), y' = x\\sin\\(θ\\) + y\\cos\\(θ\\)", "Transformation de rotation autour d'un cercle", "Math"),
  ("Symétrie par rapport à un point", "\\(x', y'\\) = \\(2a-x, 2b-y\\)", "Symétrie d'un point par rapport à un autre point", "Math"),
  ("Symétrie par rapport à un cercle", "x' = a + r\\cos\\(θ\\), y' = b + r\\sin\\(θ\\)", "Symétrie par rapport à un cercle de centre \\(a, b\\) et de rayon r", "Math"),
  ("Théorème des médianes", "Les trois médianes d'un triangle se croisent en un point appelé le centre de gravité \\(barycentre\\)", "Théorème des médianes dans la géométrie du triangle", "Math"),
  ("Théorème de Varignon", "Le milieu des côtés d'un quadrilatère forme un parallélogramme.", "Théorème de Varignon en géométrie", "Math"),
  ("Centre de gravité d'une figure plane", "Le centre de gravité d'une figure plane est le point d'équilibre.", "Centre de gravité en géométrie plane", "Math"),
  ("Recherche de M dans un ensemble de barycentres", "M\\(x, y\\) = \\left\\(\\frac{m_1x_1 + m_2x_2 + \\ldots + m_nx_n}{m_1 + m_2 + \\ldots + m_n}, \\frac{m_1y_1 + m_2y_2 + \\ldots + m_ny_n}{m_1 + m_2 + \\ldots + m_n}\\right\\)", "Recherche de M en tant que barycentre dans un ensemble de points pondérés", "Math"),
  ("Calcul des coefficients de pondération", "m_i = \\frac{M\\(x - x_i\\)}{x - x_i} + \\frac{M\\(y - y_i\\)}{y - y_i}", "Calcul des coefficients de pondération pour le barycentre M", "Math"),
  ("Recherche du barycentre pondéré M", "M\\(x, y\\) = \\left\\(\\frac{\\sum_{i=1}^{n} m_ix_i}{\\sum_{i=1}^{n} m_i}, \\frac{\\sum_{i=1}^{n} m_iy_i}{\\sum_{i=1}^{n} m_i}\\right\\)", "Recherche du barycentre pondéré M dans un ensemble de points pondérés", "Math"),
  ("Utilisation de la moyenne pondérée", "La recherche du barycentre peut être vue comme une moyenne pondérée des points", "Utilisation de la moyenne pondérée pour trouver le barycentre", "Math"),
    ("Identités trigonométriques fondamentales", 
    "\\sin^2\\(x\\) + \\cos^2\\(x\\) = 1
\\tan\\(x\\) = \\frac{\\sin\\(x\\)}{\\cos\\(x\\)}
\\cot\\(x\\) = \\frac{1}{\\tan\\(x\\)}", 
    "Les identités trigonométriques fondamentales", "Math"),
  ("Formules d'addition et de soustraction", 
    "\\sin\\(A + B\\) = \\sin\\(A\\)\\cos\\(B\\) + \\cos\\(A\\)\\sin\\(B\\)
\\cos\\(A + B\\) = \\cos\\(A\\)\\cos\\(B\\) - \\sin\\(A\\)\\sin\\(B\\)
\\tan\\(A + B\\) = \\frac{\\tan\\(A\\) + \\tan\\(B\\)}{1 - \\tan\\(A\\)\\tan\\(B\\)}",
    "Formules d'addition et de soustraction pour sinus, cosinus et tangente", "Math"),
  ("Formules de demi-angle", 
    "\\sin\\left\\(\\frac{x}{2}\\right\\) = \\pm\\sqrt{\\frac{1 - \\cos\\(x\\)}{2}}
\\cos\\left\\(\\frac{x}{2}\\right\\) = \\pm\\sqrt{\\frac{1 + \\cos\\(x\\)}{2}}
\\tan\\left\\(\\frac{x}{2}\\right\\) = \\pm\\sqrt{\\frac{1 - \\cos\\(x\\)}{1 + \\cos\\(x\\)}}",
    "Formules de demi-angle pour les fonctions trigonométriques", "Math"),
  ("Identités trigonométriques hyperboliques", 
    "\\cosh^2\\(x\\) - \\sinh^2\\(x\\) = 1
\\tanh\\(x\\) = \\frac{\\sinh\\(x\\)}{\\cosh\\(x\\)}
\\coth\\(x\\) = \\frac{1}{\\tanh\\(x\\)}",
    "Les identités trigonométriques hyperboliques", "Math"),
  ("Loi des sinus", 
    "\\frac{a}{\\sin\\(A\\)} = \\frac{b}{\\sin\\(B\\)} = \\frac{c}{\\sin\\(C\\)}",
    "Loi des sinus pour les triangles", "Math"),
  ("Loi des cosinus", 
    "c^2 = a^2 + b^2 - 2ab\\cos\\(C\\)",
    "Loi des cosinus pour les triangles", "Math"),
  ("Loi des tangentes", 
    "\\frac{a - b}{a + b} = \\frac{\\tan\\left\\(\\frac{A - B}{2}\\right\\)}{\\tan\\left\\(\\frac{A + B}{2}\\right\\)}",
    "Loi des tangentes pour les triangles", "Math"),
  ("Formules d'Euler", 
    "e^{ix} = \\cos\\(x\\) + i\\sin\\(x\\)",
    "Formules d'Euler pour les nombres complexes", "Math"),
  ("Identités trigonométriques inverses", 
    "\\sin^{-1}\\(x\\) + \\cos^{-1}\\(x\\) = \\frac{\\pi}{2}
\\tan^{-1}\\(x\\) + \\cot^{-1}\\(x\\) = \\frac{\\pi}{2}
\\sec^{-1}\\(x\\) + \\csc^{-1}\\(x\\) = \\frac{\\pi}{2}",
    "Les identités trigonométriques inverses", "Math"),
  ("Formules de conversion", 
    "\\sin\\(x\\) = \\frac{\\tan\\(x\\)}{\\sec\\(x\\)}
\\cos\\(x\\) = \\frac{1}{\\sec\\(x\\)}
\\tan\\(x\\) = \\frac{\\sin\\(x\\)}{\\cos\\(x\\)}",
    "Formules de conversion entre les fonctions trigonométriques", "Math"),
  ("Identités trigonométriques complexes", 
    "\\sin\\(ix\\) = i\\sinh\\(x\\)
\\cos\\(ix\\) = \\cosh\\(x\\)
\\tan\\(ix\\) = i\\tanh\\(x\\)",
    "Les identités trigonométriques pour les fonctions trigonométriques complexes", "Math"),
  ("Formules de somme de produits", 
    "\\sin\\(A\\)\\sin\\(B\\) = \\frac{1}{2}\\(\\cos\\(A - B\\) - \\cos\\(A + B\\)\\)
\\cos\\(A\\)\\cos\\(B\\) = \\frac{1}{2}\\(\\cos\\(A - B\\) + \\cos\\(A + B\\)\\)
\\sin\\(A\\)\\cos\\(B\\) = \\frac{1}{2}\\(\\sin\\(A + B\\) + \\sin\\(A - B\\)\\)",
    "Formules de somme de produits pour les fonctions trigonométriques", "Math"),
  ("Série de Fourier", 
    "f\\(x\\) = a_0 + \\sum_{n=1}^{\\infty} [a_n\\cos\\(n\\omega x\\) + b_n\\sin\\(n\\omega x\\)]",
    "Décomposition de fonctions périodiques en série de Fourier", "Math"),
  ("Identités de duplication", 
    "\\sin\\(2x\\) = 2\\sin\\(x\\)\\cos\\(x\\)
\\cos\\(2x\\) = \\cos^2\\(x\\) - \\sin^2\\(x\\)
\\tan\\(2x\\) = \\frac{2\\tan\\(x\\)}{1 - \\tan^2\\(x\\)}",
    "Les identités de duplication pour les fonctions trigonométriques", "Math"),
  ("Formules d'intégration trigonométrique", 
    "\\int \\sin\\(x\\)dx = -\\cos\\(x\\) + C
\\int \\cos\\(x\\)dx = \\sin\\(x\\) + C
\\int \\tan\\(x\\)dx = -\\ln|\\cos\\(x\\)| + C",
    "Formules d'intégration pour les fonctions trigonométriques", "Math"),
  ("Formules d'angle multiple", 
    "\\sin\\(2x\\) = 2\\sin\\(x\\)\\cos\\(x\\)
\\cos\\(2x\\) = \\cos^2\\(x\\) - \\sin^2\\(x\\)
\\tan\\(2x\\) = \\frac{2\\tan\\(x\\)}{1 - \\tan^2\\(x\\)}",
    "Formules d'angle multiple pour les fonctions trigonométriques", "Math"),
  ("Identités hyperboliques", 
    "\\cosh^2\\(x\\) - \\sinh^2\\(x\\) = 1
\\cosh\\(2x\\) = \\cosh^2\\(x\\) + \\sinh^2\\(x\\)
\\sinh\\(2x\\) = 2\\cosh\\(x\\)\\sinh\\(x\\)",
    "Les identités hyperboliques pour les fonctions hyperboliques", "Math"),
  ("Lois des aires", 
    "Aire = \\frac{1}{2}ab\\sin\\(C\\)
Aire = \\frac{1}{2}bc\\sin\\(A\\)
Aire = \\frac{1}{2}ca\\sin\\(B\\)",
    "Les lois des aires pour les triangles", "Math"),
  ("Identités de Bessel", 
    "J_{n+1}\\(x\\) = \\frac{2n}{x}J_n\\(x\\) - J_{n-1}\\(x\\)
Y_{n+1}\\(x\\) = \\frac{2n}{x}Y_n\\(x\\) - Y_{n-1}\\(x\\)",
    "Les identités de Bessel pour les fonctions de Bessel", "Math"),
  ("Formules de Poisson", 
    "\\sinh\\(nx\\) = \\frac{1}{2^n}[e^{nx} - e^{-nx}]
\\cosh\\(nx\\) = \\frac{1}{2^n}[e^{nx} + e^{-nx}]",
    "Les formules de Poisson pour les fonctions hyperboliques", "Math"),
  ("Formules de Simpson", 
    "L'intégration numérique en utilisant la règle de Simpson", "Formules de Simpson pour l'intégration numérique", "Math"),
  ("Identité de Wallis", 
    "\\lim_{n\\to\\infty} \\frac{2^{2n}\\(n!\\)^2}{\\(2n+1\\)!} = \\frac{\\pi}{2}", "L'identité de Wallis pour pi", "Math"),
  ("Équations polynomiales", 
    "ax^2 + bx + c = 0
ax^3 + bx^2 + cx + d = 0",
    "Résolution d'équations polynomiales de degré 2 et 3", "Math"),
  ("Formule quadratique", 
    "x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}",
    "Formule quadratique pour résoudre les équations quadratiques", "Math"),
  ("Systèmes d'équations linéaires", 
    "ax + by = c
dx + ey = f",
    "Résolution de systèmes d'équations linéaires", "Math"),
  ("Méthode de substitution", 
    "Résolution de systèmes d'équations en remplaçant une variable par une autre", "Méthode de substitution pour résoudre les systèmes d'équations", "Math"),
  ("Équations trigonométriques", 
    "\\sin\\(x\\) = a
\\cos\\(x\\) = b
\\tan\\(x\\) = c",
    "Résolution d'équations trigonométriques", "Math"),
  ("Équations trigonométriques inverses", 
    "\\sin^{-1}\\(a\\) = x
\\cos^{-1}\\(b\\) = x
\\tan^{-1}\\(c\\) = x",
    "Résolution d'équations trigonométriques inverses", "Math"),
  ("Équations trigonométriques multiples", 
    "\\sin\\(2x\\) = a
\\cos\\(2x\\) = b
\\tan\\(2x\\) = c",
    "Résolution d'équations trigonométriques multiples", "Math"),
  ("Formules de réduction trigonométrique", 
    "\\sin\\(-x\\) = -\\sin\\(x\\)
\\cos\\(-x\\) = \\cos\\(x\\)
\\tan\\(-x\\) = -\\tan\\(x\\)",
    "Formules de réduction pour les fonctions trigonométriques", "Math"),
  ("Formules d'addition multiples", 
    "\\sin\\(A + B\\) = \\sin\\(A\\)\\cos\\(B\\) + \\cos\\(A\\)\\sin\\(B\\)
\\cos\\(A + B\\) = \\cos\\(A\\)\\cos\\(B\\) - \\sin\\(A\\)\\sin\\(B\\)",
    "Formules d'addition multiples pour sinus et cosinus", "Math"),
  ("Formules de Simpson", 
    "L'intégration numérique en utilisant la règle de Simpson", "Formules de Simpson pour l'intégration numérique", "Math"),
  ("Formules de dérivation trigonométrique", 
    "\\frac{d}{dx} \\sin\\(x\\) = \\cos\\(x\\)
\\frac{d}{dx} \\cos\\(x\\) = -\\sin\\(x\\)
\\frac{d}{dx} \\tan\\(x\\) = \\sec^2\\(x\\)",
    "Formules de dérivation pour les fonctions trigonométriques", "Math"),
  ("Séries de Fourier trigonométriques", 
    "f\\(x\\) = \\frac{a_0}{2} + \\sum_{n=1}^{\\infty} [a_n\\cos\\(nx\\) + b_n\\sin\\(nx\\)]",
    "Décomposition de fonctions périodiques en séries de Fourier trigonométriques", "Math"),
  ("Identités trigonométriques avancées", 
    "\\sin^2\\(x\\) = \\frac{1 - \\cos\\(2x\\)}{2}
\\cos^2\\(x\\) = \\frac{1 + \\cos\\(2x\\)}{2}",
    "Identités trigonométriques avancées pour sinus et cosinus", "Math"),
  ("Équations paramétriques", 
    "Représentation de courbes en utilisant des équations paramétriques", "Équations paramétriques pour décrire des courbes", "Math"),
        
      ("Programmation Linéaire Entière \\(PLI\\)", "[
      x_1, x_2, \\ldots, x_n \\in \\mathbb{Z}
      ]", "La programmation linéaire entière \\(PLI\\) est une variation de la programmation linéaire où les variables de décision sont restreintes à des valeurs entières.", "math");
     
     """);

    await database.execute("""

    INSERT INTO quiz (question, explication, correctAnswerIndex, times, classe, option1, option2, option3, option4)
        VALUES
         (
        "Quelle est la formule de l'aire d'un rectangle ?",
        "L'aire d'un rectangle est calculée en multipliant sa longueur par sa largeur.",
        0,
        30,
        "Seconde",
        "A = l * L",
        "A = 2l * 2L",
        "A = \$\\pi r^2\$",
        "A = \$\\(côté1 + côté2\\) / 2\$"
    ),
    
       (
" Raisonnement logique \\(3 QCM\\) Si l’on considère vraie l’hypothèse « pour réussir en finance, il faut être bon en maths »,on peut conclure que ",
"Simplifions en notant les propositions P « être bon en maths « et Q « réussir en finance ».L’énoncé indique que P => Q, B en est la traduction, donc B est vraie",
1,
85,
"Terminale",
"A. Tous ceux qui ne réussissent pas en finance  sont  bons en maths",
"B. Tous ceux qui sont bons en maths réussissent en finance.",
"C. Tous ceux qui réussissent en finance sont bons en maths",
"D. Ceux qui ne sont pas bons en maths ne peuvent pas réussir en finance"

),


(
"Soit A et B deux ensembles disjoints. Le cardinal de leur réunion est :  ",
"Le cardinal de l'union de deux ensembles A et B, noté |A ∪ B|, est égal à la somme des cardinaux de ces ensembles, à condition que les ensembles soient disjoints, c'est-à-dire qu'ils n'aient pas d'éléments en commun",
0,
60,
"Terminale",
"Card\\(A\\)+Card\\(B\\)",
"Card\\(A\\)-Card\\(B\\)",
"Card\\(A\\)*Card\\(B\\)",
"Card\\(A\\)-Card\\(B\\) - Card\\(A-B\\)"

),


(
"Dans un BTS, on note A l'ensemble des élèves de première année et B l'ensemble des élèves de deuxième année. L'ensemble des binômes que l'on peut former, en choisissant un élève de première année et un élève de deuxième année, est :",
"Pour déterminer le nombre de binômes que l'on peut former en choisissant un élève de première année et un élève de deuxième année dans un BTS, il suffit de multiplier le nombre d'élèves de première année par le nombre d'élèves de deuxième année. En d'autres termes, le nombre de binômes possibles est égal au produit du nombre d'élèves dans chaque année.",
1,
80,
"Terminale",
"A U B",
"A x B",
"A ∩ B",
"Card\\(A\\)-Card\\(B\\) - Card\\(A-B\\)"

),



(
"Soit Un la suite définie par u0=2u0=2 et Un+1=3Un.Un+1=3Un. ",
"Le cardinal de l'union de deux ensembles A et B, noté |A ∪ B|, est égal à la somme des cardinaux de ces ensembles, à condition que les ensembles soient disjoints, c'est-à-dire qu'ils n'aient pas d'éléments en commun",
2,
110,
"Terminale",
"La suite est arithmétique de raison 3",
"Card(A)-Card(B)",
"La suite est géometrique de raison 3",
"La suite est ni géometrique ni arithmétique "

),


(
"Soit Un la suite définie par u0=2u0=2 et Un+1=3Un.Un+1=3Un. ",
"Le cardinal de l'union de deux ensembles A et B, noté |A ∪ B|, est égal à la somme des cardinaux de ces ensembles, à condition que les ensembles soient disjoints, c'est-à-dire qu'ils n'aient pas d'éléments en commun",
2,
110,
"Terminale",
"La suite est arithmétique de raison 3",
"Card\\(A\\)-Card\\(B\\)",
"La suite est géometrique de raison 3",
"La suite est ni géometrique ni arithmétique "

),
    
    (
        "Quelle est la formule du périmètre d'un carré ?",
        "Le périmètre d'un carré est la somme des longueurs de ses côtés.",
        0,
        20,
        "Seconde",
        "P = 4l",
        "P = 2l",
        "P = l * l",
        "P = \$\\sqrt{2} * l\$"
    ),
    (
        "Résolvez l'équation suivante : 2x - 5 = 15.",
        "Pour résoudre cette équation, ajoutez 5 aux deux côtés et divisez par 2.",
        3,
        45,
        "Seconde",
        "x = 5",
        "x = 20",
        "x = -10",
        "x = 10"
    ),
    
     
    (
        "sin²\\(x\\) + cos²\\(x\\) = ?",
        "sin²\\(x\\) + cos²\\(x\\) = 1",
        1,
        20,
        "Terminale",
        "1",
        "2",
        "-1",
        "-2"
) ,  

(
        "g\\(x\\)=1/x³ et g\\(-x\\)=-g\\(x\\) donc g est:",
        "g est impaire",
        0,
        30,
        "Terminale",
        "impaire",
        "paire",
        "croissant",
        "je passe"
)  ,

(
        "g\\(x\\)=x² - 1 et g\\(-x\\)=g\\(x\\) donc g est:",
        "g est impaire",
        1,
        30,
        "Terminale",
        "impaire",
        "paire",
        "croissant",
        "je passe"
),
(
        "Primitive f\\(x\\)=\\( 2 /\\(2x + 1\\) + 4\\) ; Primitive F\\(x\\) = ?",
        "F\\(x\\) = ln\\(2x + 1\\) + 4x",
        2,
        90,
        "Terminale",
        "F\\(x\\) = 2x + 1 + 4x",
        "F\\(x\\) = e^\\(2x + 1\\) + 4x",
        "F\\(x\\) = ln\\(2x + 1\\) + 4x",
        "F\\(x\\) = 2x + 1 + 4"
),
       
     (
        "Quelle est la formule de l'aire d'un triangle ?",
        "L'aire d'un triangle est calculée en multipliant la base par la hauteur, puis en divisant par 2.",
        2,
        25,
        "Seconde",
        "A = l * L",
        "A = 2l * 2L",
        "A = \$\\frac{1}{2} * base * hauteur\$",
        "A = \\(côté1 + côté2\\) / 2"
    ),
    (
        "Quelle est la racine carrée de 144 ?",
        "La racine carrée de 144 est 12, car 12 * 12 = 144.",
        1,
        15,
        "Seconde",
        "9",
        "12",
        "16",
        "10"
    ),
    (
        "Quelle est la formule de la circonférence d'un cercle ?",
        "La circonférence d'un cercle est calculée en multipliant le diamètre par π \$\\(pi\\).\$",
        0,
        20,
        "Seconde",
        "C = 2 * π * r",
        "C = π * r",
        "C = 2 * r",
        "C = r / π"
    ),
    (
        "Résolvez l'équation suivante : 3x + 7 = 22.",
        "Pour résoudre cette équation, soustrayez 7 des deux côtés et divisez par 3.",
        0,
        30,
        "Seconde",
        "x = 5",
        "x = 8",
        "x = 15",
        "x = 9"
    ),
    (
        "Quelle est la formule de la surface d'un cercle ?",
        "La surface d'un cercle est calculée en multipliant π \\(pi\\) par le carré du rayon.",
        2,
        25,
        "Seconde",
        "A = π * r",
        "A = r^2",
        "A = π * r^2",
        "A = r / π"
    ),
    (
        "Quelle est la formule de la surface d'un rectangle ?",
        "La surface d'un rectangle est calculée en multipliant sa longueur par sa largeur.",
        0,
        30,
        "Seconde",
        "A = l * L",
        "A = 2l * 2L",
        "A = \$\\pi r^2\$",
        "A = \\(côté1 + côté2\\) / 2"
    ),
    (
        "Quelle est la formule de la somme des angles d'un triangle ?",
        "La somme des angles intérieurs d'un triangle est toujours égale à 180 degrés.",
        3,
        20,
        "Seconde",
        "90 degrés",
        "60 degrés",
        "120 degrés",
        "180 degrés"        
    ),
    (
        "Résolvez l'équation suivante : 2\\(x - 5\\) = 16.",
        "Pour résoudre cette équation, commencez par distribuer 2 dans les parenthèses, puis isolez x.",
        2,
        35,
        "Seconde",
        "x = 4",
        "x = 6",
        "x = 13",
        "x = 10"
    ),
    (
        "Quelle est la formule de la surface d'un carré ?",
        "La surface d'un carré est calculée en multipliant la longueur du côté par elle-même.",
        1,
        15,
        "Seconde",
        "A = 2l * 2L",
        "A = l * L",
        "A = \$\\pi r^2 \$",
        "A = \\(côté1 + côté2\\) / 2"
    ),
    (
        "Quelle est la formule du périmètre d'un triangle équilatéral ?",
        "Le périmètre d'un triangle équilatéral est calculé en multipliant la longueur du côté par 3.",
        0,
        18,
        "Seconde",
        "P = 3l",
        "P = l^2",
        "P = 2l * 2L",
        "P = 4l"
    ),
    (
    "Calculez le périmètre d'un rectangle dont la longueur est 8 cm et la largeur est 5 cm.",
    "Le périmètre d'un rectangle est calculé en additionnant les longueurs de tous ses côtés.",
    1,
    25,
    "Seconde",
    "P = 40 cm",
    "P = 26 cm",
    "P = 13 cm",
    "P = 18 cm"
)
,
    (
        "Résolvez l'équation suivante : 3x + 2 = 12.",
        "Pour résoudre cette équation, commencez par isoler x.",
        2,
        30,
        "Seconde",
        "x = 2",
        "x = 10/5",
        "x = 10/3",
        "x = 3/2"
    ),
    (
        "Quelle est la formule de la circonférence d'un cercle ?",
        "La circonférence d'un cercle est calculée en multipliant le diamètre par π \\(pi\\).",
        1,
        12,
        "Seconde",
        "C = πr",
        "C = πd",
        "C = r^2",
        "C = 4s"
    ),
    (
        "Si un triangle a deux côtés égaux, quel type de triangle est-ce ?",
        "Un triangle ayant deux côtés égaux est un triangle isocèle.",
        0,
        10,
        "Seconde",
        "Triangle isocèle",
        "Triangle équilatéral",
        "Triangle rectangle",
        "Triangle scalène"
    ),
    (
        "Calculez la surface d'un triangle dont la base mesure 6 cm et la hauteur mesure 8 cm.",
        "La surface d'un triangle est calculée en multipliant la base par la hauteur et en divisant par 2.",
        2,
        20,
        "Seconde",
        "A = 48 cm²",
        "A = 14 cm²",
        "A = 24 cm²",
        "A = 64 cm²"
    ),

     (
        "Quelle est la notation pour l'ensemble vide ?",
        "L'ensemble vide est noté ∅ \\(symbole de phi\\).",
        2,
        10,
        "Seconde",
        "E",
        "0",
        "∅",
        "N"
    ),

    (
        "Si A = {2, 4, 6, 8} et B = {4, 8, 12}, quel est l'ensemble d'intersection A ∩ B ?",
        "L'ensemble d'intersection contient les éléments communs à A et B.",
        0,
        15,
        "Seconde",
        "{4, 8}",
        "{2, 4, 6, 8}",
        "{12}",
        "{2, 6, 12}"
    ),
    (
        "Si C = {1, 3, 5, 7} et D = {2, 4, 6}, quel est l'ensemble d'union C ∪ D ?",
        "L'ensemble d'union contient tous les éléments de C et de D, sans répétition.",
        2,
        12,
        "Seconde",
        "{1, 2, 3, 4, 5, 6, 7,8}",
        "{2, 4, 6, 1, 3, 5, 7}",
        "{1, 3, 5, 7, 2, 4, 6}",
        "{1, 2, 3, 4, 5, 6, 7, 8, 9}"
    ),
    (
        "Quel est le signe d'appartenance en mathématiques pour indiquer qu'un élément est dans un ensemble ?",
        "Le signe d'appartenance est noté ∈ \\(un epsilon renversé\\).",
        0,
        8,
        "Seconde",
        "∈",
        "∉",
        "∅",
        "="
    ),
    (
        "Quelle est la valeur de π \\(pi\\) arrondie à deux décimales ?",
        "La valeur de π \\(pi\\) est approximativement 3,14.",
        2,
        5,
        "Seconde",
        "3,12",
        "3,16",
        "3,14",
        "3,10"
    ),
     (
        "Quelle est la formule du volume d'un parallélépipède rectangle ?",
        "Le volume d'un parallélépipède rectangle est donné par V = l * L * h, où l est la longueur, L est la largeur et h est la hauteur.",
        0,
        20,
        "Seconde",
        "V = l * L * h",
        "V = 2\\(l + L + h\\)",
        "V = l^2 + L^2 + h^2",
        "V = 2lh"
    ),
    (
        "Soit la fonction affine f\\(x\\) = 3x - 5. Trouvez la valeur de x pour laquelle f\\(x\\) = 10.",
        "Pour trouver la valeur de x, nous résolvons l'équation 3x - 5 = 10.",
        1,
        25,
        "Seconde",
        "x = 2",
        "x = 5",
        "x = 10",
        "x = 15"
    ),
    (
        "Quelle est l'aire de la base d'un cône de rayon 4 cm ?",
        "L'aire de la base d'un cône est donnée par A = πr^2, où r est le rayon.",
        2,
        12,
        "Seconde",
        "A = πr",
        "A = 2πr",
        "A = 16π cm²",
        "A = 8π cm²"
    ),
    (
        "Démontrez que les diagonales d'un rectangle sont de même longueur.",
        "Pour démontrer que les diagonales d'un rectangle sont de même longueur, utilisez la propriété des rectangles et le théorème de Pythagore.",
        0,
        35,
        "Seconde",
        "Démonstration requise",
        "Aucune démonstration nécessaire",
        "Démonstration difficile",
        "Démonstration simple"
    ),
    (
        "Soit la fonction f\\(x\\) = 2x + 3. Quelle est l'image de -4 par cette fonction ?",
        "Pour trouver l'image de -4, évaluez f\\(-4\\).",
        2,
        15,
        "Seconde",
        "f\\(-4\\) = 4",
        "f\\(-4\\) = 7",
        "f\\(-4\\) = -5",
        "f\\(-4\\) = -8"
    ),
     (
        "Déterminez la distance entre les points A\\(2, 3, 4\\) et B\\(6, 8, 10\\) dans l'espace.",
        "La distance entre deux points dans l'espace est donnée par la formule : \$[d = \\sqrt{\\(x_2 - x_1\\)^2 + \\(y_2 - y_1\\)^2 + \\(z_2 - z_1\\)^2}]\$",
        1,
        40,
        "Seconde",
        "d = 15",
        "d = 8",
        "d = 10",
        "d = 12"
    ),
    (
        "Quelle est l'équation de la droite dans l'espace passant par le point A\\(1, -2, 3\\) et dirigée par le vecteur v\\(2, 1, -1\\) ?",
        "L'équation d'une droite dans l'espace est donnée par : \$[D: \\frac{x - x_0}{a} = \\frac{y - y_0}{b}\$ = \$\\frac{z - z_0}{c}] \$ où \$\\(x_0, y_0, z_0\\)\$ est un point sur la droite et \\(a, b, c\\) est le vecteur directeur de la droite.",
        0,
        700,
        "Seconde",
        "D : \$\\(\\frac{x - 1}{2} = \\frac{y + 2}{1} = \\frac{z - 3}{-1}\\)\$",
        "D : \$\\(\\frac{x + 1}{-2} = \\frac{y - 2}{1} = \\frac{z + 3}{1}\\)\$",
        "D : \$\\(\\frac{x - 1}{2} = \\frac{y + 2}{1} = \\frac{z + 3}{-1}\\)\$",
        "D : \$\\(\\frac{x + 1}{-2} = \\frac{y - 2}{1} = \\frac{z - 3}{1}\\)\$"
    ),
    (
        "Résolvez l'équation du plan 2x - y + 3z = 6.",
        "L'équation d'un plan est donnée par Ax + By + Cz = D, où \\(A, B, C\\) sont les coefficients du plan et \\(x, y, z\\) sont les coordonnées. Pour résoudre cette équation, nous pouvons déterminer les valeurs de x, y et z qui satisfont l'équation.",
        2,
        605,
        "Seconde",
        "x = 1, y = -1, z = 2",
        "x = 2, y = 0, z = 1",
        "x = 1, y = -1, z = 1",
        "x = -2, y = 4, z = 0"
    ),
    (
        "Démontrez que la médiane d'un triangle divise le triangle en deux triangles de même aire.",
        "Pour démontrer que la médiane d'un triangle divise le triangle en deux triangles de même aire, utilisez la propriété des médianes et la notion d'aire des triangles.",
        0,
        50,
        "Seconde",
        "Démonstration requise",
        "Aucune démonstration nécessaire",
        "Démonstration difficile",
        "Démonstration simple"
    ),
    (
        "Soit la fonction f\\(x\\) = \$\\frac{1}{2}x - 3. \$Quelle est la solution de l'équation \$f\\(x\\) = 4 ?\$",
        "Pour trouver la solution de l'équation, évaluez f\\(x\\) et résolvez l'équation \$\\(\\frac{1}{2}x - 3 = 4\\).\$",
        2,
        25,
        "Seconde",
        "x = 2",
        "x = 5",
        "x = 14",
        "x = 8"
    ),
    (
        "Résolvez l'équation quadratique suivante : \\(x^2 - 4x + 4 = 0\\).",
        "Pour résoudre cette équation quadratique, utilisez la formule quadratique ou facteurisez-la.",
        1,
        40,
        "Seconde",
        "x = -2",
        "x = 2",
        "x = 4",
        "x = 0"
    ),
    (
        "Quelle est la valeur de la somme \$\\(1 + 2 + 3 + \\ldots + 100\\)\$, c'est-à-dire la somme des entiers de 1 à 100 ?",
        "La somme des entiers de 1 à \\(n\\) est donnée par la formule \$\\(\\frac{n\\(n + 1\\)}{2}\\).\$",
        3,
        30,
        "Seconde",
        "4950",
        "5150",
        "4900",
        "5050"
    ),
    (
        "Démontrez le théorème de Pythagore : \\(a^2 + b^2 = c^2\\), où \\(c\\) est l'hypoténuse d'un triangle rectangle.",
        "Pour démontrer le théorème de Pythagore, utilisez des carrés pour représenter les aires des côtés d'un triangle rectangle.",
        0,
        60,
        "Seconde",
        "Démonstration requise",
        "Aucune démonstration nécessaire",
        "Démonstration difficile",
        "Démonstration simple"
    ),
    (
        "Calculez la valeur de  \\(pi\\) à trois décimales près.",
        "La valeur de \\(pi\\) est une constante mathématique approximativement égale à 3.141.",
        1,
        20,
        "Seconde",
        "3.142",
        "3.141",
        "3.140",
        "3.143"
    ),
    (
        "Résolvez l'inéquation \\(3x - 5 > 7\\).",
        "Pour résoudre cette inéquation, isolez \\(x\\) en ajoutant 5 des deux côtés, puis divisez par 3.",
        1,
        25,
        "Seconde",
        "x > 4",
        "x < 4",
        "x > -4",
        "x < -4"
    ),
     (
        "Un train quitte une gare à 9h00 en direction de la ville B, située à 200 km. Il se déplace à une vitesse constante de 80 km/h. En même temps, un autre train quitte la ville B en direction de la gare. Il se déplace à une vitesse constante de 60 km/h. À quelle heure les deux trains se croiseront-ils ?",
        "Pour résoudre ce problème, utilisez la formule de la distance \\(distance = vitesse x temps\\) et établissez une équation en tenant compte du temps que les deux trains mettront pour se rencontrer.",
        1,
        60,
        "Seconde",
        "10h00",
        "10h30",
        "11h00",
        "11h30"
    ),
    (
        "Une piscine vide peut être remplie par un robinet en 8 heures. Un autre robinet, s'il est utilisé simultanément avec le premier, peut la remplir en 4 heures. Combien de temps faudra-t-il pour remplir complètement la piscine si seulement le deuxième robinet est utilisé ?",
        "Utilisez le concept de taux de travail pour résoudre ce problème. Le taux de travail est inversément proportionnel au temps.",
        0,
        45,
        "Seconde",
        "12 heures",
        "16 heures",
        "6 heures",
        "8 heures"
    ),
    (
        "Un triangle a une aire de 36 mètres carrés et une base de 12 mètres. Calculez la hauteur du triangle.",
        "L'aire d'un triangle est donnée par la formule \$\\(A = \\frac{1}{2} \\times \\text{base} \\times \\text{hauteur}\\)\$. Utilisez cette formule pour calculer la hauteur.",
        1,
        35,
        "Seconde",
        "6 mètres",
        "9 mètres",
        "4 mètres",
        "3 mètres"
    ),
    (
        "Une boîte contient 12 boules numérotées de 1 à 12. Si une boule est tirée au hasard, quelle est la probabilité qu'elle porte un numéro pair ?",
        "Il y a 6 numéros pairs \\(2, 4, 6, 8, 10, 12\\) sur un total de 12 boules. Utilisez la définition de la probabilité \\(nombre de cas favorables / nombre de cas possibles\\) pour résoudre ce problème.",
        0,
        25,
        "Seconde",
        "0,5",
        "0,25",
        "0,75",
        "1,0"
    ),
    (
        "Un magasin vend un article au prix de 120 €. Pendant une promotion, le prix de l'article est réduit de 20 %. Quel est le prix de l'article pendant la promotion ?",
        "Pour calculer le prix réduit, soustrayez la réduction \\(20 % de 120 €\\) du prix initial.",
        2,
        20,
        "Seconde",
        "24 €",
        "100 €",
        "96 €",
        "80 €"
    ),
     (
        "Un jardinier veut créer un jardin rectangulaire le long d'un mur de 20 mètres de long. Il dispose de 60 mètres de clôture pour les trois côtés restants. Quelles dimensions le jardinier doit-il choisir pour maximiser la superficie du jardin ?",
        "Pour résoudre ce problème d'optimisation, vous pouvez introduire une variable, par exemple, \\(x\\) pour la longueur du jardin, et \\(y\\) pour la largeur. Vous devez ensuite exprimer la superficie \\(\\(A\\)\\) en fonction de \\(x\\) et \\(y\\), ainsi que la contrainte de périmètre. Ensuite, maximisez \\(A\\).",
        1,
        300,
        "Seconde",
        "10 m x 20 m",
        "15 m x 15 m",
        "5 m x 30 m",
        "12 m x 18 m"
    ),
    (
        "Un réservoir d'eau a la forme d'un cône renversé. La base a un rayon de 4 mètres, et le réservoir a une hauteur de 8 mètres. Calculez le volume d'eau qu'il peut contenir lorsque le réservoir est complètement rempli. Arrondissez la réponse à la décimale près.",
        "Pour calculer le volume d'un cône, utilisez la formule \$\\(V = \\frac{1}{3} \\pi r^2 h\\)\$, où \\(r\\) est le rayon de la base et \\(h\\) est la hauteur. Dans ce cas, \\(r = 4\\) m et \\(h = 8\\) m.",
        3,
        300,
        "Seconde",
        "33,51 m³",
        "100,48 m³",
        "75,40 m³",
        "134,04 m³"
    ),
    (
        "Un étudiant veut économiser de l'argent pour un voyage. Il décide de mettre de l'argent de côté chaque semaine. La première semaine, il met 5 € de côté. Chaque semaine suivante, il double le montant qu'il a mis de côté la semaine précédente. Combien aura-t-il économisé en 10 semaines ?",
        "Pour résoudre ce problème, vous pouvez utiliser une série géométrique, car chaque semaine le montant mis de côté double. Utilisez la formule \$\\(S_n = a\\(1 - r^n\\) / \\(1 - r\\)\\)\$ où \\(S_n\\) est la somme des \\(n\\) premiers termes, \\(a\\) est le premier terme \\(5 €\\), \\(r\\) est le rapport \\(2, car le montant double chaque semaine\\), et \\(n\\) est le nombre de semaines \\(10\\).",
        2,
        320,
        "Seconde",
        "1 015 €",
        "511 €",
        "2 045 €",
        "255 €"
    ),
    (
        "Une étagère en forme de triangle équilatéral est suspendue au mur. La longueur de chaque côté de l'étagère est de 60 cm. Si un livre pèse 500 g et la largeur de l'étagère est de 25 cm, combien de livres au maximum peut-on empiler sur l'étagère avant qu'elle ne tombe ?",
        "Pour résoudre ce problème, vous devez calculer la somme des moments des livres sur l'étagère et comparer cela au moment maximal supporté par l'étagère sans basculer.",
        1,
        360,
        "Seconde",
        "25 livres",
        "18 livres",
        "30 livres",
        "22 livres"
    ),
    (
        "Un distributeur de boissons propose une offre spéciale : achetez 5 boissons pour le prix de 4. Si chaque boisson coûte 1,20 €, combien coûteraient 15 boissons avec cette offre spéciale ?",
        "Pour résoudre ce problème, calculez d'abord le coût de 15 boissons au prix normal, puis appliquez la réduction pour obtenir le coût final.",
        0,
        300,
        "Seconde",
        "18 €",
        "21 €",
        "15 €",
        "20 €"
    ),
    (
        "Un père a aujourd'hui trois fois l'âge de son fils. Dans 10 ans, l'âge du père sera deux fois celui de son fils. Quels sont les âges actuels du père et du fils ?",
        "Pour résoudre ce problème, vous pouvez établir deux équations en utilisant les informations données. Soit \\(x\\) l'âge actuel du fils et \\(y\\) l'âge actuel du père. Ensuite, résolvez le système d'équations.",
        0,
        420,
        "Seconde",
        "5 ans pour le fils et 15 ans pour le père",
        "10 ans pour le fils et 30 ans pour le père",
        "15 ans pour le fils et 45 ans pour le père",
        "20 ans pour le fils et 60 ans pour le père"
    ),
    (
        "Un commerçant vend des pommes à 0,60 € l'unité. Il décide d'offrir une réduction de 20 % à ses clients pour l'achat de 5 pommes ou plus. Si un client achète 7 pommes, combien paiera-t-il au total après la réduction ?",
        "Pour résoudre ce problème, calculez le coût total des 7 pommes avant la réduction, puis appliquez la réduction de 20 %.",
        3,
        360,
        "Seconde",
        "4,80 €",
        "5,40 €",
        "6,00 €",
        "7,20 €"
    ),
    (
        "Un train parcourt la distance entre deux villes à une vitesse constante de 120 km/h. Un autre train part des mêmes deux villes 2 heures plus tard et parcourt la même distance à une vitesse constante de 160 km/h. Combien de temps le deuxième train mettra-t-il pour rattraper le premier train ?",
        "Pour résoudre ce problème, vous pouvez utiliser une équation de distance en fonction du temps pour chaque train. Ensuite, trouvez le moment où les deux équations sont égales.",
        2,
        420,
        "Seconde",
        "5 heures",
        "4 heures",
        "6 heures",
        "3 heures"
    ),
    (
        "Un rectangle a un périmètre de 28 cm. Si la longueur du rectangle est 2 cm de plus que la largeur, quelles sont les dimensions du rectangle ?",
        "Pour résoudre ce problème, utilisez les informations fournies pour établir une équation de périmètre en fonction de la longueur et de la largeur du rectangle. Ensuite, résolvez l'équation pour trouver les dimensions.",
        2,
        360,
        "Seconde",
        "7 cm x 9 cm",
        "6 cm x 10 cm",
        "6 cm x 8 cm",
        "5 cm x 7 cm"
    ),
    (
        "Un magasin propose une promotion : si vous achetez deux articles au prix normal, le troisième est offert. Si un client achète trois articles, dont deux à 30 € chacun et un à 40 €, combien paiera-t-il au total avec la promotion ?",
        "Pour résoudre ce problème, calculez d'abord le coût total des trois articles au prix normal, puis appliquez la réduction pour le troisième article.",
        1,
        360,
        "Seconde",
        "70 €",
        "80 €",
        "90 €",
        "100 €"
    ),
     (
        "Résolvez l'équation : \\(2x - 5 = 3x + 7\\)",
        "Pour résoudre cette équation, commencez par regrouper les termes contenant \\(x\\) d'un côté et les termes constants de l'autre côté de l'équation. Ensuite, isolez \\(x\\).",
        0,
        300,
        "Seconde",
        "x = -12",
        "x = -5",
        "x = 12",
        "x = 5"
    ),
    (
        "Résolvez l'inéquation : \\(3\\(2x - 4\\) > 5x + 1\\)",
        "Pour résoudre cette inéquation, commencez par distribuer le \\(3\\) à l'intérieur de la parenthèse. Ensuite, regroupez les termes contenant \\(x\\) d'un côté et les termes constants de l'autre côté de l'inéquation. N'oubliez pas d'inverser le sens de l'inégalité si vous divisez par un nombre négatif.",
        3,
        300,
        "Seconde",
        "\\(-1 < x < 3\\)",
        "\\(-3 < x < 1\\)",
        "x < -1",
        "x > 13"
    ),
    (
        "Un triangle a un périmètre de 30 cm. Le côté le plus court mesure \\(x\\) cm, le côté moyen mesure \\(2x\\) cm et le côté le plus long mesure \\(3x\\) cm. Quelle est la valeur de \\(x\\) et quelles sont les longueurs des trois côtés du triangle ?",
        "Pour résoudre ce problème, établissez une équation basée sur le périmètre du triangle en utilisant les longueurs des côtés en fonction de \\(x\\). Ensuite, résolvez l'équation pour trouver \\(x\\) et les longueurs des côtés.",
        0,
        420,
        "Seconde",
        "x = 5 cm, côtés : 5 cm, 10 cm, 15 cm",
        "x = 3 cm, côtés : 3 cm, 6 cm, 9 cm",
        "x = 4 cm, côtés : 4 cm, 8 cm, 12 cm",
        "x = 6 cm, côtés : 6 cm, 12 cm, 18 cm"
    ),
    (
        "Résolvez l'équation suivante pour \\(x\\) : \\(2x^2 - 5x - 3 = 0\\)",
        "Pour résoudre cette équation quadratique, vous pouvez utiliser la formule quadratique ou factoriser l'expression. Trouvez les valeurs de \\(x\\) qui satisfont cette équation.",
        2,
        420,
        "Seconde",
        "x = -1 et x = 3",
        "x = 1 et x = -3",
        "x = -1/2 et x = 3",
        "x = 4 et x = -4"
    ),
    (
        "Un magasin vend deux types de bonbons, des bonbons A à 2 € l'unité et des bonbons B à 3 € l'unité. Un client souhaite acheter un total de 10 bonbons et dépenser au plus 25 €. Combien de bonbons de chaque type peut-il acheter au maximum ?",
        "Pour résoudre ce problème, vous pouvez définir deux variables, \\(x\\) pour le nombre de bonbons A et \\(y\\) pour le nombre de bonbons B. Ensuite, établissez un système d'inéquations basé sur le coût total et la quantité totale de bonbons. Trouvez les valeurs de \\(x\\) et \\(y\\) qui satisfont ces inéquations.",
        2,
        420,
        "Seconde",
        "5 bonbons A et 5 bonbons B",
        "4 bonbons A et 6 bonbons B",
        "6 bonbons A et 4 bonbons B",
        "3 bonbons A et 7 bonbons B"
    ),

    (
        "Résolvez l'équation trigonométrique suivante : \$\\(2\\sin\\(x\\) + \\sqrt{3} = 0\\)\$ pour \$\\(0 \\leq x \\leq 2\\pi\\)\$",
        "Pour résoudre cette équation trigonométrique, isolez d'abord le terme trigonométrique, puis utilisez les propriétés des fonctions trigonométriques pour trouver les solutions dans l'intervalle donné.",
        2,
        480,
        "Seconde",
        "\$\\(x = \\frac{\\pi}{6}\\)\$",
        "\$\\(x = \\frac{\\pi}{3}\\)\$",
        "\$\\(x = \\frac{7\\pi}{6}\\)\$",
        "\$\\(x = \\frac{4\\pi}{3}\\)\$"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) : \$\\(\\frac{x}{x-3} \\leq 1\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité, puis testez des valeurs dans les intervalles appropriés pour déterminer les solutions.",
        0,
        480,
        "Seconde",
        "\$\\(x \\leq 0\\) ou \\(x \\geq 3\\)\$",
        "\$\\(x > 0\\) et \\(x < 3\\)\$",
        "\$\\(x > 0\\) ou \\(x < 3\\)\$",
        "\$\\(x \\geq 0\\) et \\(x \\leq 3\\)\$"
    ),
    (
        "Résolvez le système d'équations suivant :  \\(2x + 3y = 11\\)  \\(4x - y = 5\\)",
        "Pour résoudre ce système d'équations, utilisez la méthode de substitution ou d'élimination. Trouvez les valeurs de \\(x\\) et \\(y\\) qui satisfont les deux équations.",
        0,
        480,
        "Seconde",
        "\\(x = 2, y = 3\\)",
        "\\(x = 3, y = 2\\)",
        "\\(x = 4, y = 1\\)",
        "\\(x = 1, y = 4\\)"
    ),
    (
        "Un rectangle a une aire de 36 cm². Si la longueur du rectangle est 3 cm de plus que la largeur, trouvez les dimensions du rectangle.",
        "Pour résoudre ce problème, établissez une équation basée sur l'aire du rectangle et la relation entre la longueur et la largeur. Ensuite, résolvez l'équation pour trouver les dimensions.",
        1,
        540,
        "Seconde",
        "Largeur : 4 cm, Longueur : 7 cm",
        "Largeur : 6 cm, Longueur : 9 cm",
        "Largeur : 5 cm, Longueur : 8 cm",
        "Largeur : 3 cm, Longueur : 6 cm"
    ),
    (
        "Résolvez l'inéquation : \$\\(\\frac{3x - 1}{2x + 1} \\geq 2\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité en évitant les valeurs qui rendent le dénominateur nul. Ensuite, testez des intervalles pour déterminer les solutions.",
        2,
        540,
        "Seconde",
        "\$\\(x \\leq -\\frac{3}{2}\\)\$",
        "\$\\(x \\geq -\\frac{3}{2}\\)\$",
        "\$\\(x < -\\frac{3}{2}\\)\$",
        "\$\\(x > -\\frac{3}{2}\\)\$"
    ),

     (
        "Résolvez l'inéquation suivante pour \\(x\\) : \$\\(\\frac{1}{x-2} - \\frac{1}{x+2} > 0\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité, puis testez des valeurs dans les intervalles appropriés pour déterminer les solutions.",
        1,
        600,
        "Seconde",
        "\\(x > -2\\) et \\(x < 2\\)",
        "\\(x < -2\\) ou \\(x > 2\\)",
        "\\(x > -2\\) ou \\(x < 2\\)",
        "\\(x < -2\\) et \\(x > 2\\)"
    ),
    (
        "Résolvez l'équation suivante pour \\(x\\) : \$\\(\\sqrt{3x+1} - 2 = 0\\)\$",
        "Pour résoudre cette équation avec une racine carrée, isolez d'abord la racine, puis élevez les deux côtés au carré pour trouver la solution.",
        2,
        540,
        "Seconde",
        "\\(x = 4\\)",
        "\\(x = 1\\)",
        "\\(x = -1\\)",
        "\\(x = 9\\)"
    ),
    (
        "Résolvez l'équation suivante pour \\(x\\) : \$\\(2\\sqrt{2x+3} = 4\\)\$",
        "Pour résoudre cette équation avec une racine carrée, isolez d'abord la racine, puis simplifiez l'expression pour trouver la solution.",
        2,
        540,
        "Seconde",
        "\\(x = 4\\)",
        "\\(x = 2\\)",
        "\\(x = 1/2\\)",
        "\\(x = 6\\)"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) : \\(x^2 - 4x + 4 > 0\\)",
        "Pour résoudre cette inéquation quadratique, trouvez d'abord les valeurs critiques, puis testez les intervalles pour déterminer les solutions.",
        0,
        600,
        "Seconde",
        "\\(x < 2\\) ou \\(x > 2\\)",
        "\\(x > 2\\)",
        "\\(x \\leq 2\\)",
        "\\(x \\geq 2\\)"
    ),
    (
        "Résolvez le système d'équations suivant :  \\(3x + 4y = 17\\)  \\(x - 2y = 4\\)",
        "Pour résoudre ce système d'équations, utilisez la méthode de substitution ou d'élimination. Trouvez les valeurs de \\(x\\) et \\(y\\) qui satisfont les deux équations.",
        1,
        600,
        "Seconde",
        "\\(x = 2, y = 1\\)",
        "\\(x = 5, y = 1/2\\)",
        "\\(x = 4, y = 3\\)",
        "\\(x = 1, y = 0\\)"
    ),

     (
        "Résolvez l'inéquation suivante pour \\(x\\) :\$ \\(\\frac{2x+1}{x-3} \\leq 3\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité, puis testez des valeurs dans les intervalles appropriés pour déterminer les solutions.",
        0,
        600,
        "Seconde",
        "\\(x < -1\\) ou \\(x > 3\\)",
        "\\(x > -1\\) et \\(x < 3\\)",
        "\\(x < -1\\) et \\(x > 3\\)",
        "\\(x > -1\\) ou \\(x < 3\\)"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) : \$\\(\\frac{x}{x+1} - \\frac{1}{x-2} > 1\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité, puis testez des valeurs dans les intervalles appropriés pour déterminer les solutions.",
        3,
        600,
        "Seconde",
        "\\(x < -1\\) ou \\(x > 2\\)",
        "\\(x > -1\\) et \\(x < 2\\)",
        "\\(x < -1\\) et \\(x > 2\\)",
        "\\(x < -1\\) ou \$\\(x € [\\frac{3-\\sqrt{13}}{2}; 2]< 2\\)\$ ou \$\\(x >\\frac{3+\\sqrt{13}}{2}\\)\$"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) : \\(x^3 - 2x^2 - 8x > 0\\)",
        "Pour résoudre cette inéquation polynomiale, commencez par factoriser et trouver les valeurs critiques, puis testez les intervalles pour déterminer les solutions.",
        3,
        600,
        "Seconde",
        "\\(x < -2\\) ou \\(x > 0\\)",
        "\\(x > -2\\) et \\(x < 0\\)",
        "\\(x < -2\\) et \\(x > 0\\)",
        "\\(x > -2 et x < 0\\) ou \\(x > 4\\)"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) :\$ \\(\\frac{1}{x^2-9} > 0\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité, puis testez des valeurs dans les intervalles appropriés pour déterminer les solutions.",
        0,
        600,
        "Seconde",
        "\\(x < -3\\) ou \\(x > 3\\)",
        "\\(x > -3\\) et \\(x < 3\\)",
        "\\(x < -3\\) et \\(x > 3\\)",
        "\\(x > -3\\) ou \\(x < 3\\)"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) : \$\\(2x^2 - 5x - 3 \\leq 0\\)\$",
        "Pour résoudre cette inéquation quadratique, trouvez d'abord les valeurs critiques, puis testez les intervalles pour déterminer les solutions.",
        1,
        600,
        "Seconde",
        "\\(x < -1\\) ou \\(x > 3/2\\)",
        "\\(x > -1\\) et \\(x < 3/2\\)",
        "\\(x < -1\\) et \\(x > 3/2\\)",
        "\\(x > -1\\) ou \\(x < 3/2\\)"
    ),
     (
        "Résolvez l'inéquation suivante pour \\(x\\) :\$\\(\\frac{x-2}{x^2-4} < 0\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité, puis testez des valeurs dans les intervalles appropriés pour déterminer les solutions.",
        2,
        600,
        "Seconde",
        "\\(x < -2\\) ou \\(x > 2\\)",
        "\\(x > -2\\) et \\(x < 2\\)",
        "\\(x < -2\\) et \\(x > 2\\)",
        "\\(x > -2\\) ou \\(x < 2\\)"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) : \$\\(\\frac{x^2-4}{x^2-9} \\geq 0\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité, puis testez des valeurs dans les intervalles appropriés pour déterminer les solutions.",
        0,
        600,
        "Seconde",
        "\\(x < -3\\) ou \\(x > -2\\)",
        "\\(x > -3\\) et \\(x < -2\\)",
        "\\(x < -3\\) et \\(x > -2\\)",
        "\\(x > -3\\) ou \\(x < -2\\)"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) : \\(x^4 - 5x^2 + 4 > 0\\)",
        "Pour résoudre cette inéquation polynomiale, commencez par factoriser et trouver les valeurs critiques, puis testez les intervalles pour déterminer les solutions.",
        2,
        600,
        "Seconde",
        "\\(x < -1\\) ou \\(x > -2\\)",
        "\\(x > -1\\) et \\(x < -2\\)",
        "\\(x < -2\\) ou \\(x > -1 et x < 1 \\) ou \\(x > 2\\)",
        "\\(x > -1\\) ou \\(x < -2\\)"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) :\$\\(\\frac{x^2-9}{x^2-4} < 0\\)\$",
        "Pour résoudre cette inéquation rationnelle, commencez par trouver le domaine de validité, puis testez des valeurs dans les intervalles appropriés pour déterminer les solutions.",
        1,
        600,
        "Seconde",
        "\\(x < -3\\) ou \\(x > 3\\)",
        "\\(x > -3\\) et \\(x < 3\\)",
        "\\(x < -3\\) et \\(x > 3\\)",
        "\\(x > -3\\) ou \\(x < 3\\)"
    ),
    (
        "Résolvez l'inéquation suivante pour \\(x\\) :\$\\(x^3 - 4x^2 - 4x + 16 \\geq 0\\)\$",
        "Pour résoudre cette inéquation polynomiale, commencez par factoriser et trouver les valeurs critiques, puis testez les intervalles pour déterminer les solutions.",
        3,
        600,
        "Seconde",
        "\\(x < -2\\) ou \\(x > 2\\)",
        "\\(x > -2\\) et \\(x < 2\\)",
        "\\(x < -2\\) et \\(x > 2\\)",
        "\\(x > -2\\) ou \\(x < 2\\)"
    ),
     (
        "Résolvez l'équation suivante pour \\(x\\) : \\(2x + 3 = 7\\)",
        "Pour résoudre cette équation linéaire, isolez \\(x\\) en effectuant les opérations inverses. Commencez par soustraire 3 des deux côtés, puis divisez par 2.",
        0,
        300,
        "Seconde",
        "x = 2",
        "x = 5",
        "x = -2",
        "x = 10"
    ),
    (
        "Résolvez l'équation suivante pour \\(x\\) : \\(-3x + 5 = 2x - 1\\)",
        "Pour résoudre cette équation linéaire, isolez \\(x\\) en déplaçant tous les termes contenant \\(x\\) d'un côté et les constantes de l'autre. Ensuite, effectuez les opérations inverses pour trouver \\(x\\).",
        3,
        300,
        "Seconde",
        "x = 1",
        "x = 2",
        "x = 4",
        "x = -3"
    ),
    (
        "Résolvez l'équation suivante pour \\(x\\) : \$\\(\\frac{2x}{3} - 4 = 5\\)\$",
        "Pour résoudre cette équation linéaire, commencez par ajouter 4 des deux côtés, puis multipliez par \$\\(\\frac{3}{2}\\)\$ pour isoler \\(x\\).",
        1,
        300,
        "Seconde",
        "x = 9",
        "x = -3",
        "x = 7",
        "x = 0"
    ),
    (
        "Trouvez le domaine de validité de la fonction affine \\(f\\(x\\) = 3x - 2\\) dans \$\\(\\mathbb{R}\\).\$",
        "Le domaine de validité d'une fonction affine est \$\\(\\mathbb{R}\\)\$, ce qui signifie que la fonction est définie pour tous les réels \\(x\\). Il n'y a pas de restriction.",
        0,
        300,
        "Seconde",
        "\$\\(\\mathbb{R}\\)\$",
        "\$\\(\\mathbb{R}^+\\)\$",
        "\$\\(\\mathbb{R}^-\\)\$",
        "\$[0, +\\infty[\$"
    ),
    (
        "Trouvez l'ensemble des solutions de l'inéquation \\(2x - 1 > 3x + 5\\).",
        "Pour résoudre cette inéquation linéaire, déplacez tous les termes contenant \\(x\\) d'un côté et les constantes de l'autre. Ensuite, effectuez les opérations inverses. N'oubliez pas d'inverser le sens de l'inégalité lorsque vous multipliez ou divisez par un nombre négatif.",
        0,
        600,
        "Seconde",
        "x < -6",
        "x > -6",
        "x > 6",
        "x < 6"
    ),
     (
        "Trouvez la valeur de \\(k\\) dans l'équation \\(3k - 7 = 2k + 5\\).",
        "Pour résoudre cette équation, déplacez tous les termes contenant \\(k\\) d'un côté et les constantes de l'autre. Ensuite, effectuez les opérations inverses pour trouver \\(k\\).",
        3,
        300,
        "Seconde",
        "k = -12",
        "k = 5",
        "k = -5",
        "k = 12"
    ),
    (
        "Résolvez l'inéquation \\(3x - 5 < x - 1\\).",
        "Pour résoudre cette inéquation linéaire, déplacez tous les termes contenant \\(x\\) d'un côté et les constantes de l'autre. Inversez le sens de l'inégalité si nécessaire lors de la multiplication ou de la division par un nombre négatif.",
        1,
        600,
        "Seconde",
        "x > 2",
        "x < 2",
        "x > -1",
        "x < 3"
    ),
    (
        "Trouvez l'ensemble des solutions de l'inéquation \$\\(4 - 2x \\geq 6x + 3\\).\$",
        "Pour résoudre cette inéquation linéaire, déplacez tous les termes contenant \\(x\\) d'un côté et les constantes de l'autre. Inversez le sens de l'inégalité si nécessaire lors de la multiplication ou de la division par un nombre négatif.",
        0,
        600,
        "Seconde",
        "\$x \\leq -1\$",
        "\$x \\geq -1\$",
        "\$x > -1\$",
        "\$x < -1\$"
    ),
    (
        "Calculez l'expression suivante : \$\\(\\frac{2x - 3}{5} + \\frac{3x + 2}{4}\\)\$.",
        "Pour additionner ces deux fractions, trouvez d'abord un dénominateur commun, puis ajoutez les numérateurs. Simplifiez si nécessaire.",
        2,
        300,
        "Seconde",
        "\$\\(\\frac{11x + 5}{20}\\)\$",
        "\$\\(\\frac{5x + 11}{20}\\)\$",
        "\$\\(\\frac{5x + 11}{4}\\)\$",
        "\$\\(\\frac{11x + 5}{4}\\)\$"
    ),
     (
        "Quelle est la formule générale du périmètre d'un rectangle ?",
        "Le périmètre d'un rectangle est la somme de la longueur de tous ses côtés. La formule générale est : Périmètre = 2 * \\(Longueur + Largeur\\).",
        0,
        180,
        "Seconde",
        "Périmètre = Longueur + Largeur",
        "Périmètre = 2 * Longueur",
        "Périmètre = 2 * Largeur",
        "Périmètre = Longueur * Largeur"
    ),
    (
        "Quelle est la formule du périmètre d'un triangle équilatéral de côté \\(a\\) ?",
        "Dans un triangle équilatéral, les trois côtés ont la même longueur. La formule du périmètre est : Périmètre = 3 * a.",
        2,
        180,
        "Seconde",
        "Périmètre = a + a + a + a",
        "Périmètre = 2 * a",
        "Périmètre = 3 * a",
        "Périmètre = a * a * a"
    ),
    (
        "Donnez la formule du périmètre d'un cercle en fonction de son rayon.",
        "Le périmètre d'un cercle est égal à \\(2\\pi\\) fois son rayon. La formule est : \$Périmètre = \\(2\\pi r\\).\$",
        2,
        120,
        "Seconde",
        "Périmètre = 2 * r",
        "Périmètre = 3 * r",
        "\$Périmètre = \\(2\\pi r\\)\$",
        "\$Périmètre = \\(\\pi r^2\\)\$"

    ),
    (
        "Déduisez la formule du périmètre d'un carré à partir de celle d'un rectangle.",
        "Un carré est un type particulier de rectangle où tous les côtés sont de même longueur. La formule du périmètre d'un carré est la même que celle d'un rectangle : Périmètre = 2 * \\(Longueur + Largeur\\). Cependant, dans un carré, Longueur = Largeur, donc la formule peut également être exprimée comme : Périmètre = 4 * Côté.",
        2,
        240,
        "Seconde",
        "Périmètre = Longueur + Largeur",
        "Périmètre = 2 * Longueur",
        "Périmètre = 4 * Côté",
        "Périmètre = Longueur * Largeur"
    ),
     (
        "Dans un triangle, l'angle opposé à un côté est appelé :",
        "L'angle opposé à un côté dans un triangle est appelé angle opposé.",
        1,
        120,
        "Seconde",
        "Angle adjacent",
        "Angle opposé",
        "Angle complémentaire",
        "Angle supplémentaire"
    ),
    (
        "Dans un triangle, si un angle est droit, quel est le nom de ce triangle ?",
        "Un triangle avec un angle droit est appelé triangle rectangle.",
        3,
        150,
        "Seconde",
        "Triangle isocèle",
        "Triangle équilatéral",
        "Triangle scalène",
        "Triangle rectangle"
    ),
    (
        "Dans un cercle inscrit dans un triangle, quel est l'angle au centre qui intercepte le même arc qu'un angle inscrit de 60 degrés ?",
        "L'angle au centre qui intercepte le même arc qu'un angle inscrit est deux fois plus grand. Donc, l'angle au centre est de 120 degrés.",
        2,
        180,
        "Seconde",
        "60 degrés",
        "90 degrés",
        "120 degrés",
        "180 degrés"
    ),
    (
        "Dans un triangle inscrit dans un cercle, si un angle est droit, que pouvez-vous dire de ce triangle et du cercle ?",
        "Si un triangle a un angle droit, il est automatiquement un triangle rectangle. Le cercle est le cercle circonscrit au triangle.",
        2,
        150,
        "Seconde",
        "Le triangle est isocèle, le cercle inscrit au triangle",
        "Le triangle est équilatéral,le cercle inscrit au triangle",
        "Le triangle est rectangle , le cercle circonscrit au triangle",
        "Le cercle est un cercle inscrit , le triangle est rectangle"
    ),
     (
        "Dans un triangle ABC, le cercle inscrit touche le côté BC en D. Si les mesures des angles ADC, ADB et BAC sont de 60 degrés chacune, montrez que le triangle ABC est équilatéral.",
        "Pour montrer que le triangle ABC est équilatéral, nous devons prouver que ses trois côtés sont égaux. Commençons par considérer les angles ADC et ADB, qui sont tous deux de 60 degrés. Cela signifie que les côtés AD et AB sont égaux, car ils sont opposés à des angles égaux. Maintenant, considérons le triangle ABD. Comme les angles ADC et ADB sont égaux à 60 degrés et que la somme des angles d'un triangle est de 180 degrés, l'angle BAD est également de 60 degrés. Cela signifie que le triangle ABD est équilatéral, et donc, les côtés AB et BD sont égaux. Enfin, puisque le cercle inscrit touche le côté BC en D, les segments BD et CD sont égaux. Ainsi, nous avons montré que les côtés AB, BC et CA du triangle ABC sont égaux, ce qui en fait un triangle équilatéral.",
        3,
        300,
        "Seconde",
        "Le triangle ABC est isocèle",
        "Le triangle ABC est équilatéral",
        "Le triangle ABC est scalène",
        "Le triangle ABC est rectangle"
    ),
    (
        "Dans un triangle ABC, le cercle inscrit touche les côtés BC, CA et AB en D, E et F respectivement. Si les mesures des angles ADC, AEC et BFA sont de 90 degrés chacune, montrez que le triangle ABC est rectangle.",
        "Pour montrer que le triangle ABC est rectangle, nous devons prouver qu'il a un angle droit. Commençons par considérer l'angle ADC, qui est de 90 degrés. Cela signifie que le segment AD est un diamètre du cercle inscrit. Ensuite, considérons l'angle AEC, qui est également de 90 degrés. Cela signifie que le segment AE est un diamètre du cercle inscrit. Enfin, considérons l'angle BFA, qui est de 90 degrés. Cela signifie que le segment AF est un diamètre du cercle inscrit. Ainsi, les segments AD, AE et AF sont tous des diamètres du cercle inscrit, ce qui implique que le centre du cercle inscrit est également le centre de gravité du triangle ABC. Par conséquent, le triangle ABC a un angle droit à son centre de gravité, ce qui en fait un triangle rectangle.",
        3,
        360,
        "Seconde",
        "Le triangle ABC est isocèle",
        "Le triangle ABC est équilatéral",
        "Le triangle ABC est rectangle",
        "Le triangle ABC est scalène"
    ),
    (
        "Résolvez l'équation suivante pour x : 2x^2 + 3x - 5 = 0.",
        "Pour résoudre cette équation quadratique, nous pouvons utiliser la formule quadratique :\$ x = \\(-b ± √\\(b² - 4ac\\)\\) / \\(2a\\)\$, où a, b et c sont les coefficients de l'équation ax² + bx + c = 0. Dans ce cas, a = 2, b = 3 et c = -5. En substituant ces valeurs dans la formule quadratique, nous obtenons :\$ x = \\(-3 ± √\\(3² - 4\\(2\\)\\(-5\\)\\)\\) / \\(2\\(2\\)\\)\$. Après avoir effectué les calculs, nous obtenons deux solutions : x₁ ≈ 1.697 et x₂ ≈ -1.197.",
        1,
        300,
        "Seconde",
        "x = 2.5 et x = -3.5",
        "x = 1.697 et x = -1.197",
        "x = 0.5 et x = -2.5",
        "x = -1.5 et x = 2.5"
    ),
    (
        "Résolvez le système d'équations suivant :  3x + 2y = 10 , x - y = 1",
        "Pour résoudre ce système d'équations, nous pouvons utiliser la méthode de substitution ou la méthode d'élimination. Dans ce cas, utilisons la méthode d'élimination. Tout d'abord, multiplions la deuxième équation par 2 pour éliminer y :  2\\(x - y\\) = 2\\(1\\) → 2x - 2y = 2. Ensuite, additionnons cette nouvelle équation à la première équation :  3x + 2x - 2y + 2y = 10 + 2 → 5x = 12. Alors x=12/5, nous allons déterminer y , prenons la deuxième équation x - y = 1 ,on a y = x-1 , alors y = 7/5 . Donc  x = 12/5 et y = 7/5 ",
        2,
        300,
        "Seconde",
        "x = 1 et y = 2",
        "x = 2 et y = 3",
        "x = 12/5 et y = 7/5",
        "x = 4 et y = 5"
    ),
    (
        "Résolvez le problème suivant : Un réservoir est rempli à un débit de 5 litres par minute, tandis qu'un autre réservoir est vidé à un débit de 3 litres par minute. Si les deux réservoirs étaient initialement vides et qu'ils ont fonctionné en même temps, combien de temps faudra-t-il pour que le premier réservoir déborde ?",
        "Pour résoudre ce problème, nous devons établir une équation basée sur le débit d'entrée et le débit de sortie. Le premier réservoir se remplit à un débit de 5 litres par minute, donc son taux de remplissage est de 5 l/min. Le deuxième réservoir se vide à un débit de 3 litres par minute, donc son taux de vidange est de 3 l/min. Le temps nécessaire pour que le premier réservoir déborde est donné par :  Temps = \\(Volume du réservoir\\) / \\(Taux de remplissage - Taux de vidange\\) = \\(0 - 0\\) / \\(5 - 3\\) = 0 / 2 = 0 minutes. Donc, il faudra 0 minute pour que le premier réservoir déborde.",
        0,
        300,
        "Seconde",
        "0 minute",
        "1 minute",
        "2 minutes",
        "3 minutes"
    ),
     (
        "Dans un triangle équilatéral ABC, si AB = 6 cm, quel est le périmètre du triangle ?",
        "Dans un triangle équilatéral, tous les côtés sont de longueur égale. Donc, si AB = 6 cm, alors AC et BC sont également de 6 cm chacun. Le périmètre du triangle équilatéral ABC est la somme de ses trois côtés :  Périmètre = AB + AC + BC = 6 cm + 6 cm + 6 cm = 18 cm.",
        0,
        300,
        "Seconde",
        "12 cm",
        "15 cm",
        "18 cm",
        "24 cm"
    ),
    (
        "Dans un triangle ABC, si les mesures des angles sont α = 50°, β = 70° et γ = 60°, quel type de triangle est-ce \\(rectangle, obtusangle ou aigu\\) ?",
        "Pour déterminer le type de triangle, nous examinons les mesures des angles. Un triangle est aigu si tous ses angles sont inférieurs à 90°, obtusangle s'il a un angle supérieur à 90°, et rectangle s'il a un angle égal à 90°. Dans ce cas, α = 50°, β = 70° et γ = 60°, ce qui signifie que tous les angles sont inférieurs à 90°. Par conséquent, il s'agit d'un triangle aigu.",
        2,
        300,
        "Seconde",
        "Triangle rectangle",
        "Triangle obtusangle",
        "Triangle aigu",
        "Triangle équilatéral"
    ),
    (
        "Dans un rectangle ABCD, si AB = 8 cm et BC = 6 cm, quelle est la longueur de la diagonale AC ?",
        "Dans un rectangle, les diagonales sont égales en longueur et se croisent au centre du rectangle. Par conséquent, la diagonale AC a la même longueur que la diagonale BD. Pour calculer la longueur de la diagonale AC, nous pouvons utiliser le théorème de Pythagore, car le triangle ABC est un triangle rectangle. La diagonale AC est l'hypoténuse, et AB et BC sont les côtés du triangle rectangle. Donc, AC² = AB² + BC² = 8 cm² + 6 cm² = 64 cm² + 36 cm² = 100 cm². En prenant la racine carrée des deux côtés, nous obtenons AC = √100 cm² = 10 cm.",
        3,
        300,
        "Seconde",
        "4 cm",
        "6 cm",
        "8 cm",
        "10 cm"
    ),
     (
        "Dans un triangle ABC, si AB = 5 cm, BC = 12 cm et AC = 13 cm, quel type de triangle est-ce \\(rectangle, obtusangle ou aigu\\) ?",
        "Pour déterminer le type de triangle, nous pouvons utiliser le théorème de Pythagore. Si le carré de la plus grande longueur est égal à la somme des carrés des deux autres longueurs, alors il s'agit d'un triangle rectangle. Dans ce cas, AB² + BC² = 5 cm² + 12 cm² = 25 cm² + 144 cm² = 169 cm², et AC² = 13 cm². Puisque 169 cm² = 13 cm², il s'agit d'un triangle rectangle.",
        0,
        300,
        "Seconde",
        "Triangle rectangle",
        "Triangle obtusangle",
        "Triangle aigu",
        "Triangle isocèle"
    ),
    (
        "Dans un cercle de rayon 7 cm, quelle est la longueur de l'arc correspondant à un angle central de 60 degrés ?",
        "Pour calculer la longueur de l'arc d'un cercle, nous utilisons la formule : Longueur de l'arc = \\(angle central / 360°\\) * \\(2 * π * rayon\\). Dans ce cas, l'angle central est de 60 degrés, le rayon est de 7 cm, alors la longueur de l'arc est \\(60° / 360°\\) * \\(2 * π * 7 cm\\) = \\(1/6\\) * \\(14π cm\\) ≈ 7π cm.",
        3,
        300,
        "Seconde",
        "7 cm",
        "14 cm",
        "7√3 cm",
        "7π cm"
    ),
    (
        "Dans un trapèze ABCD, AB est parallèle à CD, AB = 8 cm, CD = 14 cm, et la hauteur du trapèze est 5 cm. Trouvez l'aire du trapèze.",
        "L'aire d'un trapèze se calcule en utilisant la formule : Aire = \\(1/2\\) * hauteur * \\(somme des longueurs des bases\\). Dans ce cas, la hauteur est de 5 cm, et la somme des longueurs des bases est AB + CD = 8 cm + 14 cm = 22 cm. Donc, l'aire du trapèze est \\(1/2\\) * 5 cm * 22 cm = 55 cm².",
        3,
        300,
        "Seconde",
        "40 cm²",
        "44 cm²",
        "48 cm²",
        "55 cm²"
    ),
    (
        "Calculez le volume d'un parallélépipède rectangle dont les dimensions sont : longueur = 6 cm, largeur = 4 cm et hauteur = 3 cm.",
        "Le volume d'un parallélépipède rectangle se calcule en utilisant la formule : Volume = longueur * largeur * hauteur. Dans ce cas, le volume est de 6 cm * 4 cm * 3 cm = 72 cm³.",
        3,
        300,
        "Seconde",
        "48 cm³",
        "36 cm³",
        "24 cm³",
        "72 cm³"
    ),
    (
        "Un cylindre a un rayon de base de 5 cm et une hauteur de 10 cm. Calculez son volume.",
        "Le volume d'un cylindre se calcule en utilisant la formule : Volume = π * rayon² * hauteur. Dans ce cas, le volume est π * \\(5 cm\\)² * 10 cm = 250π cm³ ≈ 785,4 cm³.",
        1,
        300,
        "Seconde",
        "750 cm³",
        "785,4 cm³",
        "800 cm³",
        "900 cm³"
    ),
    (
        "Trouvez la longueur de l'arête d'un cube dont le volume est de 64 cm³.",
        "La longueur de l'arête d'un cube peut être trouvée en utilisant la formule : Arête = ∛\\(Volume du cube\\). Dans ce cas, Arête = ∛\\(64 cm³\\) = 4 cm.",
        2,
        300,
        "Seconde",
        "2 cm",
        "3 cm",
        "4 cm",
        "5 cm"
    ),
     (
        "Démontrez que la somme des angles d'un triangle est égale à 180 degrés.",
        "Nous pouvons diviser un triangle en deux triangles plus petits en traçant une ligne à partir d'un sommet jusqu'au côté opposé. Cela crée deux triangles distincts à l'intérieur du triangle initial. Chacun de ces triangles a deux angles adjacents au sommet du triangle initial. Donc, la somme des angles intérieurs de ces deux triangles est égale à 180 degrés \\(2 angles droits\\).  Ainsi, la somme des angles intérieurs du triangle initial est également égale à 180 degrés.",
        3,
        600,
        "Seconde",
        "La somme des angles d'un triangle est toujours de 90 degrés.",
        "La somme des angles d'un triangle est toujours de 120 degrés.",
        "La somme des angles d'un triangle est toujours de 150 degrés.",
        "La somme des angles d'un triangle est toujours de 180 degrés."
    ),
     (
        "Démontrez que les angles opposés par le sommet sont égaux.",
        "Considérons un quadrilatère ABCD où les côtés AB et CD sont parallèles, et les côtés AD et BC se croisent en un point O. Si nous regardons les triangles ABO et CDO, ils partagent le même angle à la base, c'est-à-dire l'angle AOB est égal à l'angle COD. De plus, les angles opposés aux côtés parallèles AB et CD sont également égaux \\(angle ABO = angle COD\\).  De même, si nous examinons les triangles ACO et BDO, nous pouvons montrer que l'angle ACO est égal à l'angle BDO et que les angles opposés aux côtés parallèles AD et BC sont égaux \\(angle ACO = angle BDO\\).  Par conséquent, nous avons démontré que les angles opposés par le sommet dans le quadrilatère ABCD sont égaux.",
        1,
        600,
        "Seconde",
        "Les angles opposés par le sommet ne sont pas égaux.",
        "Les angles opposés par le sommet sont égaux dans tous les quadrilatères.",
        "Les angles opposés par le sommet sont égaux uniquement dans les triangles.",
        "Les angles opposés par le sommet sont égaux uniquement dans les rectangles."
    ),
    (
        "Démontrez que les angles alternes-internes sont égaux lorsque deux lignes sont coupées par une transversale.",
        "Lorsque deux lignes sont coupées par une transversale, des paires d'angles alternes-internes se forment. Pour démontrer qu'ils sont égaux, nous pouvons utiliser la propriété de la somme des angles sur une ligne droite. Si nous considérons les deux lignes parallèles coupées par une transversale, nous pouvons montrer que les angles alternes-internes sont des angles supplémentaires, ce qui signifie que leur somme est égale à 180 degrés. Donc, les angles alternes-internes sont égaux.",
        1,
        600,
        "Seconde",
        "Les angles alternes-internes ne sont pas égaux.",
        "Les angles alternes-internes sont toujours égaux à 90 degrés.",
        "Les angles alternes-internes sont toujours égaux à 360 degrés.",
        "Les angles alternes-internes sont toujours égaux à 45 degrés."
    ),
     (
        "Démontrez le théorème de Pythagore.",
        "Considérons un triangle rectangle ABC avec l'angle droit à C. Selon le théorème de Pythagore, la somme des carrés des longueurs des deux côtés plus courts \\(a et b\\) est égale au carré de la longueur de l'hypoténuse \\(c\\). Mathématiquement, cela peut être exprimé comme : a² + b² = c².  Pour le démontrer, nous pouvons construire un carré de côté \\(a + b\\) en ajoutant deux carrés de côtés a et b. Ensuite, nous pouvons construire un carré de côté c. En comparant les deux figures, nous constatons que l'aire du carré de côté \\(a + b\\) est égale à la somme des aires des deux carrés de côtés a et b, tandis que l'aire du carré de côté c est égale à l'aire du carré de côté \\(a + b\\) puisque ce sont des figures congruentes. Donc, nous pouvons écrire : a² + b² = c².",
        1,
        900,
        "Seconde",
        "Le théorème de Pythagore n'a pas besoin de démonstration.",
        "Le théorème de Pythagore est basé sur des calculs trigonométriques.",
        "Le théorème de Pythagore est utilisé uniquement pour les triangles équilatéraux.",
        "Le théorème de Pythagore ne s'applique qu'aux triangles rectangles."
    ),
     (
        "Démontrez comment calculer l'aire d'un cercle.",
        "L'aire d'un cercle peut être calculée en utilisant la formule A = πr², où A représente l'aire du cercle, π \\(pi\\) est une constante \\(environ égale à 3,14159\\), et r est le rayon du cercle.  Pour démontrer cette formule, nous pouvons diviser un cercle en un grand nombre de petits secteurs. Ensuite, nous pouvons réorganiser ces secteurs pour former une forme qui ressemble à un rectangle. En calculant l'aire de ce rectangle, nous pouvons montrer que l'aire du cercle est en effet égale à πr².",
        2,
        900,
        "Seconde",
        "L'aire d'un cercle se calcule en multipliant la circonférence par 2.",
        "L'aire d'un cercle se calcule en multipliant le diamètre par π.",
        "L'aire d'un cercle se calcule en multipliant la circonférence par la moitié du rayon.",
        "L'aire d'un cercle se calcule en multipliant le diamètre par 2."
    ),
     (
        "Démontrez les propriétés des parallélogrammes.",
        "Un parallélogramme est un quadrilatère dont les côtés opposés sont parallèles. Parmi ses propriétés, on peut citer :  1. Les côtés opposés d'un parallélogramme sont de même longueur. 2. Les angles opposés d'un parallélogramme sont de même mesure. 3. Les diagonales d'un parallélogramme se croisent en leur milieu. 4. Les angles adjacents dans un parallélogramme sont supplémentaires, c'est-à-dire que la somme de deux angles adjacents est égale à 180 degrés.  Ces propriétés peuvent être démontrées en utilisant des concepts de géométrie, notamment les angles alternes-internes et les angles correspondants.",
        1,
        900,
        "Seconde",
        "Les parallélogrammes n'ont pas de propriétés spéciales.",
        "Les côtés opposés d'un parallélogramme ont même longueurs.",
        "Les angles opposés d'un parallélogramme ont des mesures différentes.",
        "Les diagonales d'un parallélogramme sont perpendiculaires."
    ),

    (
        "Démontrez le théorème de Pythagore.",
        "Considérons un triangle rectangle ABC avec l'angle droit à C. Selon le théorème de Pythagore, la somme des carrés des longueurs des deux côtés plus courts \\(a et b\\) est égale au carré de la longueur de l'hypoténuse \\(c\\). Mathématiquement, cela peut être exprimé comme : a² + b² = c².  Pour le démontrer, nous pouvons construire un carré de côté \\(a + b\\) en ajoutant deux carrés de côtés a et b. Ensuite, nous pouvons construire un carré de côté c. En comparant les deux figures, nous constatons que l'aire du carré de côté \\(a + b\\) est égale à la somme des aires des deux carrés de côtés a et b, tandis que l'aire du carré de côté c est égale à l'aire du carré de côté \\(a + b\\) puisque ce sont des figures congruentes. Donc, nous pouvons écrire : a² + b² = c².",
        2,
        900,
        "Seconde",
        "Le théorème de Pythagore n'a pas besoin de démonstration.",
        "Le théorème de Pythagore est basé sur des calculs trigonométriques.",
        "Le théorème de Pythagore est utilisé uniquement pour les triangles équilatéraux.",
        "Le théorème de Pythagore ne s'applique qu'aux triangles rectangles."
    ),

    (
        "Démontrez comment calculer l'aire d'un cercle.",
        "L'aire d'un cercle peut être calculée en utilisant la formule A = πr², où A représente l'aire du cercle, π \\(pi\\) est une constante \\(environ égale à 3,14159\\), et r est le rayon du cercle.  Pour démontrer cette formule, nous pouvons diviser un cercle en un grand nombre de petits secteurs. Ensuite, nous pouvons réorganiser ces secteurs pour former une forme qui ressemble à un rectangle. En calculant l'aire de ce rectangle, nous pouvons montrer que l'aire du cercle est en effet égale à πr².",
        3,
        900,
        "Seconde",
        "L'aire d'un cercle se calcule en multipliant la circonférence par le rayon.",
        "L'aire d'un cercle se calcule en multipliant la circonférence par 2.",
        "L'aire d'un cercle se calcule en multipliant le diamètre par π.",
        "L'aire d'un cercle se calcule en multipliant le par π le rayon au carré ."
    ),

    (
        "Démontrez les propriétés des parallélogrammes.",
        "Un parallélogramme est un quadrilatère dont les côtés opposés sont parallèles. Parmi ses propriétés, on peut citer :  1. Les côtés opposés d'un parallélogramme sont de même longueur. 2. Les angles opposés d'un parallélogramme sont de même mesure. 3. Les diagonales d'un parallélogramme se croisent en leur milieu. 4. Les angles adjacents dans un parallélogramme sont supplémentaires, c'est-à-dire que la somme de deux angles adjacents est égale à 180 degrés.  Ces propriétés peuvent être démontrées en utilisant des concepts de géométrie, notamment les angles alternes-internes et les angles correspondants.",
        1,
        900,
        "Seconde",
        "Les parallélogrammes n'ont pas de propriétés spéciales.",
        "Les côtés opposés d'un parallélogramme ont des longueurs différentes.",
        "Les angles opposés d'un parallélogramme ont des mesures différentes.",
        "Les diagonales d'un parallélogramme sont perpendiculaires."
    ),
    (
        "Résolvez le système d'inéquations suivant :   1. x + y ≥ 5 2. 2x - y < 8",
        "Pour résoudre ce système d'inéquations, nous allons d'abord représenter graphiquement chaque inéquation sur un plan cartésien. Ensuite, nous identifierons la région où les deux inéquations se chevauchent, ce qui représente la solution du système.  Après avoir tracé les graphiques, nous trouvons que la région de chevauchement est un polygone délimité par les droites. La solution du système est l'ensemble des points à l'intérieur de ce polygone.",
        3,
        900,
        "Seconde",
        "x > 5 et y > 8",
        "x < 5 et y > 8",
        "x < 5 et y < 8",
        "x > 5 et y < 8"
    ),
     (
        "Calculez le discriminant de l'équation quadratique suivante : 3x² - 4x + 1 = 0",
        "Le discriminant \\(Δ\\) d'une équation quadratique de la forme ax² + bx + c = 0 est calculé à l'aide de la formule Δ = b² - 4ac. Dans ce cas, a = 3, b = -4, et c = 1. En substituant ces valeurs dans la formule, nous obtenons Δ = \\(-4\\)² - 4\\(3\\)\\(1\\) = 16 - 12 = 4.",
        1,
        900,
        "Seconde",
        "Δ = 7",
        "Δ = 4",
        "Δ = -4",
        "Δ = 12"
    ),
     (
        "Trouvez les solutions de l'équation quadratique suivante : 2x² - 5x - 3 = 0",
        "Pour trouver les solutions de cette équation quadratique, nous pouvons utiliser la formule quadratique : x = \\(-b ± √Δ\\) / \\(2a\\), où a = 2, b = -5 et Δ = 25 + 24 = 49.  En substituant ces valeurs dans la formule, nous obtenons : x₁ = \\(-\\(-5\\) + √49\\) / \\(2 * 2\\) = \\(5 + 7\\) / 4 = 3, et x₂ = \\(-\\(-5\\) - √49\\) / \\(2 * 2\\) = \\(5 - 7\\) / 4 = -1/2.",
        3,
        900,
        "Seconde",
        "x₁ = 2 et x₂ = -3",
        "x₁ = 5 et x₂ = 3",
        "x₁ = -1/2 et x₂ = 3",
        "x₁ = 3 et x₂ = -1/2"
    ),
    (
        "Résolvez le système d'inéquations suivant : \$ 1. \\(3x - 2y \\leq 12\\) ,  \\(x + 4y > 8\\) 3. \\(2x + 3y \\geq 6\\)\$",
        "Pour résoudre ce système d'inéquations, vous pouvez commencer par représenter graphiquement chaque inéquation sur un plan cartésien en utilisant des droites et des zones ombrées. Ensuite, trouvez la région où toutes les zones ombrées se chevauchent, ce qui représente la solution du système. N'oubliez pas de noter les signes d'égalité ou d'inégalité pour chaque inéquation.",
        3,
        900,
        "Seconde",
        "\$\\(x \\leq 2 \\text{ et } y \\geq 3\\)",
        "\$\\(x \\geq 2 \\text{ et } y \\leq 3\\)",
        "\$\\(x \\leq 2 \\text{ et } y \\leq 3\\)",
        "\$\\(x \\geq 2 \\text{ et } y \\geq 3\\)"
    ),
    (
        "Calculez le discriminant \$\\(\\(\\Delta\\)\\)\$ de l'équation quadratique : \\(2x^2 - 7x + 5 = 0\\)",
        "Le discriminant \$\\(\\(\\Delta\\)\\)\$ d'une équation quadratique de la forme \\(ax^2 + bx + c = 0\\) se calcule avec la formule \$\\(\\Delta = b^2 - 4ac\\)\$. Dans ce cas, \\(a = 2\\), \\(b = -7\\), et \\(c = 5\\). En substituant ces valeurs dans la formule, nous obtenons \$\\(\\Delta = \\(-7\\)^2 - 4\\(2\\)\\(5\\) = 49 - 40 = 9\\).\$",
        2,
        900,
        "Seconde",
        "\$\\(\\Delta = 12\\)\$",
        "\$\\(\\Delta = 15\\)\$",
         "\$\\(\\Delta = 9\\)\$",
        "\$\\(\\Delta = 7\\)\$"
    ),
    (
        "Trouvez les solutions de l'équation quadratique : \\(x^2 - 5x + 6 = 0\\)",
        "Pour trouver les solutions de cette équation quadratique, utilisez la formule quadratique : \$\\(x = \\frac{-b \\pm \\sqrt{\\Delta}}{2a}\\)\$, où \\(a = 1\\), \\(b = -5\\) et \$\\(\\Delta = 25 - 4\\(1\\)\\(6\\) = 1\\)\$. En substituant ces valeurs dans la formule, nous obtenons \$\\(x_1 = \\frac{-\\(-5\\) + \\sqrt{1}}{2\\(1\\)} = \\frac{5 + 1}{2} = 3\\)\$ et \$\\(x_2 = \\frac{-\\(-5\\) - \\sqrt{1}}{2\\(1\\)} = \\frac{5 - 1}{2} = 2\$\\).",
        2,
        900,
        "Seconde",
        "Les solutions sont \\(x_1 = 5\\) et \\(x_2 = 6\\)",
        "Les solutions sont \\(x_1 = 2\\) et \\(x_2 = -3\\)",
        "Les solutions sont \\(x_1 = 3\\) et \\(x_2 = 2\\)",
        "Les solutions sont \\(x_1 = 6\\) et \\(x_2 = 5\\)"
    ),
    (
        "Dans un cercle de rayon 5 cm, un angle inscrit mesure 45 degrés. Quel est l'angle au centre correspondant ?",
        "Lorsqu'un angle inscrit d'un cercle mesure \\(x\\) degrés, l'angle au centre correspondant mesure \\(2x\\) degrés. Dans ce cas, l'angle inscrit mesure 45 degrés, donc l'angle au centre correspondant mesure \\(2 \\cdot 45\\) degrés.",
        2,
        600,
        "Seconde",
        "45 degrés",
        "135 degrés",
        "90 degrés",
        "180 degrés"
    ),
     (
        "Calculez le volume d'un cylindre ayant une hauteur de 8 cm et un rayon de base de 4 cm. Arrondissez votre réponse à l'unité près.",
        "Le volume d'un cylindre se calcule avec la formule \$\\(V = \\pi r^2 h\\)\$, où \\(V\\) est le volume, \\(\\pi\\) est une constante \\(environ 3,14\\), \\(r\\) est le rayon de base et \\(h\\) est la hauteur. Dans ce cas, \\(r = 4\\) cm et \\(h = 8\\) cm. Utilisez ces valeurs pour calculer le volume.",
        1,
        600,
        "Seconde",
        "32 cm³",
        "402 cm³",
        "128 cm³",
        "64 cm³"
    ),
    
( " Quelle est la formule de discriminant  d'un polynome du second degré  ?",
        "discriminant = b² -4ac ",
        2,
        10,
        "Première",
        "b² -ac ",
        "b² + 4ac",
        "b² -4ac",
        "b -4ac"
        ),
         

( " Quel sont les deux racines de ce polynome p\\(x\\) = x² - 1 ",
        "-1 et 1 sont les racines ou les zeros de p\\(x\\)",
        0,
        60,
        "Première",
        "-1 et 1",
        "1 et 2",
        "1",
        "-1"),


(
        "sin²\\(x\\) + cos²\\(x\\) = ?",
        "sin²\\(x\\) + cos²\\(x\\) = 1",
        1,
        20,
        "Première",
        "1",
        "2",
        "-1",
        "-2"
),   

(
        "f et g sont deux fonctions, l'étude de signe de \\(f-g\\) est negatif:  Quel est la position relative de ces deux courbes Cg et Cf ?",
        "Cg est au dessus de Cf",
        0,
        30,
        "Première",
        "Cg est au dessus de Cf",
        "Cf et Cg se coupent en un point K\\(x,y\\)",
        "Cf est au dessus de Cg",
        "Je ne sais pas "
)

,
(
        "\\(+inf\\) + \\(-inf\\)",
        "forme indéterminéé",
        2,
        20,
        "Première",
        "-inf",
        "+inf",
        "indéterminéé",
        "je passe"
)   ,

(
        "Une asymptote vertical a géneralement pour equation",
        "x=a",
        3,
        20,
        "Première",
        "y = ax +b",
        "y = b",
        "x = ax",
        "x = a"
)

 ;

     """);



    await database.execute("""

    INSERT INTO quiztv (question, explication, correctAnswerIndex, times, classe, option1, option2)
        VALUES
         (
        "-5 appartient a l'ensemble N \\(-5 € N\\)",
        "-5 appartient á l'ensemble Z \\( les nombres entiers relatifs\\)",
        1,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
    ),
    
    (
        "lR* siginfie tous nombres réels privés de 0",
        "lR* siginfie tous nombres réels privés de 0",
        0,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
    ),

(
        "lR+ siginfie tous nombres réels negatifs",
        "lR+ siginfie tous nombres réels positifs",
        1,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
    )
    ,
       
   
  (
       "selon l'équation 2x+3=7 , x = 1",
        "selon l'équation 2x+3=7 , x= 2",
        1,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
    ),
(
       "6/2 est equivaut à 6 * 1/2",
        "6/2 est equivaut à 6 * 1/2",
        0,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
    ),
(
       "1/2 / 4/6     est équivaut à   1/2 * 6/4",
        "selon l'équation 2x+3=7 , x= 2",
        0,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
    ),

(
       "L'air  d'un disque se calcule par la formule A = π * r",
        "L'air  d'un disque se calcule par la formule A = π * r²",
        1,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
),


(
       "Le produit scalaire est la somme de deux vecteurs",
        "Le produit scalaire est le produit de deux vecteurs",
        1,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
),

(
       "deux vecteurs u et v sont colinéaire donc det\\(u,v\\)" = 1,
       "deux vecteurs u et v sont colinéaire donc det\\(u,v\\)" = 0,        
        1,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
    ),




(
       "X £ [a ; b] ==> a <= x <= b",
       "X £ [a ; b] ==> a <= x <= b",
        0,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
),



(
       "X £ ]a ; b] ==> a < x <= b",
       "X £ ]a ; b] ==> a < x <= b",
        0,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
),

(
       "X £ R ==> X £ ]-inf ; +inf[",
       "X £ R ==> X £ ]-inf ; +inf[",
        0,
        10,
        "Seconde",
        "VRAI",
        "FAUX"
)
,

(
        "f\\(x\\) = x³ est une fonction paire",
        "f\\(x\\) est impaire",
        1,
        20,
        "Première",
        "VRAI",
        "FAUX"
),

(
        " f\\(x\\) = x⁴ est une fonction paire",
        "f\\(x\\)=est paire",
        0,
        20,
        "Première",
        "VRAI",
        "FAUX"
),
(
        "soit R un réel ; inf/R = 0",
        "soit R un réel ; inf/R = inf",
        1,
        20,
        "Première",
        "VRAI",
        "FAUX"
),

(
        " soit f\\(x\\) = X³ + 2X² + 3;  df = lR",
        " soit f\\(x\\) = X³ + 2X² + 3;  df = lR",
        0,
        20,
        "Première",
        "VRAI",
        "FAUX"
),

(
        "les limites: -oo / -3 = -oo",
        "-oo / -3 = +oo  car la division de - et - donne + et infini / réel donne infini ",
        1,
        20,
        "Première",
        "VRAI",
        "FAUX"
),

(
        "les limites: +oo / -3 = +oo",
        "-oo / -3 = -oo   car la division produit de \\(- et +\\) donne - et  \\(infini / réel\\) donne infini",
        1,
        20,
        "Première",
        "VRAI",
        "FAUX"
),


(
        "Les limites: 3 / 0 = 0",
        "3 / 0 = +oo CAR  \\(réel / 0\\) donne infini",
        1,
        20,
        "Première",
        "VRAI",
        "FAUX"
),

(
        "Les limites: -33 / 0 = -oo",
        "-33 / 0 = -oo CAR  \\(réel / 0\\) donne infini",
        0,
        20,
        "Première",
        "VRAI",
        "FAUX"
),

(
        "Dérivé: f\\(x\\)=x² - 3, f'\\(x\\) = 2x",
        "Dérivé: f\\(x\\)=x² - 3, f'\\(x\\) = 2x",
        0,
        20,
        "Première",
        "VRAI",
        "FAUX"
),



(
        "Domaine de défintion: f\\(x\\) = racineCARRé\\(x - 1\\),  df = ]-oo , 1]",
        "df = [1 , +oo[",
        1,
        20,
        "Première",
        "VRAI",
        "FAUX"
),

(
        "Domaine de défintion: f\\(x\\) = racineCARRé\\(x - 1\\),  df = ]-oo , 1]",
        "df = [1 , +oo[",
        1,
        20,
        "Terminale",
        "VRAI",
        "FAUX"
),

(
        "Les limites: -33 / 0 = -oo",
        "-33 / 0 = -oo CAR  \\(réel / 0\\) donne infini",
        0,
        20,
        "Terminale",
        "VRAI",
        "FAUX"
),
(
        "soit R un réel ; inf/R = 0",
        "inf/R = inf",
        1,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
),


(
        "nombres complexe: i² = 1",
        "i² = -1",
        1,
        10,
         "Terminale",
        "VRAI",
        "FAUX"
),

(
        "Un nombre complexe est un nombre sous la forme ix + iy",
        "Un nombre complexe est un nombre sous la forme x + iy",
         1,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
),

(
        "soit z = a + ib et a est la partie imaginaire de z et b la partie réelle de z ",
        " a est la partie réelle de z et b la partie imaginaire de z ",
        1,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
),


(
        "f\\(x\\) = ln\\(x\\) df = lR",
        "df = ]0, +oo[",
        1,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
),

(
        "f\\(x\\) = ln\\(x\\) df = lR",
        "df = ]0, +oo[",
        1,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
),



(
        "f\\(x\\) = ln\\(x\\) f\\(e\\)=1",
        "f\\(x\\) = ln\\(x\\) f\\(e\\)=1",
        0,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
),


(
        "f\\(x\\) = ln\\(x\\) f\\(e\\)=1",
        "f\\(x\\) = ln\\(x\\) f\\(e\\)=1",
        0,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
),


(
        "f\\(x\\) = ln\\(x\\) f\\(e\\)=1",
        "f\\(x\\) = ln\\(x\\) f\\(e\\)=1",
        0,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
),

(
        "f\\(x\\) = ln\\(x\\) + 3 ; f\\(1\\)=0",
        "f\\(x\\) = ln\\(x\\) + 3 ; f\\(1\\)=3",
        1,
        10,
        "Terminale",
        "VRAI",
        "FAUX"
)

;
    """);
  }









}
