import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class UserListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListSuccess extends UserListState {
  final List<User> users;
  final bool hasReachedMax;

  UserListSuccess({required this.users, required this.hasReachedMax});

  UserListSuccess copyWith({
    List<User>? users,
    bool? hasReachedMax,
  }) {
    return UserListSuccess(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [users, hasReachedMax];
}

class UserListError extends UserListState {
  final String message;

  UserListError(this.message);

  @override
  List<Object?> get props => [message];
}
