import 'package:fadzmaq/controllers/account.dart';
import 'package:fadzmaq/views/splashscreen.dart';
import 'package:fadzmaq/views/widgets/roundButton.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // moveOnPermitted(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.grey,
              size: 150,
            ),
            SizedBox(height: 32),
            Text("Server Error",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            SizedBox(
              width: 220,
              child: Text("Something went wrong!",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 32),
            RoundButton(
              label: "Retry",
              fontSize: 18,
              minWidth: 220,
              height: 50,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SplashScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            RoundButton(
              label: "Log Out",
              fontSize: 18,
              minWidth: 220,
              height: 50,
              color: Colors.grey,
              textColor: Colors.black,
              onPressed: () {
                logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
