// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  final double coverHeight = 280;
  final double profileHeight = 144;

  Future<void> _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfilePicture(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        width: double.infinity,
        height: coverHeight,
        child: Image.network(
          "https://i.pinimg.com/736x/7e/0a/a7/7e0aa718f6d1b148bd75d5b978431caf.jpg",
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfilePicture() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage('assets/profile_me.jpg'),
      );

  Widget buildContent() => Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            "Sumit Sinha",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSocialIcon(
                  FontAwesomeIcons.github, "https://github.com/Misenpai"),
              const SizedBox(
                width: 12,
              ),
              buildSocialIcon(FontAwesomeIcons.instagram,
                  "https://www.instagram.com/misenpai_/"),
              const SizedBox(
                width: 12,
              ),
              buildSocialIcon(
                  FontAwesomeIcons.xTwitter, "https://twitter.com/Misenpai_"),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const SizedBox(
            height: 16,
          ),
          buildAbout(),
          const SizedBox(
            height: 32,
          ),
        ],
      );
  Widget buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "About Me",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "Hello, I'm Sumit Sinha",
          style: TextStyle(fontSize: 16, height: 1.4),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildSocialIcon(IconData icon, String socialUrl) => CircleAvatar(
        radius: 25,
        child: Material(
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.orange,
          child: InkWell(
            onTap: () {
              _launchURL(socialUrl);
            },
            child: Center(
              child: Icon(
                icon,
                size: 32,
              ),
            ),
          ),
        ),
      );
}
