class Errors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'auth/email-already-exists':
        return 'Bu mail adresi zaten kullanılmakta.';

      case 'email-already-in-use':
        return 'Bu mail adresi zaten kullanılmakta.';

      case 'invalid-email':
        return 'Geçersiz email adresi!';

      default:
        return 'Bir Hata Oluştu';
    }
  }
}
