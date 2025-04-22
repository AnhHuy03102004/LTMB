import 'package:flutter/material.dart';

class ImageDemo extends StatelessWidget {
  const ImageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images Flutter'),
      ),
      body: Center(
        child: Row(
          // Dàn đều các ảnh theo chiều ngang
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Sử dụng Expanded để ảnh dàn đều trong hàng
            Expanded(
              child: Image.asset(
                'assets/images/image_1.png',
                width: 130,
                height: 150,
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/image_2.png',
                width: 130,
                height: 150,
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/image_3.png',
                width: 130,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
