import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todoapp/main.dart';
import 'package:flutter_todoapp/model/Task.dart';
import 'package:flutter_todoapp/model/TodosModel.dart';
import 'package:flutter_todoapp/utils/color.dart';
import 'package:flutter_todoapp/utils/dimentions.dart';
import 'package:provider/provider.dart';

class Addtodo extends StatefulWidget {
  AddtodoState createState() => AddtodoState();
}

class AddtodoState extends State<Addtodo> {
  final taskTitleController = TextEditingController();
  final description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ADD"),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: taskTitleController,
                  decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ContainerColor, width: 0.2),
                      ),
                      hintText: "Enter title",
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ContainerColor, width: 0.2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15)),
                ),
                SizedBox(height: twenty,),

                TextField(
                  controller: description,
                  decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ContainerColor, width: 0.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ContainerColor, width: 0.2),
                      ),
                      hintText: "Enter Description",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15)),
                ),

                InkWell(
                  child:  Padding(padding:EdgeInsets.only(top: twenty,left: twentyFive,right:twentyFive),
                    child: Container(
                        height: fifty,
                        decoration: BoxDecoration(borderRadius:BorderRadius.circular(five),color: ContainerColor),
                        child:Center(child: Text("Add",textAlign: TextAlign.center,style: TextStyle(color: whiteColor,fontSize: eighteen),),)
                    ),),
                  onTap: (){
                    getvalue();
                  },
                ),



              ],
            ),
          ),
        ));
  }

  Future<void> getvalue() async {
    try {
      DatabaseReference _userRef =
          FirebaseDatabase.instance.reference().child("todolist");
      _userRef.reference().push().set({
        'title': taskTitleController.text,
        'descreption': description.text,
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } on Exception catch (_) {
      throw FirebaseDatabase;
    }
  }
}
