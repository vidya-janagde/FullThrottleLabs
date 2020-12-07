import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Task {
  var key;
  String title;
  String description;


  Task(this.key,this.title, this.description);

  Task.map(dynamic obj){
    title = obj.value['title'];
    description = obj.value['descreption'];
  }

  Task.fromsnapshot(DataSnapshot snapshot){
    key = snapshot.key;
    title = snapshot.value['title'];
    description = snapshot.value['descreption'];
 }

  toJson() {
  return {
    "title": title,
    "descreption": description
  };

  }
}