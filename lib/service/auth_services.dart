import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helper_function.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUserNameandPassword(
       String email, String password
      )async{
    try{
      User user=(await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;

        return true;
    } on FirebaseAuthException catch(e){
      print(e);
      return e;

    }
  }



  //register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password
      )async{
    try{
      User user=(await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user!;
      if(user!=null){
        DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch(e){
      print(e);
      return e;

    }
  }

  //signout

  Future signOut() async{
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch(e){
      return null;
    }
  }

}