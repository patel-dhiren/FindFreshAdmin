import 'package:flutter/material.dart';
import '../../gen/assets.gen.dart';
import 'components/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
              ),
              SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LoginForm(),
                  )
              )
            ],
          )
      ),
    );
  }
}
