import 'dart:io';
import 'dart:math';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/views/edithobbiespage.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:fadzmaq/views/widgets/profile_body.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
// import 'package:permission_handler/permission_handler.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: VerifyModel(
        model: Model.userProfile,
        builder: (context) {
          return new EditProfile();
        },
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new EditProfileState();
}

String profileFieldFromString(ProfileData pd, String fieldName) {
  if (pd != null && pd.profileFields != null) {
    for (ProfileField pf in pd.profileFields) {
      // Dart lets us compare stings this way, what a revolution!
      if (pf.name == fieldName) {
        if (pf.displayValue != null) {
          return pf.displayValue;
        } else {
          return "";
        }
      }
    }
  }
  return "";
}

class EditProfileState extends State<EditProfile> {
  File _image1;

  String imgurl;

  String imgurlForm;

  bool disableButton = false;

  final FirebaseStorage storage =
      new FirebaseStorage(storageBucket: 'gs://fadzmaq1.appspot.com/');

  // Get an image from your gallery
  Future getImage1() async {
// Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Directory tempDir = Directory.systemTemp;
      final path = tempDir.path;
      int rand = new Random().nextInt(10000);
      Im.Image newimage = Im.decodeImage(image.readAsBytesSync());
      newimage = Im.copyResizeCropSquare(newimage, 1080);
      var newim1 = new File('$path/img_$rand.jpg')
        ..writeAsBytesSync(Im.encodeJpg(newimage, quality: 52));

      setState(() {
        _image1 = newim1;
      });
    }
  }

  // Upload File to firebase
  Future<Null> _uploadFile() async {
    String fileName = "${Uuid().v1()}";
    final StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_image1);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String url = (await taskSnapshot.ref.getDownloadURL());
    print('URL Is $url');

    setState(() {
      imgurl = url;
      imgurlForm = imgurl;
    });
  }

  String returnImageURL() {
    return imgurl;
  }

  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    // ProfileData pd = RequestProvider.of<ProfileContainer>(context).profile;
    ProfileData userProfile = getUserProfile(context);
    String server = AppConfig.of(context).server;

    // check for id 1 (about me) and grab the display value
    String bio = profileFieldFromString(userProfile, "bio");
    String contactPhone = profileFieldFromString(userProfile, "phone");
    String contactEmail = profileFieldFromString(userProfile, "email");

//    final String contact_phone =
//        pd.contactDetails.phone != null ? pd.contactDetails.phone : "";
//    String contact_email =
//        pd.contactDetails.email != null ? pd.contactDetails.email : "";

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                // context,
                key: _fbKey,
                autovalidate: true,
                initialValue: {
                  'movie_rating': 5,
                },
                // readOnly: true,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: _image1 != null
                          ? Image.file(
                              _image1,
                              height: Globals.recThumbDim,
                              width: Globals.recThumbDim,
                            )
                          : DisplayPhoto(
                              url: userProfile.photo,
                              dimension: Globals.recThumbDim,
                            ),
                    ),
                    // Get an Image
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      child: Text('Select Image'),
                      onPressed: getImage1,
                    ),
                    // FormBuilderTextField(
                    //     attribute: "photo",
                    //     initialValue: imgurlForm,
                    //     readOnly: true,
                    //     decoration: InputDecoration(labelText: "")),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                        attribute: "nickname",
                        initialValue: userProfile.name,
                        decoration: InputDecoration(labelText: "Nickname")),
                    SizedBox(
                      height: 20,
                    ),
                    ProfileHobbies(
                        hobbies: userProfile.hobbyContainers,
                        direction: HobbyDirection.discover),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditHobbyPage2(isShare: false)),
                          );
                        },
                        child: Text("Choose hobbies that you want to discover"),
                      ),
                    ),
                    ProfileHobbies(
                        hobbies: userProfile.hobbyContainers,
                        direction: HobbyDirection.share),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditHobbyPage2(isShare: true)),
                          );
                        },
                        child: Text("Choose hobbies that you want to share"),
                      ),
                    ),
                    FormBuilderTextField(
                        attribute: "email",
                        initialValue: contactEmail,
                        decoration: InputDecoration(labelText: "email")),
                    FormBuilderTextField(
                        attribute: "phone",
                        initialValue: contactPhone,
                        decoration: InputDecoration(labelText: "phone")),
                    FormBuilderTextField(
                        attribute: "bio",
                        initialValue: bio,
                        decoration: InputDecoration(labelText: "bio")),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                disabledColor: Colors.grey,
                color: Theme.of(context).accentColor,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: disableButton
                    ? null
                    : () async {
                        setState(() {
                          disableButton = true;
                        });
                        if (_image1 != null) {
                          await _uploadFile();
                        }
                        if (_fbKey.currentState.saveAndValidate()) {
                          _fbKey.currentState.value.addAll({"photo": imgurl});
                          print("Sending" + '${_fbKey.currentState.value}');
                          httpPost(server + "profile",
                              json: _fbKey.currentState.value);

                          print(_fbKey.currentState.value.toString());

                          if (imgurl != null) userProfile.photo = imgurl;
                          String nickname =
                              _fbKey.currentState.value['nickname'];
                          String email = _fbKey.currentState.value['email'];
                          String phone = _fbKey.currentState.value['phone'];
                          String bio = _fbKey.currentState.value['bio'];

                          if (nickname != null) userProfile.name = nickname;

                          if (email != null)
                            userProfile.replaceProfileField("email", email);
                          if (phone != null)
                            userProfile.replaceProfileField("phone", phone);
                          if (bio != null)
                            userProfile.replaceProfileField("bio", bio);

                          // setState(() {
                          //   disableButton = false;
                          // });

                          Navigator.pop(context);
                        } else {
                          print(_fbKey.currentState.value);
                          print("validation failed");
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
