import 'package:MyMosq/data/models/subsTopic.dart';
import 'package:MyMosq/providers/news_page/label_filter.dart';
import 'package:MyMosq/widgets/news_page/posts_sub_page/label_button.dart';
import 'package:flutter/material.dart';

class LabelButtonsRow extends StatelessWidget {
  const LabelButtonsRow({
    Key key,
    @required this.subTopicList,
    @required List<String> hiddenTopicsList,
    @required HiddenTopics hiddenTopics,
  })  : _hiddenTopicsList = hiddenTopicsList,
        _hiddenTopics = hiddenTopics,
        super(key: key);

  final List<SubsTopic> subTopicList;
  final List<String> _hiddenTopicsList;
  final HiddenTopics _hiddenTopics;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          List<Widget> labelButtons = [];
          for (var i = 0; i < subTopicList.length; i++) {
            bool _isHidden = _hiddenTopicsList.contains(subTopicList[i].topic);
            bool gap = (i <= subTopicList.length - 2);
            labelButtons.add(
              LabelButton(
                isHidden: _isHidden,
                subTopicList: subTopicList,
                hiddenTopics: _hiddenTopics,
                index: i,
              ),
            );
            if (gap) labelButtons.add(SizedBox(width: 5));
          }
          if (labelButtons.length < 2) {
            return SizedBox();
          }

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: labelButtons,
            ),
          );
        },
      ),
    );
  }
}
