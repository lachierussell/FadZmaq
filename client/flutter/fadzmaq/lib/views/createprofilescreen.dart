// Unused

// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:math';
// import 'package:image/image.dart' as Im;
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:uuid/uuid.dart';

// class CreateProfileScreen extends StatefulWidget {
//   @override
//   _CreateProfileScreenState createState() => _CreateProfileScreenState();
// }

// class _CreateProfileScreenState extends State<CreateProfileScreen> {

//   File _image1;
//   // File _image2;
//   // File _image3;

//   String imgurl;

//   final FirebaseStorage storage = new FirebaseStorage(storageBucket: 'gs://fadzmaq1.appspot.com/');

//   String dropdownValue = 'One';
//   String _dropdownValue = 'One';

//   String discoverdropdownValue = 'One';
//   String _discoverdropdownValue = 'One';

//   Future getImage1() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       final Directory tempDir = Directory.systemTemp;
//       final path = tempDir.path;
//       int rand = new Random().nextInt(10000);
//       Im.Image newimage = Im.decodeImage(image.readAsBytesSync());
//       newimage = Im.copyResizeCropSquare(newimage, 1080);
//       var newim1 = new File('$path/img_$rand.jpg')
//         ..writeAsBytesSync(Im.encodeJpg(newimage, quality: 52));


//       setState(() {
//         _image1 = newim1;
//       });

//       _uploadFile();
//     }
//   }

//   Future<Null> _uploadFile() async {

//     String fileName = "${Uuid().v1()}";
//     final StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//     StorageUploadTask uploadTask = reference.putFile(_image1);
//     StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//     final String url = (await taskSnapshot.ref.getDownloadURL());
//     print('URL Is $url');

//     setState(() {
//       imgurl = url;
//     });

//   }

//   // Future getImage2() async {
//   //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);

//   //   if (image != null) {
//   //     final Directory tempDir = Directory.systemTemp;
//   //     final path = tempDir.path;
//   //     int rand = new Random().nextInt(10000);
//   //     Im.Image newimage = Im.decodeImage(image.readAsBytesSync());
//   //     newimage = Im.copyResizeCropSquare(newimage, 1080);
//   //     var newim2 = new File('$path/img_$rand.jpg')
//   //       ..writeAsBytesSync(Im.encodeJpg(newimage, quality: 52));


//   //     setState(() {
//   //       _image2 = newim2;
//   //     });
//   //   }
//   // }

//   // Future getImage3() async {
//   //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);

//   //   if (image != null) {
//   //     final Directory tempDir = Directory.systemTemp;
//   //     final path = tempDir.path;
//   //     int rand = new Random().nextInt(10000);
//   //     Im.Image newimage = Im.decodeImage(image.readAsBytesSync());
//   //     newimage = Im.copyResizeCropSquare(newimage, 1080);
//   //     var newim3 = new File('$path/img_$rand.jpg')
//   //       ..writeAsBytesSync(Im.encodeJpg(newimage, quality: 52));


