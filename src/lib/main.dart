import 'package:flutter/material.dart';
import 'screens/design.dart';
import 'screens/images.dart';
import 'screens/list.dart';
import 'screens/forms.dart';
import 'screens/navigation.dart';
import 'screens/network.dart';
import 'screens/animation.dart';
import 'screens/persistance.dart';

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
          seedColor: Colors.green, // Color principal (verde)
          primary: Colors.green, // Color primario
          secondary: Colors.greenAccent, // Color secundario
          background: Colors.white, // Fondo blanco
          surface: Colors.white, // Superficie blanca
          onPrimary: Colors.white, // Texto sobre el color primario (blanco)
          onSecondary: Colors.black, // Texto sobre el color secundario (negro)
          onBackground: Colors.black, // Texto sobre el fondo (negro)
          onSurface: Colors.black, // Texto sobre la superficie (negro)
          brightness: Brightness.light, // Modo claro
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Texto en negro
          ),
          titleLarge: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            color: Colors.black, // Texto en negro
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black, // Texto en negro
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green, // Fondo del AppBar en verde
          foregroundColor: Colors.white, // Texto e íconos del AppBar en blanco
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Fondo del botón en verde
            foregroundColor: Colors.white, // Texto del botón en blanco
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 20),
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black, // Texto de la pestaña seleccionada
          unselectedLabelColor:
              Colors.grey, // Texto de las pestañas no seleccionadas
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.green, // Indicador de la pestaña seleccionada
              width: 2.0,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white, // Fondo del menú en blanco
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Envuelve el contenido en un SingleChildScrollView
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Asegura que el Column no ocupe más espacio del necesario
              children: [
                ListTile(
                  leading: const Icon(Icons.design_services,
                      color: Colors.green), // Ícono verde
                  title: const Text(
                    'Tareas Design',
                    style: TextStyle(color: Colors.black), // Texto en negro
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: "Tarea Designs")),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image,
                      color: Colors.green), // Ícono verde
                  title: const Text(
                    'Tareas Images',
                    style: TextStyle(color: Colors.black), // Texto en negro
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ImagesHomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list,
                      color: Colors.green), // Ícono verde
                  title: const Text(
                    'List tareas',
                    style: TextStyle(color: Colors.black), // Texto en negro
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListHomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit,
                      color: Colors.green), // Ícono verde
                  title: const Text(
                    'Forms tareas',
                    style: TextStyle(color: Colors.black), // Texto en negro
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FormsHomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.navigation,
                      color: Colors.green), // Ícono verde
                  title: const Text(
                    'Navigation tareas',
                    style: TextStyle(color: Colors.black), // Texto en negro
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavigationHomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.network_wifi,
                      color: Colors.green), // Ícono verde
                  title: const Text(
                    'Network tareas',
                    style: TextStyle(color: Colors.black), // Texto en negro
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NetworkHomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.animation,
                      color: Colors.green), // Ícono verde
                  title: const Text(
                    'Animation tareas',
                    style: TextStyle(color: Colors.black), // Texto en negro
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnimationHomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.all_inbox_rounded,
                      color: Colors.green), // Ícono verde
                  title: const Text(
                    'Persistance tareas',
                    style: TextStyle(color: Colors.black), // Texto en negro
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersistenceHomePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una tarea'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showMenu(context),
          child: const Text('Selección de Tareas'),
        ),
      ),
    );
  }
}
