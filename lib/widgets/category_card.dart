import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {

  final Color color;

  final String title;

  final int tasks;

  const CategoryCard({
    super.key,
    required this.color,
    required this.title,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: 150,

      margin: const EdgeInsets.only(right: 15),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: color,

        borderRadius: BorderRadius.circular(25),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            "$tasks Tasks",
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          )
        ],
      ),
    );
  }
}