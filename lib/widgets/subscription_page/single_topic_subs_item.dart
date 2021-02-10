import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/common/styling.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import '../../providers/subscription/subs_list_provider.dart';
import '../../data/models/subsTopic.dart';
import '../../data/models/mosque_data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import './checkbox.dart';

class SingleTopicSubsItem extends ConsumerWidget {
  const SingleTopicSubsItem({
    Key key,
    @required SubsTopic topic,
    @required bool selected,
    @required MosqueData mosqueData,
  })  : _topic = topic,
        _selected = selected,
        _mosqueData = mosqueData,
        super(key: key);

  final SubsTopic _topic;
  final bool _selected;
  final MosqueData _mosqueData;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SelectedSubsItem _selectedSubsItemProvider = watch(selectedSubsItem);

    List<String> currentSubsList = watch(currentSubsListProvider.state);
    CurrentSubsList currentSubsListController = watch(currentSubsListProvider);

    bool subscribed = currentSubsList.contains(_topic.topic);

    return GestureDetector(
      onTap: () {
        _selected
            ? _selectedSubsItemProvider.updateSelectedSubsItem('')
            : _selectedSubsItemProvider.updateSelectedSubsItem(_topic.mosqueId);
      },
      child: Card(
        color: _selected
            ? CustomColors.highlightColor
            : Theme.of(context).cardColor,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_mosqueData.ort} ${_mosqueData.kanton}',
                    style: CustomTextFonts.mosqueListOther.copyWith(
                        color: CustomColors.cityNameColor, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: AutoSizeText(
                      '${_mosqueData.name}',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontStyle: FontStyle.italic, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    if (subscribed) {
                      // remove from sub list
                      currentSubsListController.removeFromSubsList(
                        _topic.topic,
                      );
                    } else {
                      currentSubsListController.addToSubsList(
                        _topic.topic,
                      );
                    }
                  },
                  child: CustomCheckBox(
                    size: 20,
                    iconSize: 17,
                    isChecked: subscribed,
                    isDisabled: false,
                    isClickable: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
