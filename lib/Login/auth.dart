import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instaface/Login/image_picker.dart';
import 'package:instaface/Screens/home.dart';

// final _firebase = FirebaseAuth.instance;

// class Auth extends StatefulWidget {
//   const Auth({super.key});

//   @override
//   State<Auth> createState() => _AuthState();
// }

// class _AuthState extends State<Auth> {
//   final _form = GlobalKey<FormState>();

//   var _islogin = true;
//   var _enteredEmail = '';
//   var _enteredPassword = '';
//   var _enteredUsername = '';

//   File? _selectedImage;
//   var _isAuthenticating = false;

//   void _submit() async {
//     final isvalid = _form.currentState!.validate();
//     if (!isvalid || !_islogin && _selectedImage == null) {
//       return;
//     }

//     _form.currentState!.save();
//     try {
//       setState(() {
//         _isAuthenticating = true;
//       });
//       if (_islogin) {
//         final userCredentials = await _firebase.signInWithEmailAndPassword(
//             email: _enteredEmail, password: _enteredPassword);

//         // Add navigation here if login is successful
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) {
//               // Replace `YourNextScreen` with the screen you want to navigate to.
//               return home();
//             },
//           ),
//         );
//       } else {
//         final userCredentials = await _firebase.createUserWithEmailAndPassword(
//             email: _enteredEmail, password: _enteredPassword);

//         final storageRef = FirebaseStorage.instance
//             .ref()
//             .child('user_images')
//             .child('${userCredentials.user!.uid}.jpg');

//         await storageRef.putFile(_selectedImage!);
//         final imageUrl = await storageRef.getDownloadURL();
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userCredentials.user!.uid)
//             .set({
//           'username': _enteredUsername,
//           'email': _enteredEmail,
//           'image_url': imageUrl,
//         });

//         // Add navigation here if signup is successful
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) {
//               // Replace `YourNextScreen` with the screen you want to navigate to.
//               return home();
//             },
//           ),
//         );
//       }
//     } on FirebaseAuthException catch (error) {
//       if (error.code == 'email-already-in-use') {}
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error.message ?? 'Authentication failed')));
//       setState(() {
//         _isAuthenticating = false;
//       });
//     }
//   }

//   Color purpleColor = Color(0xFF8692f7);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Container(
//         height: 1000,
//         child: Stack(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: 250,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50)),
//                 color: purpleColor,
//               ),
//             ),
//             Positioned(
//               left: 60,
//               top: 25,
//               child: Container(
//                 width: 265,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(image: AssetImage('assets/instalogin.webp'),fit: BoxFit.cover)
//                 ),
//                 height: 170,
//               ),
//             ),
//             Positioned(
//               right: 32,
//               left: 32,
//               top: 180,
//               child: Container(
//                 width: 250,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.white,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Form(
//                         key: _form,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               _islogin ? 'Login' : 'Signup',
//                               style:
//                                   TextStyle(fontSize: 21, color: purpleColor),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             if (!_islogin)
//                               UserImagePicker(
//                                 onpickImage: (pickedImage) {
//                                   _selectedImage = pickedImage;
//                                 },
//                               ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             TextFormField(
//                               onSaved: (value) {
//                                 _enteredEmail = value!;
//                               },
//                               validator: (value) {
//                                 if (value == null ||
//                                     value.trim().isEmpty ||
//                                     !value.contains('@')) {
//                                   return 'Please Enter a valid email address.';
//                                 }
//                                 return null;
//                               },
//                               keyboardType: TextInputType.emailAddress,
//                               textCapitalization: TextCapitalization.none,
//                               autocorrect: false,
//                               decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.person),
//                                   labelText: "Email",
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(20))),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             if (!_islogin)
//                               TextFormField(
//                                 decoration: InputDecoration(
//                                     labelText: "Username",
//                                     border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(20))),
//                                 enableSuggestions: false,
//                                 validator: (value) {
//                                   if (value == null ||
//                                       value.isEmpty ||
//                                       value.trim().length < 4) {
//                                     return 'Please enter a valid username (at least 4 characters,)';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) {
//                                   _enteredUsername = value!;
//                                 },
//                               ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             TextFormField(
//                               onSaved: (value) {
//                                 _enteredPassword = value!;
//                               },
//                               validator: (value) {
//                                 if (value == null || value.trim().length < 6) {
//                                   return 'Password must be at least 6 characters long.';
//                                 }
//                                 return null;
//                               },
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.lock),
//                                   labelText: "password",
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(20))),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             if (_isAuthenticating) CircularProgressIndicator(),
//                             if (!_isAuthenticating)
//                               ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       shape: ContinuousRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(50)),
//                                       backgroundColor: purpleColor,
//                                       minimumSize: Size(400, 50)),
//                                   onPressed: _submit,
//                                   child: Text(_islogin ? 'LOGIN' : 'Signup')),
//                           ],
//                         )),
//                   ),
//                 ),
//               ),
//             ),
//             if (!_isAuthenticating)
//               Positioned(
//                 top: 680,
//                 left: 80,
//                 right: 70,
//                 child: TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _islogin = !_islogin;
//                       });
//                     },
//                     child: Text(
//                       _islogin
//                           ? 'create an account'
//                           : 'I alredy have an account',
//                       style: TextStyle(color: purpleColor),
//                     )),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class home extends StatefulWidget {
//   const home({super.key});

