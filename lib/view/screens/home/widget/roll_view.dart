import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:flutter_grocery/view/screens/home/web/web_daily_item_view.dart';
import 'package:flutter_grocery/view/screens/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class RollView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, productProvider, child) {
      return productProvider.rollList != null ? Column(children: [

        SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0),

        TitleWidget(title: getTranslated('momos_item', context), onTap: () {
          Navigator.pushNamed(context, RouteHelper.RollRoute());
        }),

        ResponsiveHelper.isDesktop(context)
            ?  GridView.builder(
                  itemCount: productProvider.rollList.length >= 10 ? 10 : productProvider.rollList.length,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio:  (1 / 1.3),
                  crossAxisCount: 5,
                  mainAxisSpacing: 13,
                  crossAxisSpacing: 13,
                  ),
                    itemBuilder: (context,index){
                      return listViewRollItem(context: context,index: index,productProvider: productProvider);
                    },
                  )

            : SizedBox(
          height: 190,
          child:  ListView.builder(
            itemCount: productProvider.rollList.length,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return listViewRollItem(context: context,index: index,productProvider: productProvider);
            },
          ),
        ),

      ]) : SizedBox();
    });
  }
  Widget listViewRollItem({BuildContext context, int index, ProductProvider productProvider}){
    return Padding(
      padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(product: productProvider.rollList[index]),
              arguments: ProductDetailsScreen(product: productProvider.rollList[index]));
        },
        child: Container(
          width: 150,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Container(
              height: 100, width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: ColorResources.getGreyColor(context)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder(context), width: 100, height: 150, fit: BoxFit.cover,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}'
                      '/${productProvider.rollList[index].image[0]}',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 80, height: 50, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(
                productProvider.rollList[index].name,
                style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),

              Text(
                '${productProvider.rollList[index].capacity} ${productProvider.rollList[index].unit}',
                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PriceConverter.convertPrice(
                        context, productProvider.rollList[index].price,
                        discount: productProvider.rollList[index].discount,
                        discountType: productProvider.rollList[index].discountType,
                      ),
                      style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),

                    productProvider.rollList[index].discount > 0 ? Text(
                      PriceConverter.convertPrice(
                        context, productProvider.rollList[index].price,
                        discount: productProvider.rollList[index].discount,
                        discountType: productProvider.rollList[index].discountType,
                      ),
                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, decoration: TextDecoration.lineThrough),
                    ) : SizedBox(),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: ColorResources.getHintColor(context).withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                ),
              ]),

            ]),
          ]),
        ),
      ),
    );
  }
}
