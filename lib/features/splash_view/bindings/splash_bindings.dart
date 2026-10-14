import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/splash_view/controller/splash_view_controller.dart';

class SplashBindings extends Bindings{
  
  @override
  void dependencies(){
    Get.lazyPut<SplashController>(()=> SplashController());
  }
}