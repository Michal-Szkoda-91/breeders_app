import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class TutorialTextContainer extends StatefulWidget {
  const TutorialTextContainer({
    required this.screenNumber,
  });

  final int screenNumber;

  @override
  _TutorialTextContainerState createState() => _TutorialTextContainerState();
}

class _TutorialTextContainerState extends State<TutorialTextContainer> {
  ScrollController _rrectController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(5),
        width: size.width * 0.9,
        child: DraggableScrollbar.rrect(
          labelConstraints: BoxConstraints(maxHeight: 21),
          backgroundColor: Theme.of(context).primaryColor,
          alwaysVisibleScrollThumb: true,
          controller: _rrectController,
          heightScrollThumb: 30,
          child: ListView.builder(
            controller: _rrectController,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: _switchText(),
              );
            },
          ),
        ),
      ),
    );
  }

  Text _switchText() {
    switch (widget.screenNumber) {
      case 1:
        return Text(
          'Dodaj nową papugę do hodowli.\n\nWybierz jej rasę i opisz ją!\n\nPapuga jest dostępna w Wybranej Hodowli\n',
          textAlign: TextAlign.start,
        );
      case 2:
        return Text(
            'Utworzoną papugę można edytować lub usunąć w wybranej hodowli.\n\nWystarczy na ekranie hodowli przesunąc w prawo i wybrać odpowiednią opcję\n');
      case 3:
        return Text(
            'Jeśli w hodowli są dostępne dwie papugi: samiec i samica, możesz utworzyć ich parę.\n\nW wybranej hodowli wejdź w ekran Parowania i naciśnij dodaj parę.\n\nUzupełnij wymagane pola, jeśli chcesz dodaj zdjęcie.\n\nUtworzone pary są widoczne sekcji Parowanie.\n');
      case 4:
        return Text(
            'Raz utworzoną parę możesz edytować lub usunąć.\n\nWejdź w sekcję Parowanie i wybierz odpowiednią ikonę w karcie pary.\n\nZawsze możesz uzupełnić lub zmienić zdjęcie.\n\n');
      case 5:
        return Text(
            'Wybierz START INKUBACJI jeśli parze wykluły się jaja.\n\nProgram automatycznie obliczy orientacyjny czas wyklucia jaj.\n\nMożesz skorzystać z podglądu inkubacji wybierając Listę aktywnych inkubacji w rozwijanym menu.\n\nAuluj inkubację jeśli jest taka potrzeba.\n\n');
      case 6:
        return Text(
            'Archiwum dla par pozwala na zapisanie w historii pary która jest już nie aktualna.\n\nRozwiń kartę pary i wybierz ARCHIWUM aby przeniść parę. Operacja jest nieodwracalna.\n\nZapiszę się ona wraz z potomstwem i datami.\n\nPara przeniesiona do archiwum zwolni sparowane papugi tak aby można je było sparować ponownie.\n\nAby wyświetlić archiwum wciśnij Wyświetl Archiwum.\n\n');
      case 7:
        return Text(
            'Każda para może mieć dowolną ilość potomków.\n\nDodawaj je w karcie pary.\n\nTabela potomków znajduję się w karcie pary. Posortowana jest wg daty wylęgu.\n\nKażdego potomka możesz edytować lub usunąc przesuwając tabelę w PRAWO.\n\nJeśli potomek przeszedł do hodowli wybierz BIAŁY PLUS i uzupełnij dane. Papuga zostanie dodana do hodowli w wybranej rasie.\n\n');
      default:
        return Text('Tekst nr ${widget.screenNumber}');
    }
  }
}
