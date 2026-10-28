import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_grocery/features/menu/domain/models/custom_drawer_controller_model.dart';
import 'package:flutter_grocery/features/refer_and_earn/screens/refer_hint_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/third_party_chat_widget.dart';
import 'package:flutter_grocery/features/home/screens/home_screens.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  final bool isReload;
  final bool fromIntro;
  final CustomDrawerController drawerController;
  const MainScreen({super.key, required this.drawerController, this.isReload = true, this.fromIntro = false});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool canExit = kIsWeb;

  @override
  void initState() {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    splashProvider.initializeScreenList();
    if (widget.isReload) {
      HomeScreen.loadData(true, context);
    }
    if(widget.fromIntro){
      WidgetsBinding.instance.addPostFrameCallback((_){
        _showBottomSheet(context);
      });
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return CustomPopScopeWidget(
          child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) => InkWell(
                    onTap: (){
                      if(!ResponsiveHelper.isDesktop(context) && widget.drawerController.isOpen()) {
                        widget.drawerController.toggle();
                      }
                    },
                    child: Scaffold(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      floatingActionButton: !ResponsiveHelper.isDesktop(context) ?
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0),
                        child: ThirdPartyChatWidget(configModel: splash.configModel),
                      ) :
                      null,
                      appBar: ResponsiveHelper.isDesktop(context) ?
                      null :
                      AppBar(
                        backgroundColor: isDarkTheme ? Theme.of(context).cardColor : ColorResources.headerYellow,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: isDarkTheme ? Theme.of(context).cardColor : ColorResources.headerYellow,
                          statusBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
                          statusBarBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
                        ),
                        leading: IconButton(
                          icon: Image.asset(Images.moreIcon, color: Theme.of(context).primaryColor, height: 30, width: 30),
                          onPressed: () {
                            widget.drawerController.toggle();
                          },
                        ),
                        title: splash.pageIndex == 0 ?
                        Row(children: [
                          Image.asset(Images.appLogo, width: 28),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppConstants.appName, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: poppinsBold.copyWith(color: Theme.of(context).primaryColor, fontSize: 16),
                              ),
                              Text(
                                'From The Sea To Your Door',
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: poppinsRegular.copyWith(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.75),
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          )),
                        ]) :
                        Text(
                          getTranslated(splash.screenList[splash.pageIndex].title, context),
                          style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                        ),
                        elevation: 0,
                        bottom: splash.pageIndex == 0 ? PreferredSize(
                          preferredSize: const Size.fromHeight(60),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12, top: 2),
                            child: InkWell(
                              onTap: () => RouteHelper.getSearchProduct(),
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      size: 20,
                                      color: Color(0xFF004B4B),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Search for fresh seafood, fish, prawns, crabs...',
                                        style: poppinsRegular.copyWith(
                                          fontSize: 13,
                                          color: const Color(0xFF7A8B8E),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ) : null,
                        actions: splash.screenList[splash.pageIndex].title == 'home' ? [
                          IconButton(
                            icon: Image.asset(Images.search, color: Theme.of(context).primaryColor, width: 20),
                            onPressed: () {
                              RouteHelper.getSearchProduct();
                            },
                          ),

                          IconButton(
                            icon: Stack(clipBehavior: Clip.none, children: [
                              Icon(Icons.shopping_cart, color: isDarkTheme ? Theme.of(context).hintColor.withValues(alpha: 0.9) : Theme.of(context).primaryColor, size: 25),

                              Positioned(top: -7, right: -2, child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                                child: Text(
                                  '${Provider.of<CartProvider>(context).getTotalCartQuantity()}',
                                  style: TextStyle(color: Theme.of(context).cardColor, fontSize: 10),
                                ),
                              )),
                            ]),
                            onPressed: () {
                              splash.setPageIndex(2);
                            },
                          ),
                        ] :
                        splash.screenList[splash.pageIndex].title == 'loyalty_point' ? [
                          IconButton(
                              onPressed: (){
                                ResponsiveHelper().showDialogOrBottomSheet(
                                  context,
                                    ReferHintWidget(hintList: profileProvider.hintList)
                                );
                              },
                              icon: Icon(Icons.info_outline)
                          )
                        ] :
                        null,
                      ),

                      bottomNavigationBar: !ResponsiveHelper.isDesktop(context)
                          ? _CustomBottomNavBar(splash: splash)
                          : null,

                      body: splash.screenList[splash.pageIndex].screen,
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final SplashProvider splash;
  const _CustomBottomNavBar({required this.splash});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final int profileIndex = splash.screenList.indexWhere((m) => m.title == 'profile');

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_rounded,
                inactiveIcon: Icons.home_outlined,
                label: 'Home',
                isDarkTheme: isDarkTheme,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.grid_view_rounded,
                inactiveIcon: Icons.grid_view_rounded,
                label: 'Categories',
                isDarkTheme: isDarkTheme,
              ),
              _buildNavItem(
                context: context,
                index: 4,
                icon: Icons.inventory_2_rounded,
                inactiveIcon: Icons.inventory_2_outlined,
                label: 'Orders',
                isDarkTheme: isDarkTheme,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.favorite_rounded,
                inactiveIcon: Icons.favorite_border_rounded,
                label: 'Wishlist',
                isDarkTheme: isDarkTheme,
              ),
              _buildNavItem(
                context: context,
                index: profileIndex >= 0 ? profileIndex : -1,
                icon: Icons.person_rounded,
                inactiveIcon: Icons.person_outline_rounded,
                label: 'Profile',
                isDarkTheme: isDarkTheme,
                onTapOverride: profileIndex < 0 ? () => RouteHelper.getProfileScreen() : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData inactiveIcon,
    required String label,
    required bool isDarkTheme,
    VoidCallback? onTapOverride,
  }) {
    final bool isSelected = splash.pageIndex == index && index != -1;
    final Color activeColor = isDarkTheme
        ? (Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white)
        : const Color(0xFF004B4B);
    final Color inactiveColor = const Color(0xFF5E757A);

    return InkWell(
      onTap: () {
        if (onTapOverride != null) {
          onTapOverride();
        } else if (index >= 0 && index < splash.screenList.length) {
          splash.setPageIndex(index);
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? icon : inactiveIcon,
              size: 23,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: isSelected
                  ? poppinsBold.copyWith(
                      fontSize: 10.5,
                      color: activeColor,
                    )
                  : poppinsMedium.copyWith(
                      fontSize: 10.5,
                      color: inactiveColor,
                    ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            if (isSelected)
              Container(
                height: 2.5,
                width: 22,
                decoration: BoxDecoration(
                  color: ColorResources.headerYellow,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            else
              const SizedBox(height: 2.5, width: 22),
          ],
        ),
      ),
    );
  }
}

void _showBottomSheet(BuildContext context){
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius:  const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const SizedBox(width: 25),

              Container(height: 5, width: 40, decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(25),
              )),

              InkWell(
                onTap: ()=> Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).hintColor.withValues(alpha: 0.1)
                  ),
                  padding: EdgeInsets.all(7),
                  child: Image.asset(Images.crossIcon, height: Dimensions.paddingSizeSmall, width: Dimensions.paddingSizeSmall),
                ),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Image.asset(Images.lockIcon, height: 60, width: 60),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text(getTranslated('you_are_almost_there', context), style: poppinsBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
            ), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(getTranslated('log_in_or_sign_up_to_continue_and_enjoy', context), style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
            ), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: CustomButtonWidget(
                onPressed: ()=> RouteHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil),
                buttonText: getTranslated('login_or_signup', context),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            if((Provider.of<SplashProvider>(context, listen: false).configModel?.isGuestCheckout ?? false))...[
              Center(child: TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(1, 40)),
                onPressed: () => Navigator.pop(context),
                child: RichText(text: TextSpan(children: [
                  TextSpan(
                    text: '${getTranslated('continue_as_a', context)} ',
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withValues(alpha: 0.6)),
                  ),

                  TextSpan(text: getTranslated('guest', context), style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor)),

                ])),
              )),

              const SizedBox(height: Dimensions.paddingSizeDefault),
            ]

          ]),
        );
      }
  );
}