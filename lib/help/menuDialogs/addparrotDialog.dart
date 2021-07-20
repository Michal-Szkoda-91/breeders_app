import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class AddParrotDialog {
  ScrollController _rrectController = ScrollController();
  showMaterialDialog(BuildContext context) {
    showAnimatedDialog(
      context: context,
      builder: (ctx) => SafeArea(
        child: new AlertDialog(
          insetPadding: const EdgeInsets.all(5.0),
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text(
            "Dodawanie / Edycja / Usuwanie Papug",
            style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: DraggableScrollbar.rrect(
              controller: _rrectController,
              heightScrollThumb: 100,
              backgroundColor: Theme.of(context).accentColor,
              child: ListView.builder(
                controller: _rrectController,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 5, right: 5),
                      child: Column(
                        children: [
                          createText(context,
                              "DODAJ PAPUGĘ do hodowli na głównym ekranie:"),
                          createPicture(
                              context, "assets/help/help_screen_1.png"),
                          createText(context, "Wybierz interesującą Cię rasę:"),
                          createPicture(
                              context, "assets/help/help_screen_2.png"),
                          createText(
                              context, "A teraz uzupełnij wszystkie dane:"),
                          createPicture(
                              context, "assets/help/help_screen_3.png"),
                          createText(context,
                              "Jeśli para ma potomstwo można dodać je do hodowli papug przesuwając tabelę w lewo i klikajać w odpowiedni przycisk."),
                          createPicture(
                              context, "assets/help/help_screen_13.png"),
                          createText(context,
                              "EDYTUJ już istniejący wpis w ekranie hodolwi, przesuwając zwartość tabeli Papug w bok:"),
                          createPicture(
                              context, "assets/help/help_screen_4.png"),
                          createText(context,
                              "Aby USUNĄĆ jedną wybraną papugę należy na końcu tabeli w ekranie hodowli wybrać ikonę kosza:"),
                          createPicture(
                              context, "assets/help/help_screen_5.png"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).backgroundColor,
              ),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      ),
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 1400),
    );
  }

  Widget createText(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: new Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor),
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
