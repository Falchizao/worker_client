import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scarlet_graph/helper/helper_function.dart';
import 'package:scarlet_graph/services/firebase_auth.dart';

import '../utils/handler.dart';
import '../utils/requests.dart';
import 'jwtservice.dart';

class DatabaseService {
  String? uid;
  DatabaseService({this.uid});
  String cryptedPass = '';
  String targetEmail = '';

  // reference for our collections
  AuthService authService = AuthService();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving the userdata
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  instantiateGroup(String username, String groupname) {
    uid = FirebaseAuth.instance.currentUser!.uid;
    createGroup(username, FirebaseAuth.instance.currentUser!.uid, groupname);
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    String ownerName = '';
    await HelperFunctions.getUserNameFromSF().then((val) {
      ownerName = val ?? '';
    });

    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$ownerName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${id}_$ownerName"]),
      "groupId": groupDocumentReference.id,
    });

    // ADD O NOVO
    //String useruid = await getUserInfoByName(userName);
    //toggleGroupJoin(groupDocumentReference.id, userName, groupName, useruid);

    //await getBackToMainUser();

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  Future<String> getUserInfoByName(String username) async {
    await fetchUserPassword(username);

    await authService.loginWithUserNameandPassword(targetEmail, cryptedPass);

    await authService.loginFirebase(username, cryptedPass, Get.context!);
    return uid = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> getBackToMainUser() async {
    String? myEmail = await HelperFunctions.getUserEmailFromSF();
    String? myPassword = await HelperFunctions.getUserPasswordSF();

    await authService.loginWithUserNameandPassword(myEmail!, myPassword!);
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName, String uidUser) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uidUser);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uidUser}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uidUser}_$userName"])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  Future<void> fetchUserPassword(String username) async {
    dynamic token = await JwtService().getToken();
    var url = '$BASE_URL/user/findByUsername?name=$username';

    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final userDetails = jsonDecode(response.body);
      cryptedPass = userDetails['password'];
      targetEmail = userDetails['email'];
    } else {
      handleToast("Error fetching user data");
    }
  }
}





// createGroup(String username, String offer_title) {
//   DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
//       .createGroup(username, FirebaseAuth.instance.currentUser!.uid,
//           'Offer ${offer_title} $username')
//       .whenComplete(() {
//     handleToast('A chat was created, now you can talk with the user');
//   });
// }
