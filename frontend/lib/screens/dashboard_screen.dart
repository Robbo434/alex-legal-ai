import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  late String currentGreeting;

  final List<String> greetings = [
    "How can I help you today, Lochie?",
    "What can I assist with today, Lochie?",
    "What are we working on today, Lochie?",
    "Ready when you are, Lochie.",
  ];

  Timer? greetingTimer;

  @override
  void initState() {
    super.initState();

    currentGreeting =
        greetings[Random().nextInt(greetings.length)];

    greetingTimer = Timer.periodic(
      const Duration(seconds: 6),
      (_) {
        if (!mounted) return;

        setState(() {
          currentGreeting = greetings[
              Random().nextInt(greetings.length)];
        });
      },
    );
  }

  @override
  void dispose() {
    greetingTimer?.cancel();
    super.dispose();
  }

  String timeGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning, Lochie.";
    }

    if (hour < 17) {
      return "Good afternoon, Lochie.";
    }

    return "Good evening, Lochie.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alex Legal AI"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              timeGreeting(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 500,
              ),
              child: Text(
                currentGreeting,
                key: ValueKey(currentGreeting),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: const [
                  DashboardCard(
                    title: "Chat",
                    icon: Icons.chat,
                  ),
                  DashboardCard(
                    title: "Summarise",
                    icon: Icons.description,
                  ),
                  DashboardCard(
                    title: "Proofread",
                    icon: Icons.spellcheck,
                  ),
                  DashboardCard(
                    title: "Compare",
                    icon: Icons.compare_arrows,
                  ),
                  DashboardCard(
                    title: "Timeline",
                    icon: Icons.timeline,
                  ),
                  DashboardCard(
                    title: "Knowledge Base",
                    icon: Icons.search,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}