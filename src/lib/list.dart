import 'package:flutter/material.dart';

class ListHomePage extends StatefulWidget {
  const ListHomePage({super.key});

  @override
  State<ListHomePage> createState() => _ListHomePageState();
}

class _ListHomePageState extends State<ListHomePage> {
  int _selectedIndex =
      0; // Índice para controlar la opción seleccionada en el Drawer

  // Lista de widgets que se mostrarán en el cuerpo de la página
  static const List<Widget> _widgetOptions = <Widget>[
    GridListPage(), // Página de la cuadrícula
    HorizontalListPage(), // Página de la lista horizontal
    ListTypeItems(), // Página de la lista mixta
    CustomScrollPage(), // Página de CustomScrollView con SliverAppBar
    ListViewPage(),
    LongListPage(),
    ListWithSpacePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cambia el índice seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Tareas'),
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
              title: const Text('Create a Grid List'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0); // Cambia a la página de la cuadrícula
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              title: const Text('Horizontal List'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1); // Cambia a la lista horizontal
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              title: const Text('List Type Items'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2); // Cambia a la lista mixta
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              title: const Text('Custom Scroll Page'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3); // Cambia a la página de CustomScrollView
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              title: const Text('Use List'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4); // Cambia a la página de CustomScrollView
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              title: const Text('Long page'),
              selected: _selectedIndex == 5,
              onTap: () {
                _onItemTapped(5); // Cambia a la página de CustomScrollView
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              title: const Text('List with space'),
              selected: _selectedIndex == 6,
              onTap: () {
                _onItemTapped(6); // Cambia a la página de CustomScrollView
                Navigator.pop(context); // Cierra el Drawer
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

// Página de la cuadrícula
class GridListPage extends StatelessWidget {
  const GridListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // Número de columnas
      children: List.generate(100, (index) {
        return Center(
          child: Text(
            'Item $index',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        );
      }),
    );
  }
}

// Página de la lista horizontal
class HorizontalListPage extends StatelessWidget {
  const HorizontalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 160,
            color: Colors.red,
          ),
          Container(
            width: 160,
            color: Colors.blue,
          ),
          Container(
            width: 160,
            color: Colors.green,
          ),
          Container(
            width: 160,
            color: Colors.yellow,
          ),
          Container(
            width: 160,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

// Página de la lista mixta
class ListTypeItems extends StatelessWidget {
  const ListTypeItems({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List<ListItem>.generate(
      1000,
      (i) => i % 6 == 0
          ? HeadingItem('Heading $i')
          : MessageItem('Sender $i', 'Message body $i'),
    );

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: item.buildTitle(context),
          subtitle: item.buildSubtitle(context),
        );
      },
    );
  }
}

class ListViewPage extends StatelessWidget {
  const ListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        ListTile(
          leading: Icon(Icons.map),
          title: Text('Map'),
        ),
        ListTile(
          leading: Icon(Icons.photo_album),
          title: Text('Album'),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Phone'),
        ),
      ],
    );
  }
}

// Página de CustomScrollView con SliverAppBar
class CustomScrollPage extends StatelessWidget {
  const CustomScrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Floating App Bar';

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text(title),
          automaticallyImplyLeading: false,
          floating: true, // Permite que la AppBar flote
          flexibleSpace: Placeholder(), // Espacio flexible para la AppBar
          expandedHeight: 200, // Altura inicial de la AppBar
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(
              title: Text('Item #$index'),
            ),
            childCount: 1000, // Número de elementos en la lista
          ),
        ),
      ],
    );
  }
}

// Página de lista larga
class LongListPage extends StatelessWidget {
  const LongListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Genera una lista de 10,000 elementos
    final items = List<String>.generate(10000, (i) => 'Item $i');

    return ListView.builder(
      itemCount: items.length,
      prototypeItem: ListTile(
        title: Text(items.first),
      ),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
        );
      },
    );
  }
}

class ListWithSpacePage extends StatelessWidget {
  const ListWithSpacePage({super.key});

  @override
  Widget build(BuildContext context) {
    const items = 4; // Número de elementos en la lista

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                items,
                (index) => ItemWidget(text: 'Item $index'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(child: Text(text)),
      ),
    );
  }
}

// Clase base para los elementos de la lista
abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
}

// Elemento de encabezado
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

// Elemento de mensaje
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
