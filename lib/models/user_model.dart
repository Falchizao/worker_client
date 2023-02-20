class User {
  String username;
  String email;
  String password;

  User(this.email, this.username, this.password);

  // Map<String, dynamic> toMap() {
  //   return {
  //     'username': username,
  //     'email': email,
  //   };
  // }

  // factory User.fromMap(Map<String, dynamic> map) {
  //   return User(
  //     username: map['username'] ?? '',
  //     email: map['email'] ?? '',
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
