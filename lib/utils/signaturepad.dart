import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignutureScreen extends StatefulWidget {
  const SignutureScreen({super.key});

  @override
  State<SignutureScreen> createState() => _SignutureScreenState();
}

class _SignutureScreenState extends State<SignutureScreen> {

  SignatureController signutureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.white,

  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
    children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height*0.9,
        child: Signature(
          backgroundColor: Colors.black,
          height: MediaQuery.sizeOf(context).height*0.9,
          width: MediaQuery.sizeOf(context).width,
          controller: signutureController),
        // child: SfSignaturePad(
        //   // key: _signaturePadKey,
        //   backgroundColor: Colors.black,
        //   strokeColor: Colors.white,
        //   minimumStrokeWidth: 4.0,
        //   maximumStrokeWidth: 6.0,
        // ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () async{
                if(signutureController.isNotEmpty){
                  final signuture = await exportSignuture();
                  if(signuture.isNotEmpty){
                    Navigator.pop(context,signuture);
                  }
                }
              },
              icon: Icon(
                Icons.done,
                color: Colors.black,
                size: 50,
              )),
          IconButton(
              onPressed: () {
                signutureController.clear();
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 50,
              ))
        ],
      )
    ],
  )
    );
  }

  Future<Uint8List> exportSignuture()async{
    final exportController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: signutureController.points
    );

    final signuture = await exportController.toPngBytes();
    exportController.dispose();
    return signuture!;
  }
}