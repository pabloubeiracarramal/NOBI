import 'package:desktop/src/models/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  CustomAppBar({this.title = '', this.actions = const <Widget>[]});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color.fromARGB(255, 255, 255, 255),
        width: 1.0,
        style: BorderStyle.none,
      ))),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'nobi.',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                ref
                    ?.read(authServiceProvider)
                    .signOut()
                    .then((value) => context.go('/login'));
              },
              label: Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
