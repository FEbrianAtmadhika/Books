import 'package:books/models/booksmodel.dart';
import 'package:books/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GridviewMenu extends StatelessWidget {
  final BookModel data;
  const GridviewMenu({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: data.id);
      },
      child: Card(
        elevation: 3,
        surfaceTintColor: lightBackgroundColor,
        color: Colors.white,
        shadowColor: Colors.black,
        child:
            // Padding(
            // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            // child:
            Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Expanded(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(25)),
            //       color: lightBackgroundColor,
            //     ),
            //     child: Center(
            //         child: Image.network(
            //       // data.image!,
            //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmATmRyYShgj8BtaGe_wq_6iKus9E-APjY-w&s",
            //       fit: BoxFit.fill,
            //     )),
            //   ),
            // ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(
                  data.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              data.judul!,
              textAlign: TextAlign.center,
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
                fontFamily: "Roboto",
              ),
              maxLines: 2,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
    // );
  }
}
