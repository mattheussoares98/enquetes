import 'package:flutter/material.dart';

import '../components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LoginHeader(),
            const SizedBox(height: 30),
            const HeadLine1(text: "Login"),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "E-mail",
                        icon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Entrar".toUpperCase()),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text("Criar conta"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
