// ignore_for_file: use_key_in_widget_constructors, avoid_print
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/all_categories.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/newproducts.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/offers.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/section_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../app_cubit/app_cubit.dart';
import '../allproducts/all_offers/all_offers.dart';
import '../allproducts/new_product/new_product.dart';
import '../category/category.dart';
import '../product_detail/product_detail.dart';
import 'componnent/appbar.dart';
import 'componnent/category.dart';
import 'model/home_model.dart';
// import 'model/home_model.dart';

class TaboneScreen extends StatefulWidget {
  @override
  _TaboneScreenState createState() => _TaboneScreenState();
}

class _TaboneScreenState extends State<TaboneScreen> {
  String lang = '';
  bool islogin = false;
  bool isVideo = true; // Variable to check whether to display video or image

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      islogin = preferences.getBool('login') ?? false;
    });
  }

  final Geolocator geolocator = Geolocator();
  late Position currentPosition;
  late String currentAddress;
  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {}
//.....

    //
    ///////////////
    //
    //git
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) async {
      setState(() {
        currentPosition = position;
      });
      SharedPreferences pres = await SharedPreferences.getInstance();
      pres.setString('late', position.altitude.toString());
      pres.setString('lang', position.longitude.toString());
      print("lattitude ................. : " + position.altitude.toString());
      print("longtitude ................. : " + position.longitude.toString());
    }).catchError((e) {
      print("location errrrrrrrrrrrrrrrrrrrrrrrr : " + e.toString());
    });
  }

  @override
  void initState() {
    getLang();
    getCurrentLocation();
    DataBaseCubit.get(context).cart.length;
    BlocProvider.of<AppCubit>(context).notifyCount();
    HomeCubit.get(context).getSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBarHome.app_bar_home(context, lang: lang, login: islogin),
        body: BlocConsumer<HomeCubit, AppCubitStates>(
            builder: (context, state) {
              return ConditionalBuilder(
                  condition: state is! HomeitemsLoaedingState ||
                      HomeCubit.get(context).homeitemsModel != null,
                  builder: (context) => ListView(
                        primary: true,
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: h * 0.01,
                          ),
                          Container(
                            width: w,
                            height: h * 0.4,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0), // حواف دائرية لـ Swiper
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Swiper(
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {},
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30.0), // حواف دائرية للعناصر داخل Swiper
                                        child: HomeCubit.get(context).homeitemsModel!.data!.sliders![i].sliderType == "video"
                                            ? VideoPlayerScreen(
                                          videoUrl: HomeCubit.get(context).homeitemsModel!.data!.sliders![i].appImgFullPath!,
                                        )
                                            : CachedNetworkImage(
                                          imageUrl: HomeCubit.get(context).homeitemsModel!.data!.sliders![i].imgFullPath!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              color: mainColor,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: HomeCubit.get(context).homeitemsModel!.data!.sliders!.length,
                                  autoplay: true,
                                  autoplayDelay: 5000,
                                  pagination: SwiperPagination(
                                    builder: SwiperPagination.dots,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: h * 0.02,
                          ),
                          SectionTitle(
                              title: LocalKeys.HOME_CAT.tr(),
                              press: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubCategoriesScreen(
                                            catItem: HomeCubit.get(context)
                                                .homeitemsModel!
                                                .data!
                                                .categories!,
                                          )))),
                          SizedBox(
                            height: h * 0.015,
                          ),
                          CategorySection(
                            catItem: HomeCubit.get(context)
                                .homeitemsModel!
                                .data!
                                .categories!,
                          ),
                          SizedBox(
                            height: h * 0.04,
                          ),
                          SectionTitle(
                              title: translateString(
                                  LocalKeys.HOME_NEW.tr(), 'أحدث المنتجات'),
                              press: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewProductScreen()))),
                          SizedBox(
                            height: h * 0.01,
                          ),
                          NewProducts(
                            newItem: HomeCubit.get(context)
                                .homeitemsModel!
                                .data!
                                .newArrive!,
                          ),
                          // SizedBox(
                          //   height: h * 0.02,
                          // ),
                          // BestSellers(
                          //   bestItem: HomeCubit.get(context)
                          //       .homeitemsModel!
                          //       .data!
                          //       .bestSell!,
                          // ),
                          SizedBox(
                            height: h * 0.05,
                          ),
                          //ads
                          SizedBox(
                            height: h * 0.43,
                            width: w,
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 0.04 * w),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                primary: false,
                                shrinkWrap: true,
                                children: [
                                  context
                                              .read<HomeCubit>()
                                              .settingModel
                                              ?.data ==
                                          null
                                      ? CircularProgressIndicator(
                                          color: mainColor)
                                      : CustomAdsWidget(
                                          title: (lang == 'en')
                                              ? context
                                                      .read<HomeCubit>()
                                                      .settingModel
                                                      ?.data
                                                      ?.leftAdTitleEn ??
                                                  ""
                                              : context
                                                      .read<HomeCubit>()
                                                      .settingModel
                                                      ?.data
                                                      ?.leftAdTitleAr ??
                                                  "",
                                          body: context
                                                  .read<HomeCubit>()
                                                  .settingModel
                                                  ?.data
                                                  ?.leftAdDetailsAr ??
                                              "",
                                          buttonText: "تسوق الان",
                                          image:"https://rayan-storee.com/"+
                                            "${context
                                      .read<HomeCubit>()
                                      .settingModel
                                      ?.data
                                      ?.leftAdImage }"??
                                              "",
                                          w: w,
                                          h: h,
                                          onTap: () {
                                            if (context
                                                    .read<HomeCubit>()
                                                    .settingModel
                                                    ?.data
                                                    ?.leftAdLinkType
                                                    .toString() ==
                                                "product") {
                                              HomeCubit.get(context)
                                                  .getProductdata(
                                                      productId: context
                                                              .read<HomeCubit>()
                                                              .settingModel
                                                              ?.data
                                                              ?.leftAdLinkReference
                                                              .toString() ??
                                                          "");
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetail()));
                                            } else if (context
                                                    .read<HomeCubit>()
                                                    .settingModel
                                                    ?.data
                                                    ?.leftAdLinkType
                                                    .toString() ==
                                                "category") {
                                              String newMainCat = HomeCubit.get(
                                                      context)
                                                  .findMainCatById(
                                                      context
                                                              .read<HomeCubit>()
                                                              .settingModel
                                                              ?.data
                                                              ?.leftAdLinkReference
                                                              .toString() ??
                                                          "",
                                                      lang);
                                              List<CategoriesSub>?
                                                  newSubCategory =
                                                  HomeCubit.get(context)
                                                      .findSubCategoryById(context
                                                              .read<HomeCubit>()
                                                              .settingModel
                                                              ?.data
                                                              ?.leftAdLinkReference
                                                              .toString() ??
                                                          "");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CategoriesSection(
                                                    mainCat: newMainCat,
                                                    mainCatId: context
                                                            .read<HomeCubit>()
                                                            .settingModel
                                                            ?.data
                                                            ?.leftAdLinkReference
                                                            .toString() ??
                                                        "",
                                                    subCategory:
                                                        newSubCategory!,
                                                  ),
                                                ),
                                              );
                                              // HomeCubit.get(context).getProductdata(
                                              //    productId: context.read<HomeCubit>().settingModel?.data?.id.toString()??"");
                                              //    Navigator.push(
                                              //    context,
                                              //    MaterialPageRoute(
                                              //    builder: (context) => C()));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Container()));
                                            }
                                          },
                                        ),
                                  SizedBox(
                                    width: w * 0.03,
                                  ),
                                  CustomAdsWidget(
                                    title: (lang == 'en')
                                        ? context
                                                .read<HomeCubit>()
                                                .settingModel
                                                ?.data
                                                ?.rightAdTitleEn ??
                                            ""
                                        : context
                                                .read<HomeCubit>()
                                                .settingModel
                                                ?.data
                                                ?.rightAdTitleAr ??
                                            "",
                                    body: context
                                            .read<HomeCubit>()
                                            .settingModel
                                            ?.data
                                            ?.rightAdDetailsAr ??
                                        "",
                                    buttonText: "تسوق الان",
                                    image:"https://rayan-storee.com/"+
                                       "${context
                                      .read<HomeCubit>()
                                      .settingModel
                                      ?.data
                                      ?.rightAdImage}"  ??
                                        "",
                                    w: w,
                                    h: h,
                                    onTap: () {
                                      if (context
                                              .read<HomeCubit>()
                                              .settingModel
                                              ?.data
                                              ?.rightAdLinkType
                                              .toString() ==
                                          "product") {
                                        HomeCubit.get(context).getProductdata(
                                            productId: context
                                                    .read<HomeCubit>()
                                                    .settingModel
                                                    ?.data
                                                    ?.rightAdLinkReference
                                                    .toString() ??
                                                "");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail()));
                                      } else if (context
                                              .read<HomeCubit>()
                                              .settingModel
                                              ?.data
                                              ?.rightAdLinkType
                                              .toString() ==
                                          "category") {
                                        String newMainCat = HomeCubit.get(
                                                context)
                                            .findMainCatById(
                                                context
                                                        .read<HomeCubit>()
                                                        .settingModel
                                                        ?.data
                                                        ?.leftAdLinkReference
                                                        .toString() ??
                                                    "",
                                                lang);
                                        List<CategoriesSub>? newSubCategory =
                                            HomeCubit.get(context)
                                                .findSubCategoryById(context
                                                        .read<HomeCubit>()
                                                        .settingModel
                                                        ?.data
                                                        ?.leftAdLinkReference
                                                        .toString() ??
                                                    "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategoriesSection(
                                              mainCat: newMainCat,
                                              mainCatId: context
                                                      .read<HomeCubit>()
                                                      .settingModel
                                                      ?.data
                                                      ?.leftAdLinkReference
                                                      .toString() ??
                                                  "",
                                              subCategory: newSubCategory!,
                                            ),
                                          ),
                                        );
                                        // HomeCubit.get(context).getProductdata(
                                        //    productId: context.read<HomeCubit>().settingModel?.data?.id.toString()??"");
                                        //    Navigator.push(
                                        //    context,
                                        //    MaterialPageRoute(
                                        //    builder: (context) => C()));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Container()));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: h * 0.05,
                          ),
                          SectionTitle(
                            title: LocalKeys.HOME_OFFER.tr(),
                            press: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllOffersScreen())),
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          CustomOffer(
                            offersItem: HomeCubit.get(context)
                                .homeitemsModel!
                                .data!
                                .offers!,
                          ),
                          SizedBox(
                            height: h * 0.01,
                          ),
                        ],
                      ),
                  // ),
                  //   ],
                  // ),
                  fallback: (context) => Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ));
            },
            listener: (context, state) {}));
  }
}

