class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime birthDate;
  final String? birthTime;
  final String gender;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    this.birthTime,
    required this.gender,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'birthDate': birthDate.toIso8601String(),
        'birthTime': birthTime,
        'gender': gender,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        birthDate: DateTime.parse(json['birthDate'] as String),
        birthTime: json['birthTime'] as String?,
        gender: json['gender'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
