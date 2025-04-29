import 'package:karmalab_assignment/helper/dialog_helper.dart';
import 'package:karmalab_assignment/services/base/app_exceptions.dart';

class BaseController {
  void handleError(error) {
    // Print the error for debugging purposes
    print('This is for testing purpose: $error');

    if (error == null) {
      return;  // No action needed for null error
    }

    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErrorDialog(description: message);
    } else if (error is FetchDataException) {
      //var message = 'main culprit is here!!!!!!!';
      //DialogHelper.showErrorDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErrorDialog(description: "It took longer to respond.");
    } else if (error is InvalidException) {
      DialogHelper.showErrorDialog(
          description: error.message, title: "Oops 🥸");
    } else {
      // Handle any unexpected or unknown errors
      DialogHelper.showErrorDialog(description: "Something went wrong");
    }
  }
}
