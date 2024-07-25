import 'package:desktop/src/views/HomePage/components/CustomAppBar.dart';
import 'package:desktop/src/views/HomePage/components/DashboardCard.dart';
import 'package:desktop/src/models/AuthModel.dart';
import 'package:desktop/src/models/DashboardModel.dart';
import 'package:desktop/src/services/DashboardService.dart';
import 'package:desktop/src/views/HomePage/components/DashboardRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metaballs/metaballs.dart';

import 'components/EmptyDashboardCard.dart';
import '../../models/ApiModel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<List<Dashboard>> userDashboards;

  @override
  void initState() {
    super.initState();
    userDashboards = DashboardService().fetchDashboardsUser();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Custom background widget
          Positioned.fill(
            child: Metaballs(
              color: const Color.fromARGB(255, 66, 133, 244),
              effect: MetaballsEffect.follow(
                growthFactor: 1,
                smoothing: 1,
                radius: 0.5,
              ),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 221, 241, 245),
                Color.fromARGB(255, 240, 247, 247),
              ], begin: Alignment.bottomRight, end: Alignment.topLeft),
              metaballs: 15,
              animationDuration: const Duration(milliseconds: 300),
              speedMultiplier: 0.2,
              bounceStiffness: 3,
              minBallRadius: 20,
              maxBallRadius: 80,
              glowRadius: 0.8,
              glowIntensity: 0.4,
            ),
          ),
          // Home Page Body
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'nobi.',
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 31, 104, 117),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 50),
                        backgroundColor: Color.fromARGB(255, 31, 104, 117),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {
                        ref
                            ?.read(authServiceProvider)
                            .signOut()
                            .then((value) => context.go('/login'));
                      },
                      child: Text(
                        'Log Out',
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row of dashboards title
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Your Dashboards',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),

                    // Row containing fetched dashboards
                    FutureBuilder<List<Dashboard>>(
                      future: userDashboards,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return DashboardRow(
                            dashboardDetails: snapshot.data ?? [],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
