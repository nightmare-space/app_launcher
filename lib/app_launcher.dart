import 'package:app_manager/app_manager.dart';
import 'package:app_manager/controller/app_manager_controller.dart';
import 'package:app_manager/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

class AppLauncher extends StatefulWidget {
  const AppLauncher({Key key}) : super(key: key);

  @override
  _AppLauncherState createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  AppManagerController appManagerController = Get.put(AppManagerController());
  String filter = '';
  int getCount() {
    return MediaQuery.of(context).size.width ~/ 100.w;
  }

  @override
  void initState() {
    super.initState();
    appManagerController.getUserApp();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppManagerController>(
      autoRemove: false,
      builder: (context) {
        List<AppInfo> apps = List.from(appManagerController.userApps);
        if (apps.isEmpty) {
          return SpinKitDualRing(
            color: AppColors.accentColor,
            size: 20.w,
            lineWidth: 2.w,
          );
        }
        if (filter != null && filter.isNotEmpty) {
          // 移除不包含关键字的item
          apps.removeWhere((element) {
            return !element.appName.toLowerCase().contains(filter) &&
                !element.packageName.toLowerCase().contains(filter);
          });
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
              child: SearchBox(
                onInput: (data) {
                  filter = data;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getCount(),
                  crossAxisSpacing: 4.w,
                  mainAxisSpacing: 8.w,
                  childAspectRatio: 1,
                ),
                itemCount: apps.length,
                itemBuilder: (c, i) {
                  AppInfo appInfo = apps[i];
                  return InkWell(
                    onTap: () async {
                      String main = await appManagerController.curChannel
                          .getAppMainActivity(
                        appInfo.packageName,
                      );
                      Log.i('main : $main');
                      appManagerController.curChannel.openApp(
                        appInfo.packageName,
                        main,
                      );
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: AppIconHeader(
                            key: Key(appInfo.packageName),
                            packageName: appInfo.packageName,
                            channel: appManagerController.curChannel,
                          ),
                        ),
                        HighlightText(
                          data: appInfo.appName,
                          hightlightData: filter,
                          maxLine: 2,
                          defaultStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.w,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
