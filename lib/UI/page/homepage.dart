import 'package:books/UI/widget/gridviewbookmenu.dart';
import 'package:books/bloc/auth/auth_bloc.dart';
import 'package:books/bloc/books/books_bloc.dart';
import 'package:books/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void didChangeDependencies() {
    context.read<BooksBloc>().add(BooksGetAll());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
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
        if (state is AuthInitial) {
          Navigator.pushReplacementNamed(context, '/signin');
        }
      },
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Scaffold(
            key: _scaffoldKey,
            body: Container(
              height: mediaquery.size.height,
              width: mediaquery.size.width,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                state.data.name!,
                                style: blackTextStyle.copyWith(
                                  fontWeight: semiBold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(AuthLogout());
                                  },
                                  icon: const Icon(
                                    Icons.logout_sharp,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: BlocConsumer<BooksBloc, BooksState>(
                      listener: (context, state) {
                        if (state is BooksFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(state.e),
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          ));
                        }
                      },
                      builder: (context, state) {
                        if (state is BooksSuccess) {
                          return GridView.builder(
                            itemCount: state.data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              mainAxisExtent:
                                  MediaQuery.of(context).size.height / 2.5,
                            ),
                            itemBuilder: (context, index) {
                              return Builder(builder: (context) {
                                return GridviewMenu(
                                  data: state.data[index],
                                );
                              });
                            },
                          );
                        }
                        if (state is BooksLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return const Center(
                          child: Text("default"),
                        );
                      },
                    ))
                  ]),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text('Error'),
          ),
        );
      },
    );
  }
}
