import 'package:fitness_app/common_widget/on_boarding_page.dart';
import 'package:fitness_app/view/login/signup_view.dart';
import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.hasClients) {
        final currentPage = controller.page?.round() ?? 0;
        if (currentPage != selectPage) {
          setState(() {
            selectPage = currentPage;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final List<Map<String, String>> pageArr = [
    {
      "title": "Track Your Goal",
      "subtitle":
      "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      "image": "assets/img/on_1.png"
    },
    {
      "title": "Get Burn",
      "subtitle":
      "Let's keep burning, to achieve your goals, it hurts only temporarily, if you give up now you will be in pain forever",
      "image": "assets/img/on_2.png"
    },
    {
      "title": "Eat Well",
      "subtitle":
      "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      "image": "assets/img/on_3.png"
    },
    {
      "title": "Improve Sleep\nQuality",
      "subtitle":
      "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      "image": "assets/img/on_4.png"
    },
  ];

  void _navigateToNextPage() {
    if (selectPage < pageArr.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final scale = media.width / 375; // Base width used for scaling

    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: (context, index) {
              final pObj = pageArr[index];
              return OnBoardingPage(pObj: pObj);
            },
          ),
          Positioned(
            bottom: 30 * scale,
            right: 20 * scale,
            child: SizedBox(
              width: 120 * scale,
              height: 120 * scale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70 * scale,
                    height: 70 * scale,
                    child: CircularProgressIndicator(
                      color: TColor.primaryColor1,
                      value: (selectPage + 1) / pageArr.length,
                      strokeWidth: 2 * scale,
                      backgroundColor: TColor.primaryColor1.withOpacity(0.3),
                    ),
                  ),
                  Container(
                    width: 60 * scale,
                    height: 60 * scale,
                    decoration: BoxDecoration(
                      color: TColor.primaryColor1,
                      borderRadius: BorderRadius.circular(30 * scale),
                    ),
                    child: IconButton(
                      icon: Icon(
                        selectPage < pageArr.length - 1
                            ? Icons.navigate_next
                            : Icons.check,
                        size: 28 * scale,
                        color: TColor.white,
                      ),
                      onPressed: _navigateToNextPage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}