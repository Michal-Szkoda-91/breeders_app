import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PairCircleAvatar extends StatefulWidget {
  const PairCircleAvatar({
    @required this.picUrl,
    this.isAssets,
    this.size,
  });

  final String picUrl;
  final bool isAssets;
  final double size;

  @override
  _PairCircleAvatarState createState() => _PairCircleAvatarState();
}

class _PairCircleAvatarState extends State<PairCircleAvatar> {
  String takenURL;
  bool isMaximaze = false;

  Future _getImage(String basicUrl) async {
    final ref = FirebaseStorage.instance.ref().child(basicUrl);
    takenURL = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    takenURL = null;
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
            break;
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
                      backgroundImage: widget.isAssets || takenURL == null
                          ? AssetImage(
                              "assets/image/parrotsRace/parrot_pair.jpg")
                          : NetworkImage("$takenURL"),
                    ),
                  ),
                ),
              );
            }
            break;

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
