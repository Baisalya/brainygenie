enum ChatType{user,bot}
class ChatMessage{
  String? text;
  ChatType ? type;
  ChatMessage({required this.text,required this.type});
}