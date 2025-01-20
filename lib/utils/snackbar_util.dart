import 'package:company_print/common/index.dart';

class SnackBarUtil {
  static void success(String text) {
    Get.snackbar(
      'Success',
      text,
      duration: const Duration(seconds: 3),
      backgroundColor: Get.theme.colorScheme.surfaceContainerHighest,
      colorText: Get.theme.colorScheme.onSurfaceVariant,
      snackPosition: SnackPosition.bottom,
    );
  }

  static void error(String text) {
    Get.snackbar(
      'Error',
      text,
      duration: const Duration(seconds: 3),
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
      snackPosition: SnackPosition.bottom,
    );
  }
}
