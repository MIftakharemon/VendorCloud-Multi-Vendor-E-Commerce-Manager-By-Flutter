import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/chat/chat_user_list.dart';
import 'package:karmalab_assignment/screens/order/widgets/orders_list.dart';
import '../screens/Dashboard/dashboard.dart';
import '../screens/authentication/forgot/forgot_password.dart';
import '../screens/authentication/login/changePasswordForPhoneLogin.dart';
import '../screens/authentication/login/login_view.dart';
import '../screens/authentication/new_password/new_password.dart';
import '../screens/authentication/siginup/signup_view.dart';
import '../screens/authentication/verification/verification_view.dart';
import '../screens/category/category_management_screen.dart';
import '../screens/event_ad_management_package(1st screen)/event_ad_mangement_package(1st screen).dart';
import '../screens/finance/vendor_finance.dart';
import '../screens/home/home.dart';
import '../screens/mainScreen/mainscreen.dart';
import '../screens/onboarding/onboarding_view.dart';
import '../screens/product/all_products.dart';
import '../screens/product/product_details_screen.dart';
import '../screens/product/product_upload_screen.dart';
import '../screens/product_reviews/products_for_review_screen.dart';
import '../screens/profile/profile_view.dart';
import '../screens/report/all_reports.dart';
import '../screens/splash/splash_view.dart';
import 'Bindings/category_bindings.dart';
import 'Bindings/fetchProductBindings.dart';
import 'Bindings/orderlist_binding.dart';
import 'Bindings/product_creation_screen_binding.dart';

class RouteUtil {
  static final routes = [
    GetPage(name: SplashView.routeName, page: () => const SplashView()),
    GetPage(name: OnboardingView.routeName, page: () => const OnboardingView()),
    GetPage(name: SignUpView.routeName, page: () => SignUpView()),
    GetPage(name: LoginView.routeName, page: () => LoginView()),
    GetPage(name: VerificationView.routeName, page: () => const VerificationView()),
    GetPage(name: Profile.routeName, page: () => Profile()),
    GetPage(name: ProductCreationScreen.routeName, page: () => ProductCreationScreen(), binding: ProductCreationScreenBinding(),),
    GetPage(name: CategorySubcategoryView.routeName, page: () => const CategorySubcategoryView(), binding: Categorybindings(),),
    GetPage(name: Package_EventScreen.packageRouteName, page: () => const Package_EventScreen()),
    GetPage(name: Package_EventScreen.eventRouteName, page: () => const Package_EventScreen(isPackageScreen: false,)),
    GetPage(name: OrdersListItems.routeName, page: () => const OrdersListItems(), binding: OrderlistBinding()),
    GetPage(name: MainScreen.routeName, page: () =>  MainScreen()),
    GetPage(name: AllReports.routeName, page: () =>  AllReports()),
    GetPage(name: HomeScreen.routeName, page: () =>  HomeScreen()),
    GetPage(name: FinanceScreen.routeName, page: () =>  FinanceScreen()),
    GetPage(name: FinanceScreen.routeName, page: () =>  FinanceScreen()),
    GetPage(name: NewPassWordView.routeName, page: () => const NewPassWordView()),
    GetPage(name: ProductsListScreen.routeNameReviews, page: () => const ProductsListScreen(isReviewScreen: true),),
    GetPage(name: ProductsListScreen.routeNameQA, page: () => const ProductsListScreen(isReviewScreen: false),),
    GetPage(name: DashboardScreen.routeName, page: () => DashboardScreen()),
    GetPage(name: ChatListScreen.routeName, page: () => ChatListScreen()),
    GetPage(name: ProductDetailsScreen.routeName, page: () => ProductDetailsScreen(product: Get.arguments,), transition: Transition.fadeIn,),

  ];
}
