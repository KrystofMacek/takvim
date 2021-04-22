import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/providers/subscription/subs_list_provider.dart';

class NewsPageFab extends ConsumerWidget {
  const NewsPageFab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final mosqueList = watch(currentMosqueSubs.state);
    return Material(
      borderRadius: BorderRadius.circular(50),
      elevation: 2,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
          ),
          onPressed: () {
            if (mosqueList.length > 1) {
              Navigator.pop(context);
            } else {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            }
          },
        ),
      ),
    );
  }
}
