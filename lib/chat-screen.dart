
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final _fireStore = FirebaseFirestore.instance;
late User LoggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'Chat_Screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String messageText;

  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  final firestoreInstance = FirebaseFirestore.instance;

  Future getImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        uploadImage();
      } else {
        debugPrint('failed');
      }
    });
  }
  Future uploadImage() async {
    Reference ref = FirebaseStorage.instance.ref().child("images");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    debugPrint(downloadURL);
    await firestoreInstance.collection('messages').add({
      'sender' :LoggedInUser.email,
      'url': downloadURL,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        LoggedInUser = user;
        // print(LoggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  void messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                messagesStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('✨Chat App',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.purple),),
        backgroundColor: Colors.cyan,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      // _auth.signOut();
                      // Navigator.pop(context);
                      messageTextController.clear();
                      _fireStore.collection('messages').add(
                          {'text': messageText,
                            'sender': LoggedInUser.email,
                            'timestamp': FieldValue.serverTimestamp()}
                      );
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.add_a_photo_outlined),
                      onPressed: (){
                    getImage();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages')
          .orderBy('timestamp',
          descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
             return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.brown,
              ),
            );
        }
        else{
          final messages = snapshot?.data.docs;
          for(var message in messages){
            debugPrint('$message[]');
          }
          return Expanded(
            child: ListView.builder(
                reverse:true,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                itemCount: messages.length,
                itemBuilder: (context,position){
                  final messageText = messages[position].data()['text'];
                  final messageSender = messages[position].data()['sender'];
                  final currentUser = messageSender;
                  final imageUrl = messages[position].data()['url'];
                  return  MessageBubble(
                    sender:messageSender,
                    text:messageText?? '',
                    imageUrl:imageUrl ?? '',
                    isMe:currentUser == messageSender,
                  );
                }
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String imageUrl;
  const MessageBubble({super.key, required this.sender, required this.text, required this.isMe,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Image.network(''),
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black,
            ),
          ),
          Container(
            decoration: BoxDecoration( borderRadius: isMe
                ? const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
              // elevation: 5.0,
              color: isMe ? const Color(0xffa538e0) : const Color(0xffcb73fa),),

            child: Column(
              children: [
                if(imageUrl.isEmpty)
                  SizedBox()
                else
                  Image.network(imageUrl,height: 200,width: 200,),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    '$text',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}