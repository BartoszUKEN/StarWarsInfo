import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ustawienia.dart';

class UstawieniaScreen extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const UstawieniaScreen({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<UstawieniaModel>(builder: (context, ustaw, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tryb ciemny'),
                  Switch(value: ustaw.ciemnyTryb, onChanged: (v) async => await ustaw.ustawTryb(v)),
                ],
              );
            }),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Odśwież dane z API'),
                onPressed: onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
