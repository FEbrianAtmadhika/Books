part of 'books_bloc.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object> get props => [];
}

class BooksGetAll extends BooksEvent {}

class BooksUpdate extends BooksEvent {
  final BookModel data;
  final File pdf;
  final File image;
  final List<BookModel> book;

  const BooksUpdate(
      {required this.book,
      required this.data,
      required this.image,
      required this.pdf});

  @override
  List<Object> get props => [book, data, pdf, image];
}

class BooksAdd extends BooksEvent {
  final BookModel data;
  final File pdf;
  final File image;
  final List<BookModel> book;

  const BooksAdd(
      {required this.book,
      required this.data,
      required this.image,
      required this.pdf});

  @override
  List<Object> get props => [book, data, pdf, image];
}

class BooksDelete extends BooksEvent {
  final int id;
  final List<BookModel> book;

  const BooksDelete({required this.book, required this.id});

  @override
  List<Object> get props => [book, id];
}
