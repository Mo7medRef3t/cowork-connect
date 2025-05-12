class UserModel {
  final String username;
  final String email;
  final String password;
  final String? photoPath;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    this.photoPath,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'photoPath': photoPath,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json['username'],
    email: json['email'],
    password: json['password'],
    photoPath: json['photoPath'],
  );
}
