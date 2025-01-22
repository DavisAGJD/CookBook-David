import 'package:flutter/material.dart';

class ImagesHomePage extends StatefulWidget {
  const ImagesHomePage({super.key});

  @override
  State<ImagesHomePage> createState() => _ImagesHomePageState();
}

class _ImagesHomePageState extends State<ImagesHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ImageFromInternetPage(),
    FadeInImagePage(),
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
        title: const Text('Tarea Images'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Images Drawer Header'),
            ),
            ListTile(
              title: const Text('Imagen desde internet'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Fade in images'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
    );
  }
}

class ImageFromInternetPage extends StatelessWidget {
  const ImageFromInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        'https://picsum.photos/250?image=9',
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Text('Error al cargar la imagen');
        },
      ),
    );
  }
}

class FadeInImagePage extends StatelessWidget {
  const FadeInImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInImage.assetNetwork(
        placeholder:
            'assets/loading.gif', // Asegúrate de que esta imagen exista
        image: 'https://picsum.photos/250?image=9',
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return const Text('Error al cargar la imagen');
        },
      ),
    );
  }
}
