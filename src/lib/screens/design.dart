import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Gabooo',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    SnackBarPage(),
    Text(
      'Fonts',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        fontFamily: 'Raleway',
        fontStyle: FontStyle.italic,
      ),
    ),
    OrientationList(
      title: 'Orientation list',
    ),
    FonstDiferentsPage(),
    TabsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Gaboooo'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('SnackBar'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Fonts'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Orientation List'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Different Fonts'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pestañas'),
              onTap: () {
                _onItemTapped(5);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.dark,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class SnackBarPage extends StatelessWidget {
  const SnackBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: const Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Text('Show SnackBar'),
      ),
    );
  }
}

class OrientationList extends StatelessWidget {
  final String title;

  const OrientationList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            );
          }),
        );
      }),
    );
  }
}

class FonstDiferentsPage extends StatefulWidget {
  const FonstDiferentsPage({super.key});

  @override
  State<FonstDiferentsPage> createState() => _FonstDiferentsPageState();
}

class _FonstDiferentsPageState extends State<FonstDiferentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diferentes Fuentes'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Texto con Raleway Regular',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Texto con Raleway Italic',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Texto con RobotoMono Regular',
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Texto con RobotoMono Bold',
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pestañas'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Inicio'),
              Tab(icon: Icon(Icons.list), text: 'Lista'),
              Tab(icon: Icon(Icons.settings), text: 'Configuración'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Contenido de Inicio')),
            Center(child: Text('Contenido de Lista')),
            Center(child: Text('Contenido de Configuración')),
          ],
        ),
      ),
    );
  }
}
