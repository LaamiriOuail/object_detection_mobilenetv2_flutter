import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detection_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detection App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false, // Disable the debug banner
      initialRoute: '/',
      routes: {
        '/': (context) =>  const AppScaffold(
              screen:  HomeScreen(),
              userName: "Ouail Laamiri",
              userEmail: "ouaillaamiri@gmail.com",
              userImage: "assets/images/avatar.png", // Provide the path to your image
            ),
        '/detection': (context) => const AppScaffold(
              screen: DetectionScreen(),
              userName: "Ouail Laamiri",
              userEmail: "ouaillaamiri@gmail.com",
              userImage: "assets/images/avatar.png",
            ),
        '/history': (context) => const AppScaffold(
              screen: HistoryScreen(),
              userName: "Ouail Laamiri",
              userEmail: "ouaillaamiri@gmail.com",
              userImage: "assets/images/avatar.png",
            ),
      },
    );
  }
}

/// Scaffold wrapper with Drawer
class AppScaffold extends StatelessWidget {
  final Widget screen;
  final String userName;
  final String userEmail;
  final String userImage;

  const AppScaffold({
    super.key,
    required this.screen,
    required this.userName,
    required this.userEmail,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Detection App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(userImage), // Load user image
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Object Detection'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/detection');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/history');
              },
            ),
          ],
        ),
      ),
      body: screen,
    );
  }
}