class Custom_ads_widget extends StatelessWidget {
  const Custom_ads_widget({
    super.key,
    required this.w,
    required this.h,
  });

  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Image.asset(
        'assets/ads.png',
        fit: BoxFit.fill,
        width: w * 0.45,
        height: h * 0.4,
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        if (_controller.value.hasError) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      })
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: mainColor,
      ));
    }

    // if (_hasError) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text('Error loading video'),
    //         ElevatedButton(
    //           onPressed: () {
    //             setState(() {
    //               _isLoading = true;
    //               _hasError = false;
    //               _controller = VideoPlayerController.network(widget.videoUrl)
    //                 ..addListener(() {
    //                   if (_controller.value.hasError) {
    //                     setState(() {
    //                       _hasError = true;
    //                       _isLoading = false;
    //                     });
    //                   }
    //                 })
    //                 ..initialize().then((_) {
    //                   setState(() {
    //                     _isLoading = false;
    //                   });
    //                 });
    //             });
    //           },
    //           child: Text('Retry'),
    //         ),
    //       ],
    //     ),
    //   );
    // }
    if (_hasError) {
      // If there's an error or we are using the fallback video, use asset video
      return VideoPlayer(
          VideoPlayerController.asset("assets/videos/video.mp4"));
    }
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//
//   VideoPlayerWidget({required this.videoUrl});
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isLoading = true;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadNetworkVideo();
//   }
//
//   void _loadNetworkVideo() {
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..addListener(() {
//         if (_controller.value.hasError) {
//           setState(() {
//             _hasError = true;
//             _isLoading = false;
//           });
//           _loadAssetVideo(); // Fallback to asset video if network video fails
//         }
//       })
//       ..initialize().then((_) {
//         if (!_hasError) {
//           setState(() {
//             _isLoading = false;
//           });
//           _controller.play();
//           _controller.setLooping(true);
//         }
//       }).catchError((error) {
//         _loadAssetVideo(); // Fallback to asset video if initialization fails
//       });
//   }
//
//   void _loadAssetVideo() {
//     _controller = VideoPlayerController.asset("assets/videos/video.mp4")
//       ..initialize().then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//         _controller.play();
//         _controller.setLooping(true);
//       }).catchError((error) {
//         print("Error loading asset video: $error");
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     if (_hasError) {
//       return Center(child: Text('Error loading video.'));
//     }
//
//     return AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: VideoPlayer(_controller),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   VideoPlayerWidget({required this.videoUrl});
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Video Player')),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
// class YouTubePlayerWidgetget extends StatelessWidget {
//   final String videoUrl;
//   YouTubePlayerWidget({required this.videoUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     final videoId = Uri.parse(videoUrl).queryParameters['v'] ?? '';
//
//     return Scaffold(
//       appBar: AppBar(title: Text('YouTube Player')),
//       body: WebView(
//         initialUrl: 'https://www.youtube.com/embed/$videoId',
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
class YouTubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  YouTubePlayerWidget({required this.videoUrl});

  @override
  _YouTubePlayerWidgetState createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('YouTube Player')),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          // Add other widgets below the player if needed
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

String? extractVideoId(String videoUrl) {
  //'https://youtu.be/4X77PBX2UeQ?si=jP8kHBQlqs4o4O6Mq
  if (videoUrl.contains('youtu.be')) {
    if (videoUrl.contains('=')) {
      RegExp regExp = RegExp(
          r'(https?://)?(www\.)?youtu\.be/([a-zA-Z0-9_-]+)\?([a-zA-Z0-9_-]+)');

      var match = regExp.firstMatch(videoUrl);

      if (match != null && match.groupCount >= 3) {
        return match.group(3);
      } else {
        // If the regex doesn't match, it could be an invalid URL or a different format
        return null;
      }
    } else {
      Uri uri = Uri.parse(videoUrl);
      String videoId = uri.pathSegments.last;
      return videoId;
    }
  } else {
    RegExp regExp =
        RegExp(r'(https?://)?(www\.)?youtube\.com/watch\?v=([a-zA-Z0-9_-]+)');

    var match = regExp.firstMatch(videoUrl);

    if (match != null && match.groupCount >= 3) {
      return match.group(3);
    } else {
      // If the regex doesn't match, it could be an invalid URL or a different format
      return null;
    }
  }
}
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _youtubeController;
  VideoPlayerController? _videoPlayerController;
  String? videoId;
  bool isYoutube = false;
  bool videoError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  void initializeVideo() {
    videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      isYoutube = true;
      initializeYoutubePlayer(videoId!);
    } else {
      isYoutube = false;
      initializeCachedVideoPlayer();
    }
  }

  void initializeYoutubePlayer(String id) {
    _youtubeController = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  Future<void> initializeCachedVideoPlayer() async {
    try {
      final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);
      _videoPlayerController = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController!.play();
        }).catchError((error) {
          setVideoError('Video player initialization error: $error');
        });
    } catch (error) {
      setVideoError('Video player error: $error');
    }
  }

  void setVideoError(String message) {
    setState(() {
      videoError = true;
      errorMessage = message;
    });
    print(message);
  }

  @override
  void dispose() {
    if (isYoutube) {
      _youtubeController.dispose();
    } else {
      _videoPlayerController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: buildVideoPlayer(),
      ),
    );
  }

  Widget buildVideoPlayer() {
    if (isYoutube) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30.0), // Apply radius to YouTube player
        child: YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
        ),
      );
    } else if (videoError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Failed to load video'),
          SizedBox(height: 10),
          Text(errorMessage, style: TextStyle(color: Colors.red)),
        ],
      );
    } else if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // Apply radius to video player
        child: AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController!),
        ),
      );
    } else {
      return CircularProgressIndicator(
        color: mainColor,
      );
    }
  }
}

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//
//   VideoPlayerScreen({required this.videoUrl});
//
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late YoutubePlayerController _youtubeController;
//   VideoPlayerController? _videoPlayerController;
//   String? videoId;
//   bool isYoutube = false;
//   bool videoError = false;
//   String errorMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     initializeVideo();
//   }
//
//   void initializeVideo() {
//     videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
//     if (videoId != null) {
//       isYoutube = true;
//       initializeYoutubePlayer(videoId!);
//     } else {
//       isYoutube = false;
//       initializeCachedVideoPlayer();
//     }
//   }
//
//   void initializeYoutubePlayer(String id) {
//     _youtubeController = YoutubePlayerController(
//       initialVideoId: id,
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );
//   }
//
//   Future<void> initializeCachedVideoPlayer() async {
//     try {
//       // تنزيل الفيديو وتخزينه مؤقتًا
//       final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);
//       _videoPlayerController = VideoPlayerController.file(file)
//         ..initialize().then((_) {
//           setState(() {});
//           _videoPlayerController!.play();
//         }).catchError((error) {
//           setVideoError('Video player initialization error: $error');
//         });
//     } catch (error) {
//       setVideoError('Video player error: $error');
//     }
//   }
//
//   void setVideoError(String message) {
//     setState(() {
//       videoError = true;
//       errorMessage = message;
//     });
//     print(message);
//   }
//
//   @override
//   void dispose() {
//     if (isYoutube) {
//       _youtubeController.dispose();
//     } else {
//       _videoPlayerController?.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: buildVideoPlayer(),
//       ),
//     );
//   }
//
//   Widget buildVideoPlayer() {
//     if (isYoutube) {
//       return YoutubePlayer(
//         controller: _youtubeController,
//         showVideoProgressIndicator: true,
//       );
//     } else if (videoError) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Failed to load video'),
//           SizedBox(height: 10),
//           Text(errorMessage, style: TextStyle(color: Colors.red)),
//         ],
//       );
//     } else if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
//       return AspectRatio(
//         aspectRatio: _videoPlayerController!.value.aspectRatio,
//         child: VideoPlayer(_videoPlayerController!),
//       );
//     } else {
//       return CircularProgressIndicator(
//         color: mainColor,
//       );
//     }
//   }
// }
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//
//   VideoPlayerScreen({required this.videoUrl});
//
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late YoutubePlayerController _youtubeController;
//   late VideoPlayerController _videoPlayerController;
//   String? videoId;
//   bool isYoutube = false;
//   bool videoError = false;
//   String errorMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     initializeVideo();
//   }
//
//   void initializeVideo() {
//     videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
//     if (videoId != null) {
//       isYoutube = true;
//       initializeYoutubePlayer(videoId!);
//     } else {
//       isYoutube = false;
//       initializeVideoPlayer();
//     }
//   }
//
//   void initializeYoutubePlayer(String id) {
//     _youtubeController = YoutubePlayerController(
//       initialVideoId: id,
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );
//   }
//
//   void initializeVideoPlayer() {
//     String videoUrll = widget.videoUrl.replaceAll(r"\", "/");
//     try {
//       print("ddddddddddddddddddddddd $videoUrll");
//       //  _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(" https://rayan-storee.com/storage/upload/sliders/videos/172485934666cf43d28fd40.mp4"))
// //
//       _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
//         ..initialize().then((_) {
//           setState(() {});
//           _videoPlayerController.play();
//         }).catchError((error) {
//           setVideoError('Video player initialization error: $error');
//         });
//     } catch (error) {
//       setVideoError('Video player error: $error');
//     }
//   }
// // void initializeVideoPlayer() {
// //   try {
// //     _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
// //         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
// //       ..initialize().then((_) {
// //         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
// //         setState(() {});
// //       });
//
// //     _videoPlayerController.initialize().then((_) {
// //       setState(() {});
// //       _videoPlayerController.play();
// //     }).catchError((error) {
// //       setVideoError('Video player initialization error: $error');
// //       print('Video player initialization error: $error'); // Log the error
// //     });
// //   } catch (error) {
// //     setVideoError('Video player error: $error');
// //     print('Video player error: $error'); // Log the error
// //   }
// // }
//
//   void setVideoError(String message) {
//     setState(() {
//       videoError = true;
//       errorMessage = message;
//     });
//     print(message);
//   }
//
//   @override
//   void dispose() {
//     if (isYoutube) {
//       _youtubeController.dispose();
//     } else {
//       _videoPlayerController.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Video Player'),
//       // ),
//       body: Center(
//         child: buildVideoPlayer(),
//       ),
//     );
//   }
//
//   Widget buildVideoPlayer() {
//     if (isYoutube) {
//       return YoutubePlayer(
//         controller: _youtubeController,
//         showVideoProgressIndicator: true,
//       );
//     } else if (videoError) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Failed to load video'),
//           SizedBox(height: 10),
//           Text(errorMessage, style: TextStyle(color: Colors.red)),
//         ],
//       );
//     } else if (!isYoutube && _videoPlayerController.value.isInitialized) {
//       return AspectRatio(
//         aspectRatio: _videoPlayerController.value.aspectRatio,
//         child: VideoPlayer(_videoPlayerController),
//       );
//     } else {
//       return CircularProgressIndicator(
//         color: mainColor,
//       );
//     }
//   }
// }

