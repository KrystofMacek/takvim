import 'package:MyMosq/common/styling.dart';
import 'package:MyMosq/common/utils.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/data/models/news_post.dart';
import 'package:MyMosq/data/models/subsTopic.dart';
import 'package:MyMosq/widgets/news_page/posts_sub_page/post_label.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    Key key,
    @required this.data,
    @required LanguagePack appLang,
    @required this.timestamp,
    @required this.hideLabel,
    @required this.subTopicList,
    @required this.subscribedTopics,
  })  : _appLang = appLang,
        super(key: key);

  final NewsPost data;
  final LanguagePack _appLang;
  final String timestamp;
  final bool hideLabel;
  final List<SubsTopic> subTopicList;
  final List<SubsTopic> subscribedTopics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: CustomColors.highlightColor,
        onTap: () async {
          if (await canLaunch(
              'http://${data.url}?languageId=${_appLang.languageId}&integratedView=true')) {
            await launch(
              'http://${data.url}?languageId=${_appLang.languageId}&integratedView=true',
              forceSafariVC: false,
            );
          } else {
            throw 'Could not launch ${data.url}';
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '$timestamp',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 16,
                          color: CustomColors.cityNameColor,
                        ),
                  ),
                ),
                !hideLabel
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        decoration: BoxDecoration(
                          color: labelColoring(
                            subTopicList.indexOf(
                              subTopicList.firstWhere(
                                (element) => element.topic == data.topicId,
                              ),
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PostLabel(
                              data: data,
                              subscribedTopics: subscribedTopics,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: AutoSizeText(
                      '${data.title}',
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            letterSpacing: .4,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                      maxLines: 2,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Share.share(data.url);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
