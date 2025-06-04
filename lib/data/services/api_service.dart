import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/user_model.dart';
import '/models/post_model.dart';
import '/models/todo_model.dart';

class ApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<List<User>> fetchUsers({int limit = 10, int skip = 0, String? search}) async {
    final query = search != null && search.isNotEmpty
        ? '/users/search?q=$search'
        : '/users?limit=$limit&skip=$skip';

    final response = await http.get(Uri.parse('$baseUrl$query'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List users = jsonData['users'];
      return users.map((u) => User.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Post>> fetchUserPosts(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/user/$userId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List posts = jsonData['posts'];
      return posts.map((p) => Post.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Todo>> fetchUserTodos(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/todos/user/$userId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List todos = jsonData['todos'];
      return todos.map((t) => Todo.fromJson(t)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
