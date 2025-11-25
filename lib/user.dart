class User {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String regDate;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.regDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'].toString(),
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      regDate: json['reg_date'],
    );
  }
}
