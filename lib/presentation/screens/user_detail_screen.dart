import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_detail/user_detail_bloc.dart';
import '../../blocs/user_detail/user_detail_event.dart';
import '../../blocs/user_detail/user_detail_state.dart';
import '../../data/services/api_service.dart';
import '../../models/user_model.dart';
import '../../presentation/screens/create_post_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDetailBloc(apiService: ApiService())..add(LoadUserDetail(user.id)),
      child: Scaffold(
        appBar: AppBar(title: Text('${user.firstName}\'s Details')),
        body: BlocBuilder<UserDetailBloc, UserDetailState>(
          builder: (context, state) {
            if (state is UserDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is UserDetailLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                    ),
                    const SizedBox(height: 16),
                    Text('Posts:', style: Theme.of(context).textTheme.titleLarge),
                    ...state.posts.map((post) => ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.body),
                        )),
                    const Divider(),
                    Text('Todos:', style: Theme.of(context).textTheme.titleLarge),
                    ...state.todos.map((todo) => CheckboxListTile(
                          title: Text(todo.todo),
                          value: todo.completed,
                          onChanged: null,
                        )),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(user: user),
      ),
    );
  },
  child: const Icon(Icons.add),
),

      ),
    );
  }
}
