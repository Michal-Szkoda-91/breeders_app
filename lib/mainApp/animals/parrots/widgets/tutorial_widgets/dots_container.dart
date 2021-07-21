import 'package:flutter/material.dart';

class DotsContainer extends StatelessWidget {
  const DotsContainer({
    required this.screenNumber,
  });

  final int screenNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.05,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 7,
                    child: CircleAvatar(
                      backgroundColor: i + 1 == screenNumber
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).backgroundColor,
                      radius: 4,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
