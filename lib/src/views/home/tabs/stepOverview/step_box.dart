import 'package:flutter/material.dart';

Widget createStepBox(String steps, BuildContext context) => SizedBox(
      width: 500,
      height: 200,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: const [
                          Text(
                            "Steps today",
                            style: TextStyle(
                                color: Colors.white, fontSize: 28),
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
