import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_detail/user_detail_bloc.dart';
import '../../blocs/user_detail/user_detail_event.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

class CreatePostScreen extends StatefulWidget {
  final User user;

  const CreatePostScreen({super.key, required this.user});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: widget.user.id,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        isLocal: true,
      );

      context.read<UserDetailBloc>().add(AddLocalPost(post));
      Navigator.pop(context); // Go back to detail screen
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Body is required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPost,
                child: const Text('Add Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
