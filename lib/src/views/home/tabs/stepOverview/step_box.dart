import 'package:flutter/material.dart';

Widget createStepBox(String steps, {String stepsGoal = "6000"}) => SizedBox(
      width: 500,
      height: 200,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              color: const Color.fromARGB(0xFF, 0x34, 0x34, 0x34),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          steps,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 70),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "/$stepsGoal",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 35),
                          )
                        ],
                      ),
                      Column(
                        children: const [
                          Icon(
                            Icons.sports_score,
                            color: Colors.white,
                            size: 40,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
