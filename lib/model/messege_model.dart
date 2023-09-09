class MessageModel {
  MessageModel({
    this.id,
    required this.message,
    required this.attachments,
    required this.users,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.updatedAt,
  });
  String? id;
  late final Message message;
  late final List<String?> attachments;
  late final List<String> users;
  late final String sender;
  late final String receiver;
  late final String createdAt;
  late final String updatedAt;
  
  MessageModel.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    message = Message.fromJson(json['message']);
    attachments = List.castFrom<dynamic, String>(json['attachments']);
    users = List.castFrom<dynamic, String>(json['users']);
    sender = json['sender'];
    receiver = json['receiver'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['message'] = message.toJson();
    _data['attachments'] = attachments;
    _data['users'] = users;
    _data['sender'] = sender;
    _data['receiver'] = receiver;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class Message {
  Message({
    required this.text,
  });
  late final String text;
  
  Message.fromJson(Map<String, dynamic> json){
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['text'] = text;
    return _data;
  }
}