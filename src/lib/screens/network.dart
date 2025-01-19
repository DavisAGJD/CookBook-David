
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NetworkHomePage extends StatefulWidget {
  const NetworkHomePage({super.key});

  @override
  State<NetworkHomePage> createState() => _NetworkHomePageState();
}

class _NetworkHomePageState extends State<NetworkHomePage> {
  int _selectedIndex =
      0; // Índice para controlar la opción seleccionada en el Drawer

  // Lista de widgets que se mostrarán en el cuerpo de la página
  static const List<Widget> _widgetOptions = <Widget>[
    WebSocketPage(), // Página de BMI
    // Aquí puedes agregar más páginas si lo deseas
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
        title: const Text('Network Tareas'),
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
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Network tareas'),
            ),
            ListTile(
              title: const Text('WebSocket'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Send a message"),
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendMessage,
            child: const Text('Send Message'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
