import 'package:flutter/material.dart';
import 'package:akla00001/abonnement/abonnement.page.dart';
void showSubscriptionDialog(BuildContext context,String str) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Abonnez-vous pour débloquer toutes les fonctionnalités',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
               Text(
                str,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Abonnement()),
                  );
                },
                child: const Text('S\'abonner'),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  // Ajoutez ici la logique pour fermer le conteneur de souscription.
                  Navigator.of(context).pop();
                },
                child: const Text('Plus tard'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
