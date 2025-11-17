import 'package:flutter/material.dart';

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({Key? key}) : super(key: key);

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final List<_ChatMsg> _msgs = [
    _ChatMsg(text: 'Hi, I am on my way', fromMe: false, time: DateTime.now().subtract(const Duration(minutes: 5))),
    _ChatMsg(text: 'Thanks — please call me when you arrive', fromMe: true, time: DateTime.now().subtract(const Duration(minutes: 4))),
  ];
  final TextEditingController _ctl = TextEditingController();
  final ScrollController _sc = ScrollController();

  void _send(String t) {
    final text = t.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_ChatMsg(text: text, fromMe: true, time: DateTime.now()));
    });
    _ctl.clear();
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _msgs.add(_ChatMsg(text: 'Acknowledged: "$text"', fromMe: false, time: DateTime.now()));
      });
      _scrollToEnd();
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sc.hasClients) {
        _sc.animateTo(_sc.position.maxScrollExtent + 80, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _ctl.dispose();
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat'), backgroundColor: Colors.deepOrange),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _sc,
              padding: const EdgeInsets.all(12),
              itemCount: _msgs.length,
              itemBuilder: (c, i) {
                final m = _msgs[i];
                return Align(
                  alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: m.fromMe ? Colors.deepOrange : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(m.text, style: TextStyle(color: m.fromMe ? Colors.white : Colors.black87)),
                        const SizedBox(height: 6),
                        Text('${m.time.hour.toString().padLeft(2,'0')}:${m.time.minute.toString().padLeft(2,'0')}', style: TextStyle(color: m.fromMe ? Colors.white70 : Colors.black45, fontSize: 11)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctl,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _send,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () => _send(_ctl.text),
                    mini: true,
                    backgroundColor: Colors.deepOrange,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMsg {
  final String text;
  final bool fromMe;
  final DateTime time;
  _ChatMsg({required this.text, required this.fromMe, required this.time});
}