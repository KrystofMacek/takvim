import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../data/models/mosque_data.dart';
import '../../../common/styling.dart';
import '../../../providers/news_page/selected_mosque_news_provider.dart';

class SubsMosqueItem extends ConsumerWidget {
  const SubsMosqueItem({
    Key key,
    @required this.data,
    @required this.isSelected,
  }) : super(key: key);

  final MosqueData data;
  final bool isSelected;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SelectedMosuqeNewsProvider _selectedMosqueNewsController =
        watch(selectedMosuqeNewsProvider);
    return GestureDetector(
      onTap: () {
        _selectedMosqueNewsController.updateSelectedMosqueNews(data.mosqueId);
        Navigator.pushNamed(context, '/newsPage');
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
                    '${data.ort} ${data.kanton}',
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
                      '${data.name}',
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
                child: FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: CustomColors.mainColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
