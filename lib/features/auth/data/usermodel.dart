class Usermodel {
  final String id;
  final String username;
  final String email;

  Usermodel({required this.id, required this.username, required this.email});

  Map<String, dynamic> toJson() {
    return {"id": id, "username": username, "email": email};
  }
}
