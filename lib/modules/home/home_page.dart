import 'package:flutter/material.dart';
import 'package:rankify/components/assistant_service.dart';
import 'package:rankify/components/sound_service.dart';
import 'package:rankify/modules/home/home_style.dart';
import 'package:wolkarutils/wolkarutils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //ATOMS Home title
    final title = Text("Home").h1();

    //ATOMS Home card
    final mainCards = Wrap(
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
      children: [
        BigHomeCard(text: "It's high time you stopped losing."),
        Column(
          spacing: 10,
          children: [
            SmallHomeCard(
              image: "assets/images/settings.png",
              text: "Personalize Rankify whatever you like.",
              scale: 2,
            ),
            SmallHomeCard(
              image: "assets/images/logo.png",
              text: "Help mantaining Rankify an open source app.",
            ),
          ],
        ),
      ],
    );

    //LAYOUT Page
    final page = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        spacing: 15,
        children: [
          title,
          mainCards,
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hearing!")));
              AssistantService.instance.initHearing();
            },
            icon: const Icon(Icons.mic),
            label: const Text("Init hearing"),
          ),
          const Divider(),
          const Text("Assistant Simulator").h2(),
          TextField(
            decoration: const InputDecoration(
              hintText: "Type something (e.g. Hola Rankify)",
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              AssistantService.instance.processText(value);
            },
          ),
        ],
      ),
    );

    return Scaffold(body: page);
  }
}
