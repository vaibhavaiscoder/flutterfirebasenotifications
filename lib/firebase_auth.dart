import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userAuthentication = FirebaseAuth.instance;
final phoneAuthentication = FirebaseAuth.instance;

FirebaseFirestore userFirestore = FirebaseFirestore.instance;
FirebaseFirestore phoneFirestore = FirebaseFirestore.instance;

User? currentUser = userAuthentication.currentUser;
User? currentPhoneAuth = phoneAuthentication.currentUser;

//collections
const userCollection = "users";
const phoneCollection = "phone";
