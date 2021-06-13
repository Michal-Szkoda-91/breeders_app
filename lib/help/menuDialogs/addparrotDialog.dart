import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:flutter/material.dart';

class AddParrotDialog {
  ScrollController _rrectController = ScrollController();
  showMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => new AlertDialog(
        insetPadding: const EdgeInsets.all(5.0),
        backgroundColor: Theme.of(context).backgroundColor,
        title: new Text(
          "Dodawanie / Edycja / Usuwanie Papug",
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
                          "DODAJ PAPUGĘ do hodowli na głównym ekranie:"),
                      createPicture(context, "assets/help/help_screen_1.png"),
                      createText(context, "Wybierz interesującą Cię rasę:"),
                      createPicture(context, "assets/help/help_screen_2.png"),
                      createText(context, "A teraz uzupełnij wszystkie dane:"),
                      createPicture(context, "assets/help/help_screen_3.png"),
                      createText(context,
                          "EDYTUJ już istniejący wpis w ekranie hodolwi, przesuwając zwartość w bok:"),
                      createPicture(context, "assets/help/help_screen_4.png"),
                      createText(context,
                          "Aby USUNĄĆ jedną wybraną papugę należy na końcu tabeli w ekranie hodowli wybrać ikonę kosza:"),
                      createPicture(context, "assets/help/help_screen_5.png"),
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
