import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/iap_provider.dart';

class RestorePurchasesButton extends ConsumerWidget {
  const RestorePurchasesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        final iapService = ref.read(iapServiceProvider);
        await iapService.restorePurchases();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchases restored successfully'),
            ),
          );
        }
      },
      child: const Text('Restore Purchases'),
    );
  }
}
