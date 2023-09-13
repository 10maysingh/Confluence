import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection=
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection=
  FirebaseFirestore.instance.collection("groups");



  Future savingUserData(String fullName, String email)async{
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilepic": "",
      "uid":uid,
    });

  }

  Future gettingUserData(String email) async{
    QuerySnapshot snapshot= await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }

  Future createGroup(String userName, String id, String groupName) async{
    DocumentReference groupDocumentReference= await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members":[],
      "groupId":"",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["{uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  getChats(String groupId) async{
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  getGroupMembers(groupId) async{
    return groupCollection.doc(groupId).snapshots();

  }
}