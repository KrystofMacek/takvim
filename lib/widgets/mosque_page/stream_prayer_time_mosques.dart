import 'package:MyMosq/widgets/mosque_page/mosque_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:MyMosq/data/models/mosque_data.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';

class StreamPrayerTimeMosques extends StatelessWidget {
  const StreamPrayerTimeMosques({
    Key key,
    @required MosqueController mosqueController,
  })  : _mosqueController = mosqueController,
        super(key: key);

  final MosqueController _mosqueController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MosqueData>>(
      stream: _mosqueController.watchPrayerTimeFirestoreMosques(),
      initialData: [],
      builder:
          (BuildContext context, AsyncSnapshot<List<MosqueData>> snapshot) {
        if (snapshot.hasData) {
          return Consumer(
            builder: (context, watch, child) {
              List<MosqueData> filteredList = watch(filteredMosqueList.state);

              String selectedId = watch(tempSelectedMosque.state);

              if (watch(sortByDistanceToggle.state)) {
                filteredList = _mosqueController.updateDistances(filteredList);
                filteredList.sort((a, b) => a.distance.compareTo(b.distance));
              } else {
                filteredList.sort((a, b) => a.ort.compareTo(b.ort));
              }

              return Expanded(
                child: ListView.separated(
                  itemCount: filteredList.length + 1,
                  separatorBuilder: (context, index) => SizedBox(),
                  itemBuilder: (context, index) {
                    if (index == filteredList.length) {
                      return SizedBox(
                        height: 80,
                      );
                    }
                    MosqueData data = filteredList[index];

                    bool isSelected = (data.mosqueId == selectedId);

                    return MosqueItem(
                      data: data,
                      isSelected: isSelected,
                    );
                  },
                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