//   @override
//   State<home> createState() => _homeState();
// }

// class _homeState extends State<home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [Text("data")],
//       ),
//     );
//   }
// }

final _firebase = FirebaseAuth.instance;

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _form = GlobalKey<FormState>();

  var _islogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';

  File? _pickedImageFile;
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || (!_islogin && _pickedImageFile == null)) {
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_islogin) {
        final userCredentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);

        // Retrieve the user's data from Firestore
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .get();

        String username = userData['username'];
        String imageUrl = userData['image_url'];

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen(username: username, imageFile: imageUrl);
              //return Home(username: username, imageFile: imageUrl);
            },
          ),
        );
      } else {
        final userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_pickedImageFile!);
        final imageUrl = await storageRef.getDownloadURL();

        // Store the user's data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
                            return HomeScreen(username: _enteredUsername, imageFile: imageUrl);

              //return Home(username: _enteredUsername, imageFile: imageUrl);
            },
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // Handle the email already in use case
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Color purpleColor = Color(0xFF8692f7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        height: 1000,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                color: purpleColor,
              ),
            ),
            Positioned(
              left: 60,
              top: 25,
              child: Container(
                width: 265,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/instalogin.webp'),
                        fit: BoxFit.cover)),
                height: 170,
              ),
            ),
            Positioned(
              right: 32,
              left: 32,
              top: 180,
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _islogin ? 'Login' : 'Signup',
                              style:
                                  TextStyle(fontSize: 21, color: purpleColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (!_islogin)
                              UserImagePicker(
                                onpickImage: (pickedImage) {
                                  _pickedImageFile = pickedImage;
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 230,
                              child: ListView(
                                children: [
                                  TextFormField(
                                    onSaved: (value) {
                                      _enteredEmail = value!;
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          !value.contains('@')) {
                                        return 'Please Enter a valid email address.';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    textCapitalization: TextCapitalization.none,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: "Email",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (!_islogin)
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Username",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      enableSuggestions: false,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length < 4) {
                                          return 'Please enter a valid username (at least 4 characters,)';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredUsername = value!;
                                      },
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    onSaved: (value) {
                                      _enteredPassword = value!;
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 6) {
                                        return 'Password must be at least 6 characters long.';
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        labelText: "password",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                  ),
                                ],
                              ),
                            ),
                            // TextFormField(
                            //   onSaved: (value) {
                            //     _enteredEmail = value!;
                            //   },
                            //   validator: (value) {
                            //     if (value == null ||
                            //         value.trim().isEmpty ||
                            //         !value.contains('@')) {
                            //       return 'Please Enter a valid email address.';
                            //     }
                            //     return null;
                            //   },
                            //   keyboardType: TextInputType.emailAddress,
                            //   textCapitalization: TextCapitalization.none,
                            //   autocorrect: false,
                            //   decoration: InputDecoration(
                            //       prefixIcon: Icon(Icons.person),
                            //       labelText: "Email",
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(20))),
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // if (!_islogin)
                            //   TextFormField(
                            //     decoration: InputDecoration(
                            //         labelText: "Username",
                            //         border: OutlineInputBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(20))),
                            //     enableSuggestions: false,
                            //     validator: (value) {
                            //       if (value == null ||
                            //           value.isEmpty ||
                            //           value.trim().length < 4) {
                            //         return 'Please enter a valid username (at least 4 characters,)';
                            //       }
                            //       return null;
                            //     },
                            //     onSaved: (value) {
                            //       _enteredUsername = value!;
                            //     },
                            //   ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // TextFormField(
                            //   onSaved: (value) {
                            //     _enteredPassword = value!;
                            //   },
                            //   validator: (value) {
                            //     if (value == null || value.trim().length < 6) {
                            //       return 'Password must be at least 6 characters long.';
                            //     }
                            //     return null;
                            //   },
                            //   obscureText: true,
                            //   decoration: InputDecoration(
                            //       prefixIcon: Icon(Icons.lock),
                            //       labelText: "password",
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(20))),
                            // ),
                            SizedBox(
                              height: 30,
                            ),
                            if (_isAuthenticating) CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      backgroundColor: purpleColor,
                                      minimumSize: Size(400, 50)),
                                  onPressed: _submit,
                                  child: Text(_islogin ? 'LOGIN' : 'Signup')),
                          ],
                        )),
                  ),
                ),
              ),
            ),
            if (!_isAuthenticating)
              Positioned(
                top: 680,
                left: 80,
                right: 70,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _islogin = !_islogin;
                      });
                    },
                    child: Text(
                      _islogin
                          ? 'create an account'
                          : 'I alredy have an account',
                      style: TextStyle(color: purpleColor),
                    )),
              )
          ],
        ),
      ),
    );
  }
}
