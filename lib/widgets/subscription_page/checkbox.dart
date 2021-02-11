import 'package:flutter/material.dart';
import '../../common/styling.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key key,
    double size,
    double iconSize,
    bool isChecked,
    bool isDisabled,
    bool isClickable,
  })  : _size = size,
        _isClickable = isClickable,
        _iconSize = iconSize,
        _isChecked = isChecked,
        _isDisabled = isDisabled,
        super(key: key);

  final double _size;
  final double _iconSize;
  final bool _isChecked;
  final bool _isDisabled;
  final bool _isClickable;

  @override
  Widget build(BuildContext context) {
    if (_isDisabled) {
      return Container(
        height: _size,
        width: _size,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(5),
        ),
        // child: Center(
        //   child: Icon(
        //     Icons.close,
        //     size: _iconSize,
        //     color: Colors.white,
        //   ),
        // ),
      );
    }
    if (!_isClickable) {
      return Container(
        height: _size,
        width: _size,
        decoration: BoxDecoration(
          color: _isChecked ? Colors.grey[500] : Theme.of(context).cardColor,
          border: Border.all(
            width: 2,
            color: Colors.grey[500],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: _isChecked
              ? Icon(
                  Icons.check,
                  size: _iconSize,
                  color: Colors.white,
                )
              : SizedBox(),
          // Icon(
          //     Icons.remove,
          //     size: _iconSize,
          //     color: Colors.white,
          //   ),
        ),
      );
    }

    return Container(
      height: _size,
      width: _size,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: CustomColors.mainColor,
        ),
        borderRadius: BorderRadius.circular(5),
        color:
            _isChecked ? CustomColors.mainColor : Theme.of(context).cardColor,
      ),
      child: Center(
        child: _isChecked
            ? Icon(
                Icons.check,
                size: _iconSize,
                color: Colors.white,
              )
            : SizedBox(),
      ),
    );
  }
}
