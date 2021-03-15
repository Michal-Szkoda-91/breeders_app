import 'package:breeders_app/mainApp/animals/parrots/models/parrot_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ParrotCard extends StatelessWidget {
  const ParrotCard({
    Key key,
    @required List<Parrot> createdParrotList,
  })  : _createdParrotList = createdParrotList,
        super(key: key);

  final List<Parrot> _createdParrotList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: _createdParrotList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 20,
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleRow(context, "Obrączka:", index, true),
                  _contentText(
                      index, context, _createdParrotList[index].ringNumber),
                ],
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(thickness: 3.0),
                    _titleRow(context, "Kolor:", index, false),
                    _contentText(
                        index, context, _createdParrotList[index].color),
                    Divider(thickness: 3.0),
                    _titleRow(context, "Rozczepienie:", index, false),
                    _contentText(
                        index, context, _createdParrotList[index].fission),
                    Divider(thickness: 3.0),
                    _titleRow(context, "Numer klatki:", index, false),
                    _contentText(
                        index, context, _createdParrotList[index].cageNumber),
                    Divider(thickness: 3.0),
                    _titleRow(context, "Notatki:", index, false),
                    _contentText(
                        index, context, _createdParrotList[index].notes),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _contentText(int index, BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _titleRow(BuildContext context, String text, int index, bool isFirst) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        isFirst ? _genderIcon(context, index) : Center(),
      ],
    );
  }

  Container _genderIcon(BuildContext context, int index) {
    Color colorBackground = Colors.greenAccent;
    Color colorIcon = Colors.green[700];
    IconData icon = MaterialCommunityIcons.help;

    if (_createdParrotList[index].sex == "Samiec") {
      colorBackground = Colors.blue[300];
      colorIcon = Colors.blue[700];
      icon = MaterialCommunityIcons.gender_male;
    } else if (_createdParrotList[index].sex == "Samica") {
      colorBackground = Colors.pink[300];
      colorIcon = Colors.pink[700];
      icon = MaterialCommunityIcons.gender_female;
    }

    return Container(
      width: 45,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorBackground,
        border: Border.all(
          color: Theme.of(context).textSelectionColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(35),
        ),
      ),
      child: Icon(icon, color: colorIcon),
    );
  }
}
