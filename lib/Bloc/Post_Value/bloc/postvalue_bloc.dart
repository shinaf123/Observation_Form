import 'dart:convert';
import 'dart:developer';
// import 'dart:html';
import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'postvalue_event.dart';
part 'postvalue_state.dart';

class PostvalueBloc extends Bloc<PostvalueEvent, PostvalueState> {

  PostvalueBloc() : super(PostvalueInitial()) {
    on<PostvalueEvent>((event, emit) async {

   
      try {
        final response = await http.post(
            Uri.parse("http://103.120.178.195/Sang.Ray.Mob.Api/Ray/PostHSE"),
            headers: {
               'Content-Type': 'application/x-www-form-urlencoded' 
            },
        
            body:jsonEncode({
              
              "iTransId": "0",
              "DocDate": "2023-10-07",
              "Project": "306",
              "ProjectDes": "123",
              "Location": "Loc1",
              "UserId": "3",
             "Signature": "sign121.jpg",
            "Body": [
              {
                "Observation": "Test",
                "RiskLevel": "2",
                "ActionReq": "User1",
                "ActionBy": "37",
                "TargetDate": "2023-02-04",
                "Images": "1.jpg"
              },
              {
                "Observation": "Test",
                "RiskLevel": "2",
                "ActionReq": "Test1",
                "ActionBy": "17",
                "TargetDate": "2023-02-04",
                "Images": "3.jpg"
              }
          ]
            
           })
        
            );

        // log(response.body.toString() +response.statusCode.toString());

        // print("resssssss=== ${response.body.toString()}");
          log(response.body.toString());
          print("RRRRRRRR${response.body.toString()}");

        if (response.statusCode == 200) {
          emit(PostvalueSuccess());
        } else {
          final errorMessege = response.body;
          print("responsee $response");
          emit(PostvalueFailure(error: errorMessege));
        }
      } catch (error) {
        log("error :$error");

        emit(PostvalueFailure(error: error.toString()));
      }
    });
  }
}
