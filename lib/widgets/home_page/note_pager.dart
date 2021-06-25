import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyMosq/data/models/day_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkwell/linkwell.dart';
import 'package:MyMosq/providers/home_page/pager.dart';

class NotePager extends ConsumerWidget {
  const NotePager({
    Key key,
    @required this.data,
  }) : super(key: key);

  final DayData data;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    if (data.notes != null && data.notes.isNotEmpty) {
      List<String> _notePages = data.notes.split('//');
      int length = _notePages.length;

      int _currentPage = watch(pageViewProvider.state);
      PageController _pageController = watch(pageViewControllerProvider.state);

      return Flexible(
        fit: FlexFit.loose,
        child: Column(
          children: [
            (length > 1)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_currentPage + 1}/ $length',
                      ),
                    ],
                  )
                : SizedBox(),
            Flexible(
              fit: FlexFit.loose,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  context.read(pageViewControllerProvider).goToPage(value);
                },
                itemCount: _notePages.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: data.notes.isNotEmpty
                                    ? Theme.of(context).colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: LinkWell(
                                '${_notePages[index]}',
                                style: Theme.of(context).textTheme.headline3,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
