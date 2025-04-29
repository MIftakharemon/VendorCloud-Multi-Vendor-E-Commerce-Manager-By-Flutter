
class NetworkConstants {

  static const String baseURL = "https://readyhow.com/";

  static const String registerAPI = "api/auth/register";
  static const String loginAPI = "api/auth/login";
  static const String forgotPassWord = "api/auth/forgot-password";
  static const String verifyOtp = "api/auth/verify-otp";
  static const String sendOtp = "api/auth/send-otp";


  static const String googleAuth = "api/auth/google";
  static const String googleLoginSuccessRedirectTo= "api/auth/google/callback";
  static const String googleSuccess= "api/auth/google/success";




  static const String logoutUser = "api/auth/logout";
  static const String updatePassword = "api/auth/update-password";
  static const String forgotPassword = "api/auth/forgot-password";
  static const String resetPassword = "api/auth/reset-password";
  static const String changePassword = "api/auth/update-password";



  static const String getAllUsers = "api/users";
  static String getUserById(String userId) => "api/users/$userId";
  static const String getMe = "api/users/me";
  static String updateUserById(String userId) => "api/users/$userId";
  static const String updateMe = "api/users/me";
  static String deleteUserById(String userId) => "api/users/$userId";
  static const String deleteMe = "api/users/me";



  static const String uploadImage = "api/auth/register";


  static String getUsers({int? page, int? limit, String? sort, String? search, String? fields}) {
    final queryParams = <String>[];
    if (page != null) queryParams.add('_page=$page');
    if (limit != null) queryParams.add('_limit=$limit');
    if (sort != null) queryParams.add('_sort=$sort');
    if (search != null) queryParams.add('_search=$search');
    if (fields != null) queryParams.add('_fields=$fields');
    final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    return 'api/users$queryString';
  }




  static String getBrandFromProductByCategory(String id) => "api/products?_filter[category]=$id";


  static const String getProducts = "api/products?_limit=200";
  static const String createProduct = "api/products";
  static String getProductById(String id) => "api/products/$id";
  static String getProductBySlug(String slug) => "api/products/$slug";
  static String updateProductById(String id) => "api/products/$id";
  static String updateProductBySlug(String slug) => "api/products/$slug";
  static String deleteProductById(String id) => "api/products/$id";
  static String deleteProductBySlug(String slug) => "api/products/$slug";
  static const String getRandomProducts = "api/products/get-random-products?_limit=20";
  static String getRandomProductsWithLimit(int limit) => "api/products/get-random-products?_limit=$limit";

  static String getUserProducts(String userId) => "api/users/$userId/products";
  static String getFavouriteProducts() => "api/users/me/products";

  static String toggleLikeProduct(String productId) => "api/products/$productId/like";

  static String getPaginatedProducts(int limit, int page) => "api/products?_limit=$limit&_page=$page";
  static String getProductsForBrand(String id,int limit) => "api/users/$id/products?_limit=$limit";



  static String getSubCategoryProductsByUser(String userId, String subCategoryId, int limit) => "api/users/$userId/products?_filter[subCategory]=$subCategoryId&_limit=$limit";


  static searchProduct(String query) => "api/products?_search=$query,product,name,slug,summary,description";
  static const String sortProductsByPriceLowestToHigest = "api/products?_sort=-price";
  static const String sortProductsByPriceHigestToLowest = "api/products?_sort=price";

  static getProductsForOnlySelectedField(String query) => "api/products?_fields=$query";

  static const String getManyProducts = "api/products/many";






  static const String getAllReviews = "api/reviews";
  static String getReviewsByProductId(String productId) => "api/products/$productId/reviews";
  static String getReviewsByUserId(String userId) => "api/users/$userId/reviews";
  static const String getLoggedInUserReviews = "api/me/reviews";
  static const String createReview = "api/reviews";
  static String getReviewById(String reviewId) => "api/reviews/$reviewId";
  static String updateReviewById(String reviewId) => "api/reviews/$reviewId";
  static String deleteReviewById(String reviewId) => "api/reviews/$reviewId";


  static String getReviewByProductIdAndReviewId(String productId, String reviewId) => "api/products/$productId/reviews/$reviewId";
  static String getReviewByUserIdAndReviewId(String userId, String reviewId) => "api/users/$userId/reviews/$reviewId";
  static String getReviewByLoggedInUserAndReviewId(String reviewId) => "api/me/reviews/$reviewId";


  static const String getAllVouchers = "api/vouchers";
  static String getVoucherById(String voucherId) => "api/vouchers/$voucherId";
  static const String createVoucher = "api/vouchers";
  static String updateVoucherById(String voucherId) => "api/vouchers/$voucherId";
  static String deleteVoucherById(String voucherId) => "api/vouchers/$voucherId";


  static const String getAllCategories = "api/categories";
  static String getCategoryById(String categoryId) => "api/categories/$categoryId";
  static const String createCategory = "api/categories";
  static String updateCategoryById(String categoryId) => "api/categories/$categoryId";
  static String deleteCategoryById(String categoryId) => "api/categories/$categoryId";


