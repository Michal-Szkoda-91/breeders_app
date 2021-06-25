import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PairCircleAvatar extends StatefulWidget {
  const PairCircleAvatar({
    required this.picUrl,
    required this.isAssets,
    required this.size,
  });

  final String picUrl;
  final bool isAssets;
  final double size;

  @override
  _PairCircleAvatarState createState() => _PairCircleAvatarState();
}

class _PairCircleAvatarState extends State<PairCircleAvatar> {
  late String takenURL;
  bool isMaximaze = false;

  Future _getImage(String basicUrl) async {
    final ref = FirebaseStorage.instance.ref().child(basicUrl);
    takenURL = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    takenURL = '';
    return FutureBuilder(
      future: _getImage(widget.picUrl),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            {
              return Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: isMaximaze
                      ? (MediaQuery.of(context).size.width / 2) - 15
                      : widget.size,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Center(
                    child: const CircularProgressIndicator(),
                  ),
                ),
              );
            }
          case ConnectionState.done:
            {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    isMaximaze = !isMaximaze;
                  });
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: isMaximaze
                        ? (MediaQuery.of(context).size.width / 2) - 10
                        : widget.size,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: isMaximaze
                          ? (MediaQuery.of(context).size.width / 2) - 15
                          : widget.size - 3,
                      child: widget.isAssets || takenURL == ''
                          ? Image.asset(
                              "assets/image/parrotsRace/parrot_pair.jpg")
                          : Image.network("$takenURL"),
                    ),
                  ),
                ),
              );
            }

          default:
            {
              return Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: isMaximaze
                      ? (MediaQuery.of(context).size.width / 2) - 10
                      : widget.size,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    radius: isMaximaze
                        ? (MediaQuery.of(context).size.width / 2) - 15
                        : widget.size - 3,
                    backgroundImage:
                        AssetImage("assets/image/parrotsRace/parrot_pair.jpg"),
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
