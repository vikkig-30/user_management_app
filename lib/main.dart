import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/services/api_service.dart';
import 'blocs/user_list_bloc.dart';
import 'presentation/screens/user_list_screen.dart';
import 'blocs/user_list_event.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => UserListBloc(apiService: apiService)..add(LoadUsers()),
        child: UserListScreen(),
      ),
    );
  }
}
