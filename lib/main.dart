 import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instaface/Login/auth.dart';
import 'package:instaface/Login/image_picker.dart';
import 'package:instaface/firebase_options.dart';





// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserImagePicker(),
    );
  }
}




// class TextToSpeech extends StatefulWidget {
//   @override
//   _TextToSpeechState createState() => _TextToSpeechState();
// }

// class _TextToSpeechState extends State<TextToSpeech> {
//   final FlutterTts flutterTts = FlutterTts();
//   String _text = "hi my name is piyush";

//   Future _speak() async {
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setPitch(1.0);
//     await flutterTts.speak(_text);
//   }

//   // Future _stop() async {
//   //   await flutterTts.stop();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Text to Speech Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_text),
//             SizedBox(height: 20),
//             ElevatedButton(
//               child: Text('Speak'),
//               onPressed: () {
//                 _speak();
//               },
//             ),
//             // SizedBox(height: 20),
//             // ElevatedButton(
//             //   child: Text('Stop'),
//             //   onPressed: () {
//             //     _stop();
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }




















// class VideoSearchPage extends StatefulWidget {
//   @override
//   _VideoSearchPageState createState() => _VideoSearchPageState();
// }

// class _VideoSearchPageState extends State<VideoSearchPage> {
//   final String apiKey = 'Idn0OmGgh0YX2uIfUwswTOcGculNvTxfitIGFSQzbG7ANJGhcjDlVjmd';
//   final String baseUrl = 'https://api.pexels.com/videos/search';

//   String query = 'Nature'; 
//   String orientation = 'landscape'; // Change this as needed
//   String size = 'large'; // Change this as needed
//   String locale = 'en-US'; // Change this as needed
//   int page = 1;
//   int perPage = 15;

//   Future<Map<String, dynamic>> fetchVideos() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl?query=$query&orientation=$orientation&size=$size&locale=$locale&page=$page&per_page=$perPage'),
//       headers: {
//         'Authorization': apiKey,
//       },
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load videos');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pexels Video Search'),
//       ),
//       body: FutureBuilder(
//         future: fetchVideos(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             final videos = snapshot.data!['videos'];
//             // Process and display the videos as needed
//             return ListView.builder(
//               itemCount: videos.length,
//               itemBuilder: (context, index) {
//                 final video = videos[index];
//                 return ListTile(
//                   title: Text(video['url']),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
