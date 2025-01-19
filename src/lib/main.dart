import 'package:flutter/material.dart';
import 'screens/design.dart'; // Importa el archivo de diseño
import 'screens/images.dart'; // Importa el archivo de imágenes
import 'screens/list.dart';
import 'screens/forms.dart';
import 'screens/navigation.dart';
import 'screens/network.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = "Tareas App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: const HomeScreen(), // Pantalla inicial con botones
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una tarea'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de Tareas Design
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: "Tarea Designs"),
                  ),
                );
              },
              child: const Text('Tareas Design'),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de Tareas Images
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImagesHomePage(),
                  ),
                );
              },
              child: const Text('Tareas Images'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListHomePage(),
                    ));
              },
              child: const Text('List tareas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FormsHomePage(),
                    ));
              },
              child: const Text('Forms tareas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigationHomePage(),
                    ));
              },
              child: const Text('Navigation tareas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NetworkHomePage(),
                    ));
              },
              child: const Text('Network tareas'),
            ),
          ],
        ),
      ),
    );
  }
}
