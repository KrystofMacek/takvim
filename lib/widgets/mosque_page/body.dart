import 'package:MyMosq/widgets/mosque_page/mosque_page_widgets.dart';
import 'package:MyMosq/widgets/mosque_page/stream_prayer_time_mosques.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/mosque_page/mosque_provider.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:MyMosq/widgets/mosque_page/selected_mosque_view.dart';

class MosqueSettingsPageContent extends StatelessWidget {
  const MosqueSettingsPageContent({
    Key key,
    @required MosqueController mosqueController,
    @required LanguagePack appLang,
    @required Connectivity connectivity,
  })  : _mosqueController = mosqueController,
        _appLang = appLang,
        _connectivity = connectivity,
        super(key: key);

  final MosqueController _mosqueController;
  final LanguagePack _appLang;
  final Connectivity _connectivity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Consumer(
          builder: (context, watch, child) {
            String tempSelectedMosqueId = watch(tempSelectedMosque.state);
            return SelectedMosqueView(
              mosqueController: _mosqueController,
              selectedMosqueController: tempSelectedMosqueId,
            );
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              flex: 6,
              fit: FlexFit.loose,
              child: FilterMosqueInput(
                appLang: _appLang,
                mosqueController: _mosqueController,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder(
          stream: _connectivity.isConnected,
          initialData: true,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Consumer(
              builder: (context, watch, child) {
                if (snapshot.data) {
                  return StreamPrayerTimeMosques(
                    mosqueController: _mosqueController,
                  );
                } else {
                  return Expanded(
                    child: !snapshot.data
                        ? ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            leading: Icon(
                              Icons.wifi_off,
                              color: Colors.red[300],
                              size: 28,
                            ),
                            title: Text(
                              '${_appLang.noInternet}',
                              style: TextStyle(color: Colors.red[300]),
                            ),
                            onTap: () {},
                          )
                        : SizedBox(),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
