import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_handel_deep_link_widget.dart';
import 'package:flutter_grocery/features/auth/domain/models/signup_model.dart';
import 'package:flutter_grocery/helper/email_checker_helper.dart';
import 'package:flutter_grocery/helper/phone_number_checker_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  final String? referralCode;
  const CreateAccountScreen({super.key, this.referralCode});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referTextFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referTextController = TextEditingController();

  String? countryCode;

  @override
  void initState() {
    countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.country!).dialCode;
    Provider.of<AuthProvider>(context, listen: false).updateRegistrationErrorMessage('', false);

    if (Provider.of<SplashProvider>(context, listen: false).configModel?.referEarnStatus == true && (widget.referralCode?.isNotEmpty ?? false)) {
      _referTextController.text = widget.referralCode ?? '';
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final config = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final double width = MediaQuery.of(context).size.width;
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return CustomPopScopeHandelDeepLinkWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        RouteHelper.getMainRoute();
                      }
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE2E9EA).withValues(alpha: 0.8),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF004B4B)),
                    ),
                  ),
                ),
              ),
        body: Consumer<AuthProvider>(builder: (context, authProvider, child) => SafeArea(
          child: CustomScrollView(slivers: [

            SliverToBoxAdapter(child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.isDesktop(context) ? 0 : 16,
                vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 8,
              ),
              child: Center(child: Column(children: [
                Container(
                  width: width > 540 ? 500 : width,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.isDesktop(context) ? 40 : 20,
                    vertical: 26,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE2E9EA).withValues(alpha: 0.8),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with SeaWala Logo
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE1F2E8),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(Images.appLogo, width: 44, height: 44),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              getTranslated('create_account', context),
                              style: poppinsBold.copyWith(
                                fontSize: 22,
                                color: isDarkTheme ? Theme.of(context).textTheme.bodyLarge?.color : const Color(0xFF004B4B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Join SeaWala for fresh seafood at your doorstep',
                              textAlign: TextAlign.center,
                              style: poppinsRegular.copyWith(
                                fontSize: 12.5,
                                color: const Color(0xFF64777D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // First & Last Name side-by-side
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextFieldWidget(
                              title: getTranslated('first_name', context),
                              hintText: 'John',
                              isShowBorder: true,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Icons.person_outline_rounded,
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              nextFocus: _lastNameFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              fillColor: isDarkTheme ? null : const Color(0xFFF9FBFA),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextFieldWidget(
                              title: getTranslated('last_name', context),
                              hintText: 'Doe',
                              isShowBorder: true,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Icons.person_outline_rounded,
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              fillColor: isDarkTheme ? null : const Color(0xFFF9FBFA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Mobile number section
                      CustomTextFieldWidget(
                        countryDialCode: countryCode,
                        onCountryChanged: (CountryCode value) {
                          countryCode = value.dialCode;
                        },
                        hintText: getTranslated('number_hint', context),
                        isShowBorder: true,
                        controller: _numberController,
                        inputType: TextInputType.phone,
                        title: getTranslated('mobile_number', context),
                        fillColor: isDarkTheme ? null : const Color(0xFFF9FBFA),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Email section
                      CustomTextFieldWidget(
                        title: getTranslated('email', context),
                        hintText: getTranslated('demo_gmail', context),
                        isShowBorder: true,
                        isShowPrefixIcon: true,
                        prefixIconUrl: Icons.mail_outline_rounded,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: config.referEarnStatus! ? _referTextFocus : _passwordFocus,
                        inputType: TextInputType.emailAddress,
                        fillColor: isDarkTheme ? null : const Color(0xFFF9FBFA),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Refer code section (if enabled)
                      if (config.referEarnStatus!) ...[
                        CustomTextFieldWidget(
                          title: '${getTranslated('refer_code', context)} (${getTranslated('optional', context)})',
                          hintText: 'Enter referral code',
                          isShowBorder: true,
                          isShowPrefixIcon: true,
                          prefixIconUrl: Icons.card_giftcard_rounded,
                          controller: _referTextController,
                          focusNode: _referTextFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.text,
                          fillColor: isDarkTheme ? null : const Color(0xFFF9FBFA),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ],

                      // Password section
                      CustomTextFieldWidget(
                        title: getTranslated('password', context),
                        hintText: getTranslated('password_hint', context),
                        isShowBorder: true,
                        isPassword: true,
                        isShowPrefixIcon: true,
                        prefixIconUrl: Icons.lock_outline_rounded,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                        fillColor: isDarkTheme ? null : const Color(0xFFF9FBFA),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Confirm password section
                      CustomTextFieldWidget(
                        title: getTranslated('confirm_password', context),
                        hintText: getTranslated('password_hint', context),
                        isShowBorder: true,
                        isPassword: true,
                        isShowPrefixIcon: true,
                        prefixIconUrl: Icons.lock_outline_rounded,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                        inputAction: TextInputAction.done,
                        fillColor: isDarkTheme ? null : const Color(0xFFF9FBFA),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      // Error message (if any)
                      if (authProvider.registrationErrorMessage != null && authProvider.registrationErrorMessage!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error_outline_rounded, size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.registrationErrorMessage!,
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Signup button
                      const SizedBox(height: 8),
                      CustomButtonWidget(
                        isLoading: authProvider.isLoading,
                        buttonText: getTranslated('signup', context),
                        borderRadius: 25,
                        height: 48,
                        backgroundColor: const Color(0xFF004B4B),
                        textStyle: poppinsBold.copyWith(fontSize: 15, color: Colors.white),
                        onPressed: () => _onSignUpPress(config),
                      ),

                      // Already have an account? Login
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated('already_have_account', context),
                            style: poppinsRegular.copyWith(
                              fontSize: 13,
                              color: const Color(0xFF64777D),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              RouteHelper.getLoginRoute(action: RouteAction.pushReplacement);
                            },
                            child: Text(
                              getTranslated('login', context),
                              style: poppinsBold.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF004B4B),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ResponsiveHelper.isDesktop(context) ? const SizedBox(height: 50) : const SizedBox(height: 20),

              ])),
            )),

            const FooterWebWidget(footerType: FooterType.sliver),

          ]),
        )),
      ),
    );
  }

  void _onSignUpPress(ConfigModel config) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String number = _numberController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    String phoneWithCountryCode = (countryCode ?? '') + number;
    bool isPhoneValid = PhoneNumberCheckerHelper.isPhoneValidWithCountryCode(phoneWithCountryCode);

    if (firstName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_first_name', context));

    }else if (lastName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_last_name', context));

    }else if (number.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_phone_number', context));

    }else if(!isPhoneValid){
      showCustomSnackBarHelper(getTranslated('invalid_phone_number', context));

    }else if (password.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_password', context));

    }else if (password.length < 6) {
      showCustomSnackBarHelper(getTranslated('password_should_be', context));

    }else if (confirmPassword.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_confirm_password', context));

    }else if(password != confirmPassword) {
      showCustomSnackBarHelper(getTranslated('password_did_not_match', context));

    }else if (email.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_email_address', context));

    }else if (EmailCheckerHelper.isNotValid(email)) {
      showCustomSnackBarHelper(getTranslated('enter_valid_email', context));

    }else {

      SignUpModel signUpModel = SignUpModel(
        fName: firstName,
        lName: lastName,
        email: email,
        password: password,
        phone: '$countryCode$number',
        referralCode: _referTextController.text.trim(),
      );
      authProvider.registration(context, signUpModel, config).then((status) async {
        if (status.isSuccess) {
          RouteHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
        }
      });
    }
  }

}
