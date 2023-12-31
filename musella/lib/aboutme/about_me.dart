// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:musella/widgit/bottom_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  Future<void> _launchURL(String url) async {
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
        title: Text('About Me'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              // You can replace the backgroundImage with your own image
              backgroundImage: AssetImage('assets/profile_me.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              'Sumit Sinha',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Software Developer',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'About Me:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Just a Weeb from Assam.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Social Links:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Display clickable social links
            InkWell(
              onTap: () => _launchURL('https://github.com/Misenpai'),
              child: Text(
                'GitHub: github.com/Misenpai',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: () => _launchURL('https://www.instagram.com/misenpai_/'),
              child: Text(
                'Instagram: twitter.com/misenpai_',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 8),
            // Display clickable social links
            InkWell(
              onTap: () => _launchURL('https://twitter.com/Misenpai_'),
              child: Text(
                'Twitter: twitter.com/Misenpai_',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            // Add more social links as needed
          ],
        ),
      ),
    );
  }
}
