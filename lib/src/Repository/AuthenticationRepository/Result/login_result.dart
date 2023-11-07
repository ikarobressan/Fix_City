class MyLoginResult {
  final bool success;
  final String? errorMessage;

  MyLoginResult.success() : success = true, errorMessage = null;
  MyLoginResult.failure(this.errorMessage) : success = false;
}
