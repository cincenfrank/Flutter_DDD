import 'package:flutter/material.dart';

import 'package:resolly/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  const CriticalFailureDisplay({
    Key? key,
    required this.failure,
  }) : super(key: key);

  final NoteFailure failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '😱',
            style: TextStyle(fontSize: 100),
          ),
          Text(
            failure.maybeMap(
                orElse: () => 'Unexpected Error. \nPlease contact support.',
                insufficientPermission: (_) => 'Insufficient Permissions.'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.mail),
                SizedBox(
                  width: 4,
                ),
                Text('I NEED HELP'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
