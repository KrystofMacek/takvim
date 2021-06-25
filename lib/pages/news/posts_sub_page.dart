import 'package:MyMosq/widgets/news_page/posts_sub_page/app_bar.dart';
import 'package:MyMosq/widgets/news_page/posts_sub_page/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/news_page/selected_mosque_news_provider.dart';
import '../../data/models/language_pack.dart';
import '../../providers/language_page/language_provider.dart';
import 'package:flutter_riverpod/all.dart';
import '../../widgets/home_page/app_bar.dart';
import '../../widgets/news_page/posts_sub_page/news_drawer.dart';
import '../../widgets/news_page/posts_sub_page/news_fab.dart';

class NewsPage extends ConsumerWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String mosqueId = watch(selectedMosuqeNewsProvider.state);

    final LanguagePack _appLang = watch(appLanguagePackProvider.state);

    final size = MediaQuery.of(context).size;
    double baseSize = size.height;
    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: NewsAppBarContent(
              mosqueId: mosqueId,
            ),
          ),
          drawer: NewsDrawer(
            languagePack: _appLang,
          ),
          floatingActionButton: NewsPageFab(),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: colWidth),
                child: PostsSubPageBody(
                  mosqueId: mosqueId,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
