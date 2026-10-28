import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/on_hover_widget.dart';
import 'package:provider/provider.dart';

import 'wish_button_widget.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final String productType;
  final bool isGrid;
  final bool isCenter;
  const ProductWidget({super.key, required this.product, this.productType = ProductType.dailyItem, this.isGrid = false, this.isCenter = false});


  @override
  Widget build(BuildContext context) {


    final discountValue = PriceConverterHelper.convertProductDiscount(
      price: product.price,
      discount: product.discount,
      discountType: product.discountType,
      categoryDiscount: product.categoryDiscount,
    );
    final double? priceWithDiscount = discountValue.discount;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        double price = 0;
        int? stock = 0;
        bool isExistInCart = false;
        int? cardIndex;
        CartModel? cartModel;
        if(product.variations!.isNotEmpty) {

          for(int index=0; index<product.variations!.length; index++) {
            price = product.variations!.isNotEmpty ? (product.variations![index].price ?? 0) : (product.price ?? 0);
            stock = product.variations!.isNotEmpty ? product.variations![index].stock : product.totalStock;
            cartModel = CartModel(product.id, product.image!.isNotEmpty ? product.image![0] : '', product.name, price,
                discountValue.discount,
                1,
                product.variations!.isNotEmpty ? product.variations![index] : null,
                (price - (discountValue.discount ?? 0)),
                ((discountValue.discount ?? 0) - PriceConverterHelper.convertWithDiscount(discountValue.discount, product.tax, product.taxType)!),
                product.capacity,
                product.unit,
                stock,product
            );
            isExistInCart = cartProvider.isExistInCart(cartModel) != null;
            cardIndex = cartProvider.isExistInCart(cartModel);

            if(isExistInCart) {
              break;
            }
          }
        }else {
          price =  product.price ?? 0;
          stock = product.totalStock;
          cartModel = CartModel(
            product.id, (product.image?.isNotEmpty ?? false) ?  product.image![0] : '',
            product.name, price,
            discountValue.discount,
            1, null,
            (price - (discountValue.discount ?? 0)),
            ((discountValue.discount ?? 0) - PriceConverterHelper.convertWithDiscount(discountValue.discount, product.tax, product.taxType)!),
            product.capacity,
            product.unit,
            stock,product,
          );

          isExistInCart = cartProvider.isExistInCart(cartModel) != null;
          cardIndex = cartProvider.isExistInCart(cartModel);
        }

        final bool hasNotVariations = product.variations == null || (product.variations?.isEmpty ?? false);


        return isGrid ? OnHoverWidget(isItem: true, child: _ProductGridWidget(
          cardIndex: cardIndex,
          isCenter: isCenter,
          isExistInCart: isExistInCart,
          priceWithDiscount: priceWithDiscount ?? 0,
          discountType: discountValue.type,
          product: product,
          productType: productType,
          cartModel: cartModel,
          stock: stock,
        )) : Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: InkWell(
            hoverColor: Colors.transparent,
            onTap: () => RouteHelper.getProductDetailsRoute(
              productId: product.id, formSearch: productType == ProductType.searchItem,
            ),

            child: OnHoverWidget(
              isItem: true,
              child: Container(
                height: 110,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 4), blurRadius: 7, spreadRadius: 0.1)],
                ),
                child: Row(children: [

                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.05)),
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomImageWidget(
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${
                                product.image!.isNotEmpty ? product.image![0] : ''}',
                            height: 110, width: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      product.price != discountValue.discount ? Positioned(
                        top: 5, left: 5,
                        child: _DiscountTag(product: product, discountType: discountValue.type),
                      ) : const SizedBox(),

                      Positioned(
                          top:  5,
                          right: 5,
                          bottom: null,
                        child: !isExistInCart || !hasNotVariations? Tooltip(
                          message: getTranslated('click_to_add_to_your_cart', context),
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  if(product.variations == null || product.variations!.isEmpty) {
                                    if (isExistInCart) {
                                      showCustomSnackBarHelper('already_added'.tr);
                                    } else if (stock! < 1) {
                                      showCustomSnackBarHelper('${getTranslated('there_is_nt_enough_quantity_on_stock', context)} ${getTranslated('only', context)} $stock ${getTranslated('is_available', context)}', snackBarStatus: SnackBarStatus.info);
                                    } else {
                                      Provider.of<CartProvider>(context, listen: false).addToCart(cartModel!);
                                      showCustomSnackBarHelper('added_to_cart'.tr, isError: false);
                                    }
                                  }else {
                                    RouteHelper.getProductDetailsRoute(
                                      productId: product.id, formSearch:productType == ProductType.searchItem,
                                    );
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.05)),
                                    ),
                                    child: Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: Dimensions.paddingSizeLarge,
                                    )
                                ),
                              ),

                              if(isExistInCart && !hasNotVariations) Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    transform: Matrix4.translationValues(5, -10, 0),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                                    child: Text('${Provider.of<CartProvider>(context).getCartQuantityByProductId(product.id!)}',
                                        style: TextStyle(color: Theme.of(context).cardColor, fontSize: 10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) : Consumer<CartProvider>(builder: (context, cart, child) => RotatedBox(
                          quarterTurns: 3,
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: 0.05)),
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.80),
                            ),

                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              InkWell(
                                onTap: () {
                                  if (cart.cartList[cardIndex!].quantity! > 1) {
                                    Provider.of<CartProvider>(context, listen: false).setCartQuantity(false, cardIndex, context: context, showMessage: true);
                                  } else {
                                    Provider.of<CartProvider>(context, listen: false).removeItemFromCart(cardIndex, context);
                                  }
                                },
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(
                                      Icons.remove, size: Dimensions.paddingSizeLarge,
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              ),

                              RotatedBox(
                                quarterTurns: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    cart.cartList[cardIndex!].quantity.toString(),
                                    style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                                  ),
                                ),
                              ),


                              InkWell(
                                onTap: () {
                                  if(cart.cartList[cardIndex!].product!.maximumOrderQuantity == null || cart.cartList[cardIndex].quantity! < cart.cartList[cardIndex].product!.maximumOrderQuantity!) {
                                    if(cart.cartList[cardIndex].quantity! < cart.cartList[cardIndex].stock!) {
                                      cart.setCartQuantity(true, cardIndex, showMessage: false, context: context);
                                    }else {
                                      showCustomSnackBarHelper('${getTranslated('there_is_nt_enough_quantity_on_stock', context)} ${getTranslated('only', context)} ${cart.cartList[cardIndex].stock} ${getTranslated('is_available', context)}', snackBarStatus: SnackBarStatus.info);
                                    }
                                  }else{
                                    showCustomSnackBarHelper('${getTranslated('you_cant_add_more_than', context)} ${(cart.cartList[cardIndex].product!.maximumOrderQuantity ?? 0)} '
                                        '${getTranslated((cart.cartList[cardIndex].product!.maximumOrderQuantity ?? 0) > 1 ? 'items' : 'item', context)}', snackBarStatus: SnackBarStatus.info);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      shape: BoxShape.circle
                                  ),
                                  child: Icon(Icons.add, size: Dimensions.paddingSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        ),
                      ),

                    ],
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            product.rating != null ? Row(mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.start, children: [
                              const Icon(Icons.star_rounded, color: ColorResources.ratingColor, size: 20),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text(product.rating!.isNotEmpty ? product.rating![0].average!.toStringAsFixed(1) : '0.0', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                            ]) : const SizedBox(),

                            Tooltip(message: product.name, child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Text(product.name ?? '',
                                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),

                            Text('${product.capacity} ${product.unit}', style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

                            Flexible(
                              child: Row(children: [
                                product.price! > priceWithDiscount! ? CustomDirectionalityWidget(child: Text(
                                  PriceConverterHelper.convertPrice(context, product.price),
                                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough, color: Theme.of(context).disabledColor),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )) : const SizedBox(),

                                product.price! > priceWithDiscount ? const SizedBox(width: Dimensions.paddingSizeExtraSmall) : const SizedBox(),

                                CustomDirectionalityWidget(child: Text(
                                  PriceConverterHelper.convertPrice(context, priceWithDiscount),
                                  style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )),

                              ],),
                            ),
                          ]),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: WishButtonWidget(product: product, edgeInset: const EdgeInsets.all(5)),
                  ),

                ]),
              ),
            ),
          ),
        );
      },
    );
  }


}


