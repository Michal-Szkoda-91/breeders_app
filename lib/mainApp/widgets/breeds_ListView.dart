import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../mainApp/screens/race_list_screen.dart';
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
                    builder: (context) => RaceListScreen(
                      name: breedingsList[index].name,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 0,
                color: Theme.of(context).primaryColor,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          breedingsList[index].pictureUrl,
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.width * 0.30,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AutoSizeText(
                              breedingsList[index].name,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textSelectionColor,
                              ),
                            ),
                            AutoSizeText(
                              "Liczba zwierzaków:",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: 25,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              // child: Text(
                              //   _breedingsList[index].animals.length.toString(),
                              //   style: TextStyle(
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ),
                          ],
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
