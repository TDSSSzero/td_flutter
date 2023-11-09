import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td_flutter/common/pages.dart';
import 'package:td_flutter/module/hero_test/hero_detail_view.dart';

import 'hero_test_logic.dart';

class HeroTestPage extends StatelessWidget {
  HeroTestPage({Key? key}) : super(key: key);

  final logic = Get.put(HeroTestLogic());
  final state = Get.find<HeroTestLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
        body: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Container(
            width: 50,
            height: 50,
            child: Hero(
                tag: "fhero",
                // createRectTween: (){},
                child: InkWell(
                  onTap: (){
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HeroDetailView()));
                    Get.toNamed(Pages.heroDetailPage);
                  },
                  child: FlutterLogo(size: 50),
                )
            ),
          ),
        )
    );
  }
}
