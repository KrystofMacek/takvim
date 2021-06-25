import 'package:MyMosq/data/models/mosque_data.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:MyMosq/providers/subscription/subs_list_provider.dart';
import 'package:MyMosq/widgets/news_page/mosques_sub_page/mosque_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/all.dart';

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
          stream: _mosqueController.watchSubscribableFirestoreMosques(),
          initialData: [],
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