class CustomAdsWidget extends StatelessWidget {
  const CustomAdsWidget({
    super.key,
    required this.w,
    required this.h,
    this.onTap,
    required this.title,
    required this.body,
    required this.buttonText,
    required this.image,
  });

  final double w;
  final double h;
  final void Function()? onTap;
  final String image;
  final String title;
  final String body;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w * 0.45,
      height: h * 0.4,
      child: Stack(
        children: [
          // Image.asset(
          //   // image
          //   'assets/slider.jpeg',
          //   fit: BoxFit.fill,
          //   width: w * 0.45,
          //   height: h * 0.4,
          // ),
          CachedNetworkImage(
            imageUrl: image, fit: BoxFit.fill,

            width: w * 0.45,
            height: h * 0.4,

            // placeholder: (context, url) => SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.02,
            //   height: MediaQuery.of(context).size.height * 0.02,
            //   child: Image.asset(
            //     "assets/icons/LOGO.png",
            //     fit: BoxFit.contain,
            //   ),
            // ),
            placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
              color: mainColor,
            )),
            errorWidget: (context, url, error) => Image.asset(
              // image
              'assets/LOGO.png',
              fit: BoxFit.fill,
              width: w * 0.45,
              height: h * 0.4,
            ),
            // Icon(
            //   Icons.error,
            //   color: Colors.red, // Example error color
            // ),
          ),
          Container(
            color: Colors.black.withOpacity(.2),
            width: w * 0.45,
            height: h * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 3,
                ),
                //
                //////vb
                Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      body,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(18)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Text(
                            buttonText,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
