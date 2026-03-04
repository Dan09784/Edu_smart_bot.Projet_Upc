import 'package:flutter/material.dart';

class ChatAiScreen extends StatefulWidget {
  const ChatAiScreen({super.key});

  @override
  State<ChatAiScreen> createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  final TextEditingController controller = TextEditingController();
  final List<String> messages = [];
  void sendMessage() {
    if (controller.text.isEmpty) return;

    setState(() {
      messages.add("{$controller.text}");
      messages.add("Reponse IA simulee pour l'u=instant");
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assistant IA")
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(messages[index]));
            },
          ),
          ),
          Padding(padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText:"Pose ta preocupation", 
                ),
              ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
                ),
            ],
          ),
          )
        ],
      ),
    );
  }
}
