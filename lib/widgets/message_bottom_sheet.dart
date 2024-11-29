
// New MessageBottomSheet widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBottomSheet extends StatelessWidget {
  final VoidCallback onSend;
  final TextEditingController messageController;

  const MessageBottomSheet({
    Key? key,
    required this.onSend,
    required this.messageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Message Seller',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onSend,
            icon: Icon(Icons.send),
            label: Text('Send Message'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}