import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:openlib/src/common/extensions/context_extensions.dart';


@RoutePage()
class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Suggestions'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
                'For the development of the Book Lovers Program, we welcome your suggestions and comments',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: context.theme.textTheme.titleLarge!.color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            TextFormField(
              minLines: 6, // any number you need (It works as the rows for the textarea)
              maxLines: 100,
              decoration: InputDecoration(
                hintText: 'Enter text',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.red.withOpacity(10),
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey,  
                    width: 2.0,
                  ),
                ),
              )
              ),
          ],
        ),
      ),
    );
  }

}



