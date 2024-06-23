import 'package:books/bloc/auth/auth_bloc.dart';
import 'package:books/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) => Center(
          child: Image.asset('assets/icons/SplashScreen.png'),
        ),
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state is AuthInitial) {
            Future.delayed(
              const Duration(seconds: 1),
              () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
            );
          }
        },
      ),
    );
  }
}
