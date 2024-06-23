import 'package:books/service/booksservice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(DownloadInitial()) {
    on<DownloadEvent>((event, emit) async {
      if (event is DownloadBook) {
        try {
          emit(DownloadLoading());
          String res = await BooksService().downlaod(event.url, event.name);
          emit(DownloadSuccess(res));
        } catch (e) {
          print(e.toString());
          emit(DownloadFailed(e.toString()));
        }
      }
    });
  }
}
