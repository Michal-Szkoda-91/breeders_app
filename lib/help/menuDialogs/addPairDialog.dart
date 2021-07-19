import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class AddPairDialog {
  ScrollController _rrectController = ScrollController();
  showMaterialDialog(BuildContext context) {
    showAnimatedDialog(
      context: context,
      builder: (ctx) => SafeArea(
        child: new AlertDialog(
          insetPadding: const EdgeInsets.all(5.0),
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text(
            "Dodawanie / Usuwanie Par",
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
                itemCount: 1,
                controller: _rrectController,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 5, right: 5),
                      child: Column(
                        children: [
                          createText(context,
                              "DODAJ PARĘ PAPUG do hodowli w ekranie parowania"),
                          createPicture(
                              context, "assets/help/help_screen_7.png"),
                          createText(context,
                              "Wybierz samice i samca z wybranej rasy, jeśli nie ma możliwości wyboru dodaj najpierw odpowiednie papugi."),
                          createPicture(
                              context, "assets/help/help_screen_8.png"),
                          createText(context,
                              "Wpisz kolor, wybierz datę parowania i ewentualnie dodaj zdjęcie aparatem lub wybierz je pamięci telefonu."),
                          createText(context,
                              "USUŃ parę wybierając odpowiedni przycisk na karcie PAR"),
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
      duration: Duration(seconds: 2),
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
