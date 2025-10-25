import 'package:flutter/material.dart';
import 'package:lab_2/router.dart';
import 'package:lab_2/styles/styles.dart';
import 'package:lab_2/widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final cross = isWide ? 4 : 2;

    return AppScaffold(
      title: 'Watchlist',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Trending', style: h1),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .65,
              ),
              itemCount: 8,
              itemBuilder: (_, i) => _MovieCard(index: i),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: const Text('Profile →'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Expanded(
              child: Container(color: Colors.black12),
            ),
            ListTile(
              title: Text('Movie #$index'),
              subtitle: const Text('2024 • Action'),
            ),
          ],
        ),
      ),
    );
  }
}
