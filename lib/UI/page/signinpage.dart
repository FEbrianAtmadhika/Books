import 'package:books/UI/widget/buttons.dart';
import 'package:books/UI/widget/forms.dart';
import 'package:books/bloc/auth/auth_bloc.dart';
import 'package:books/models/signinformmodel.dart';
import 'package:books/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is AuthFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.e),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ));
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Sign In To Library',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOTE: EMAIL INPUT
                        CustomFormField(
                          title: 'Email Address',
                          controller: emailController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // NOTE: PASSWORD INPUT
                        CustomFormField(
                          title: 'Password',
                          obscureText: true,
                          controller: passwordController,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot Password',
                            style: blueTextStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomFilledButton(
                          title: 'Sign In',
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  AuthLogin(SignInFormModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  )),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomTextButton(
                    title: 'Create New Account',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
