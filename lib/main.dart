import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/services/get_it.dart';
import 'package:foda_admin/utils/common.dart';

import 'app.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBiQ1nZErmG2rJiCNeJby5zURHWQ8EvuoE",
          authDomain: "order-189fe.firebaseapp.com",
          projectId: "order-189fe",
          storageBucket: "order-189fe.appspot.com",
          messagingSenderId: "741953799047",
          appId: "1:741953799047:web:1f3936ae57ebbf308e4922",
          measurementId: "G-LGP6E053LV"),
    );

    GetItService.initializeService();
    runApp(const FodaAdmin());
  }, (error, stack) => fodaPrint(error));
}
