import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getUserInfo(int usuarioId) async {
    try {
      final response = await _dio.get(
          'https://backend-smartwallet.onrender.com/api/usuarios/cookbook/info-user/$usuarioId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load user info: $e');
    }
  }
}

class ApiServiceJson {
  final Dio _dio = Dio();

  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio
          .get('https://backend-smartwallet.onrender.com/api/usuarios/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) {
          try {
            return User.fromJson(json);
          } catch (e) {
            print('Error parsing user: $e');
            print('JSON data: $json');
            throw Exception('Failed to parse user data');
          }
        }).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Failed to fetch users: $e');
    }
  }
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['usuario_id'],
      name: json['nombre_usuario'],
    );
  }
}

class ApiServiceDelete {
  final Dio _dio = Dio();

  // Método para eliminar un recurso por su ID
  Future<void> deleteResource(int usuarioId) async {
    try {
      final response = await _dio.delete(
        'https://backend-smartwallet.onrender.com/api/usuarios/delete/$usuarioId', // Cambia a la URL de tu API
      );

      // Verifica el código de estado de la respuesta
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Éxito: El recurso fue eliminado correctamente
        return;
      } else {
        // Error: Lanza una excepción con el código de estado
        throw Exception('Failed to delete resource: ${response.statusCode}');
      }
    } catch (e) {
      // Error en la solicitud
      throw Exception('Failed to delete resource: $e');
    }
  }
}

class ApiServiceNews {
  final Dio _dio = Dio();

  Future<List<Noticia>> fetchNoticias(String keyword) async {
    try {
      final response = await _dio.get(
        'https://backend-smartwallet.onrender.com/api/articles',
        queryParameters: {'keyword': keyword},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}

class Noticia {
  final String titulo;
  final String descripcion;
  final String? imagenUrl;
  final String fuente;
  final String fecha;

  Noticia({
    required this.titulo,
    required this.descripcion,
    this.imagenUrl,
    required this.fuente,
    required this.fecha,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['title'] ?? 'Sin título',
      descripcion: json['description'] ?? 'Sin descripción',
      imagenUrl: json['image_url'],
      fuente: json['source_id'] ?? 'Fuente desconocida',
      fecha: json['pubDate'] ?? 'Fecha desconocida',
    );
  }
}

class ApiServiceCreate {
  final Dio _dio = Dio();

  Future<void> createUsuario(
      String nombreUsuario, String email, String passwordUsuario) async {
    try {
      final response = await _dio.post(
        'https://backend-smartwallet.onrender.com/api/usuarios/register',
        data: Usuario(
          nombreUsuario: nombreUsuario,
          email: email,
          passwordUsuario: passwordUsuario,
        ).toJson(),
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 201) {
        // No necesitas devolver nada, solo confirmar que fue exitoso
        return;
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create usuario: $e');
    }
  }
}

class Usuario {
  final String nombreUsuario;
  final String email;
  final String passwordUsuario;

  Usuario({
    required this.nombreUsuario,
    required this.email,
    required this.passwordUsuario,
  });

  // Convierte el objeto Usuario en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre_usuario': nombreUsuario,
      'email': email,
      'password_usuario': passwordUsuario,
    };
  }

  // Convierte un mapa JSON en un objeto Usuario
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombreUsuario: json['nombre_usuario'],
      email: json['email'],
      passwordUsuario: json['password_usuario'],
    );
  }
}

class ApiServiceUpdate {
  static const String baseUrl = 'https://backend-smartwallet.onrender.com/api';
  final Dio _dio = Dio();

  // Método para obtener un usuario por ID usando Dio
  Future<UsuarioUpdate> fetchUsuario(int id) async {
    try {
      final response =
          await _dio.get('$baseUrl/usuarios/cookbook/info-user/$id');

      if (response.statusCode == 200) {
        return UsuarioUpdate.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load usuario');
      }
    } catch (e) {
      throw Exception('Failed to fetch usuario: $e');
    }
  }

  // Método para actualizar un usuario por ID usando Dio
  Future<String> updateUsuario(
      int id, String nombreUsuario, String email) async {
    try {
      final response = await _dio.put(
        '$baseUrl/usuarios/update/$id',
        data: {
          'nombre_usuario': nombreUsuario,
          'email': email,
        },
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      print('Respuesta de la API: ${response.data}'); // Depuración

      if (response.statusCode == 200) {
        // Devuelve el mensaje de la API
        return response.data['message'] as String;
      } else {
        throw Exception('Failed to update usuario');
      }
    } catch (e) {
      throw Exception('Failed to update usuario: $e');
    }
  }
}

class UsuarioUpdate {
  final int id;
  final String nombreUsuario;
  final String email;

  UsuarioUpdate({
    required this.id,
    required this.nombreUsuario,
    required this.email,
  });

  factory UsuarioUpdate.fromJson(Map<String, dynamic> json) {
    return UsuarioUpdate(
      id: json['usuario_id'],
      nombreUsuario: json['nombre_usuario'],
      email: json['email'],
    );
  }
}
