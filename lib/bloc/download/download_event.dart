part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadBook extends DownloadEvent {
  final String url;
  final String name;

  const DownloadBook({required this.url, required this.name});

  @override
  List<Object> get props => [url, name];
}
