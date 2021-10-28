import 'package:flutter/material.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FriendsTabView(),
    );
  }
}

class FriendsTabView extends StatelessWidget {
  const FriendsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Search',
                  ),
                  Tab(
                    text: 'Invites',
                  ),
                ],
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IncomingPage(),
            OutgoingPage(),
          ],
        ),
      ),
    );
  }
}

class OutgoingPage extends StatelessWidget {
  const OutgoingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class IncomingPage extends StatelessWidget {
  const IncomingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
