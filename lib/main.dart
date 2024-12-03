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
      initialRoute: '/',
      routes: {
        '/': (context) => AppScaffold(screen: HomeScreen()),
        '/detection': (context) => AppScaffold(screen: DetectionScreen()),
        '/history': (context) => AppScaffold(screen: HistoryScreen())
      },
    );
  }
}

/// Scaffold wrapper with Drawer
class AppScaffold extends StatelessWidget {
  final Widget screen;

  const AppScaffold({super.key, required this.screen});

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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.app_registration, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
