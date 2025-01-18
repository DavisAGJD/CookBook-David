import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Forms Tareas',
      home: FormsHomePage(),
    );
  }
}

class FormsHomePage extends StatefulWidget {
  const FormsHomePage({super.key});

  @override
  State<FormsHomePage> createState() => _FormsHomePageState();
}

class _FormsHomePageState extends State<FormsHomePage> {
  int _selectedIndex =
      0; // Índice para controlar la opción seleccionada en el Drawer

  // Lista de widgets que se mostrarán en el cuerpo de la página
  final List<Widget> _widgetOptions = <Widget>[
    const FormValidationPage(), // Página de validación de formulario
    MyCustomFormPage(), // Página con TextField y TextFormField
    const FocusFormPage(), // Nueva página con enfoque en campos de texto
    HandleChangesPage(), // Nueva página para manejar cambios en campos de texto
    RetrieveTextFieldPage(), // Nueva página para recuperar el valor de un campo de texto
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
        title: const Text('Forms Tareas'),
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
            // Opción para la página de validación de formulario
            ListTile(
              title: const Text('Form Validation'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(
                    0); // Cambia a la página de validación de formulario
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            // Opción para la página personalizada
            ListTile(
              title: const Text('Custom Form Page'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1); // Cambia a la página personalizada
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            // Nueva opción para la página de enfoque en campos de texto
            ListTile(
              title: const Text('Focus Form Page'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2); // Cambia a la nueva página
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            // Nueva opción para la página de manejo de cambios en campos de texto
            ListTile(
              title: const Text('Handle Changes Page'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3); // Cambia a la nueva página
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            // Nueva opción para la página de recuperar el valor de un campo de texto
            ListTile(
              title: const Text('Retrieve Text Field Page'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4); // Cambia a la nueva página
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

// Página de validación de formulario
class FormValidationPage extends StatefulWidget {
  const FormValidationPage({super.key});

  @override
  State<FormValidationPage> createState() => _FormValidationPageState();
}

class _FormValidationPageState extends State<FormValidationPage> {
  // Clave global para identificar y validar el formulario
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de texto con validación
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter your text',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20), // Espacio entre el campo y el botón
            // Botón para enviar el formulario
            ElevatedButton(
              onPressed: () {
                // Validar el formulario
                if (_formKey.currentState!.validate()) {
                  // Si el formulario es válido, mostrar un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Página con TextField y TextFormField
class MyCustomFormPage extends StatelessWidget {
  const MyCustomFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TextField básico
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          // TextFormField con validación
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Nueva página con enfoque en campos de texto
class FocusFormPage extends StatefulWidget {
  const FocusFormPage({super.key});

  @override
  State<FocusFormPage> createState() => _FocusFormPageState();
}

class _FocusFormPageState extends State<FocusFormPage> {
  // Crear un FocusNode para manejar el enfoque del campo de texto
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Limpiar el FocusNode cuando el widget se desmonte
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Form Page'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // TextField básico con enfoque automático
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                autofocus: true, // Enfocar automáticamente este campo
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
            ),
            // TextFormField con enfoque manual
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                focusNode: myFocusNode, // Asignar el FocusNode
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            ),
            // Botón para enfocar el segundo campo de texto
            Center(
              child: ElevatedButton(
                onPressed: () {
                  myFocusNode.requestFocus(); // Enfocar el campo de texto
                },
                child: const Text('Focus on Username Field'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Nueva página para manejar cambios en campos de texto
class HandleChangesPage extends StatefulWidget {
  const HandleChangesPage({super.key});

  @override
  State<HandleChangesPage> createState() => _HandleChangesPageState();
}

class _HandleChangesPageState extends State<HandleChangesPage> {
  // Controlador para manejar cambios en el campo de texto
  final TextEditingController _controller = TextEditingController();
  String _textFieldValue =
      ''; // Variable para almacenar el valor del campo de texto

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el controlador
    _controller.addListener(_updateTextFieldValue);
  }

  @override
  void dispose() {
    // Limpiar el controlador cuando el widget se desmonte
    _controller.dispose();
    super.dispose();
  }

  // Función para actualizar el valor del campo de texto
  void _updateTextFieldValue() {
    setState(() {
      _textFieldValue =
          _controller.text; // Actualizar el valor del campo de texto
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handle Changes Page'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField con onChanged
            TextField(
              onChanged: (text) {
                setState(() {
                  _textFieldValue =
                      text; // Actualizar el valor del campo de texto
                });
                print('First text field: $text (${text.characters.length})');
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
            // TextField con TextEditingController
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your username',
              ),
            ),
            // Mostrar el valor del campo de texto en la interfaz
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Texto ingresado: $_textFieldValue',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Nueva página para recuperar el valor de un campo de texto
class RetrieveTextFieldPage extends StatefulWidget {
  const RetrieveTextFieldPage({super.key});

  @override
  State<RetrieveTextFieldPage> createState() => _RetrieveTextFieldPageState();
}

class _RetrieveTextFieldPageState extends State<RetrieveTextFieldPage> {
  // Controlador para manejar cambios en el campo de texto
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Limpiar el controlador cuando el widget se desmonte
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Field Page'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto con TextEditingController
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your text',
              ),
            ),
            const SizedBox(height: 20), // Espacio entre el campo y el botón
            // Botón para mostrar el valor del campo de texto
            ElevatedButton(
              onPressed: () {
                // Mostrar un AlertDialog con el valor del campo de texto
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content:
                          Text(_controller.text), // Mostrar el texto ingresado
                    );
                  },
                );
              },
              child: const Text('Show Text Value'),
            ),
          ],
        ),
      ),
    );
  }
}
