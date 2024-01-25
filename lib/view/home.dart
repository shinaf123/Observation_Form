import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:obsarvation_form/Bloc/Post_Value/bloc/postvalue_bloc.dart';
import 'package:obsarvation_form/model/listmodel.dart';
import 'package:obsarvation_form/utils/custombutton.dart';
// import 'package:obsarvation_form/utils/custompopup.dart';
import 'package:obsarvation_form/utils/description_textfileld.dart';
import 'package:obsarvation_form/utils/signaturepad.dart';
import 'package:obsarvation_form/utils/textfiled.dart';
import 'dart:developer';

// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
List<ListModel> conditions = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];
  var _value;
  var _valuus;
  List descriptionData = [];
 

// ProjectAPICalling
  Future<void>getProject() async {
    final response = await http.get(
        Uri.parse('http://103.120.178.195/Sang.Ray.Mob.Api/Ray/GetProject'));
    // Map<String, dynamic> resp = jsonDecode(res.body);

    if (response.statusCode == 200) {
      // print('Resp body: ${res.body}');

      Map<String, dynamic> respo = jsonDecode(response.body);

      setState(() {
        data = jsonDecode(respo['ResultData']);
      });
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  }

// ProjectDescriptionAPICalling
   Future<void>getProjectDescription() async {
    final response = await http.get(
      Uri.parse(
        'http://103.120.178.195/Sang.Ray.Mob.Api/Ray/GetProjectDescription?iProject=2'));
    // Map<String, dynamic> respo = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('Response body: ======${response.body}');

      Map<String, dynamic> resp = json.decode(response.body);


       List<dynamic> resultData = jsonDecode(resp["ResultData"]);

        print("=========????????$resultData");
        // log(responsess.body.toString());

      setState(() {
        descriptionData = resultData;
      });
    } else {
      print('Failed to load data. Status code:======== ${response.statusCode}');
    }
  }


  TextEditingController dateInputController = TextEditingController();
  TextEditingController actionController = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TimeOfDay? time = const TimeOfDay(hour: 12, minute: 12);

  @override
  void initState() {
    timeinput.text = "";
    super.initState();
    getProject();
    getProjectDescription();
   
  }



  TextEditingController _typeController = TextEditingController();
  String? _typeSelectedValue;
  String? typeSelectedValue;
  String? valuess;

  TextEditingController actionByController = TextEditingController();
  List<String> type = ['Low', 'Medium', 'High'];

  Uint8List? signutureImage;

  @override
  Widget build(BuildContext context) {

    getProject();
    getProjectDescription();
    // getActionBy();
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: custombotton("Submit", () {

        //  BlocProvider.of<PostvalueBloc>(context).add(PostvalueButtonpressed(itransid: null));
        
        context.read<PostvalueBloc>().add(PostvalueButtonpressed(
          itransid: 0, 
          docdate: dateInputController.text, 
          project: _value.toString(), 
          projectdes: _valuus.toString(), 
          location: locationController.text, 
          userid: 3, 
          signature: signutureImage, 

          observation: descriptionController.text, 
          risklevel: valuess.toString(), 
          actionreq: actionController.text, 
          actionby: actionByController.toString(), 
          targetdate: dateInputController.toString(), 
          image: selectedImage));

          showDialog(context: context, builder: (context){
            return const AlertDialog(
              title: Text("successfull",style: TextStyle(fontStyle: FontStyle.italic),),
             icon: Icon(Icons.thumb_up_alt_sharp,size:50)  ,            
              
              shape: CircleBorder(side: BorderSide.none,eccentricity: 1.0),
            );

          });


        }, MediaQuery.sizeOf(context).width),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(Icons.arrow_back_ios_new),
        title: const Text(
          'HSE OBSERVATION FORM',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: DropdownButtonFormField(
                  items: data.map((e) {
                    return DropdownMenuItem(
                      child: Text(e['sName'] ?? "Project"),
                      value: e['iId'] ?? 0,
                    );
                  }).toList(),
                  value: _value,
                  onChanged: (v) {
                    // setState(() {
                      _value = v;
                    // });
                  },
                  decoration: InputDecoration(
                      // hintText: "(demo)",
                      labelText: "Project",
                      labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 138, 138, 138)),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 162, 163, 164),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 162, 163, 164),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      )),
                ),
              ),
   
              const SizedBox(
                height: 15,
              ),
              Center(
                child: DropdownButtonFormField(
                  items: descriptionData.map((e) {

                    return DropdownMenuItem(
                      
                      child: Text(e .toString()),
                      value: e .toString(),
                    );
                  }).toList(),
                  value: _valuus,
                  onChanged: (vv) {
                    // setState(() {
                      _valuus = vv;
                    // });
                  },
                  decoration: InputDecoration(
                    labelText: "Project Description",
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 138, 138, 138),
                    ),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 162, 163, 164),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 162, 163, 164),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              textfieledCustom(
                  'Location', locationController, TextInputType.emailAddress),
              const SizedBox(
                height: 15,
              ),

              TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    labelText: "Date of incident",
                    labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 138, 138, 138)),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 129, 128, 127))),
                  ),
                  controller: dateInputController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      dateInputController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400)),

              const SizedBox(
                height: 15,
              ),

              const SizedBox(
                height: 15,
              ),
              const Text(
                'General Condition :',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),

              const Divider(),
              const SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Text(
                      'Actions',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 77, 77, 77)),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Sl\nNo',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 77, 77, 77)),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                    Text(
                      'Observation/\nFindings',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 77, 77, 77)),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                    Text(
                      'Risk\nLevel',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 77, 77, 77)),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                    Text(
                      'Action',
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 77, 77, 77)),
                    )
                  ],
                ),
                // })),
              ),
              const Divider(),
              const SizedBox(
                height: 25,
              ),
           
              conditions.isEmpty
                  ? const Center(
                      child: Text(
                        'No data',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 138, 138, 138)),
                      ),
                    )
                  : SizedBox(
                      height: 100,
                      width: 410,
                      child: ListView.builder(
                        // scrollDirection:Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: conditions.length,
                        itemBuilder: (context, index) {
                          return 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              const Icon(
                                Icons.edit,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              const Text("1"),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                "${conditions[index].observation}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Text("${conditions[index].riskLevel}"),
                              const SizedBox(
                                width: 20,
                              ),
                              Text('${conditions[index].actionReq}')
                            ],
                          );
                        },
                      ),
                    ),

             
              // ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: custombotton('Add General Condition ', () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomPopUpWidget(context);
                      });
                }, 180),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Signature',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),

              Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 162, 163, 164))),
                  child: signutureImage == null
                  
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                signutureImage = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignutureScreen()));

                                setState(() {
                                  signutureImage;
                                });
                              },
                              child: const Icon(
                                Icons.upload_file,
                                size: 50,
                                color: Color.fromARGB(255, 138, 138, 138),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Upload Signature',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 138, 138, 138)),
                            )
                          ],
                        )
                      : Image.memory(
                          signutureImage!,
                          fit: BoxFit.fill,
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                        ))
            ],
          ),
        ),
      ),
    );
  }

