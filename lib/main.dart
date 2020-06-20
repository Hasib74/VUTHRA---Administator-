import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vutha_admin_app/src/Provider/NewUser/UserProvider.dart';
import 'package:vutha_admin_app/src/View/Home/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          body1: GoogleFonts.montserrat(textStyle: textTheme.body1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(), child: MaterialApp(home: HomePage())),
    );
  }
}
