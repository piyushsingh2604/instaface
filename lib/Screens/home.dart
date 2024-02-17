import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaface/Screens/Profile.dart';
import 'package:instaface/Screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String imageFile;

  HomeScreen({required this.username, required this.imageFile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();

  Future<void> _uploadImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
    final UploadTask uploadTask =
        storageReference.putFile(File(pickedImage.path));

    await uploadTask.whenComplete(() async {
      final imageUrl = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance.collection('photos').add({
        'url': imageUrl,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              icon: Icon(Icons.person, color: Colors.black)),
      
          IconButton(

              onPressed: _uploadImage,
              icon: Icon(Icons.camera_alt_outlined, color: Colors.black)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()));
              },
              icon: Icon(Icons.message_outlined, color: Colors.black))
        ],
        title: Text(
          "Instaface",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 30),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: widget.imageFile.isNotEmpty
                  ? NetworkImage(widget.imageFile)
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, top: 5),
            child: Text(
              ' ${widget.username}',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Divider(
            color: Colors.black12,
            thickness: 1,
          ),
          SizedBox(
            height: 30,
          ),
          PhotoList(),
        ],
      ),
    );
  }
}




class PhotoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('photos').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final photos = snapshot.data!.docs;

        return Expanded(
          child: ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              final imageUrl = photo['url'] as String;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child:
                      CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                ),
              );
            },
          ),
        );
      },
    );
  }
}





// rules_version = '2';

// service cloud.firestore {
//   match /databases/{database}/documents {
//     match /{document=**} {
//       allow read, write;
//     }
//   }
// }







