import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zanadu_coach/core/routes.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> createAccountWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (ex) {
      throw ex.message.toString();
    } catch (ex) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (ex) {
      throw ex.message.toString();
    } catch (ex) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      if (Platform.isAndroid) {
        log("google token 10");
        final GoogleSignInAccount? googleUser = await GoogleSignIn(
          signInOption: SignInOption.standard,
          scopes: ['email', 'https://www.googleapis.com/auth/calendar'],
        ).signIn();
        log("google token ${googleUser}");
        if (googleUser == null) throw 'Operation cancelled by the user';
        log("google token 12");
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        log("google token 13");
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        log("google token 14");
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        log("google token 15");
        return userCredential;
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn(
                signInOption: SignInOption.standard,
                scopes: ['email', 'https://www.googleapis.com/auth/calendar'],
                clientId:
                    "847098207975-6nesf9od72qj2l3i1sabrc3p713u1b3s.apps.googleusercontent.com")
            .signIn();
        if (googleUser == null) throw 'Operation cancelled by the user';

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        return userCredential;
      }
    } on FirebaseAuthException catch (ex) {
      throw ex.message.toString();
    } catch (ex) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithApple() async {
    try {
      bool appleSignInAvailable = await SignInWithApple.isAvailable();

      if (!appleSignInAvailable) {
        throw 'Sign In with Apple is not supported on this device';
      }

      final appleCredential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      final oauthCredential = OAuthProvider("apple.com")
          .credential(idToken: appleCredential.identityToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);

      if (userCredential.additionalUserInfo?.isNewUser == false) {
        Routes.goTo(Screens.signupscreensecond);
      }

      print(userCredential.user!.uid);

      print(userCredential.toString());

      return userCredential;
    } on FirebaseAuthException catch (ex) {
      throw ex.message.toString();
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get userChanges => _auth.userChanges();
}
