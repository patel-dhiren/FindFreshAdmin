class UserData {
  final String id;
  final String contact;
  final int createdAt;
  final String email;
  final String name;
  final bool isActive;

  UserData({required this.id, required this.contact, required this.createdAt, required this.email, required this.name, required this.isActive});

  factory UserData.fromJson(Map<dynamic, dynamic> json) {
    return UserData(
      id: json['id'],
      contact: json['contact'],
      createdAt: json['createdAt'],
      email: json['email'] ?? '', // Use get method to handle null
      name: json['name'],
      isActive: json['isActive'],
    );
  }
}