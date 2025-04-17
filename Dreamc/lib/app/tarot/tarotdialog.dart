import 'dart:ui';
import 'package:dream/app/tarot/tarot.dart';
import 'package:dream/app/tarot/tarot_ai_service.dart';
import 'package:flutter/material.dart';

class TarotCardDialog extends StatefulWidget {
  final String positionTitle;
  final TarotCard card;
  final String? cachedDescription;

  const TarotCardDialog({
    Key? key,
    required this.positionTitle,
    required this.card,
    this.cachedDescription,
  }) : super(key: key);

  @override
  State<TarotCardDialog> createState() => _TarotCardDialogState();
}

class _TarotCardDialogState extends State<TarotCardDialog> {
  String aiDescription = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();

    if (widget.cachedDescription != null) {
      aiDescription = widget.cachedDescription!;
      loading = false;
    } else {
      fetchAIExplanation(); // sadece cache yoksa
    }
  }

  /// İngilizce kart adını JSON uyumlu hale getir
  String normalizeCardName(String title) {
    return title.toLowerCase().replaceAll(" ", "_");
  }

  /// Kart adının Türkçesini döndür
  String getTranslatedCardTitle(String title) {
    final translations = {
      "the_fool": "Deli",
      "the_magician": "Büyücü",
      "the_high_priestess": "Başrahibe",
      "the_empress": "İmparatoriçe",
      "the_emperor": "İmparator",
      "the_hierophant": "Aziz",
      "the_lovers": "Aşıklar",
      "the_chariot": "Savaş Arabası",
      "strength": "Güç",
      "the_hermit": "Ermiş",
      "wheel_of_fortune": "Kader Çarkı",
      "justice": "Adalet",
      "the_hanged_man": "Asılan Adam",
      "death": "Ölüm",
      "temperance": "Denge",
      "the_devil": "Şeytan",
      "the_tower": "Kule",
      "the_star": "Yıldız",
      "the_moon": "Ay",
      "the_sun": "Güneş",
      "judgement": "Mahkeme",
      "the_world": "Dünya",
    };

    final key = normalizeCardName(title);
    return translations[key] ?? title;
  }

  Future<void> fetchAIExplanation() async {
    final desc = await TarotLocalService.getMeaning(
      normalizeCardName(widget.card.title),
      widget.positionTitle,
    );

    if (mounted) {
      setState(() {
        aiDescription = desc;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return Center(
      child: AnimatedScale(
        scale: 1.0,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF120019).withOpacity(0.9),
                          Color(0xFF2E003E).withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.5),
                          blurRadius: 16,
                          spreadRadius: 6,
                          offset: Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.amberAccent.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 8,
                          offset: Offset(-4, -2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.positionTitle,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            getTranslatedCardTitle(widget.card.title),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.amberAccent.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                widget.card.imagePath,
                                width: 140,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          loading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: CircularProgressIndicator(
                                    color: Colors.amberAccent,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  aiDescription,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.5,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: Icon(Icons.auto_fix_high_rounded),
                            label: Text("Ruhsal Yolculuğa Dön"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
