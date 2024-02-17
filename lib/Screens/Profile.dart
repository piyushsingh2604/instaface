import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = "";
  String bio = "";
  File? profileImage;

  @override
  void initState() {
    super.initState();
        loadSavedImagePaths();

    loadUserInfo();
  }

  // Load user information from SharedPreferences
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "";
      bio = prefs.getString('bio') ?? "";
    });
  }

  // Save user information to SharedPreferences
  Future<void> saveUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('bio', bio);
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });
      // Upload the image to Firebase Storage
      await uploadImageToFirebaseStorage();
    }
  }

  Future<void> uploadImageToFirebaseStorage() async {
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('profile_images/$username.jpg');

    final UploadTask uploadTask = storageRef.putFile(profileImage!);

    await uploadTask.whenComplete(() => null);
  }


   List<String?> imagePaths = [];
  late SharedPreferences sharedPreferences;
  FirebaseStorage _storage = FirebaseStorage.instance;


  Future<void> loadSavedImagePaths() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final savedImagePaths = sharedPreferences.getStringList('imagePaths');
    if (savedImagePaths != null) {
      setState(() {
        imagePaths = savedImagePaths.cast<String?>();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_box_outlined, color: Colors.black),
          ),
        ],
        title: Column(
          children: [
            Text(
              username,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CircleAvatar(
              maxRadius: 40,
              backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
              child: profileImage == null
                  ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10),
            child: Text(
              bio,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Username",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onChanged: (value) {
                                setState(() {
                                  username = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Bio",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onChanged: (value) {
                                setState(() {
                                  bio = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: ElevatedButton(
                              onPressed: 
                               pickImage,
                                
                              child: Text(
                                "Edit Photo",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(600, 43),
                                  backgroundColor: Colors.grey[300],
                                  elevation: 0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                await saveUserInfo();
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Save Changes",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(600, 43),
                                  backgroundColor: Colors.grey[300],
                                  elevation: 0),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(600, 43),
                  backgroundColor: Colors.grey[300],
                  elevation: 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 40),
            child: Icon(Icons.grid_view_rounded),
          ),
            Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                final imagePath = imagePaths[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0), // Add desired gap here
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageDetailScreen(imagePath: imagePath),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'image_$index',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[200],
                        ),
                        child: imagePath != null
                            ? Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              imagePickerOption();
            },
            icon: const Icon(Icons.add_a_photo_sharp),
            label: const Text('UPLOAD IMAGE'),
          ),
        ],
      ),
    );
  }

  void imagePickerOption() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Container(
              color: Colors.white,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Pick Image From",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImages(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text("CAMERA"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImages(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("GALLERY"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text("CANCEL"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> pickImages(ImageSource imageType) async {
    try {
      final picker = ImagePicker();
      final pickedImageFile = await picker.pickImage(source: imageType);

      if (pickedImageFile == null) return;

      final pickedImageTemp = File(pickedImageFile.path);
      final appDirectory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      await pickedImageTemp.copy(imagePath);

      setState(() {
        imagePaths.add(imagePath);
      });

      await uploadImageToFirebase(pickedImageTemp, imagePath);

      saveImagePaths();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> uploadImageToFirebase(File imageFile, String imagePath) async {
    try {
      Reference storageReference =
          _storage.ref().child('images/${imageFile.path.split('/').last}');
      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        setState(() {
          imagePaths[imagePaths.indexOf(imagePath)] = imageUrl;
        });
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> saveImagePaths() async {
    final nonNullableImagePaths =
        imagePaths.where((path) => path != null).cast<String>();
    await sharedPreferences.setStringList(
        'imagePaths', nonNullableImagePaths.toList());
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String? imagePath;

  const ImageDetailScreen({Key? key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          tag: 'image_${imagePath.hashCode}',
          child: Container(height: 580,
          width: 420,
            color: Colors.black,
            child: imagePath != null
                ? Image.network(
                    imagePath!,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image),
          ),
        ),
      ),
    );
  }
}







