import 'package:dream/app/dream.dart';
import 'package:dream/app/create_dream.dart';
import 'package:dream/commen_widget/alert_dialog.dart';
import 'package:dream/commen_widget/paywall_widget.dart';
import 'package:dream/model/dreams.dart';
import 'package:dream/services/purchase_api.dart';
import 'package:dream/viewmodel/user_model.dart';
import 'package:dream/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timeago/timeago.dart' as timeago;

class UsersPage extends StatefulWidget {
  Dreams? newDream;
  UsersPage({Key? key, this.newDream}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isrewardedAdReady = false;
  RewardedAd? _rewardedAd;

  List<Dreams>? _allDream;
  bool _isLoading = false;
  bool _hasMore = true;
  int _pageItemCount = 10;
  Dreams? _lastDream;
  ScrollController _scrollController = ScrollController();
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    RewardedAd.load(
        adUnitId: 'ca-app-pub-9241755428967871/7438530378',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _error = error.toString();
          },
        ));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getDream();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position == 0) {
        } else {
          getDream();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var myBackgrounColor = Theme.of(context).primaryColor;
    var myCardColor = Theme.of(context).cardColor;
    var myTextColor = Theme.of(context).focusColor;
    var myTextColor2 = Theme.of(context).hoverColor;
    var myButtonColor = Theme.of(context).colorScheme.secondary;
    final _userModel = Provider.of<UserModel>(context, listen: true);

    var jeton = _userModel.user!.jeton;
    print(jeton);

    return AppWrapper(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(color: myTextColor),
            backgroundColor: Colors.transparent,
            title: Text("Rüyalarım", style: GoogleFonts.amaranth()),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                    onPressed: () {
                      _showwJeton(context);
                    },
                    icon: const Icon(Icons.monetization_on_outlined,
                        color: Colors.yellow),
                    label: Text(
                      jeton.toString(),
                      style:
                          const TextStyle(color: Colors.yellow, fontSize: 18),
                    ),
                    style: TextButton.styleFrom(
                        side: BorderSide(color: myTextColor))),
              )
            ],
          ),
          body: _allDream == null
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(myButtonColor),
                  ),
                )
              : _createDreamList(
                  _userModel.user!.jeton,
                  myCardColor,
                  myTextColor2,
                  const Color.fromARGB(255, 42, 2, 58),
                  myButtonColor)),
    );
  }

  getDream() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (!_hasMore) {
      return;
    }
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    List<Dreams> _dreams = await _userModel.getAllDreamsPagination(
        _userModel.user!.usersID, _lastDream, _pageItemCount);

    if (_lastDream == null) {
      _allDream = [];
      _allDream?.addAll(_dreams);
    } else {
      _allDream!.addAll(_dreams);
    }

    if (_dreams.length < _pageItemCount) {
      _hasMore = false;
    }
    if (_allDream!.length > 0) {
      _lastDream = _allDream!.last;
    }
    setState(() {
      _isLoading = false;
    });
  }

  _createDreamList(int? jeton, Color myCardColor, Color myTextColor2,
      Color myBackgrounColor, Color myButtonColor) {
    if (_allDream!.length > 0) {
      return RefreshIndicator(
        backgroundColor: Colors.transparent,
        color: myButtonColor,
        onRefresh: _dreamsListRefresh,
        child: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: _allDream!.length + 1,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                if (index == _allDream!.length) {
                  return _newItemWaitIndicator(myBackgrounColor, myButtonColor);
                }
                return _listItemCreate(index, myCardColor, myTextColor2);
              }),
            ),
            Align(
              alignment: const Alignment(1.0, 0.6),
              child: FloatingActionButton(
                onPressed: () {
                  if (jeton != null && jeton >= 1) {
                    _navigateAndDisplaySelection(context);
                  } else {
                    _showwJeton(context);
                  }
                },
                backgroundColor: myButtonColor,
                tooltip: 'Increment',
                child: const Icon(Icons.chat),
              ),
            ),
          ],
        ),
      );
    } else {
      return RefreshIndicator(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height - 150,
              child: Stack(
                children: [
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.chat),
                      Text("Henüz rüya yok"),
                    ],
                  )),
                  Align(
                    alignment: Alignment(1.0, 0.6),
                    child: FloatingActionButton(
                      onPressed: () async {
                        Dreams? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateDream()),
                        );
                        if (result != null) {
                          _dreamsListRefresh();
                        }
                      },
                      tooltip: 'Increment',
                      child: const Icon(Icons.chat),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onRefresh: _dreamsListRefresh);
    }
  }

  Widget _listItemCreate(int index, Color myCardColor, Color myTextColor2) {
    var _nowDream = _allDream![index];
    timeago.setLocaleMessages("tr", timeago.TrMessages());
    var updateTime = _nowDream.updatedAt;
    DateTime _dateTime = DateTime.now();
    var timeAgo;
    if (updateTime != null) {
      var _duration = _dateTime.difference(updateTime);
      timeAgo = timeago.format(_dateTime.subtract(_duration), locale: "tr");
    } else {
      var _duration = _dateTime.difference(DateTime.now());
      timeAgo = timeago.format(_dateTime.subtract(_duration), locale: "tr");
    }

    if (_nowDream.request!.length > 1) myTextColor2 = Colors.white;
    var locale = Localizations.localeOf(context);
    var myTextStyle = GoogleFonts.firaSans(locale: locale);
    if (_nowDream.request!.length > 1)
      myTextStyle = GoogleFonts.firaSans(color: Colors.white, locale: locale);

    return GestureDetector(
      onTap: () {
        print(_nowDream.commenter);
        Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(
            builder: ((context) => Dream(
                  oneDream: _nowDream,
                )),
          ),
        );
      },

      //color: myCardColor,
      child: Card(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: ListTile(
          hoverColor: Colors.transparent,
          tileColor: Colors.transparent,
          focusColor: Colors.transparent,
          selectedColor: Colors.transparent,
          selectedTileColor: Colors.transparent,
          splashColor: Colors.transparent,
          title: Text(
            _nowDream.content!,
            maxLines: 2,
            style: myTextStyle,
          ),
          subtitle: Text(
            timeAgo,
            style: myTextStyle,
          ),
          trailing: _nowDream.request!.length < 1
              ? Icon(
                  Icons.av_timer,
                  color: myTextColor2,
                )
              : Icon(Icons.done, color: myTextColor2),
        ),
      ),
    );
  }

  _newItemWaitIndicator(Color myBackgrounColor, Color myButtonColor) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Opacity(
          opacity: _isLoading ? 1 : 0,
          child: _isLoading
              ? CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(myButtonColor),
                )
              : null,
        ),
      ),
    );
  }

  Future<Null> _dreamsListRefresh() async {
    _hasMore = true;
    _lastDream = null;
    getDream();
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    Dreams? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateDream()),
    );
    if (result != null) {
      _dreamsListRefresh();
    }
  }

  Future<void> _showwJeton(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 41, 45, 78),
            content: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: IconButton(
                          icon: Image.asset("images/watch_add.png"),
                          onPressed: () {
                            DateTime? serverTime = _userModel.user!.lastWatch;
                            DateTime now = DateTime.now();
                            if (serverTime == null) {
                              _showRewardedAd(_userModel.user!.usersID, now,
                                  _userModel.user!.jeton!);
                              if (_error != null) {
                                Navigator.pop(context);
                              }
                            } else {
                              if (serverTime.day != now.day) {
                                _showRewardedAd(_userModel.user!.usersID, now,
                                    _userModel.user!.jeton!);
                                if (_error != null) {
                                  Navigator.pop(context);
                                }
                              } else {
                                PlatformSensAlertDialog(
                                  title: "Bilgilendirme",
                                  content:
                                      "Gün içinde sadece 1 kez reklam izleyebilirsiniz",
                                  mainButtonText: "Tamam",
                                ).show(context);
                              }
                            }
                          }),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: IconButton(
                          icon: Image.asset("images/buy_jeton.png"),
                          onPressed: () {
                            Navigator.pop(context);

                            fetchOfffers();
                          }),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showRewardedAd(String userID, DateTime time, int jeton) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_rewardedAd != null) {
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rpoint) async {
        print("Rewarded Erned is ${rpoint.amount}");
      });
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedAd ad) {},
          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
            ad.dispose();
          },
          onAdDismissedFullScreenContent: (RewardedAd ad) {
            ad.dispose();
          },
          onAdImpression: (RewardedAd ad) => print('$ad impression occurred'));
    }
    var takeJeton = await _userModel.takeJeton(userID, time, jeton);
    _dreamsListRefresh();
  }

  Future fetchOfffers() async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No Plans Found")));
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: const Color.fromARGB(255, 73, 11, 73),
          context: context,
          builder: (context) => PaywallWidget(
              packages: packages,
              title: "Jeton yükle",
              description:
                  "Size uygun jeton paketini seçerek yükleme yapabilirsiniz",
              onClickedPackage: (package) async {
                final isSuccess = await PurchaseApi.purchasePackage(package);
                if (isSuccess) {
                  final _userModel =
                      Provider.of<UserModel>(context, listen: false);
                  await _userModel.addJeton(package);

                  //add coin
                }
                Navigator.pop(context);
              }));
      print("offer:  $packages");
    }
  }
}
