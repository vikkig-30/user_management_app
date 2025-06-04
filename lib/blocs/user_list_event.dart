import 'package:equatable/equatable.dart';

abstract class UserListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Load users for first time or when scrolling
class LoadUsers extends UserListEvent {
  final bool isRefresh;

  LoadUsers({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

// Search users by name
class SearchUsers extends UserListEvent {
  final String query;

  SearchUsers(this.query);

  @override
  List<Object?> get props => [query];
}
