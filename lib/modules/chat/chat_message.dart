class ChatMessage {
  final String sender;
  final String content;
  final DateTime timestamp;

  ChatMessage(
      {required this.sender, required this.content, required this.timestamp});
}
