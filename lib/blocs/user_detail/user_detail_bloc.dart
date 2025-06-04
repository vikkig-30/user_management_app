import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';
import '../../data/services/api_service.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final ApiService apiService;

  UserDetailBloc({required this.apiService}) : super(UserDetailInitial()) {
    on<LoadUserDetail>(_onLoadUserDetail);

    // ✅ This must be inside the constructor!
    on<AddLocalPost>((event, emit) {
      if (state is UserDetailLoaded) {
        final currentState = state as UserDetailLoaded;
        final updatedPosts = [event.post, ...currentState.posts];
        emit(UserDetailLoaded(posts: updatedPosts, todos: currentState.todos));
      }
    });
  }

  Future<void> _onLoadUserDetail(
    LoadUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserDetailLoading());

    try {
      final posts = await apiService.fetchUserPosts(event.userId);
      final todos = await apiService.fetchUserTodos(event.userId);
      emit(UserDetailLoaded(posts: posts, todos: todos));
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }
}
