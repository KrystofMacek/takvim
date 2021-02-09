import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/common/styling.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import './sub_topic_list_view.dart';
import '../../providers/subscription/subs_list_provider.dart';

class OpenedSubsItem extends ConsumerWidget {
  const OpenedSubsItem({Key key, @required String mosqueId})
      : _mosqueId = mosqueId,
        super(key: key);

  final String _mosqueId;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<String> currentMosqueSubsList = watch(currentMosqueSubs.state);
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: CustomColors.highlightColor,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_mosqueId',
                        style: CustomTextFonts.mosqueListOther.copyWith(
                            color: CustomColors.cityNameColor, fontSize: 18),
                      ),
                    ],
                  ),
                  Checkbox(
                    value: currentMosqueSubsList.contains(_mosqueId),
                    onChanged: (value) {},
                  )
                ],
              ),
              SubTopicListView(
                mosqueId: _mosqueId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
