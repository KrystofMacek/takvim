import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:MyMosq/common/styling.dart';
import '../../providers/subscription/selected_subs_item_provider.dart';
import '../../data/models/mosque_data.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UnsubscribableTopicItem extends ConsumerWidget {
  const UnsubscribableTopicItem({
    Key key,
    @required bool selected,
    @required MosqueData mosqueData,
  })  : _selected = selected,
        _mosqueData = mosqueData,
        super(key: key);

  final bool _selected;
  final MosqueData _mosqueData;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SelectedSubsItem _selectedSubsItemProvider = watch(selectedSubsItem);

    return GestureDetector(
      onTap: () {
        _selected
            ? _selectedSubsItemProvider.updateSelectedSubsItem('')
            : _selectedSubsItemProvider
                .updateSelectedSubsItem(_mosqueData.mosqueId);
      },
      child: Card(
        color: Theme.of(context).cardColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
