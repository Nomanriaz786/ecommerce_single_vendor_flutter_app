import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/util/formatters/formatters.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  late final List<String> roles;
  late final String email;
  final String userName;
  String phoneNumber;
  String profilePicture;

  /// -Constructor for user model
  UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.roles,
    required this.profilePicture,
  });

  /// - Function to get Full Name
  String get fullName => '$firstName $lastName';

  /// - Helper function to format the phone number
  String get formattedPhoneNo => EFormatters.formatPhoneNumber(phoneNumber);

  /// - Static function to split full name into first and last name
  static List<String> nameParts(fullName) => fullName.split(' ');

  /// - Static function to generate username from full name
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = camelCaseUsername;
    return usernameWithPrefix;
  }

  /// - Static function to create empty user model
  static UserModel empty() => UserModel(
      id: '',
      email: '',
      phoneNumber: '',
      firstName: '',
      lastName: '',
      userName: '',
      roles: [],
      profilePicture: '');

  /// - Convert model to Json to store data in firebase
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Roles': roles,
    };
  }

  /// - Factory method to create UserModel from Firebase Document Snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        userName: data['Username'] ?? '',
        roles: List<String>.from(data['Roles'] ?? []),
        profilePicture: data['ProfilePicture'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}
