import 'package:books/UI/page/detail_screen.dart';
import 'package:books/UI/page/homepage.dart';
import 'package:books/UI/page/signinpage.dart';
import 'package:books/UI/page/signuppage.dart';
import 'package:books/UI/page/splash_page.dart';
import 'package:books/bloc/auth/auth_bloc.dart';
import 'package:books/bloc/books/books_bloc.dart';
import 'package:books/bloc/download/download_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DownloadBloc(),
        ),
        BlocProvider(
          create: (context) => BooksBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc()..add(AuthGetCurrent(context)),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const SplashScreen(),
          '/signin': (context) => const SignInPage(),
          '/home': (context) => const HomePage(),
          '/signup': (context) => const SignUpPage(),
          '/detail': (context) => const DetailScreen()
        },
      ),
    );
  }
}
