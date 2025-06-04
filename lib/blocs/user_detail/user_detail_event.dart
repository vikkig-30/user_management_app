import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';


abstract class UserDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserDetail extends UserDetailEvent {
  final int userId;

  LoadUserDetail(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddLocalPost extends UserDetailEvent {
  final Post post;

  AddLocalPost(this.post);

  @override
  List<Object?> get props => [post];
}
