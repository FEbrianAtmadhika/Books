import 'package:books/bloc/books/books_bloc.dart';
import 'package:books/bloc/download/download_bloc.dart';
import 'package:books/models/booksmodel.dart';
import 'package:books/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int id = int.parse(ModalRoute.of(context)!.settings.arguments.toString());
    var mediaquery = MediaQuery.of(context);
    return Scaffold(
        body: SingleChildScrollView(
            child: BlocConsumer<BooksBloc, BooksState>(
      builder: (context, state) {
        if (state is BooksSuccess) {
          BookModel book = state.data.firstWhere((element) => element.id == id);
          return Container(
              height: mediaquery.size.height,
              width: mediaquery.size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 30,
                              )),
                          Text(
                            // book.judul!,
                            "Detail",
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Center(
                                      child: Image.network(
                                        book.image!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  book.judul!,
                                  style: blackTextStyle.copyWith(
                                    fontSize: 24,
                                    fontWeight: bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Author",
                                style: blackTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: semiBold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                // book.author!,
                                "Febrian Athmadika",
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: medium,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Halaman",
                                style: blackTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: semiBold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                book.page.toString(),
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //     border: Border.all(width: 2),
                          //     color: Colors.black,
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(15),
                          //     child: Center(
                          //       child: Image.network(
                          //         book.image!,
                          //         fit: BoxFit.cover,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          // Container(
                          //   height: 200,
                          //   padding:
                          //       const EdgeInsets.symmetric(vertical: 10),
                          //   child: Column(
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.spaceAround,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Container(
                          //           width: mediaquery.size.width * 0.4,
                          //           padding: const EdgeInsets.symmetric(
                          //               vertical: 5, horizontal: 10),
                          //           decoration: BoxDecoration(
                          //               borderRadius:
                          //                   const BorderRadius.all(
                          //                       Radius.circular(10)),
                          //               border: Border.all(width: 1)),
                          //           child: Text(
                          //             book.judul!,
                          //             style: blackTextStyle,
                          //           )),
                          //       Container(
                          //           width: mediaquery.size.width * 0.4,
                          //           padding: const EdgeInsets.symmetric(
                          //               vertical: 5, horizontal: 10),
                          //           decoration: BoxDecoration(
                          //               borderRadius:
                          //                   const BorderRadius.all(
                          //                       Radius.circular(10)),
                          //               border: Border.all(width: 1)),
                          //           child: Text(
                          //             '${book.page} Halaman',
                          //             style: blackTextStyle,
                          //           )),
                          //       Container(
                          //           width: mediaquery.size.width * 0.4,
                          //           padding: const EdgeInsets.symmetric(
                          //               vertical: 5, horizontal: 10),
                          //           decoration: BoxDecoration(
                          //               borderRadius:
                          //                   const BorderRadius.all(
                          //                       Radius.circular(10)),
                          //               border: Border.all(width: 1)),
                          //           child: Text(
                          //             book.author!,
                          //             style: blackTextStyle,
                          //           )),
                          //     ],
                          //   ),
                          // )
                          //   ],
                          // ),

                          BlocConsumer<DownloadBloc, DownloadState>(
                            listener: (context, state) async {
                              if (state is DownloadLoading) {
                                const Scaffold(
                                  body: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is DownloadFailed) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                              if (state is DownloadSuccess) {
                                await OpenFile.open(state.path);
                              }
                            },
                            builder: (context, state) {
                              if (state is DownloadLoading) {
                                return GestureDetector(
                                  onTap: () async {
                                    context.read<DownloadBloc>().add(
                                        DownloadBook(
                                            url: book.pdf!, name: book.judul!));
                                  },
                                  child: Container(
                                    width: mediaquery.size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 25.0),
                                    decoration: BoxDecoration(
                                      color: purpleColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: whiteColor,
                                    )),
                                  ),
                                );
                              }
                              return GestureDetector(
                                onTap: () async {
                                  context.read<DownloadBloc>().add(DownloadBook(
                                      url: book.pdf!, name: book.judul!));
                                },
                                child: Container(
                                  width: mediaquery.size.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 25.0),
                                  decoration: BoxDecoration(
                                    color: purpleColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Download PDF',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        }
        return const Scaffold(
          body: Center(
            child: Text("error"),
          ),
        );
      },
      listener: (BuildContext context, BooksState state) {},
    )));
  }
}
