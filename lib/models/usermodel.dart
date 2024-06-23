class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  int? role;
  String? createdAt;
  String? updatedAt;
  String? token;
  String? tokenType;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.createdAt,
      required this.updatedAt,
      required this.token,
      required this.password,
      required this.tokenType});

  UserModel.fromjson(Map<String, dynamic> json) {
    id = json['user']['id'];
    name = json['user']['name'];
    email = json['user']['email'];
    password = json['user']['password'];
    role = json['user']['role']['id'];
    createdAt = json['user']['created_at'];
    updatedAt = json['user']['updated_at'];
    token = json['access_token'];
    tokenType = json['token_type'];
  }
}
