import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:books/models/booksmodel.dart';
import 'package:books/service/booksservice.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc() : super(BooksInitial()) {
    on<BooksEvent>((event, emit) async {
      if (event is BooksGetAll) {
        try {
          emit(BooksInitial());
          List<BookModel> res = await BooksService().getAllBook();
          emit(BooksSuccess(res));
        } catch (e) {
          print(e.toString());
          emit(BooksFailed(e.toString()));
        }
      }
      if (event is BooksAdd) {
        try {
          emit(BooksInitial());
          List<BookModel> res = await BooksService()
              .addBooks(event.book, event.data, event.pdf, event.image);
          emit(BooksSuccess(res));
        } catch (e) {
          print(e.toString());
          emit(BooksFailed(e.toString()));
        }
      }
    });
  }
}
