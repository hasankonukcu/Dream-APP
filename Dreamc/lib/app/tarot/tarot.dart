// 🔧 Tüm kod performans iyileştirmeleriyle güncellendi
import 'package:dream/app/tarot/bgfile.dart';
import 'package:dream/app/tarot/tarotdialog.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:ui' as ui;

class TarotCard {
  final String title;
  String imagePath;
  final String description;
  bool isSelected;
  bool isRead;

  TarotCard({
    required this.title,
    required this.imagePath,
    required this.description,
    this.isSelected = false,
    this.isRead = false,
  });
}

class TarotScreen extends StatefulWidget {
  @override
  _TarotScreenState createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen>
    with TickerProviderStateMixin {
  final Map<String, String> aiCache = {};
  final List<String> majorCardNames = [
    'the_fool',
    'the_magician',
    'the_high_priestess',
    'the_empress',
    'the_emperor',
    'the_hierophant',
    'the_lovers',
    'the_chariot',
    'strength',
    'the_hermit',
    'wheel_of_fortune',
    'justice',
    'the_hanged_man',
    'death',
    'temperance',
    'the_devil',
    'the_tower',
    'the_star',
    'the_moon',
    'the_sun',
    'judgement',
    'the_world',
  ];
  final List<String> tarotPositions = [
    "Geçmiş",
    "Şu An",
    "Gelecek",
    "Zorluklar",
    "Rehberlik",
    "Bilinçaltı",
    "Sonuç",
  ];
  final List<TarotCard> cards = List.generate(
    22,
    (index) => TarotCard(
      title: 'Card $index',
      imagePath: 'assets/cards/back.png',
      description: 'Description for card $index',
    ),
  );

  double dragOffset = 0.0;
  List<TarotCard> selectedCards = [];
  bool animationStarted = false;
  bool showDeck = true;
  bool showInstructionOverlay = false;
  bool overlayVisible = false;

  List<AnimationController> finalCardControllers = [];
  List<Animation<Offset>> finalCardAnimations = [];
  List<Offset> initialCardOffsets = [];

  late AnimationController deckCollapseController;
  late AnimationController pulseController;
  late AnimationController globalFlipController;
  late AnimationController overlayOpacityController;
  late Animation<double> overlayOpacity;

  bool _imagesPrecached = false;

  @override
  void initState() {
    super.initState();
    deckCollapseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    globalFlipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    overlayOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    overlayOpacity = CurvedAnimation(
      parent: overlayOpacityController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      for (var card in cards) {
        precacheImage(const AssetImage('assets/cards/back.png'), context);
      }
      for (var name in majorCardNames) {
        precacheImage(AssetImage('assets/cards/major/$name.png'), context);
      }
      _imagesPrecached = true;
    }
  }

  @override
  void dispose() {
    for (final c in finalCardControllers) {
      c.dispose();
    }
    deckCollapseController.dispose();
    pulseController.dispose();
    globalFlipController.dispose();
    overlayOpacityController.dispose();
    super.dispose();
  }

  Future<void> selectRandomMajorCards() async {
    final random = Random();
    final selected = <String>{};
    while (selected.length < 7) {
      selected.add(majorCardNames[random.nextInt(majorCardNames.length)]);
    }

    final newCards = selected.map((name) {
      return TarotCard(
        title: name.replaceAll('_', ' ').toUpperCase(),
        imagePath: 'assets/cards/major/$name.png',
        description: 'Description for $name',
      );
    }).toList();

    if (mounted) {
      setState(() {
        selectedCards = newCards;
        animationStarted = true; // ✅ animasyonu burada başlat
      });

      // ⏳ animasyon setup'ı burada güvenli şekilde çağrılır
      startCardThrowAnimation();
    }
  }

  void startCardThrowAnimation() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final center = Offset(screenWidth / 2, screenHeight * 0.46);
    final radius = 190.0;
    final finalPositions = [
      Offset(-120, 0),
      Offset(0, 0),
      Offset(120, 0),
      Offset(-120, 160),
      Offset(0, 160),
      Offset(120, 160),
      Offset(0, 320),
    ];

    initialCardOffsets.clear();
    for (int index = 0; index < selectedCards.length; index++) {
      final angle = pi / 2 + (index - 3) * 0.2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy - radius * sin(angle);
      initialCardOffsets.add(Offset(x, y));
    }

    finalCardControllers = List.generate(
      7,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      ),
    );
    finalCardAnimations = List.generate(
      7,
      (index) => Tween<Offset>(
        begin: initialCardOffsets[index],
        end: Offset(
          screenWidth / 2 - 45 + finalPositions[index].dx,
          100 + finalPositions[index].dy,
        ),
      ).animate(
        CurvedAnimation(
          parent: finalCardControllers[index],
          curve: Curves.easeOutBack,
        ),
      ),
    );

