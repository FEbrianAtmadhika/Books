part of 'download_bloc.dart';

class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => [];
}

class DownloadInitial extends DownloadState {}

class DownloadLoading extends DownloadState {}

class DownloadFailed extends DownloadState {
  final String e;

  const DownloadFailed(this.e);

  @override
  List<Object> get props => [e];
}

class DownloadSuccess extends DownloadState {
  final String path;

  const DownloadSuccess(this.path);

  @override
  List<Object> get props => [path];
}
