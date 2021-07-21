import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

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
                  radius: widget.size + 3,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Center(),
                ),
              );
            }
          case ConnectionState.done:
            {
              return GestureDetector(
                onTap: () async {
                  showAnimatedDialog(
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: (MediaQuery.of(context).size.width / 2),
                          backgroundColor: Theme.of(context).primaryColor,
                          child: widget.isAssets || takenURL == ''
                              ? CircleAvatar(
                                  radius:
                                      (MediaQuery.of(context).size.width / 2) -
                                          8,
                                  backgroundImage: AssetImage(
                                      "assets/image/parrotsRace/parrot_pair.jpg"),
                                )
                              : CircleAvatar(
                                  radius:
                                      (MediaQuery.of(context).size.width / 2) -
                                          8,
                                  backgroundImage: NetworkImage("$takenURL"),
                                ),
                        ),
                      );
                    },
                    animationType: DialogTransitionType.scale,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 900),
                  );
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: widget.size + 3,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: widget.isAssets || takenURL == ''
                        ? CircleAvatar(
                            radius: widget.size,
                            backgroundImage: AssetImage(
                                "assets/image/parrotsRace/parrot_pair.jpg"),
                          )
                        : CircleAvatar(
                            radius: widget.size,
                            backgroundImage: NetworkImage("$takenURL"),
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
                  radius: widget.size + 3,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: CircleAvatar(
                    radius: widget.size,
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
