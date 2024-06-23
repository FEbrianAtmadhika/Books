part of 'books_bloc.dart';

class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

class BooksInitial extends BooksState {}

class BooksLoading extends BooksState {}

class BooksFailed extends BooksState {
  final String e;

  const BooksFailed(this.e);

  @override
  List<Object> get props => [e];
}

class BooksSuccess extends BooksState {
  final List<BookModel> data;
  const BooksSuccess(this.data);

  @override
  List<Object> get props => [data];
}
