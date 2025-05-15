import 'dart:typed_data';

class UserModel {
  final String username;
  final String email;
  final Uint8List? profileImageBytes;
  final String? location;

  UserModel({
    required this.username,
    required this.email,
    this.profileImageBytes,
    this.location,
  });
} 