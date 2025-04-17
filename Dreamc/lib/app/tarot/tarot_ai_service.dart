import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TarotLocalService {
  static Map<String, dynamic>? _data;

  /// JSON dosyasını belleğe yükler (ilk kullanımda çağrılır)
  static Future<void> loadData() async {
    if (_data == null) {
      final jsonString = await rootBundle.loadString(
        'assets/tarot_dataset_rich.json',
      );
      _data = jsonDecode(jsonString);
    }
  }

  /// Belirli kart ve pozisyona göre bir yorum döndürür
  static Future<String> getMeaning(String cardName, String position) async {
    await loadData();

    if (_data == null) return "Veri yüklenemedi.";
    final fixedCardName = cardName.toLowerCase().replaceAll(" ", "_");
    final cardData = _data![fixedCardName];
    if (cardData == null) return "Bu kart için veri bulunamadı.";

    final List<dynamic>? meanings = cardData[position];
    if (meanings == null || meanings.isEmpty) {
      return "Bu pozisyon için yorum bulunamadı.";
    }

    // Rastgele bir yorum seç
    meanings.shuffle();
    return meanings.first;
  }
}
