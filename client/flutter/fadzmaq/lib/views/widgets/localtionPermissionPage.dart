import 'package:fadzmaq/views/landing.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({
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
            ButtonTheme(
              minWidth: 220.0,
              height: 50.0,
              child: RaisedButton(
                  textTheme: ButtonTextTheme.primary,
                  child: Text(
                    "Enable Location",
                    style: TextStyle(fontSize: 18),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    await location.requestPermission();
                    moveOnPermitted(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(60.0))),
            )
          ],
        ),
      ),
    );
  }

  void moveOnPermitted(BuildContext context) async {
    Location location = Location();

    bool hasPermission = await location.hasPermission();

    if (hasPermission) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LandingPage(),
        ),
      );
    }
  }
}
