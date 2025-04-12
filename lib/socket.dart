import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dio/dio.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    connectToSocket();
  }

  void connectToSocket() {
    socket = IO.io(
      'http://10.0.2.2:3000/message',  // تأكد من المسار الصحيح
      IO.OptionBuilder()
          .setTransports(['websocket']) // تحديد وسيلة الاتصال
          .disableAutoConnect() // لا يتم الاتصال بشكل تلقائي
          .setTimeout(5000) // 5 ثواني
          .build()
    );

    // يبدأ الاتصال بعد التهيئة
    socket.connect();

    socket.onConnect((_) {
      print('Connected to server');
    });

    socket.onDisconnect((_) {
      print('Disconnected');
      socket.connect();
    });

    socket.on('newMessage', (data) {
      // عندما يصل حدث "newMessage" من الخادم
      setState(() {
        messages.add({
          'user': data['user'], // اسم المرسل
          'message': data['message'], // نص الرسالة
        });
      });
    });
  }

  void sendMessage() async {
    if (_controller.text.isNotEmpty) {
      // إعداد الرسالة التي سيتم إرسالها
      final msg = {
        'senderId': '67fa9dfbc45b096852c3bd9e', // ID المرسل
        'receiverId': '670bd229ab1696d7a2dc177f', // ID المستقبل
        'hostId': '670bd8d4ab1696d7a2dc1786',  // ID الخاص بالـ host
        'content': _controller.text,  // نص الرسالة
      };

      try {
        // إرسال POST request باستخدام Dio
        final response = await dio.post(
          'http://10.0.2.2:3000/messages',  // تأكد من المسار الصحيح
          data: msg,
        );

        if (response.statusCode == 201) {
          print("Message sent successfully!");
          
          // إرسال الرسالة عبر Socket.IO بعد إرسالها بنجاح
          socket.emit('sendMessage', msg);

          setState(() {
            messages.add({
              'user': 'Rabab', // اسم المرسل
              'message': _controller.text, // نص الرسالة
            });
            _controller.clear(); // مسح النص بعد الإرسال
          });
        } else {
          print("Failed to send message: ${response.statusMessage}");
        }
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }

  @override
  void dispose() {
    // تأكد من إغلاق الاتصال عند الخروج من الشاشة
    socket.disconnect();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Booking')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg['user'] == 'Rabab'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: msg['user'] == 'Rabab'
                          ? Colors.blue[200]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${msg['user']}: ${msg['message']}'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
