




import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanagementapp/views/auth/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../views/auth/create_profile.dart';
import '../views/profile/add_profile.dart';
import 'package:path/path.dart' as Path;



class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  void login({String? email, String? password}) {
    isLoading(true);

    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      /// Login Success

      isLoading(false);
      Get.to(() => profileScreen( ));
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', "$e");

      ///Error occured
    });
  }
  void signUp({String? email, String? password}) {
    ///here we have to provide two things
    ///1- email
    ///2- password

    isLoading(true);

    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      isLoading(false);

      /// Navigate user to profile screen
      Get.to(() =>  profileScreen());
    }).catchError((e) {
      /// print error information
      print("Error in authentication $e");
      isLoading(false);
    });
  }
  signInWithGoogle() async {
    isLoading(true);
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      isLoading(false);

      ///SuccessFull loged in
      Get.to(() => ProfileScreen());
    }).catchError((e) {
      /// Error in getting Login
      isLoading(false);
      print("Error is $e");
    });
  }
  void forgetPassword(String email){
    Get.back();
    auth.sendPasswordResetEmail(email: email).then((value) {
      Get.snackbar('Email Sent', 'We Are Sending Reset Password Link on Your Email');
    }).catchError((e){
      print('Error in Password reset link is $e');
    });
  }

  var isProfileInformationLoading = false.obs;

  Future<String> uploadImageToFirebaseStorage(File image ) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);

    var reference =
    FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      print("Error happen $e");
    });

    return imageUrl;
  }

  upLoadProfileData(String imageurl,String firstname,String lastname,String mobileno,String dob,String gender){
   String uid=FirebaseAuth.instance.currentUser!.uid;
   FirebaseFirestore.instance.collection('user').doc(uid).set({'image':imageurl,
     'firstname':firstname,
     'lastname':lastname,
     'dob':dob,
     'gender':gender
   }).then((value){
     isProfileInformationLoading(false);
     Get.offAll(()=>HomeScreen());
   });

  }


}