  static const String getAllSubCategories = "api/sub-categories";
  static String getSubCategoryById(String subCategoryId) => "api/sub-categories/$subCategoryId";
  static const String createSubCategory = "api/sub-categories";
  static String updateSubCategoryById(String subCategoryId) => "api/sub-categories/$subCategoryId";
  static String deleteSubCategoryById(String subCategoryId) => "api/sub-categories/$subCategoryId";

//for package
  static String getAllPackages(page,limit) => "api/packages?_sort=-createdAt&_page=$page&_limit=$limit";
  static String getPackageById(String packageId) => "api/packages/$packageId";
  static const String createPackage = "api/packages";
  static String updatePackageById(String packageId) => "api/packages/$packageId";
  static String deletePackageById(String packageId) => "api/packages/$packageId";

  // for event
  static String getAllEvents(int page, int limit) => "api/events?_sort=-createdAt&_page=$page&_limit=$limit";
  static String getEventById(String eventId) => "api/events/$eventId";
  static const String createEvent = "api/events";
  static String updateEventById(String eventId) => "api/events/$eventId";
  static String deleteEventById(String eventId) => "api/events/$eventId";







  // Package Products
  static String getAllPackageProducts(int page, int limit) => "api/package-products?_sort=-createdAt&_page=$page&_limit=$limit";
  static String getPackageProductById(String packageProductId) => "api/package-products/$packageProductId";
  static const String createPackageProduct = "api/package-products";
  static String updatePackageProductById(String packageProductId) => "api/package-products/$packageProductId";
  static String deletePackageProductById(String packageProductId) => "api/package-products/$packageProductId";

  // Event Products
  static String getAllEventProducts(int page, int limit) => "api/event-products?_sort=-createdAt&_page=$page&_limit=$limit";
  static String getEventProductById(String eventProductId) => "api/event-products/$eventProductId";
  static const String createEventProduct = "api/event-products";
  static String updateEventProductById(String eventProductId) => "api/event-products/$eventProductId";
  static String deleteEventProductById(String eventProductId) => "api/event-products/$eventProductId";








  static const String getAllPayments = "api/payments";
  static String getPaymentsByUserId(String userId) => "api/users/$userId/payments";
  static String getPaymentById(String paymentId) => "api/payments/$paymentId";
  static const String createPayment = "api/payments";
  static String updatePaymentById(String paymentId) => "api/payments/$paymentId";
  static String deletePaymentById(String paymentId) => "api/payments/$paymentId";
  static const String getPaymentRequest = "api/payments/request";
  static String successPayment(String transactionId) => "api/payments/success/$transactionId";
  static String cancelPayment(String transactionId) => "api/payments/cancel/$transactionId";




  static const String getAllReports = "api/reports";
  static String getReportById(String reportId) => "api/reports/$reportId";
  static const String createReport = "api/reports";
  static String updateReportById(String reportId) => "api/reports/$reportId";
  static String deleteReportById(String reportId) => "api/reports/$reportId";




  static const String getAllOthers = "api/others";
  static String getOtherById(String otherId) => "api/others/$otherId";
  static const String createOther = "api/others";
  static String updateOtherById(String otherId) => "api/others/$otherId";
  static String deleteOtherById(String otherId) => "api/others/$otherId";



  static const String getAllOrders = "api/orders";
  static String getOrderById(String orderId) => "api/orders/$orderId";
  static const String getMultipleOrders = "api/orders/many";

  static String getUserOrders(String id, {int page = 1, int limit = 20}) {
    return 'api/orders?_filter[vendor]=$id&_sort=-createdAt&_page=$page&_limit=$limit';
  }
  static String getAllUserOrders(String id) => 'api/orders?_filter[vendor]=$id&_limit=1000000';
  //static String updateOrderStatus(String orderId) => '/api/orders/$orderId/status';

  static String updateOrderStatus(String orderId) => "api/orders/$orderId";
  static String deleteOrderById(String orderId) => "api/orders/$orderId";

  static const String createMultipleOrders = "api/orders/many";




  static const String getAllBillingAddresses = "api/billing-addresses";

  static String getUserBillingAddresses(String userId) => "api/users/$userId/billing-addresses";

  static String getBillingAddressById(String billingId) => "api/billing-addresses/$billingId";

  static const String createBillingAddress = "api/billing-addresses";

  static String updateBillingAddressById(String billingId) => "api/billing-addresses/$billingId";

  static String deleteBillingAddressById(String billingId) => "api/billing-addresses/$billingId";


//Chat users:
  static const String getChatUsers = "api/users?_filter[role]=admin";
  static const String createChat = "api/reports?chatsOnly=true";
  static  String getChats(String userId, String replyTo) => "api/users/$userId/reports?_filter[replyTo]=$replyTo";


}
