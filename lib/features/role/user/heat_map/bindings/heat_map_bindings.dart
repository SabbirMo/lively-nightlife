import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/controller/heat_map_controller.dart';


class HeatMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HeatMapController>(() => HeatMapController(),fenix: true,);
  }
}
