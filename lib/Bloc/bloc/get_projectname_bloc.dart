import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_projectname_event.dart';
part 'get_projectname_state.dart';

class GetProjectnameBloc extends Bloc<GetProjectnameEvent, GetProjectnameState> {
  GetProjectnameBloc() : super(GetProjectnameInitial()) {
    on<GetProjectnameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
