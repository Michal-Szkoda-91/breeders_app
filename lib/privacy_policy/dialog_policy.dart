import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    required this.mdFileName,
  }) : assert(
            mdFileName.contains('.md'), 'File must contain the .md extension');

  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Dialog(
        insetPadding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 150)).then((val) {
                return rootBundle
                    .loadString('assets/privacy_policy/$mdFileName');
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                    data: snapshot.data.toString(),
                    onTapLink: (text, url, title) {
                      launch(url.toString());
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
