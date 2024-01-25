part of 'postvalue_bloc.dart';

@immutable
sealed class PostvalueState {}

final class PostvalueInitial extends PostvalueState {}

class PostvalueLoading extends PostvalueState{}

class PostvalueSuccess extends PostvalueState{

}

class PostvalueFailure extends PostvalueState{
  final String error;

  PostvalueFailure({required this.error});

  @override
  List<Object> get props =>[error];
}
