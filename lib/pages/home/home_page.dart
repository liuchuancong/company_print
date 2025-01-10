import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  int transitionDuration = 100;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < 10; i++)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: const Color.fromARGB(255, 255, 201, 197),
            height: 400,
          ),
        )
    ];
    return AdaptiveScaffold(
      transitionDuration: Duration(milliseconds: transitionDuration),
      smallBreakpoint: const Breakpoint(endWidth: 700),
      mediumBreakpoint: const Breakpoint(beginWidth: 700, endWidth: 1000),
      mediumLargeBreakpoint: const Breakpoint(beginWidth: 1000, endWidth: 1200),
      largeBreakpoint: const Breakpoint(beginWidth: 1200, endWidth: 1600),
      extraLargeBreakpoint: const Breakpoint(beginWidth: 1600),
      useDrawer: false,
      selectedIndex: selectedTab,
      onSelectedIndexChange: (int index) {
        setState(() {
          selectedTab = index;
        });
      },
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.inbox_outlined),
          selectedIcon: Icon(Icons.inbox),
          label: 'Inbox',
        ),
        NavigationDestination(
          icon: Icon(Icons.article_outlined),
          selectedIcon: Icon(Icons.article),
          label: 'Articles',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_outlined),
          selectedIcon: Icon(Icons.chat),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.video_call_outlined),
          selectedIcon: Icon(Icons.video_call),
          label: 'Video',
        ),
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inbox',
        ),
      ],
      smallBody: (_) => ListView.builder(
        itemCount: children.length,
        itemBuilder: (_, int idx) => children[idx],
      ),
      body: (_) => GridView.count(crossAxisCount: 2, children: children),
      mediumLargeBody: (_) => GridView.count(crossAxisCount: 3, children: children),
      largeBody: (_) => GridView.count(crossAxisCount: 4, children: children),
      extraLargeBody: (_) => GridView.count(crossAxisCount: 5, children: children),
    );
  }
// #enddocregion Example
}
