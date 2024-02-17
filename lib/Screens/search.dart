import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class UserCountScreen extends StatefulWidget {
  @override
  _UserCountScreenState createState() => _UserCountScreenState();
}

class _UserCountScreenState extends State<UserCountScreen> {
  int userCount = 0;

  @override
  void initState() {
    super.initState();
    // Fetch the user count from Firebase Cloud Function
    fetchUserCount();
  }

  Future<void> fetchUserCount() async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getUserCount');
      final result = await callable.call();
      final data = result.data as Map<String, dynamic>;
      final count = data['userCount'] as int;
      setState(() {
        userCount = count;
      });
    } catch (error) {
      print('Error fetching user count: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Count'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total Users: $userCount',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
