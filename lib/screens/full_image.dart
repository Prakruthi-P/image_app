import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImage({Key? key, required this.imageUrls, this.initialIndex = 0}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool isTapped=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Image'),
      ),
      body: PageView.builder(
        itemCount: widget.imageUrls.length,
        controller: PageController(initialPage: widget.initialIndex),
        itemBuilder: (context, index) {
          return GestureDetector(

            child: AnimatedContainer(
              duration: Duration(milliseconds: 5000),
              curve: Curves.easeInOut,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 2.5,
                backgroundDecoration: BoxDecoration(color: Colors.black),
                enableRotation: true,
                loadingBuilder: (context, event) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
