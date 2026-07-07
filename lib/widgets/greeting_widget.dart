import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(
            "https://i.pravatar.cc/300",
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              Text(
                "Good Morning 👋",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Tahmid",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),

        Icon(
          Icons.notifications_none,
          size: 30,
        )
      ],
    );
  }
}