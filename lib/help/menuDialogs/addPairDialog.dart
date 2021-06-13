import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:flutter/material.dart';

class AddPairDialog {
  ScrollController _rrectController = ScrollController();
  showMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => new AlertDialog(
        insetPadding: const EdgeInsets.all(5.0),
        backgroundColor: Theme.of(context).backgroundColor,
        title: new Text(
          "Dodawanie / Usuwanie Par",
          style: TextStyle(color: Theme.of(context).textSelectionColor),
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: DraggableScrollbar.rrect(
            controller: _rrectController,
            heightScrollThumb: 100,
            backgroundColor: Theme.of(context).accentColor,
            child: SingleChildScrollView(
              controller: _rrectController,
              child: Container(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  child: Column(
                    children: [
                      createText(context,
                          "DODAJ PARĘ PAPUG do hodowli w ekranie parowania"),
                      createPicture(context, "assets/help/help_screen_7.png"),
                      createText(context,
                          "Wybierz samice i samca z wybranej rasy, jeśli nie ma możliwości wyboru dodaj najpierw odpowiednie papugi."),
                      createPicture(context, "assets/help/help_screen_8.png"),
                      createText(context,
                          "Wpisz kolor, wybierz datę parowania i ewentualnie dodaj zdjęcie aparatem lub z pamięci telefonu."),
                      createText(context,
                          "USUŃ parę wybierając odpowiedni przycisk na karcie PAR"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              "OK",
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  Widget createText(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: new Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).textSelectionColor),
      ),
    );
  }

  Widget createPicture(BuildContext context, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        child: Image.asset(
          url,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }
}
