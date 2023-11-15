import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/common/pages.dart';

import 'home_logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.getCenterOffset(context);
    return Scaffold(
      body: _buildHomeList(),
    );
  }

  Widget _buildHomeList(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        itemBuilder: (builder, index) => _buildListItem(index),
        itemCount: Pages.pageNames.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          crossAxisSpacing: 30,
          mainAxisSpacing: 20
        )
      ),
    );
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
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.pink.shade100),
      ),
      onPressed: ()=>Get.toNamed(Pages.pageNames[index]),
      child: Text(state.pageTitle[index],textAlign: TextAlign.center, ),
    );
  }
}
