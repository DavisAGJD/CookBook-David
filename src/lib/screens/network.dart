import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'api/api.dart';

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
    WebSocketPage(), // Página de WebSocket
    JsonParsePage(), // Nueva página para parsear JSON
    DeleteDataPage(),
    FetchDataPage(),
    SendDataPage(),
    UpdateDataPage(),
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
              decoration: BoxDecoration(color: Colors.green),
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
            ListTile(
              title: const Text('Parse JSON'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Delete data'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Fetch data'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Send data'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Update data'),
              selected: _selectedIndex == 5,
              onTap: () {
                _onItemTapped(5);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Página de WebSocket (tu código actual)
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
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userInfo;
  bool _isLoading = false;

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
              decoration: const InputDecoration(labelText: "Enter User ID"),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchUserInfo,
            child: const Text('Fetch User Info'),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : _userInfo != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre_usuario: ${_userInfo!['nombre_usuario']}'),
                        Text('Email: ${_userInfo!['email']}'),
                        // Agrega más campos según la respuesta de tu API
                      ],
                    )
                  : const Text('No user info available'),
        ],
      ),
    );
  }

  void _fetchUserInfo() async {
    final usuarioId = int.tryParse(_controller.text);
    if (usuarioId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userInfo = await _apiService.getUserInfo(usuarioId);
        setState(() {
          _userInfo = userInfo;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid user ID')),
      );
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}

// Nueva página para parsear JSON
class JsonParsePage extends StatefulWidget {
  const JsonParsePage({super.key});

  @override
  State<JsonParsePage> createState() => _JsonParsePageState();
}

class _JsonParsePageState extends State<JsonParsePage> {
  late Future<List<User>> futureUsers;
  final ApiServiceJson _apiService = ApiServiceJson();

  @override
  void initState() {
    super.initState();
    futureUsers = _apiService.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Users'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DeleteDataPage extends StatefulWidget {
  const DeleteDataPage({super.key});

  @override
  State<DeleteDataPage> createState() => _DeleteDataPageState();
}

class _DeleteDataPageState extends State<DeleteDataPage> {
  final TextEditingController _idController = TextEditingController();
  final ApiServiceDelete _apiService =
      ApiServiceDelete(); // Instancia de ApiService
  bool _isLoading = false;

  Future<void> deleteResource(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService
          .deleteResource(id); // Llama al método deleteResource de ApiService
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recurso eliminado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el recurso: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eliminar Recurso'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Ingresa el ID del recurso',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final id = int.tryParse(_idController.text);
                      if (id != null) {
                        deleteResource(id);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Por favor, ingresa un ID válido')),
                        );
                      }
                    },
                    child: const Text('Eliminar'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}

class Album {
  int? id;
  String? title;

  Album({this.id, this.title});

  Album.empty();

  factory Album.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id') && json.containsKey('title')) {
      return Album(
        id: json['id'] as int,
        title: json['title'] as String,
      );
    } else {
      throw const FormatException('Failed to load album.');
    }
  }
}

class FetchDataPage extends StatefulWidget {
  const FetchDataPage({super.key});

  @override
  State<FetchDataPage> createState() => _FetchDataPageState();
}

class _FetchDataPageState extends State<FetchDataPage> {
  late Future<List<Noticia>> futureNoticias;
  final ApiServiceNews _apiService = ApiServiceNews();
  Noticia? noticiaSeleccionada;

  @override
  void initState() {
    super.initState();
    futureNoticias =
        _apiService.fetchNoticias('Finanzas'); // Palabra clave   por defecto
  }

  void _mostrarNoticiaAleatoria(List<Noticia> noticias) {
    if (noticias.isNotEmpty) {
      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % noticias.length;
      setState(() {
        noticiaSeleccionada = noticias[randomIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticia Aleatoria'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Noticia>>(
        future: futureNoticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron noticias'));
          } else {
            final noticias = snapshot.data!;

            // Usar addPostFrameCallback para llamar a setState después del build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (noticiaSeleccionada == null) {
                _mostrarNoticiaAleatoria(noticias);
              }
            });

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  if (noticiaSeleccionada != null) ...[
                    if (noticiaSeleccionada!.imagenUrl != null)
                      Image.network(noticiaSeleccionada!.imagenUrl!),
                    const SizedBox(height: 16),
                    Text(
                      noticiaSeleccionada!.titulo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      noticiaSeleccionada!.descripcion,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fuente: ${noticiaSeleccionada!.fuente}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fecha: ${noticiaSeleccionada!.fecha}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _mostrarNoticiaAleatoria(noticias);
                      },
                      child: const Text('Mostrar otra noticia'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class SendDataPage extends StatefulWidget {
  const SendDataPage({super.key});

  @override
  State<SendDataPage> createState() => _SendDataPageState();
}

class _SendDataPageState extends State<SendDataPage> {
  final TextEditingController _nombreUsuarioController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void>? _futureUsuario;
  final ApiServiceCreate _apiService = ApiServiceCreate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: (_futureUsuario == null) ? buildForm() : buildFutureBuilder(),
      ),
    );
  }

  Widget buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _nombreUsuarioController,
          decoration: const InputDecoration(
            labelText: 'Nombre de usuario',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureUsuario = _apiService.createUsuario(
                _nombreUsuarioController.text,
                _emailController.text,
                _passwordController.text,
              );
            });
          },
          child: const Text('Registrarse'),
        ),
      ],
    );
  }

  FutureBuilder<void> buildFutureBuilder() {
    return FutureBuilder<void>(
      future: _futureUsuario,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Column(
            children: [
              Text('Error: ${snapshot.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureUsuario = null; // Vuelve al formulario
                  });
                },
                child: const Text('Intentar de nuevo'),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              const Text('¡Usuario registrado exitosamente!'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureUsuario = null; // Vuelve al formulario
                  });
                },
                child: const Text('Registrar otro usuario'),
              ),
            ],
          );
        }
      },
    );
  }
}

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({super.key});

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nombreUsuarioController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late Future<UsuarioUpdate> _futureUsuario; // Para buscar el usuario
  Future<String>? _futureMessage; // Inicializada como nula
  bool _isSearching = false;

  final ApiServiceUpdate _apiServiceUpdate = ApiServiceUpdate();

  void _searchUsuario() {
    final id = int.tryParse(_idController.text);
    if (id != null) {
      setState(() {
        _isSearching = true;
        _futureUsuario = _apiServiceUpdate.fetchUsuario(id); // Busca el usuario
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un ID válido.')),
      );
    }
  }

  void _updateUsuario() {
    final id = int.tryParse(_idController.text);
    if (id != null) {
      setState(() {
        _futureMessage = _apiServiceUpdate.updateUsuario(
          id,
          _nombreUsuarioController.text,
          _emailController.text,
        ); // Actualiza el usuario
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Usuario'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID del Usuario',
                hintText: 'Ingresa el ID del usuario',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchUsuario,
              child: const Text('Buscar Usuario'),
            ),
            const SizedBox(height: 16),
            if (_isSearching)
              FutureBuilder<UsuarioUpdate>(
                future: _futureUsuario,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    _nombreUsuarioController.text =
                        snapshot.data!.nombreUsuario;
                    _emailController.text = snapshot.data!.email;
                    return Column(
                      children: [
                        TextField(
                          controller: _nombreUsuarioController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de Usuario',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _updateUsuario,
                          child: const Text('Actualizar Usuario'),
                        ),
                      ],
                    );
                  } else {
                    return const Text('No se encontró el usuario.');
                  }
                },
              ),
            const SizedBox(height: 16),
            if (_futureMessage != null)
              FutureBuilder<String>(
                future: _futureMessage,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(snapshot.data!); // Muestra el mensaje de la API
                  } else {
                    return const SizedBox(); // No muestra nada si no hay datos
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
