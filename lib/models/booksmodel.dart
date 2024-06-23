class BookModel {
  int? id;
  String? judul;
  String? image;
  String? pdf;
  String? author;
  String? isbn;
  int? page;
  int? user_id;
  String? status;

  BookModel(
      {required this.id,
      required this.judul,
      required this.image,
      required this.user_id,
      required this.author,
      required this.isbn,
      required this.page,
      required this.pdf,
      required this.status});

  BookModel.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    judul = json['title'];
    image = json['cover_image'];
    pdf = json['pdf'];
    author = json['author'];
    isbn = json['isbn'];
    page = json['page'];
    user_id = json['user_id'];
    status = json['status'];
  }
}
