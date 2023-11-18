import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? artist;
  final VoidCallback? onTap;

  const MiniPlayer({
    Key? key,
    this.imageUrl,
    this.title,
    this.artist,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If imageUrl, title, and artist are null, return an empty Container
    if (imageUrl == null && title == null && artist == null) {
      return Container();
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: Colors.orange,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Handle image load failure
                  return SizedBox(width: 50, height: 50);
                },
              ),
            if (title != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title!,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            if (onTap != null)
              IconButton(
                onPressed: onTap!,
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
