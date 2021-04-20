import 'package:flutter_riverpod/all.dart';
import 'package:permission_handler/permission_handler.dart';

final notifPermissionsStatusFuture = FutureProvider<bool>((ref) async {
  PermissionStatus status = await Permission.notification.status;

  return status.isGranted;
});
