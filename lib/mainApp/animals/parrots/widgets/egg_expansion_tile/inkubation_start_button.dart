import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InkubationStartButton extends StatelessWidget {
  const InkubationStartButton({
    required this.countData,
    required this.setEggsDate,
  });

  final Function countData;
  final Function setEggsDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black45,
      ),
      child: TextButton.icon(
        icon: Icon(
          Icons.add,
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
        onPressed: () {
          countData();
          showDatePicker(
            context: context,
            locale: const Locale("pl", "PL"),
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            cancelText: "Anuluj",
          ).then((date) {
            if (date == null) {
              return;
            } else {
              setEggsDate(
                  DateFormat("yyyy-MM-dd", 'pl_PL').format(date).toString());
            }
          });
        },
        label: Text(
          "Start inkubacji",
          style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
