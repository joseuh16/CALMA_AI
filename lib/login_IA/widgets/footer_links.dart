import 'package:flutter/material.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Olvide mi contraseña',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¿No tienes una cuenta?'),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  'register',
                );
              },
              child: const Text(
                'Crea una',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
