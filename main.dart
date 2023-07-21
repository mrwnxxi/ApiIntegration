import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Integration',
      home: ApiIntegrationScreen(),
    );
  }
}

class User {
  int id;
  String name;
  String username;
  String email;
  String? profileImage;
  Address address;
  String? phone;
  String? website;
  Company? company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profileImage,
    required this.address,
    this.phone,
    this.website,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
      address: Address.fromJson(json['address']),
      phone: json['phone'],
      website: json['website'],
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
    );
  }
}

class Address {
  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
      geo: Geo.fromJson(json['geo']),
    );
  }
}

class Geo {
  String lat;
  String lng;

  Geo({
    required this.lat,
    required this.lng,
  });

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Company {
  String name;
  String catchPhrase;
  String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }
}

class ApiIntegrationScreen extends StatefulWidget {
  @override
  _ApiIntegrationScreenState createState() => _ApiIntegrationScreenState();
}

class _ApiIntegrationScreenState extends State<ApiIntegrationScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.38:3000/users'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        users = jsonData.map((userJson) => User.fromJson(userJson)).toList();
        setState(() {});
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: user.profileImage != null
                ? CircleAvatar(
              backgroundImage: NetworkImage(user.profileImage!),
            )
                : CircleAvatar(),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Text('Username: ${user.username}'),
          );
        },
      ),
    );
  }
}
