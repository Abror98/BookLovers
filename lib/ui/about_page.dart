import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:openlib/ui/components/snack_bar_widget.dart';
import 'package:openlib/ui/components/page_title_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Book Lovers"),
        titleTextStyle: Theme.of(context).textTheme.displayLarge,
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText("About"),
              Padding(
                padding:
                    EdgeInsets.only(left: 7, right: 7, top: 13, bottom: 10),
                child: Text(
                  "An Open source app to download and read books from shadow library (Anna`s Archive)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 7, right: 7, top: 10),
                child: Text(
                  "Version",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 7, right: 7, top: 5),
                child: Text(
                  "1.0.14",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UrlText extends StatelessWidget {
  const _UrlText({Key? key, required this.text, required this.url})
      : super(key: key);

  final String url;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7, top: 5),
      child: InkWell(
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            // ignore: use_build_context_synchronously
            showSnackBar(context: context, message: 'Could not launch $uri');
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            const Icon(
              Icons.launch,
              size: 17,
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