//PopUpBar

  Uint8List? _images;
  File? selectedImage;

  Widget CustomPopUpWidget(
    BuildContext context,
  ) {
    return Dialog(
        child: Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: custombotton("Add", () {
          ListModel listModel = ListModel(
              observation: descriptionController.text,
              riskLevel: valuess,
              actionReq: actionController.text,
              actionBy: actionByController.toString(),
              targetDate: dateInputController.toString(),
              images: selectedImage);

          setState(() {
            conditions.add(listModel);
            print(conditions);
            descriptionController.clear();
            actionController.clear();
            actionByController.clear();
            dateInputController.clear();
            selectedImage?.delete();

            Navigator.pop(context);
          });
        }, MediaQuery.of(context).size.width),
      ),

      
      body: 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add General Condition',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
          
                  descriptionTextField(
                      'Observations / Findings', descriptionController),
          
                  const SizedBox(
                    height: 15,
                  ),
          
                  DropdownButtonFormField(
                    value: typeSelectedValue,
                    items: type
                        .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                        .toList(),
                    onChanged: (v) {
                      _typeSelectedValue = v;
                      _typeController.text = v!;
                      valuess = v;
                      print(valuess!);
                      // print("valuee$typeSelectedValue");
                      // print(_typeController());
                    },
                    decoration: InputDecoration(
                        hintText: "(Risk Level)",
                        labelText: "Risk Level",
                        hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 138, 138, 138)),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 162, 163, 164),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 162, 163, 164),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        )),
                  ),
                  // textfieledCustom(
                  //     '', actionsController, TextInputType.emailAddress),
                  const SizedBox(
                    height: 10,
                  ),
          
                  descriptionTextField('Action Required', actionController),
          
                  const SizedBox(
                    height: 10,
                  ),
                  // DropdownButtonFormField(
                  //   items: actionData.map((e) {
                  //     return DropdownMenuItem(
                  //       child: Text(e['sName'] ?? "ActionBy"),
                  //       value: e['iId'] ?? 0,
                  //     );
                  //   }).toList(),
                  //   value: _value,
                  //   onChanged: (vvv) {
                  //     setState(() {
                  //       _value = vvv as int;
                  //     });
                  //   },
                  //   decoration: InputDecoration(
                  //       // hintText: "(demo)",
                  //       labelText: "ActionBy",
                  //       labelStyle: const TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //           color: Color.fromARGB(255, 138, 138, 138)),
                  //       border: InputBorder.none,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: const BorderSide(
                  //           color: Color.fromARGB(255, 162, 163, 164),
                  //         ),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: const BorderSide(
                  //           color: Color.fromARGB(255, 162, 163, 164),
                  //         ),
                  //         borderRadius: BorderRadius.circular(16),
                  //       )),
                  // ),
          
                  const SizedBox(
                    height: 10,
                  ),
          
                  textfieledCustom('Employee Code', actionByController,
                      TextInputType.emailAddress),
                  const SizedBox(
                    height: 10,
                  ),
          
                  TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: "Target Date",
                        labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 138, 138, 138)),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 129, 128, 127))),
                      ),
                      controller: dateInputController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                        );
          
                        if (pickedDate != null) {
                          dateInputController.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)),
          
                  const SizedBox(
                    height: 15,
                  ),
          
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color.fromARGB(255, 162, 163, 164))),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            fit: BoxFit.fill,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {

                                  setState(() {
                                    _pickerImageFromGallery();
                                  });
                                  
                                },
                                child: const Icon(
                                  Icons.upload_file,
                                  size: 50,
                                  color: Color.fromARGB(255, 138, 138, 138),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Upload image',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 138, 138, 138)),
                              )
                            ],
                          ),
                  ),
          
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
      //   }
      // ),
    ));
  }

  //ImagePickerFromGaller
  Future _pickerImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _images = File(returnImage.path).readAsBytesSync();
    });
  }

 
}



