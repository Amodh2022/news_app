import 'package:article/article_page/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class ContentPage extends StatefulWidget {
  final String? urlToImage;
  final String? title;
  final String? url;
  final String? content;
  const ContentPage(
      {super.key, this.urlToImage, this.title, this.url, this.content});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final ScrollController _scrollController = ScrollController();
  List<String> contentList = [];
  @override
  void initState() {
    super.initState();
    _parse();
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
            const Icon(Icons.arrow_back_ios_new_rounded),
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
                child: Image.network(widget.urlToImage ??
                    "https://www.shutterstock.com/image-vector/no-image-available-vector-illustration-260nw-744886198.jpg"),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.title!,
                style: robotoText(16, FontWeight.w700, Colors.black),
              ),
              Expanded(
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
                          style: robotoText(12, FontWeight.w300, Colors.black),
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

  _parse() async {
    final response = await http.Client().get(Uri.parse(widget.url!));
    var document = parser.parse(response.body);
    var articleElements = document.getElementsByTagName('p');
    for (var element in articleElements) {
      setState(() {
        contentList.add(element.text);
      });
    }
  }
}
