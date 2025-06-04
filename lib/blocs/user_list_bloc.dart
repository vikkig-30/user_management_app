import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';
import '../../data/services/api_service.dart';
import '../../models/user_model.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final ApiService apiService;

  int limit = 10;
  int skip = 0;
  bool isFetching = false;
  String? currentQuery;

  UserListBloc({required this.apiService}) : super(UserListInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserListState> emit) async {
    if (isFetching) return;
    isFetching = true;

    try {
      if (event.isRefresh || state is! UserListSuccess) {
        emit(UserListLoading());
        skip = 0;
      }

      final users = await apiService.fetchUsers(limit: limit, skip: skip, search: currentQuery);
      skip += limit;

      final currentUsers = (state is UserListSuccess && !event.isRefresh)
          ? (state as UserListSuccess).users
          : <User>[];

      final allUsers = [...currentUsers, ...users];
      final hasReachedMax = users.length < limit;

      emit(UserListSuccess(users: allUsers, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(UserListError(e.toString()));
    }

    isFetching = false;
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<UserListState> emit) async {
    currentQuery = event.query;
    skip = 0;
    emit(UserListLoading());

    try {
      final users = await apiService.fetchUsers(limit: limit, skip: 0, search: event.query);
      emit(UserListSuccess(users: users, hasReachedMax: users.length < limit));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }
}
