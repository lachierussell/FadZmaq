import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/controllers/location.dart';
import 'package:fadzmaq/views/editprofilepage.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/splashscreen.dart';
import 'package:fadzmaq/views/widgets/roundButton.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class PermissionPage extends StatelessWidget {
  final bool navToEdit;

  const PermissionPage({
    this.navToEdit = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Location location = Location();

    // moveOnPermitted(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Colors.grey,
              size: 150,
            ),
            SizedBox(height: 32),
            Text("Location",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            SizedBox(
              width: 220,
              child: Text(
                  "Location permissions need to be enabled to use Fadzmaq",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 32),
            RoundButton(
              label: "Enable Location",
              fontSize: 18,
              minWidth: 220,
              height: 50,
              color: Theme.of(context).primaryColor,
            
              onPressed: () async {
                await location.requestPermission();
                moveOnPermitted(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void moveOnPermitted(BuildContext context) async {
    bool hasPermission = await Location().hasPermission();

    if (hasPermission) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
    }
  }
}
