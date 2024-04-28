import 'package:article/article_page/controller/article_controller.dart';
import 'package:article/article_page/model/article_model.dart';
import 'package:article/article_page/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../content_page/content_page.dart';

const _kPadding = 15.0;

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ArticleController _articleController = ArticleController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerFav = ScrollController();

  DateTime? _currentDateTime;
  String formattedDate = "";
  bool isLoading = false;
  bool isException = false;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    formattedDate = DateFormat("yyyy-MM-dd").format(_currentDateTime!);
    _tabController = TabController(length: 2, vsync: this);
    _callFetchArticle();
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
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ContentPage(
                                                        urlToImage:
                                                            _articleController
                                                                .articleData[
                                                                    index]
                                                                .urlToImage,
                                                        title:
                                                            _articleController
                                                                .articleData[
                                                                    index]
                                                                .title,
                                                        url: _articleController
                                                            .articleData[index]
                                                            .url,
                                                        content:
                                                            _articleController
                                                                .articleData[
                                                                    index]
                                                                .content,
                                                      )));
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
                                          child: Dismissible(
                                            confirmDismiss: (DismissDirection
                                                direction) async {
                                              return showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CupertinoAlertDialog(
                                                    title: const Text('Fav'),
                                                    content: const Text(
                                                        'Add to Fav?'),
                                                    actions: <CupertinoDialogAction>[
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                        child: const Text('No'),
                                                      ),
                                                      CupertinoDialogAction(
                                                        isDestructiveAction:
                                                            true,
                                                        onPressed: () {
                                                          setState(() {
                                                            if (_articleController
                                                                .fav
                                                                .contains(_articleController
                                                                        .articleData[
                                                                    index])) {
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  content: Text(
                                                                      "Got it! Seems like we're synced up on this one. Anything else you'd like to add?")));
                                                            } else {
                                                              _articleController
                                                                  .fav
                                                                  .add(_articleController
                                                                          .articleData[
                                                                      index]);
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  content: Text(
                                                                      "Added to Fav")));
                                                            }
                                                          });

                                                          Navigator.pop(context,
                                                              false); // showDialog() returns true
                                                        },
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            direction:
                                                DismissDirection.endToStart,
                                            dismissThresholds: const {
                                              DismissDirection.endToStart: 0
                                            },
                                            onDismissed: (direction) {
                                              if (direction ==
                                                  DismissDirection
                                                      .endToStart) {}
                                            },
                                            background: Container(),
                                            secondaryBackground:
                                                slideLeftBackground(),
                                            key: ValueKey<ArticleData>(
                                                _articleController
                                                    .articleData[index]),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: _kPadding,
                                                  top: _kPadding,
                                                  right: _kPadding,
                                                  bottom: _kPadding),
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

                    ///Fav
                    _articleController.fav.isEmpty
                        ? const Center(
                            child: Text("No Data"),
                          )
                        : CupertinoScrollbar(
                            thumbVisibility: true,
                            controller: _scrollControllerFav,
                            child: ListView.builder(
                                controller: _scrollControllerFav,
                                itemBuilder: (context, index) {
                                  return Container(
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: _kPadding,
                                          top: _kPadding,
                                          right: _kPadding,
                                          bottom: _kPadding),
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
                                                      .fav[index].urlToImage ??
                                                  "https://www.shutterstock.com/shutterstock/photos/2059817444/display_1500/stock-vector-no-image-available-photo-coming-soon-illustration-vector-2059817444.jpg",
                                              height: 80,
                                              width: 96,
                                            ),
                                          ),
                                          Flexible(
                                              child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              children: [
                                                Text(
                                                  maxLines: 2,
                                                  _articleController
                                                          .fav[index].title ??
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
                                                          .fav[index].content ??
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

  Future<void> _callFetchArticle() async {
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
