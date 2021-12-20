import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/step_model.dart';

class StepBox extends StatelessWidget {
  const StepBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("buil2d");
    return SizedBox(
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
                          context.watch<StepModel>().getTodaySteps().toString(),
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
                            style: TextStyle(color: Colors.white, fontSize: 28),
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
  }
}
