import 'package:flutter/material.dart';

import '../../models/parrot_model.dart';
import '../../widgets/parrot_pair_card_widgets/pairCircularContainer.dart';

class TableContentPictureRow extends StatelessWidget {
  final int index;
  final List<Parrot> createdParrotList;

  const TableContentPictureRow({
    required this.index,
    required this.createdParrotList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 60,
      decoration: const BoxDecoration(
        border: const Border(
          right: const BorderSide(color: Colors.black, width: 1.0),
          bottom: const BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 1.0),
        child: createdParrotList[index].picUrl == ""
            ? PairCircleAvatar(
                picUrl: createdParrotList[index].picUrl,
                isAssets: true,
                size: 60,
              )
            : PairCircleAvatar(
                picUrl: createdParrotList[index].picUrl,
                isAssets: false,
                size: 60,
              ),
      ),
    );
  }
}
