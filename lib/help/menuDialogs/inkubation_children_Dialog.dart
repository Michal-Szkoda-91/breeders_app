import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:flutter/material.dart';

class InkubationChildrenDialog {
  ScrollController _rrectController = ScrollController();
  showMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => new AlertDialog(
        insetPadding: const EdgeInsets.all(5.0),
        backgroundColor: Theme.of(context).backgroundColor,
        title: new Text(
          "Inkubacja / Potomowstwo",
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
                          "Dla każdej pary możesz wybrać datę rozpoczęcia inkubacji, spowoduję to automatyczne obliczenie orientacyjnego czasu pozostałego do wyklucia jaj."),
                      createPicture(context, "assets/help/help_screen_9.png"),
                      createText(context,
                          "Wybierając ANULUJ INKUBACJĘ spowodujesz zresetowanie licznika, który zawsze możesz ustawić ponownie."),
                      createText(context,
                          "Dla danej pary możesz dodać tyle potomswa ile chcesz, wystarczy wybrać przycisk DODAJ POTOMSTWO i uzupełnić dane!"),
                      createPicture(context, "assets/help/help_screen_10.png"),
                      createText(context,
                          "Lista potomków będzie posortowana alfabetycznie wg nr obrączki."),
                      createText(context,
                          "Zawartość tabele POTOMSTWO możesz przesuwać w lewo lub w prawo."),
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