class _ProductGridWidget extends StatelessWidget {
  final bool isExistInCart;
  final int? stock;
  final CartModel? cartModel;
  final int? cardIndex;
  final double priceWithDiscount;
  final DiscountType? discountType;
  final Product product;
  final String productType;
  final bool isCenter;

  const _ProductGridWidget({
    required this.isExistInCart, this.stock, this.cartModel,
    required this.cardIndex, required this.priceWithDiscount,
    required this.product, required this.productType, required this.isCenter,
    required this.discountType,
  });


  @override
  Widget build(BuildContext context) {
    final bool hasNotVariations = product.variations == null || (product.variations?.isEmpty ?? false);
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    Widget buildBadge() {
      String badgeText = '';
      Color badgeBg = const Color(0xFF004B4B);
      Color badgeTextColor = Colors.white;

      if (product.discount != null && product.discount! > 0) {
        badgeText = product.discountType == 'percent'
            ? '${product.discount!.toInt()}% OFF'
            : '-${PriceConverterHelper.convertPrice(context, product.discount)}';
        badgeBg = const Color(0xFFD94B4B);
      } else if (product.rating != null && product.rating!.isNotEmpty && (product.rating![0].average ?? 0) >= 4.5) {
        badgeText = 'Best Seller';
        badgeBg = ColorResources.headerYellow;
        badgeTextColor = const Color(0xFF163238);
      } else if (productType == ProductType.featuredItem) {
        badgeText = 'Premium';
        badgeBg = const Color(0xFF004B4B);
      } else {
        badgeText = 'Fresh';
        badgeBg = const Color(0xFF004B4B);
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
        decoration: BoxDecoration(
          color: badgeBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          badgeText,
          style: poppinsBold.copyWith(fontSize: 10, color: badgeTextColor),
        ),
      );
    }

    return InkWell(
      hoverColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        RouteHelper.getProductDetailsRoute(
          productId: product.id,
          formSearch: productType == ProductType.searchItem,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E9EA).withValues(alpha: 0.7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Badge & Wishlist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBadge(),
                WishButtonWidget(
                  product: product,
                  edgeInset: const EdgeInsets.all(4.0),
                ),
              ],
            ),

            // Product Image
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomImageWidget(
                      fit: BoxFit.contain,
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${(product.image?.isNotEmpty ?? false) ? product.image![0] : ''}',
                    ),
                  ),
                ),
              ),
            ),

            // Product Name
            Text(
              product.name ?? '',
              style: poppinsBold.copyWith(
                fontSize: 13,
                color: isDarkTheme ? Theme.of(context).textTheme.bodyLarge?.color : const Color(0xFF004B4B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Subtitle / Weight
            Text(
              (product.capacity != null && product.capacity! > 0)
                  ? '(${product.capacity! % 1 == 0 ? product.capacity!.toInt() : product.capacity} ${product.unit ?? ''})'.trim()
                  : (product.unit != null && product.unit!.isNotEmpty ? '(${product.unit})' : ''),
              style: poppinsRegular.copyWith(
                fontSize: 11,
                color: const Color(0xFF64777D),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Price Row
            Row(
              children: [
                CustomDirectionalityWidget(
                  child: Text(
                    PriceConverterHelper.convertPrice(context, priceWithDiscount),
                    style: poppinsBold.copyWith(
                      fontSize: 14,
                      color: isDarkTheme ? Theme.of(context).textTheme.bodyLarge?.color : const Color(0xFF004B4B),
                    ),
                  ),
                ),
                if (product.unit != null && product.unit!.isNotEmpty)
                  Text(
                    '/${product.unit}',
                    style: poppinsBold.copyWith(
                      fontSize: 11,
                      color: isDarkTheme ? Theme.of(context).textTheme.bodyLarge?.color : const Color(0xFF004B4B),
                    ),
                  ),
                if ((product.price ?? 0) > priceWithDiscount) ...[
                  const SizedBox(width: 4),
                  CustomDirectionalityWidget(
                    child: Text(
                      PriceConverterHelper.convertPrice(context, product.price),
                      style: poppinsRegular.copyWith(
                        fontSize: 10,
                        color: Theme.of(context).disabledColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Add to Cart Button (in #FED615 Yellow pill)
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                final bool inCart = isExistInCart && hasNotVariations;
                final int currentQty = inCart ? (cart.cartList[cardIndex!].quantity ?? 1) : 0;

                if (inCart) {
                  return Container(
                    height: 34,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorResources.headerYellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            if (currentQty > 1) {
                              Provider.of<CartProvider>(context, listen: false)
                                  .setCartQuantity(false, cardIndex, context: context, showMessage: true);
                            } else {
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeItemFromCart(cardIndex!, context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.remove, size: 14, color: Color(0xFF004B4B)),
                          ),
                        ),
                        Text(
                          '$currentQty',
                          style: poppinsBold.copyWith(fontSize: 13, color: const Color(0xFF004B4B)),
                        ),
                        InkWell(
                          onTap: () {
                            final cartProduct = cart.cartList[cardIndex!].product;
                            if (cartProduct?.maximumOrderQuantity == null ||
                                currentQty < cartProduct!.maximumOrderQuantity!) {
                              if (currentQty < (cart.cartList[cardIndex!].stock ?? 0)) {
                                Provider.of<CartProvider>(context, listen: false)
                                    .setCartQuantity(true, cardIndex, context: context, showMessage: true);
                              } else {
                                showCustomSnackBarHelper(getTranslated('out_of_stock', context));
                              }
                            } else {
                              showCustomSnackBarHelper(
                                '${getTranslated('you_can_add_max', context)} ${cartProduct.maximumOrderQuantity} ${getTranslated('items', context)}',
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.add, size: 14, color: Color(0xFF004B4B)),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return InkWell(
                  onTap: () {
                    if (product.variations == null || product.variations!.isEmpty) {
                      if (isExistInCart) {
                        showCustomSnackBarHelper('already_added'.tr);
                      } else if ((stock ?? 0) < 1) {
                        showCustomSnackBarHelper(
                          '${getTranslated('there_is_nt_enough_quantity_on_stock', context)} ${getTranslated('only', context)} $stock ${getTranslated('is_available', context)}',
                          snackBarStatus: SnackBarStatus.info,
                        );
                      } else {
                        Provider.of<CartProvider>(context, listen: false).addToCart(cartModel!);
                        showCustomSnackBarHelper('added_to_cart'.tr, isError: false);
                      }
                    } else {
                      RouteHelper.getProductDetailsRoute(
                        productId: product.id,
                        formSearch: productType == ProductType.searchItem,
                      );
                    }
                  },
                  child: Container(
                    height: 34,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorResources.headerYellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart, size: 15, color: Color(0xFF004B4B)),
                        const SizedBox(width: 6),
                        Text(
                          'Add to Cart',
                          style: poppinsBold.copyWith(
                            fontSize: 12,
                            color: const Color(0xFF004B4B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class _DiscountTag extends StatelessWidget {
  const _DiscountTag({required this.product, required this.discountType,});

  final Product product;
  final DiscountType discountType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Dimensions.radiusSizeTen),
          bottomLeft: Radius.circular(Dimensions.radiusSizeTen),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              discountType == DiscountType.productDiscount
                  ? product.discountType == 'percent'
                  ? '-${product.discount} %'
                  : '-${PriceConverterHelper.convertPrice(context, product.discount)}'
                  : product.categoryDiscount?.discountType == 'percent'
                  ? '-${product.categoryDiscount?.discountAmount} %'
                  : '-${PriceConverterHelper.convertPrice(context, product.categoryDiscount?.discountAmount)}',
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
            ),
          ),
        ],
      ),
    );
  }
}


