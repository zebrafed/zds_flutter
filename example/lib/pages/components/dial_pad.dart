import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class DialPadExample extends StatelessWidget {
  const DialPadExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ZdsButton.filled(
            child: Text('ShowDialPad'),
            onTap: () {
              showZdsDialPadSheet(
                context,
                subtitle: 'Verified Number',
                pages: {
                  'Recents': Center(child: Text('Recents list goes here')),
                  'Contacts': Center(child: Text('Contacts list goes here')),
                },
              );
            },
          ),
          const SizedBox(height: ZetaSpacing.xl),
          ZdsButton.outlined(
            child: Text('ShowDialPad (text)'),
            onTap: () {
              showZdsDialPadSheet(
                context,
                subtitle: 'Verified Number',
                showText: true,
                pages: {
                  'Recents': Center(child: Text('Recents list goes here')),
                  'Contacts': Center(child: Text('Contacts list goes here')),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
