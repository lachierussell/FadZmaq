import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class InheritedUser extends InheritedWidget {
  InheritedUser({
    this.userService,
    Widget child,
  }):super(child: child);


  final UserService userService;

  static InheritedUser of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedUser);
  }

// We don't rebuild below this if the user service changes
// We 
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}


class UserService{
  IdTokenResult _tokenResult;

  String getToken() {
    return _tokenResult.token;
  }

  void setToken(IdTokenResult result){
    _tokenResult = result;
  }
}