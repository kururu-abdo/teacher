class User {
  String id;

  /// id
  String name;
  String role; // أستاذ     طالب

  User(this.id, this.name, this.role);

  User.fromJson(Map<dynamic, dynamic> data) {
    this.id = data['id'].toString();
    this.name = data['name'];
    this.role = data['role'];
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': this.id.toString(),
      'name': this.name,
      'role': this.role,
    };
  }

  @override
  bool operator ==(other) {
    return (other is User) &&
        other.name == name &&
        other.id == id &&
        other.role == role;
  }
}
