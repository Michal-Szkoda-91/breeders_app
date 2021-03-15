import 'package:auto_size_text/auto_size_text.dart';
import 'package:breeders_app/mainApp/animals/parrots/screens/parrot_race_list_screen.dart';
import 'package:flutter/material.dart';

import '../models/breedings_model.dart';

class BreedsListView extends StatelessWidget {
  final List<BreedingsModel> breedingsList;

  const BreedsListView(this.breedingsList);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        shrinkWrap: true,
        itemCount: breedingsList.length,
        itemBuilder: (context, index) {
          return Container(
            height: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParrotsRaceListScreen(
                      name: breedingsList[index].name,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 0,
                color: Theme.of(context).backgroundColor,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            breedingsList[index].pictureUrl,
                          ),
                          radius: 45,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: AutoSizeText(
                          breedingsList[index].name,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textSelectionColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
