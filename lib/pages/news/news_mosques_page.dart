import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/language_pack.dart';
import '../../providers/language_page/language_provider.dart';
import '../../data/models/mosque_data.dart';
import 'package:flutter_riverpod/all.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../widgets/news_page/mosque_item.dart';
import '../../widgets/home_page/app_bar.dart';
import '../../widgets/news_page/appbar_content.dart';
import '../../widgets/news_page/news_mosques_drawer.dart';
import '../../widgets/news_page/news_mosques_fab.dart';
import '../../providers/subscription/subs_list_provider.dart';

class NewsMosquesPage extends ConsumerWidget {
  const NewsMosquesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final MosqueController _mosqueController = watch(mosqueController);

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
            child: NewsMosquesAppBarContent(appLang: _appLang),
          ),
          drawer: NewsMosquesDrawer(
            languagePack: _appLang,
          ),
          floatingActionButton: NewsMosquesPageFab(),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: colWidth),
                child: NewsMosquesPageBody(
                  mosqueController: _mosqueController,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewsMosquesPageBody extends StatelessWidget {
  const NewsMosquesPageBody({
    Key key,
    @required MosqueController mosqueController,
  })  : _mosqueController = mosqueController,
        super(key: key);

  final MosqueController _mosqueController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<MosqueData>>(
          stream: _mosqueController.watchMosques(),
          builder:
              (BuildContext context, AsyncSnapshot<List<MosqueData>> snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                child: Consumer(
                  builder: (context, watch, child) {
                    List<MosqueData> filteredList =
                        watch(filteredMosqueList.state);
                    List<String> subscribedMosques =
                        watch(currentMosqueSubs.state);

                    List<MosqueData> displayedList = filteredList
                        .where((element) =>
                            subscribedMosques.contains(element.mosqueId))
                        .toList();

                    return ListView.separated(
                      itemCount: displayedList.length + 1,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        if (index == displayedList.length) {
                          return SizedBox(
                            height: 80,
                          );
                        }
                        return SubsMosqueItem(
                          data: displayedList[index],
                          isSelected: false,
                        );
                      },
                    );
                  },
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