    for (int i = 0; i < finalCardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        finalCardControllers[i].forward().whenComplete(() {
          Future.delayed(const Duration(milliseconds: 300), () {
            globalFlipController.forward();
          });
        });
      });
    }

    deckCollapseController.forward();
    Future.delayed(
      const Duration(milliseconds: 1500),
      () => setState(() => showDeck = false),
    );
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          showInstructionOverlay = true;
          overlayVisible = true;
        });
        overlayOpacityController.forward();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && overlayVisible) {
            overlayOpacityController.reverse().whenComplete(() {
              if (mounted) {
                setState(() {
                  overlayVisible = false;
                  showInstructionOverlay = false;
                });
              }
            });
          }
        });
      }
    });
  }

  Widget buildOverlay() {
    return AnimatedBuilder(
      animation: overlayOpacity,
      builder: (context, child) {
        return overlayVisible
            ? Opacity(
                opacity: overlayOpacity.value,
                child: GestureDetector(
                  onTap: () =>
                      overlayOpacityController.reverse().whenComplete(() {
                    if (mounted) {
                      setState(() {
                        overlayVisible = false;
                        showInstructionOverlay = false;
                      });
                    }
                  }),
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app,
                              color: Colors.white70, size: 48),
                          SizedBox(height: 16),
                          Text(
                            'Kartlar açıldı\nOkumak için onlara dokunabilirsin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget buildCard(TarotCard card, int index) {
    final pulse =
        card.isRead ? 0.0 : sin((pulseController.value + index / 7.0) * 2 * pi);
    final scale = card.isRead ? 1.0 : 1.0 + 0.02 * pulse;
    return GestureDetector(
      onTap: () {
        if (!card.isRead) setState(() => card.isRead = true);
        final key = '${card.title}::${tarotPositions[index]}';
        final cachedDesc = aiCache[key];
        showDialog(
          context: context,
          builder: (_) => TarotCardDialog(
            positionTitle: tarotPositions[index],
            card: card,
            cachedDescription: cachedDesc,
          ),
        );
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateY(pi * globalFlipController.value)
          ..scale(scale),
        child: globalFlipController.value < 0.5
            ? Image.asset(
                'assets/cards/back.png',
                width: 90,
                height: 140,
                fit: BoxFit.cover,
              )
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(pi),
                child: Image.asset(
                  card.imagePath,
                  width: 90,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final bottomHeight = height * 0.4;
    final center = Offset(width / 2, height * 0.46);
    final radius = 190.0;
    final anglePerCard = pi / (cards.length + 2);
    final clampedOffset = dragOffset.clamp(
      -((cards.length - 1) / 2) * anglePerCard,
      ((cards.length - 1) / 2) * anglePerCard,
    );

    return Scaffold(
      body: Stack(
        children: [
          StarBackground(),
          if (!animationStarted)
            Positioned(
              top: height * 0.45,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    selectedCards.length < 7
                        ? "7 kart seçin (${selectedCards.length}/7)"
                        : "",
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  if (selectedCards.length == 7)
                    TextButton(
                      onPressed: () async {
                        await selectRandomMajorCards();
                        if (mounted) {
                          setState(() {
                            animationStarted = true;
                          });
                          startCardThrowAnimation();
                        }
                      },
                      child: const Text(
                        "Kartları Aç",
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                    ),
                  const SizedBox(height: 10),
                  const Icon(Icons.expand_less, color: Colors.orangeAccent),
                ],
              ),
            ),
          if (!animationStarted)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: const [
                    Icon(Icons.swipe, color: Colors.white30),
                    Text(
                      "Kartları sürükle",
                      style: TextStyle(color: Colors.white30),
                    ),
                  ],
                ),
              ),
            ),
          if (!animationStarted || showDeck)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              height: bottomHeight,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    dragOffset -= details.delta.dx * 0.01;
                  });
                },
                child: Stack(
                  children: List.generate(cards.length, (index) {
                    final angleIndex = index - (cards.length - 1) / 2;
                    final baseAngle =
                        pi / 2 + angleIndex * anglePerCard + clampedOffset;
                    final x = center.dx + radius * cos(baseAngle);
                    final y = center.dy - radius * sin(baseAngle);
                    final isCenter =
                        (baseAngle % (2 * pi) - pi / 2).abs() < 0.13;
                    final dx = center.dx - x;
                    final dy = center.dy - y;
                    final angleToCenter = atan2(dy, dx);

                    return AnimatedBuilder(
                      animation: deckCollapseController,
                      builder: (context, child) {
                        final collapseValue = deckCollapseController.value;
                        final collapsedX =
                            ui.lerpDouble(x, center.dx, collapseValue)!;
                        final collapsedY =
                            ui.lerpDouble(y, center.dy, collapseValue)!;
                        return Positioned(
                          left: collapsedX - 38,
                          top: collapsedY -
                              75 -
                              (cards[index].isSelected ? 65 : 0),
                          child: Opacity(
                            opacity: 1.0 - collapseValue,
                            child: Transform.rotate(
                              angle: angleToCenter + pi / 2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (cards[index].isSelected) {
                                      cards[index].isSelected = false;
                                      selectedCards.remove(cards[index]);
                                    } else if (selectedCards.length < 7) {
                                      cards[index].isSelected = true;
                                      selectedCards.add(cards[index]);
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 82,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(cards[index].imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      if (isCenter)
                                        BoxShadow(
                                          color: Colors.orangeAccent
                                              .withOpacity(0.5),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      if (cards[index].isSelected)
                                        BoxShadow(
                                          color: Colors.greenAccent.withOpacity(
                                            0.8,
                                          ),
                                          blurRadius: 15,
                                          spreadRadius: 4,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          if (animationStarted && finalCardControllers.length == 7)
            ...List.generate(7, (index) {
              return AnimatedBuilder(
                animation: Listenable.merge([
                  finalCardControllers[index],
                  pulseController,
                  globalFlipController,
                ]),
                builder: (context, child) {
                  final pos = finalCardAnimations[index].value;
                  return Positioned(
                    left: pos.dx,
                    top: pos.dy,
                    child: buildCard(selectedCards[index], index),
                  );
                },
              );
            }),
          if (showInstructionOverlay) buildOverlay(),
          if (animationStarted && selectedCards.length == 7)
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: resetTarotState,
                  child: const Text(
                    "Bitir",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void resetTarotState() {
    setState(() {
      selectedCards.clear();
      animationStarted = false;
      showDeck = true;
      overlayVisible = false;
      showInstructionOverlay = false;
      dragOffset = 0.0;

      // kartları sıfırla
      for (var card in cards) {
        card.isSelected = false;
        card.isRead = false;
      }

      // controller'ları temizle
      for (final c in finalCardControllers) {
        c.dispose();
      }
      finalCardControllers.clear();
      finalCardAnimations.clear();
      initialCardOffsets.clear();

      // animasyonları resetle
      deckCollapseController.reset();
      pulseController.reset();
      globalFlipController.reset();
      overlayOpacityController.reset();
    });
  }
}
