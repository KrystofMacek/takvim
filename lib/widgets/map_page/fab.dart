import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapFab extends ConsumerWidget {
  const MapFab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      elevation: 2,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.times,
            size: 28,
          ),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          },
        ),
      ),
    );
  }
}
