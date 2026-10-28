import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/features/home/widgets/category_page_widget.dart';
import 'package:flutter_grocery/features/home/widgets/category_shimmer_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/title_widget.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final bool isDarkTheme = Provider.of<ThemeProvider>(context).darkTheme;

    return Consumer<CategoryProvider>(builder: (context, categoryProvider, child) {
      if (categoryProvider.categoryList == null) {
        return const CategoriesShimmerWidget();
      }
      if (categoryProvider.categoryList?.isEmpty ?? true) {
        return const SizedBox();
      }

      if (ResponsiveHelper.isDesktop(context)) {
        return Column(
          children: [
            TitleWidget(
              title: getTranslated('popular_categories', context),
              onTap: () => RouteHelper.getAllCategoryScreen(),
            ),
            CategoryWebWidget(scrollController: scrollController),
          ],
        );
      }

      final categories = categoryProvider.categoryList!;
      final bool canExpand = categories.length <= 4;

      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeExtraSmall,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          color: isDarkTheme ? Theme.of(context).cardColor : ColorResources.categoryBgLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shop by Category',
                  style: poppinsBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: isDarkTheme ? Theme.of(context).textTheme.bodyLarge?.color : const Color(0xFF004B4B),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (ResponsiveHelper.isMobilePhone()) {
                      splashProvider.setPageIndex(1);
                    } else {
                      RouteHelper.getAllCategoryScreen();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getTranslated('view_all', context),
                          style: poppinsMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: isDarkTheme ? Theme.of(context).primaryColor : const Color(0xFF004B4B),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: isDarkTheme ? Theme.of(context).primaryColor : const Color(0xFF004B4B),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisAlignment: canExpand ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
                      children: categories.map((category) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: canExpand ? 0 : 8),
                          child: InkWell(
                            onTap: () {
                              categoryProvider.onChangeSelectIndex(-1, notify: false);
                              RouteHelper.getCategoryProductsRoute(
                                categoryId: '${category.id}',
                                categoryName: '${category.name}',
                              );
                            },
                            child: SizedBox(
                              width: 76,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 68,
                                    width: 68,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: ClipOval(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: CustomImageWidget(
                                            image: '${splashProvider.baseUrls?.categoryImageUrl}/${category.image}',
                                            fit: BoxFit.contain,
                                            height: 56,
                                            width: 56,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.name ?? '',
                                    style: poppinsMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: isDarkTheme ? Theme.of(context).textTheme.bodyLarge?.color : const Color(0xFF004B4B),
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}


