import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa Flutter binding
  runApp(const PersistenceApp());
}

class PersistenceApp extends StatelessWidget {
  const PersistenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistencia de Datos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PersistenceHomePage(),
    );
  }
}

class PersistenceHomePage extends StatefulWidget {
  const PersistenceHomePage({super.key});

  @override
  _PersistenceHomePageState createState() => _PersistenceHomePageState();
}

class _PersistenceHomePageState extends State<PersistenceHomePage> {
  int _selectedIndex = 0;

  // Lista de pantallas disponibles
  final List<Widget> _widgetOptions = <Widget>[
    const SQLiteScreen(), // Pantalla de SQLite (índice 0)
    const SharedPreferencesScreen(), // Pantalla de SharedPreferences (índice 1)
    FileStorageScreen(
        storage: CounterStorage()), // Pantalla de File Storage (índice 2)
  ];

  void _onItemTapped(int index) {
    // Asegúrate de que el índice esté dentro del rango válido
    if (index >= 0 && index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      // Manejo de error: índice fuera de rango
      print("Error: Índice fuera de rango");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistencia de Datos'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú de Persistencia',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('SQLite'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              title: const Text('SharedPreferences'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              title: const Text('File Storage'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
          ],
        ),
      ),
      body: Center(
        child:
            _widgetOptions[_selectedIndex], // Muestra la pantalla seleccionada
      ),
    );
  }
}

// Pantalla de SQLite
class SQLiteScreen extends StatefulWidget {
  const SQLiteScreen({super.key});

  @override
  _SQLiteScreenState createState() => _SQLiteScreenState();
}

class _SQLiteScreenState extends State<SQLiteScreen> {
  late Database _database;
  final List<Dog> _dogs = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
    await _loadDogs();
  }

  Future<void> _loadDogs() async {
    final List<Map<String, dynamic>> dogMaps = await _database.query('dogs');
    setState(() {
      _dogs.clear();
      _dogs.addAll(dogMaps.map((e) => Dog.fromMap(e)).toList());
    });
  }

  Future<void> _insertDog(Dog dog) async {
    await _database.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _loadDogs();
  }

  Future<void> _updateDog(Dog dog) async {
    await _database.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
    await _loadDogs();
  }

  Future<void> _deleteDog(int id) async {
    await _database.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite - Persistencia de Datos'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _dogs.length,
              itemBuilder: (context, index) {
                final dog = _dogs[index];
                return ListTile(
                  title: Text(dog.name),
                  subtitle: Text('Edad: ${dog.age}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteDog(dog.id),
                  ),
                  onTap: () async {
                    final updatedDog = Dog(
                      id: dog.id,
                      name: dog.name,
                      age: dog.age + 1,
                    );
                    await _updateDog(updatedDog);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final newDog = Dog(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: 'Perro Nuevo',
                  age: 1,
                );
                await _insertDog(newDog);
              },
              child: const Text('Agregar Perro'),
            ),
          ),
        ],
      ),
    );
  }
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'],
      name: map['name'],
      age: map['age'],
    );
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}

// Pantalla de SharedPreferences
class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({super.key});

  @override
  _SharedPreferencesScreenState createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (_counter + 1);
      prefs.setInt('counter', _counter);
    });
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = 0;
      prefs.remove('counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences - Persistencia de Datos'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Has pulsado el botón esta cantidad de veces:',
            ),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Incrementar Contador'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text('Reiniciar Contador'),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de File Storage
class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0; // Si hay un error, retorna 0
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}

class FileStorageScreen extends StatefulWidget {
  const FileStorageScreen({super.key, required this.storage});

  final CounterStorage storage;

  @override
  _FileStorageScreenState createState() => _FileStorageScreenState();
}

class _FileStorageScreenState extends State<FileStorageScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Storage - Persistencia de Datos'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Has pulsado el botón esta cantidad de veces:',
            ),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
