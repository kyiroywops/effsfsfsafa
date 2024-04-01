import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscordDialog extends StatelessWidget {
  final String discordUrl;

  DiscordDialog({required this.discordUrl});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      title: const Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Icon(
          Icons.discord, // Aquí puedes usar el icono de Discord
          color: Colors.black,
          size: 68.0,
        ),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Hey gym friends! Join our Discord community.',
              style: TextStyle(fontFamily: 'Geologica', fontWeight: FontWeight.w900, fontSize: 15),
            ),
          ),
          SizedBox(height: 8),
          Text(
                'We’ve just launched a new app made with you in mind. Share your ideas and feedback with us, and let’s grow this app into something amazing that benefits us all. Let’s get stronger together!',

            style: TextStyle(fontFamily: 'Geologica', fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('close', style: TextStyle(fontFamily: 'Geologica', fontWeight: FontWeight.w800, fontSize: 12)),
        ),
        ElevatedButton(
          onPressed: () async {
            if (await canLaunch(discordUrl)) {
              await launch(discordUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Something went wrong. :(')),
              );
            }
          },
          child: const Text('Open Discord', style: TextStyle(fontFamily: 'Geologica', fontWeight: FontWeight.w600, fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
