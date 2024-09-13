import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String url;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.url,
  });

  Future<void> _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.black54,
                    height: 1.5, // Improve readability
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _launchURL,
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent, // Button color
                onPrimary: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 5, // Shadow for depth
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Read Full Article'),
            ),
          ],
        ),
      ),
    );
  }
}
