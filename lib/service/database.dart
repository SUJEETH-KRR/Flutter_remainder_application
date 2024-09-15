import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addTodoDetails(Map<String, dynamic> todoInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("ToDo")
        .doc(id)
        .set(todoInfoMap);
  }
  // This function is to create a new Collection named ToDo and stores the data in firestore DB.
  // Here Map data structure is used with type <String, dynamic> as the input will be stored in DB in String dynamic format
  // Async Await is used to get the and only after this it will store it in the FireBase DB instance

  Future<Stream<QuerySnapshot>> getTodoDetails() async {
    return await FirebaseFirestore.instance.collection("ToDo").snapshots();
  }
  // This function is used to get the ToDo details from the collection
  // Here Stream is used to get the details from DB and QuerySnapshot is used to query all the details(documents) in the DB

}