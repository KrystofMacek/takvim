import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/common/styling.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import '../../providers/subscription/subs_list_provider.dart';

class ClosedSubsItem extends ConsumerWidget {
  const ClosedSubsItem({Key key, @required String mosqueId})
      : _mosqueId = mosqueId,
        super(key: key);

  final String _mosqueId;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SelectedSubsItem _selectedSubsItemProvider = watch(selectedSubsItem);
    List<String> currentMosqueSubsList = watch(currentMosqueSubs.state);

    return GestureDetector(
      onTap: () {
        _selectedSubsItemProvider.updateSelectedSubsItem(_mosqueId);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
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
        ),
      ),
    );
  }
}
