import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({Key key, @required this.mdFileName})
      : assert(
            mdFileName.contains('.md'), 'File must contain the .md extension'),
        super(key: key);

  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 150)).then((val) {
              return rootBundle.loadString('assets/privacy_policy/$mdFileName');
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Markdown(
                  data: snapshot.data,
                  onTapLink: (text, url, title) {
                    launch(url);
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'OK',
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
