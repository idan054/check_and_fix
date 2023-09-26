import 'package:flutter/material.dart';

class CustomizedButton extends StatelessWidget {
  final String image;
  final String title;
  final Function function;
  const CustomizedButton({Key? key, required this.image, required this.title, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        function();
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Image.asset(image),
            const Gap(
              width: 15,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gap extends StatelessWidget {
  final double height;
  final double width;
  const Gap({Key? key, this.height = 0, this.width = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}