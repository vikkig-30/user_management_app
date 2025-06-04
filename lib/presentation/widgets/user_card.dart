import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../screens/user_detail_screen.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.image),
      ),
      title: Text(user.fullName),
      subtitle: Text(user.email),
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserDetailScreen(user: user),
            ),
          );
        }
    );
  }
}
