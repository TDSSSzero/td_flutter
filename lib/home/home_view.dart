import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:td_flutter/common/pages.dart';

import 'home_logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final logic = Get.put(HomeLogic());
  final state = Get
      .find<HomeLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    logic.getCenterOffset(context);
    return Scaffold(
      body: _buildHomeList(),
    );
  }

  Widget _buildHomeList() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: GridView.builder(
                itemBuilder: (builder, index) => _buildListItem(index),
                itemCount: Pages.pageNames.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 20
                )
            ),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    ElevatedButton(onPressed: () {
                      SmartDialog.show(builder: (context) {
                        return Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          width: 300,
                          height: 300,
                          child: ListView.builder(
                              itemCount: logic.menuString.length,
                              itemBuilder: _buildMenuItem
                          ),
                        );
                      });
                    }, child: Text("菜单")),
                    Obx(() {
                      return Text(state.menuDesc.value);
                    })
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, int index) {
    return ElevatedButton(onPressed: () => logic.menuLogic(index),
        child: Text(logic.menuString[index]));
  }


  Widget _buildListItem(index) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        shape: const MaterialStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: Colors.black)
            )),
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.greenAccent.shade100),
      ),
      onPressed: () => Get.toNamed(Pages.pageNames.keys.toList()[index]),
      child: Text(Pages.pageNames.values.toList()[index], textAlign: TextAlign.center,),
    );
  }
}
