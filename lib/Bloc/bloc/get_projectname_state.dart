part of 'get_projectname_bloc.dart';

sealed class GetProjectnameState extends Equatable {
  const GetProjectnameState();
  
  @override
  List<Object> get props => [];
}

final class GetProjectnameInitial extends GetProjectnameState {}
