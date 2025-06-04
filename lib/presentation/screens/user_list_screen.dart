import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/user_list_bloc.dart';
import '/blocs/user_list_event.dart';
import '/blocs/user_list_state.dart';
import '../widgets/user_card.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserListBloc>().add(LoadUsers());

    _scrollController.addListener(() {
      final bloc = context.read<UserListBloc>();
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
          bloc.state is UserListSuccess &&
          !(bloc.state as UserListSuccess).hasReachedMax) {
        bloc.add(LoadUsers());
      }
    });

    _searchController.addListener(() {
      context.read<UserListBloc>().add(SearchUsers(_searchController.text.trim()));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserListBloc, UserListState>(
              builder: (context, state) {
                if (state is UserListLoading && state is! UserListSuccess) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserListError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is UserListSuccess) {
                  if (state.users.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.users.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index < state.users.length) {
                        final user = state.users[index];
                        return UserCard(user: user); // A widget we’ll define next
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
