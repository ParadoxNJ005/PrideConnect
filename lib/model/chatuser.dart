class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String image;
  final String orientation;
  final String address;
  final String gender;
  final String coins;
  final List<String> ngos;
  final String phone;
  final List<String> interest;
  final List<String> workshops;
  final List<String> campaign;
  final List<String> orders;
  final String age;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.orientation,
    required this.address,
    required this.gender,
    required this.coins,
    required this.ngos,
    required this.phone,
    required this.interest,
    required this.workshops,
    required this.campaign,
    required this.orders,
    required this.age,
  });

  /// Convert Firestore JSON to ChatUser
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      orientation: json['orientation'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      coins: json['coins'] ?? '100',
      ngos: List<String>.from(json['ngos'] ?? []),
      phone: json['phone'] ?? '',
      interest: List<String>.from(json['interest'] ?? []),
      workshops: List<String>.from(json['workshops'] ?? []),
      campaign: List<String>.from(json['campaign'] ?? []),
      orders: List<String>.from(json['orders'] ?? []),
      age: json['age'] ?? '',
    );
  }

  /// Convert ChatUser to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
      'orientation': orientation,
      'address': address,
      'gender': gender,
      'coins': coins,
      'ngos': ngos,
      'phone': phone,
      'interest': interest,
      'workshops': workshops,
      'campaign': campaign,
      'orders': orders,
      'age': age,
    };
  }

  /// ✅ **New: `copyWith` method to update specific fields**
  ChatUser copyWith(Map<String, dynamic> updatedFields) {
    return ChatUser(
      uid: updatedFields['uid'] ?? uid,
      name: updatedFields['name'] ?? name,
      email: updatedFields['email'] ?? email,
      image: updatedFields['image'] ?? image,
      orientation: updatedFields['orientation'] ?? orientation,
      address: updatedFields['address'] ?? address,
      gender: updatedFields['gender'] ?? gender,
      coins: updatedFields['coins'] ?? coins,
      ngos: updatedFields['ngos'] != null ? List<String>.from(updatedFields['ngos']) : ngos,
      phone: updatedFields['phone'] ?? phone,
      interest: updatedFields['interest'] != null ? List<String>.from(updatedFields['interest']) : interest,
      workshops: updatedFields['workshops'] != null ? List<String>.from(updatedFields['workshops']) : workshops,
      campaign: updatedFields['campaign'] != null ? List<String>.from(updatedFields['campaign']) : campaign,
      orders: updatedFields['orders'] != null ? List<String>.from(updatedFields['orders']) : orders,
      age: updatedFields['age'] ?? age,
    );
  }
}
