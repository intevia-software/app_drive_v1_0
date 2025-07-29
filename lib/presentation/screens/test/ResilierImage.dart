import 'package:flutter/material.dart';


class ResilientImage extends StatefulWidget {
  final String imageUrl;

  const ResilientImage({super.key, required this.imageUrl});

  @override
  State<ResilientImage> createState() => _ResilientImageState();
}

class _ResilientImageState extends State<ResilientImage> {
  int retry = 0;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageUrl,
      key: ValueKey('${widget.imageUrl}_$retry'),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              retry++;
            });
          }
        });

        return Column(
          children: [
            Icon(Icons.refresh, color: Colors.grey, size: 40),
            Text(
              'Chargement échoué... nouvelle tentative',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        );
      },
    );
  }
}
