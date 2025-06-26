import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ss_home/firebase_options.dart';
import 'package:ss_home/views/staff/staffMainPage.dart';
import 'package:ss_home/views/staff/stafflogin.dart';
import 'package:ss_home/views/systemAdmin/login.dart';
import 'package:ss_home/views/systemAdmin/register.dart';
import 'package:ss_home/views/systemAdmin/systemAdminHomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Check login state
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? loggedInIC = prefs.getString('staffIC');
  final bool isSystemAdminLoggedIn =
      prefs.getBool('isSystemAdminLoggedIn') ?? false;

  runApp(
    MyApp(loggedInIC: loggedInIC, isSystemAdminLoggedIn: isSystemAdminLoggedIn),
    // MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final String? loggedInIC;
  final bool isSystemAdminLoggedIn;
  const MyApp({
    super.key,
    this.loggedInIC,
    required this.isSystemAdminLoggedIn,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const SystemAdminLoginScreen(),
      // initialRoute: loggedInIC != null ? '/staffHomePage' : '/SystemAdminlogin',
      initialRoute:
          loggedInIC != null
              ? '/staffHomePage'
              : (isSystemAdminLoggedIn
                  ? '/SystemAdminHomePage'
                  : '/SystemAdminlogin'),

      routes: {
        '/SystemAdminlogin': (context) => const SystemAdminLoginScreen(),
        '/SystemAdminregister': (context) => const SystemAdminRegisterScreen(),
        '/Stafflogin': (context) => const StaffLoginScreen(),
        '/SystemAdminHomePage': (context) => const SystemAdminHomepage(),
        '/staffHomePage': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final ic =
              args is int ? args.toString() : (args as String? ?? loggedInIC!);
          return SSHomeStaffMainPage(staffIC: ic);
        },
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
