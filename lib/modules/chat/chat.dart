import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_message.dart';
import 'chat_provider.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with recruiters!',
          style: GoogleFonts.pacifico(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: Consumer<ChatProvider>(
          //     builder: (context, chatProvider, _) {
          //       return ListView.builder(
          //         itemCount: chatProvider.messages.length,
          //         itemBuilder: (context, index) {
          //           ChatMessage message = chatProvider.messages[index];
          //           return ListTile(
          //             title: Text(message.sender),
          //             subtitle: Text(message.content),
          //             trailing: Text(message.timestamp.toIso8601String()),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: _textController,
          //           decoration: InputDecoration(
          //             hintText: 'Type a message...',
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.send),
          //         onPressed: () {
          //           context
          //               .read<ChatProvider>()
          //               .sendMessage(_textController.text);
          //           _textController.clear();
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
