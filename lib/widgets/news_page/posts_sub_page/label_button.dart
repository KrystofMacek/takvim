import 'package:MyMosq/common/utils.dart';
import 'package:MyMosq/data/models/subsTopic.dart';
import 'package:MyMosq/providers/news_page/label_filter.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LabelButton extends StatelessWidget {
  LabelButton({
    Key key,
    @required bool isHidden,
    @required HiddenTopics hiddenTopics,
    @required List<SubsTopic> subTopicList,
    @required int index,
  })  : _isHidden = isHidden,
        _hiddenTopics = hiddenTopics,
        _subTopicList = subTopicList,
        _index = index,
        super(key: key);

  final bool _isHidden;
  final HiddenTopics _hiddenTopics;
  final List<SubsTopic> _subTopicList;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: GestureDetector(
        onTap: () {
          _isHidden
              ? _hiddenTopics.showTopic(_subTopicList[_index].topic)
              : _hiddenTopics.hideTopic(_subTopicList[_index].topic);
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 80, minHeight: 32),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _isHidden ? Colors.grey[200] : labelColoring(_index),
            ),
            padding: EdgeInsets.all(5),
            child: Center(
              child: AutoSizeText(
                _subTopicList[_index].label,
                style: TextStyle(color: Colors.black),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