//   //     setState(() {
//   //       _image3 = newim3;
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Create Profile"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (_image1 != null 
//           // && _image3 != null 
//           // && _image3 != null 
//           && dropdownValue != 'One' 
//           && _dropdownValue != 'One' 
//           && discoverdropdownValue != 'One' 
//           && _discoverdropdownValue != 'One') {
//             Navigator.pushReplacementNamed(context, "/login");
//           }
//         },
//         child: Icon(Icons.navigate_next),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: ListView(
//           padding: EdgeInsets.all(26.0),
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 RaisedButton(
//                   child: _image1 == null
//                     ? Text('No image selected.')
//                     : Image.file(_image1),
//                   onPressed: getImage1,
//                 ),
//                 Padding(padding: EdgeInsets.only(top: 13.0),),
//                 // RaisedButton(
//                 //   child: _image2 == null
//                 //     ? Text('No image selected.')
//                 //     : Image.file(_image2),
//                 //   onPressed: getImage2,
//                 // ),
//                 // Padding(padding: EdgeInsets.only(top: 13.0),),
//                 // RaisedButton(
//                 //   child: _image3 == null
//                 //     ? Text('No image selected.')
//                 //     : Image.file(_image3),
//                 //   onPressed: getImage3,
//                 // ),
//                 Padding(padding: EdgeInsets.only(top: 13.0),),

//                 Text("Select two hoppies you like"),
//                 DropdownButton<String>(
//                   value: dropdownValue,
//                   icon: Icon(Icons.arrow_downward),
//                   iconSize: 24,
//                   elevation: 16,
//                   style: TextStyle(
//                     color: Colors.deepPurple
//                   ),
//                   underline: Container(
//                     height: 2,
//                     color: Colors.deepPurpleAccent,
//                   ),
//                   onChanged: (String newValue) {
//                     setState(() {
//                       dropdownValue = newValue;
//                     });
//                   },
//                   items: <String>['One','3D printing','amateur radio','scrapbook','Amateur radio','Acting','Baton twirling','Board games','Book restoration','Cabaret','Calligraphy','Candle making','Computer programming','Coffee roasting','Cooking','Coloring','Cosplaying','Couponing','Creative writing','Crocheting','Cryptography','Dance','Digital arts','Drama','Drawing','Do it yourself','Electronics','Embroidery','Fashion','Flower arranging','Foreign language learning','Gaming','tabletop games','role-playing games','Gambling','Genealogy','Glassblowing','Gunsmithing','Homebrewing','Ice skating','Jewelry making','Jigsaw puzzles','Juggling','Knapping','Knitting','Kabaddi','Knife making','Lacemaking','Lapidary','Leather crafting','Lego building','Lockpicking','Machining','Macrame','Metalworking','Magic','Model building','Listening to music','Origami','Painting','Playing musical instruments','Pet','Poi','Pottery','Puzzles','Quilting','Reading','Scrapbooking','Sculpting','Sewing','Singing','Sketching','Soapmaking','Sports','Stand-up comedy','Sudoku','Table tennis','Taxidermy','Video gaming','Watching movies','Web surfing','Whittling','Wood carving','Woodworking','Worldbuilding','Writing','Yoga','Yo-yoing','Air sports','Archery','Astronomy','Backpacking','BASE jumping','Baseball','Basketball','Beekeeping','Bird watching','Blacksmithing','Board sports','Bodybuilding','Brazilian jiu-jitsu','Community','Cycling','Dowsing','Driving','Fishing','Flag Football','Flying','Flying disc','Foraging','Gardening','Geocaching','Ghost hunting','Graffiti','Handball','Hiking','Hooping','Horseback riding','Hunting','Inline skating','Jogging','Kayaking','Kite flying','Kitesurfing','LARPing','Letterboxing','Metal detecting','Motor sports','Mountain biking','Mountaineering','Mushroom hunting','Mycology','Netball','Nordic skating','Orienteering','Paintball','Parkour','Photography','Polo','Rafting','Rappelling','Rock climbing','Roller skating','Rugby','Running','Sailing','Sand art','Scouting','Scuba diving','Sculling','Rowing','Shooting','Shopping','Skateboarding','Skiing','Skimboarding','Skydiving','Slacklining','Snowboarding','Stone skipping','Surfing','Swimming','Taekwondo','Tai chi','Urban exploration','Vacation','Vehicle restoration','Water sports']
//                     .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     })
//                     .toList(),
//                 ),

//                 DropdownButton<String>(
//                   value: _dropdownValue,
//                   icon: Icon(Icons.arrow_downward),
//                   iconSize: 24,
//                   elevation: 16,
//                   style: TextStyle(
//                     color: Colors.deepPurple
//                   ),
//                   underline: Container(
//                     height: 2,
//                     color: Colors.deepPurpleAccent,
//                   ),
//                   onChanged: (String newValue) {
//                     setState(() {
//                       _dropdownValue = newValue;
//                     });
//                   },
//                   items: <String>['One','3D printing','amateur radio','scrapbook','Amateur radio','Acting','Baton twirling','Board games','Book restoration','Cabaret','Calligraphy','Candle making','Computer programming','Coffee roasting','Cooking','Coloring','Cosplaying','Couponing','Creative writing','Crocheting','Cryptography','Dance','Digital arts','Drama','Drawing','Do it yourself','Electronics','Embroidery','Fashion','Flower arranging','Foreign language learning','Gaming','tabletop games','role-playing games','Gambling','Genealogy','Glassblowing','Gunsmithing','Homebrewing','Ice skating','Jewelry making','Jigsaw puzzles','Juggling','Knapping','Knitting','Kabaddi','Knife making','Lacemaking','Lapidary','Leather crafting','Lego building','Lockpicking','Machining','Macrame','Metalworking','Magic','Model building','Listening to music','Origami','Painting','Playing musical instruments','Pet','Poi','Pottery','Puzzles','Quilting','Reading','Scrapbooking','Sculpting','Sewing','Singing','Sketching','Soapmaking','Sports','Stand-up comedy','Sudoku','Table tennis','Taxidermy','Video gaming','Watching movies','Web surfing','Whittling','Wood carving','Woodworking','Worldbuilding','Writing','Yoga','Yo-yoing','Air sports','Archery','Astronomy','Backpacking','BASE jumping','Baseball','Basketball','Beekeeping','Bird watching','Blacksmithing','Board sports','Bodybuilding','Brazilian jiu-jitsu','Community','Cycling','Dowsing','Driving','Fishing','Flag Football','Flying','Flying disc','Foraging','Gardening','Geocaching','Ghost hunting','Graffiti','Handball','Hiking','Hooping','Horseback riding','Hunting','Inline skating','Jogging','Kayaking','Kite flying','Kitesurfing','LARPing','Letterboxing','Metal detecting','Motor sports','Mountain biking','Mountaineering','Mushroom hunting','Mycology','Netball','Nordic skating','Orienteering','Paintball','Parkour','Photography','Polo','Rafting','Rappelling','Rock climbing','Roller skating','Rugby','Running','Sailing','Sand art','Scouting','Scuba diving','Sculling','Rowing','Shooting','Shopping','Skateboarding','Skiing','Skimboarding','Skydiving','Slacklining','Snowboarding','Stone skipping','Surfing','Swimming','Taekwondo','Tai chi','Urban exploration','Vacation','Vehicle restoration','Water sports']
//                     .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     })
//                     .toList(),
//                 ),

//                 Padding(padding: EdgeInsets.only(top: 26.0),),
//                 Text("Select two hoppies you want to discover"),
//                 DropdownButton<String>(
//                   value: discoverdropdownValue,
//                   icon: Icon(Icons.arrow_downward),
//                   iconSize: 24,
//                   elevation: 16,
//                   style: TextStyle(
//                     color: Colors.deepPurple
//                   ),
//                   underline: Container(
//                     height: 2,
//                     color: Colors.deepPurpleAccent,
//                   ),
//                   onChanged: (String newValue) {
//                     setState(() {
//                       discoverdropdownValue = newValue;
//                     });
//                   },
//                   items: <String>['One','3D printing','amateur radio','scrapbook','Amateur radio','Acting','Baton twirling','Board games','Book restoration','Cabaret','Calligraphy','Candle making','Computer programming','Coffee roasting','Cooking','Coloring','Cosplaying','Couponing','Creative writing','Crocheting','Cryptography','Dance','Digital arts','Drama','Drawing','Do it yourself','Electronics','Embroidery','Fashion','Flower arranging','Foreign language learning','Gaming','tabletop games','role-playing games','Gambling','Genealogy','Glassblowing','Gunsmithing','Homebrewing','Ice skating','Jewelry making','Jigsaw puzzles','Juggling','Knapping','Knitting','Kabaddi','Knife making','Lacemaking','Lapidary','Leather crafting','Lego building','Lockpicking','Machining','Macrame','Metalworking','Magic','Model building','Listening to music','Origami','Painting','Playing musical instruments','Pet','Poi','Pottery','Puzzles','Quilting','Reading','Scrapbooking','Sculpting','Sewing','Singing','Sketching','Soapmaking','Sports','Stand-up comedy','Sudoku','Table tennis','Taxidermy','Video gaming','Watching movies','Web surfing','Whittling','Wood carving','Woodworking','Worldbuilding','Writing','Yoga','Yo-yoing','Air sports','Archery','Astronomy','Backpacking','BASE jumping','Baseball','Basketball','Beekeeping','Bird watching','Blacksmithing','Board sports','Bodybuilding','Brazilian jiu-jitsu','Community','Cycling','Dowsing','Driving','Fishing','Flag Football','Flying','Flying disc','Foraging','Gardening','Geocaching','Ghost hunting','Graffiti','Handball','Hiking','Hooping','Horseback riding','Hunting','Inline skating','Jogging','Kayaking','Kite flying','Kitesurfing','LARPing','Letterboxing','Metal detecting','Motor sports','Mountain biking','Mountaineering','Mushroom hunting','Mycology','Netball','Nordic skating','Orienteering','Paintball','Parkour','Photography','Polo','Rafting','Rappelling','Rock climbing','Roller skating','Rugby','Running','Sailing','Sand art','Scouting','Scuba diving','Sculling','Rowing','Shooting','Shopping','Skateboarding','Skiing','Skimboarding','Skydiving','Slacklining','Snowboarding','Stone skipping','Surfing','Swimming','Taekwondo','Tai chi','Urban exploration','Vacation','Vehicle restoration','Water sports']
//                     .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     })
//                     .toList(),
//                 ),

//                 DropdownButton<String>(
//                   value: _discoverdropdownValue,
//                   icon: Icon(Icons.arrow_downward),
//                   iconSize: 24,
//                   elevation: 16,
//                   style: TextStyle(
//                     color: Colors.deepPurple
//                   ),
//                   underline: Container(
//                     height: 2,
//                     color: Colors.deepPurpleAccent,
//                   ),
//                   onChanged: (String newValue) {
//                     setState(() {
//                       _discoverdropdownValue = newValue;
//                     });
//                   },
//                   items: <String>['One','3D printing','amateur radio','scrapbook','Amateur radio','Acting','Baton twirling','Board games','Book restoration','Cabaret','Calligraphy','Candle making','Computer programming','Coffee roasting','Cooking','Coloring','Cosplaying','Couponing','Creative writing','Crocheting','Cryptography','Dance','Digital arts','Drama','Drawing','Do it yourself','Electronics','Embroidery','Fashion','Flower arranging','Foreign language learning','Gaming','tabletop games','role-playing games','Gambling','Genealogy','Glassblowing','Gunsmithing','Homebrewing','Ice skating','Jewelry making','Jigsaw puzzles','Juggling','Knapping','Knitting','Kabaddi','Knife making','Lacemaking','Lapidary','Leather crafting','Lego building','Lockpicking','Machining','Macrame','Metalworking','Magic','Model building','Listening to music','Origami','Painting','Playing musical instruments','Pet','Poi','Pottery','Puzzles','Quilting','Reading','Scrapbooking','Sculpting','Sewing','Singing','Sketching','Soapmaking','Sports','Stand-up comedy','Sudoku','Table tennis','Taxidermy','Video gaming','Watching movies','Web surfing','Whittling','Wood carving','Woodworking','Worldbuilding','Writing','Yoga','Yo-yoing','Air sports','Archery','Astronomy','Backpacking','BASE jumping','Baseball','Basketball','Beekeeping','Bird watching','Blacksmithing','Board sports','Bodybuilding','Brazilian jiu-jitsu','Community','Cycling','Dowsing','Driving','Fishing','Flag Football','Flying','Flying disc','Foraging','Gardening','Geocaching','Ghost hunting','Graffiti','Handball','Hiking','Hooping','Horseback riding','Hunting','Inline skating','Jogging','Kayaking','Kite flying','Kitesurfing','LARPing','Letterboxing','Metal detecting','Motor sports','Mountain biking','Mountaineering','Mushroom hunting','Mycology','Netball','Nordic skating','Orienteering','Paintball','Parkour','Photography','Polo','Rafting','Rappelling','Rock climbing','Roller skating','Rugby','Running','Sailing','Sand art','Scouting','Scuba diving','Sculling','Rowing','Shooting','Shopping','Skateboarding','Skiing','Skimboarding','Skydiving','Slacklining','Snowboarding','Stone skipping','Surfing','Swimming','Taekwondo','Tai chi','Urban exploration','Vacation','Vehicle restoration','Water sports']
//                     .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     })
//                     .toList(),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }