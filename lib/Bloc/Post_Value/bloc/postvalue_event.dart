part of 'postvalue_bloc.dart';

@immutable
sealed class PostvalueEvent {
  const PostvalueEvent();
}

class PostvalueButtonpressed extends PostvalueEvent {
  final int itransid;
  final String docdate;
  final String project;
  final String projectdes;
  final String location;
  final int userid;
  final  signature;

  final String observation;
  final String risklevel;
  final String actionreq;
  final String actionby;
  final String targetdate;
  final  image;

  PostvalueButtonpressed(
      {required this.itransid,
      required this.docdate,
      required this.project,
      required this.projectdes,
      required this.location,
      required this.userid,
      required this.signature,
      required this.observation,
      required this.risklevel,
      required this.actionreq,
      required this.actionby,
      required this.targetdate,
      required this.image});
}
