import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  int selectedDay = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xffF6F7FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Calendar",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "July 2026",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                dayWidget("Mon",29),
                dayWidget("Tue",30),
                dayWidget("Wed",1),
                dayWidget("Thu",2),
                dayWidget("Fri",3),
                dayWidget("Sat",4),
                dayWidget("Sun",5),

              ],
            ),

            const SizedBox(height: 30),

            Text(
              "Tasks for $selectedDay July",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("tasks")
                    .snapshots(),

                builder: (context,snapshot){

                  if(!snapshot.hasData){
                    return const Center(
                      child:CircularProgressIndicator(),
                    );
                  }

                  final tasks=snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: tasks.length,

                    itemBuilder:(context,index){

                      final task=tasks[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom:15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: ListTile(

                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade50,
                            child: const Icon(
                              Icons.calendar_today,
                              color: Colors.teal,
                            ),
                          ),

                          title: Text(task["title"]),

                          subtitle: Text(
                            "${task["category"]} • ${task["time"]}",
                          ),
                        ),
                      );

                    },
                  );

                },
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget dayWidget(String day,int date){

    final selected=date==selectedDay;

    return GestureDetector(

      onTap: (){
        setState(() {
          selectedDay=date;
        });
      },

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal:16,
          vertical:10,
        ),

        decoration: BoxDecoration(
          color: selected
              ? const Color(0xff2E8B72)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(18),
        ),

        child: Column(

          children: [

            Text(
              day,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.grey,
              ),
            ),

            const SizedBox(height:5),

            Text(
              "$date",
              style: TextStyle(
                fontSize:20,
                fontWeight: FontWeight.bold,
                color: selected
                    ? Colors.white
                    : Colors.black,
              ),
            ),

          ],
        ),
      ),
    );
  }
}