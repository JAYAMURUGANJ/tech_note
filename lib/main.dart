import 'package:firebase_core/firebase_core.dart';
import 'package:firstdesktop/controller/record_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'view/NoteList_page.dart';
import 'view/list_page.dart';
import 'view/upload_image.dart';
import 'view/record_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyHomePageProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ListNote(),
      ),
    );
  }
}
