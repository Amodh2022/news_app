import 'package:article/article_page/controller/article_controller.dart';
import 'package:article/article_page/model/article_model.dart';
import 'package:article/article_page/model/fav_model.dart';
import 'package:article/article_page/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../content_page/content_page.dart';

const _kPadding = 15.0;

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ArticleController _articleController = ArticleController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerFav = ScrollController();
  List<FavModel> favModel = [];

  DateTime? _currentDateTime;
  String formattedDate = "";
  String day = "";
  String date = "";
  bool isLoading = false;
  bool isException = false;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now().subtract(const Duration(days: 2));

    formattedDate = DateFormat("yyyy-MM-dd").format(_currentDateTime!);
    date = DateFormat('dd-MMM-yyyy hh:mm').format(_currentDateTime!);

    day = DateFormat('EEEE').format(_currentDateTime!);

    _tabController = TabController(length: 2, vsync: this);
    _fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: TabBar(
                splashFactory: NoSplash.splashFactory,
                dividerColor: Colors.transparent,
                controller: _tabController,
                tabs: _articleController.tabWidget,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  color: const Color.fromRGBO(238, 243, 253, 1),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ///News TabBar
                    isLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : isException
                            ? const Center(
                                child: Text(
                                  "No Data or You have made too many requests",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : CupertinoScrollbar(
                                thumbVisibility: true,
                                controller: _scrollController,
                                child: ListView.builder(
                                    controller: _scrollController,
                                    itemBuilder: (context, index) {
                                      bool checkIsThere = _articleController.fav
                                          .contains(_articleController
                                              .articleData[index]);
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ContentPage(
                                              isInFav: checkIsThere,
                                              urlToImage: _articleController
                                                  .articleData[index]
                                                  .urlToImage,
                                              title: _articleController
                                                  .articleData[index].title,
                                              url: _articleController
                                                  .articleData[index].url,
                                              content: _articleController
                                                  .articleData[index].content,
                                            );
                                          }));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.grey, //New
                                                    blurRadius: 85.0,
                                                    offset: Offset(0, 17.42))
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          margin: const EdgeInsets.only(
                                              left: _kPadding,
                                              right: _kPadding,
                                              top: _kPadding),
                                          child: Slidable(
                                            key: ValueKey<ArticleData>(
                                                _articleController
                                                    .articleData[index]),
                                            endActionPane: ActionPane(
                                              dismissible: DismissiblePane(
                                                  closeOnCancel: true,
                                                  confirmDismiss: () async {
                                                    return await showDialog<
                                                            bool>(
                                                          context: context,
                                                          builder: (context) {
                                                            return CupertinoAlertDialog(
                                                              title: const Text(
                                                                  'Fav'),
                                                              content: const Text(
                                                                  'Add to Fav?'),
                                                              actions: <CupertinoDialogAction>[
                                                                CupertinoDialogAction(
                                                                  isDefaultAction:
                                                                      true,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        false);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'No'),
                                                                ),
                                                                CupertinoDialogAction(
                                                                  isDestructiveAction:
                                                                      true,
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      if (_articleController
                                                                          .fav
                                                                          .contains(
                                                                              _articleController.articleData[index])) {
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            behavior: SnackBarBehavior.floating,
                                                                            content: Text("Already added to Favs")));
                                                                      } else {
                                                                        favModel.add(FavModel(
                                                                            true,
                                                                            _articleController.articleData[index].title));

                                                                        _articleController
                                                                            .fav
                                                                            .add(_articleController.articleData[index]);
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            behavior: SnackBarBehavior.floating,
                                                                            content: Text("Added to Favs")));
                                                                      }
                                                                    });

                                                                    Navigator.pop(
                                                                        context,
                                                                        false); // showDialog() returns true
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Yes'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ) ??
                                                        false;
                                                  },
                                                  onDismissed: () {}),
                                              extentRatio: 0.4,
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (value) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CupertinoAlertDialog(
                                                          title:
                                                              const Text('Fav'),
                                                          content: const Text(
                                                              'Add to Fav?'),
                                                          actions: <CupertinoDialogAction>[
                                                            CupertinoDialogAction(
                                                              isDefaultAction:
                                                                  true,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    false);
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                            CupertinoDialogAction(
                                                              isDestructiveAction:
                                                                  true,
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (_articleController
                                                                      .fav
                                                                      .contains(
                                                                          _articleController
                                                                              .articleData[index])) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        behavior:
                                                                            SnackBarBehavior
                                                                                .floating,
                                                                        content:
                                                                            Text("Already added to Favs")));
                                                                  } else {
                                                                    favModel.add(FavModel(
                                                                        true,
                                                                        _articleController
                                                                            .articleData[index]
                                                                            .title));

                                                                    _articleController
                                                                        .fav
                                                                        .add(_articleController
                                                                            .articleData[index]);
                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .green,
                                                                        behavior:
                                                                            SnackBarBehavior
                                                                                .floating,
                                                                        content:
                                                                            Text("Added to Favs")));
                                                                  }
                                                                });

                                                                Navigator.pop(
                                                                    context,
                                                                    false); // showDialog() returns true
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          252, 209, 209, 1),
                                                  foregroundColor: Colors.black,
                                                  icon: Icons.favorite,
                                                  label: 'Add to Favorite',
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              padding: const EdgeInsets.only(
                                                  top: _kPadding,
                                                  left: _kPadding,
                                                  bottom: _kPadding,
                                                  right: _kPadding),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      fit: BoxFit.fill,
                                                      _articleController
                                                              .articleData[
                                                                  index]
                                                              .urlToImage ??
                                                          "https://www.shutterstock.com/shutterstock/photos/2059817444/display_1500/stock-vector-no-image-available-photo-coming-soon-illustration-vector-2059817444.jpg",
                                                      height: 80,
                                                      width: 96,
                                                    ),
                                                  ),
                                                  Flexible(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          maxLines: 2,
                                                          _articleController
                                                                  .articleData[
                                                                      index]
                                                                  .title ??
                                                              "",
                                                          style: robotoText(
                                                              13.2,
                                                              FontWeight.w700,
                                                              Colors.black),
                                                        ),
                                                        Text(
                                                          softWrap: true,
                                                          maxLines: 2,
                                                          _articleController
                                                                  .articleData[
                                                                      index]
                                                                  .content ??
                                                              "",
                                                          style: robotoText(
                                                              10.2,
                                                              FontWeight.w400,
                                                              Colors.black),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .calendar_month_sharp,
                                                              size: 15,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              "$day,",
                                                              style: robotoText(
                                                                  12,
                                                                  FontWeight
                                                                      .w700,
                                                                  const Color
                                                                      .fromRGBO(
                                                                      185,
                                                                      185,
                                                                      185,
                                                                      1)),
                                                            ),
                                                            Flexible(
                                                                child: Text(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: true,
                                                              " $date GMT",
                                                              style: robotoText(
                                                                  12,
                                                                  FontWeight
                                                                      .w700,
                                                                  const Color
                                                                      .fromRGBO(
                                                                      185,
                                                                      185,
                                                                      185,
                                                                      1)),
                                                            ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        _articleController.articleData.length)),

                    ///Fav TabBar
                    _articleController.fav.isEmpty
                        ? Center(
                            child: Text(
                              "Your favorites list is waiting for you to fill it",
                              style:
                                  robotoText(14, FontWeight.w500, Colors.black),
                            ),
                          )
                        : CupertinoScrollbar(
                            thumbVisibility: true,
                            controller: _scrollControllerFav,
                            child: ListView.builder(
                                controller: _scrollControllerFav,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ContentPage(
                                          isInFav: true,
                                          urlToImage: _articleController
                                              .fav[index].urlToImage,
                                          title: _articleController
                                              .fav[index].title,
                                          url:
                                              _articleController.fav[index].url,
                                          content: _articleController
                                              .fav[index].content,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey, //New
                                                blurRadius: 85.0,
                                                offset: Offset(0, 17.42))
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      margin: const EdgeInsets.only(
                                          left: _kPadding,
                                          right: _kPadding,
                                          top: _kPadding),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: _kPadding,
                                                bottom: _kPadding,
                                                top: _kPadding,
                                                right: _kPadding),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    fit: BoxFit.fill,
                                                    _articleController
                                                            .fav[index]
                                                            .urlToImage ??
                                                        "https://www.shutterstock.com/shutterstock/photos/2059817444/display_1500/stock-vector-no-image-available-photo-coming-soon-illustration-vector-2059817444.jpg",
                                                    height: 80,
                                                    width: 96,
                                                  ),
                                                ),
                                                Flexible(
                                                    child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        maxLines: 2,
                                                        _articleController
                                                                .fav[index]
                                                                .title ??
                                                            "",
                                                        style: robotoText(
                                                            13.2,
                                                            FontWeight.w700,
                                                            Colors.black),
                                                      ),
                                                      Text(
                                                        softWrap: true,
                                                        maxLines: 2,
                                                        _articleController
                                                                .fav[index]
                                                                .content ??
                                                            "",
                                                        style: robotoText(
                                                            10.2,
                                                            FontWeight.w400,
                                                            Colors.black),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                              right: 5,
                                              top: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CupertinoAlertDialog(
                                                        title:
                                                            const Text('Alert'),
                                                        content: const Text(
                                                            'Remove This Article Fav'),
                                                        actions: <CupertinoDialogAction>[
                                                          CupertinoDialogAction(
                                                            isDefaultAction:
                                                                true,
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'No'),
                                                          ),
                                                          CupertinoDialogAction(
                                                            isDestructiveAction:
                                                                true,
                                                            onPressed: () {
                                                              setState(() {
                                                                _articleController
                                                                    .fav
                                                                    .removeAt(
                                                                        index);
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating,
                                                                    content: Text(
                                                                        "Article Removed From Favs")));
                                                              });
                                                            },
                                                            child: const Text(
                                                                'Yes'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Icon(Icons.delete),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: _articleController.fav.length),
                          )
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _fetchArticle() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _articleController.fetchArticle(formattedDate);
      setState(() {
        _articleController.articleData.addAll(response.articleData!);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isException = true;
      });
    }
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            Text(
              " Add to Fav",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
