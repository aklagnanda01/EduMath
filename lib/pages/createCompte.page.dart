import 'package:flutter/material.dart';
import 'package:akla00001/dataBase/sqfliteBase.dart';
import 'package:akla00001/pages/accueil.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedClass = 'Terminale'; // Classe par défaut

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final List<String> _classOptions = ['Terminale', 'Première', 'Seconde'];
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size ;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Page de Connexion')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height*.02,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  _buildTextFieldWithIcon(
                    controller: _firstNameController,
                    labelText: 'Nom',
                    icon: Icons.person,
                  ),
                  _buildTextFieldWithIcon(
                    controller: _lastNameController,
                    labelText: 'Prénom',
                    icon: Icons.person,
                  ),
                  _buildTextFieldWithIcon(
                    controller: _phoneNumberController,
                    labelText: 'Numéro de téléphone',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    alignment: Alignment.centerRight,

                    value: _selectedClass,
                    onChanged: (value) {
                      setState(() {
                        _selectedClass = value!;
                      });
                    },
                    items: _classOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                        alignment: Alignment.centerRight,

                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Classe',
                     // border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                      constraints: BoxConstraints( maxWidth: 400),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
      
      bottomSheet:Row(
        children: [
          Expanded(
            child: Container(
              height: size.height*0.1,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton(

                onPressed: () async {
                  String firstName = _firstNameController.text;
                  String lastName = _lastNameController.text;
                  String phoneNumber = _phoneNumberController.text;
                  String selectedClass = _selectedClass;
                  if (firstName.length >= 3 &&
                      lastName.length >= 3 &&
                      phoneNumber.length >= 8) {
                    await SQLDB.createUser(
                        firstName.toString(),
                        lastName.toString(),
                        phoneNumber.toString(),
                        selectedClass.toString());
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Accueil()));
                  } else {
                    setState(() {
                      _errorText = "Erreur détectée : vérifier vos entrées";
                    });
                  }
                  // Ici, vous pouvez gérer les actions à effectuer avec les données entrées par l'utilisateur
                },
             child:  Text('Se Connecter'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black87,fontSize: 23,),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
         // labelText: labelText,
          hintText: labelText,
          hintStyle: const TextStyle(fontSize: 16),
          border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10,) ,),
          ),
          errorText: _errorText,
          icon: Icon(icon ,color: Theme.of(context).primaryColor , size:25 ),
        ),
      ),
    );
  }
}
