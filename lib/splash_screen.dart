import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class SplashScreenPage extends ConsumerStatefulWidget {
  static const routeName = 'splash_screen_page';
  const SplashScreenPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SplashScreenPageState();
}

class SplashScreenPageState extends ConsumerState<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  // bool isLoggedin = false;
  late Animation<double> animation;
  late AnimationController controller;
  @override
  void initState() {
   
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInExpo);
    super.initState();
    //Get.find<ProductCategoryController>().getProductCategories();
    // _loadResource();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Logger().i(MediaQuery.of(context).size.width);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              // color: Colors.white,
              image: DecorationImage(
                  image: AssetImage(
                    'assets/bg/Welcomebackground.png',
                  ),
                  fit: BoxFit.cover),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      color: Colors.transparent,
                      // height: 200.h,
                      // width: 300.h,
                      child: ScaleTransition(
                        scale: animation,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           
                            Text("Solutech",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            ),
                           
                          ],
                        ),
                      ),
                       
                    ),
                  ),
                ],
              ),
            )));
    // Image(image: AssetImage('assets/logos/Fresh Life Logo_Horizontal.png'))
  }

  



// Future<void> _loadResource() async {
//   Get.find<AuthController>().userLoggedIn();
// }
}
