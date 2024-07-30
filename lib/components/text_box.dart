import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const TextBox({super.key, required this.text, required this.sectionName, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(6, 91, 0, 0),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
      padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionName,
                style: const TextStyle(color: Color.fromARGB(255, 173, 173, 173)),
              ),
              Text(text),
            ],
          ),
          IconButton(
            onPressed: onPressed,  
            icon: const Icon(Icons.settings),
            color: const Color.fromARGB(255, 173, 173, 173),
          ),
        ],
      ),
    );
  }
}
