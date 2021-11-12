import 'package:flutter/material.dart';
import 'package:sportify/src/views/home/tabs/friends/tabs/invites_pages.dart';
import 'package:sportify/src/views/home/tabs/friends/tabs/search_page.dart';

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
          backgroundColor: Theme.of(context).backgroundColor,
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
            SearchPage(),
            InvitesPage(),
          ],
        ),
      ),
    );
  }
}
