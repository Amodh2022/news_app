import 'package:article/article_page/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ContentPage extends StatefulWidget {
  final String? urlToImage;
  final String? title;
  final String? url;
  final String? content;
  final bool? isInFav;
  const ContentPage(
      {super.key,
      this.urlToImage,
      this.title,
      this.url,
      this.content,
      this.isInFav});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final ScrollController _scrollController = ScrollController();
  List<String> contentList = [];
  bool isLoading = false;
  String day = "";
  String date = "";
  DateTime? _currentDateTime;

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now().subtract(const Duration(days: 2));
    date = DateFormat('dd-MMM-yyyy hh:mm').format(_currentDateTime!);

    day = DateFormat('EEEE').format(_currentDateTime!);
    _scrapeDataFromWeb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Back",
              style: robotoText(14, FontWeight.w700, Colors.black),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.network(widget.urlToImage ??
                        "https://www.shutterstock.com/image-vector/no-image-available-vector-illustration-260nw-744886198.jpg"),
                    widget.isInFav!
                        ? const Positioned(
                            top: 10,
                            right: 10,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 35,
                            ))
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.title!,
                style: robotoText(16, FontWeight.w700, Colors.black),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_sharp,
                    size: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    softWrap: true,
                    maxLines: 2,
                    "$day,",
                    style: robotoText(12, FontWeight.w700,
                        const Color.fromRGBO(185, 185, 185, 1)),
                  ),
                  Flexible(
                      child: Text(
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    " $date GMT",
                    style: robotoText(12, FontWeight.w700,
                        const Color.fromRGBO(185, 185, 185, 1)),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : Expanded(
                      child: CupertinoScrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: contentList.length,
                            itemBuilder: (context, index) {
                              return Text(
                                contentList.isEmpty
                                    ? widget.content!
                                    : contentList[index],
                                style: robotoText(
                                    12, FontWeight.w300, Colors.black),
                              );
                            }),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _scrapeDataFromWeb() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.Client().get(Uri.parse(widget.url!));
    var document = parser.parse(response.body);
    var articleElements = document.getElementsByTagName('p');
    for (var element in articleElements) {
      if (mounted) {
        setState(() {
          contentList.add(element.text);
          isLoading = false;
        });
      }
    }
  }
}
