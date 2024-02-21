import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatDemo extends StatelessWidget {
  const ChatDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ZdsChatMessage(
            isLocalUser: false,
            shouldShake: true,
            searchTerm: 'Hello',
            highlight: true,
            message: ZdsMessage(
              status: ZdsChatMessageStatus.delivered,
              content: 'Hello There http://bbc.co.uk',
              senderColor: Colors.blueAccent.shade200,
              senderName: 'Obi-Wan Kenobi',
              time: DateTime.now(),
            ),
            onLinkTapped: (link) {
              if (!kIsWeb) {
                launchUrl(Uri.parse(link));
              }
            },
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              content: 'General Kenobi',
              time: DateTime.now(),
              senderName: 'Grievous',
              status: ZdsChatMessageStatus.delivered,
              senderColor: Colors.grey.shade600,
            ),
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              content:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis vel eros donec ac odio tempor orci dapibus. Ullamcorper a lacus vestibulum sed. Purus semper eget duis at tellus at urna condimentum. Duis at consectetur lorem donec massa sapien. Lacus vestibulum sed arcu non odio. Morbi tincidunt ornare massa eget. Massa tempor nec feugiat nisl pretium fusce. Ipsum faucibus vitae aliquet nec ullamcorper. Viverra nibh cras pulvinar mattis nunc sed blandit libero. Elit ut aliquam purus sit amet luctus venenatis lectus.\nTellus elementum sagittis vitae et. Tellus in metus vulputate eu scelerisque felis. Ut consequat semper viverra nam libero justo laoreet. Vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam. Nam aliquam sem et tortor consequat id porta. Ultricies integer quis auctor elit sed vulputate. Nulla porttitor massa id neque. Eu volutpat odio facilisis mauris sit amet massa vitae. Tellus orci ac auctor augue mauris augue. Montes nascetur ridiculus mus mauris vitae ultricies. Vivamus arcu felis bibendum ut.\nEst ullamcorper eget nulla facilisi etiam dignissim diam quis. A erat nam at lectus urna duis convallis. Neque convallis a cras semper auctor neque vitae tempus. Aliquam etiam erat velit scelerisque in dictum non consectetur a. Semper quis lectus nulla at volutpat. Odio euismod lacinia at quis risus sed vulputate odio. Diam maecenas sed enim ut sem viverra aliquet. Velit ut tortor pretium viverra suspendisse potenti. Mi proin sed libero enim sed faucibus turpis in eu. Sollicitudin aliquam ultrices sagittis orci a. Nunc pulvinar sapien et ligula ullamcorper malesuada proin libero nunc. Non blandit massa enim nec dui. Quis enim lobortis scelerisque fermentum dui.\nElementum eu facilisis sed odio. Aliquam ut porttitor leo a diam sollicitudin. Amet nisl purus in mollis nunc. Imperdiet sed euismod nisi porta lorem mollis aliquam. Tellus in hac habitasse platea dictumst vestibulum rhoncus est pellentesque. Maecenas ultricies mi eget mauris. Accumsan in nisl nisi scelerisque eu ultrices vitae auctor. Eu feugiat pretium nibh ipsum consequat nisl vel pretium. A pellentesque sit amet porttitor eget dolor. Enim nunc faucibus a pellentesque sit amet porttitor eget. Lorem dolor sed viverra ipsum nunc aliquet. Ullamcorper morbi tincidunt ornare massa eget. Nunc lobortis mattis aliquam faucibus purus in. Volutpat blandit aliquam etiam erat velit scelerisque in. Nisi quis eleifend quam adipiscing vitae proin. Egestas fringilla phasellus faucibus scelerisque. Nam aliquam sem et tortor consequat id. Euismod lacinia at quis risus sed vulputate odio ut enim. Vulputate ut pharetra sit amet aliquam id diam. Neque egestas congue quisque egestas diam.\nPellentesque eu tincidunt tortor aliquam nulla facilisi. Quis varius quam quisque id diam vel quam. Risus viverra adipiscing at in tellus integer feugiat. Purus gravida quis blandit turpis. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi tristique. Aliquam sem fringilla ut morbi tincidunt augue interdum. Orci nulla pellentesque dignissim enim sit amet venenatis urna cursus. Eu mi bibendum neque egestas congue quisque egestas diam. Risus pretium quam vulputate dignissim suspendisse. Nec feugiat in fermentum posuere urna. Id donec ultrices tincidunt arcu non. Id interdum velit laoreet id donec ultrices tincidunt. Orci a scelerisque purus semper. Pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum odio.',
              time: DateTime.now(),
              senderName: 'Grievous',
              status: ZdsChatMessageStatus.delivered,
              senderColor: Colors.grey.shade600,
            ),
          ),
          ZdsChatMessage(
            message: ZdsMessage(
              status: ZdsChatMessageStatus.delivered,
              time: DateTime.now(),
              isForwarded: true,
              content: 'Something Something',
              tags: ['Tag 1', 'Tag 2'],
            ),
          ),
          ZdsChatMessage(
            message: ZdsMessage(
              time: DateTime.now(),
              isInfo: true,
              content: 'Info Message.',
              status: ZdsChatMessageStatus.read,
            ),
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              status: ZdsChatMessageStatus.delivered,
              time: DateTime.now(),
              isDeleted: true,
              senderName: 'Peter',
            ),
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              status: ZdsChatMessageStatus.delivered,
              time: DateTime.now(),
              content: '😂😅🦓',
            ),
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              time: DateTime.now(),
              content: 'It’s an old code, but it checks out.',
              status: ZdsChatMessageStatus.read,
              replyMessageInfo: ZdsMessage(
                content: 'General Kenobi',
                senderName: 'Grevious',
                status: ZdsChatMessageStatus.read,
                time: DateTime.now(),
              ),
              reacts: {
                '😂': 2,
                '😅': 2,
                '🦓': 1,
              },
            ),
          ),
          ZdsChatMessage(
            message: ZdsMessage(
              time: DateTime.now(),
              content: 'It’s an old code, but it checks out.',
              status: ZdsChatMessageStatus.read,
              replyMessageInfo: ZdsMessage(
                content: 'General Kenobi',
                senderName: 'Grevious',
                status: ZdsChatMessageStatus.read,
                time: DateTime.now(),
              ),
              reacts: {'😂': 2, '😅': 2, '🦓': 1},
            ),
          ),
          ZdsChatMessage(
            message: ZdsMessage.imageNetwork(
              time: DateTime.now(),
              url: 'http://kalyanvarma.net/photos/DSC_6833.jpg',
              text: 'sssssssssssssssssssss',
              status: ZdsChatMessageStatus.read,
            ),
          ),
          ZdsChatMessage(
            message: ZdsMessage.imageNetwork(
              time: DateTime.now(),
              url: 'https://www.warrenphotographic.co.uk/photography/sqrs/12777.jpg',
              text: 'woof',
              status: ZdsChatMessageStatus.read,
            ),
            onFileDownload: () {},
          ),
          ZdsChatMessage(
            message: ZdsMessage.videoNetwork(
              time: DateTime.now(),
              url: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
              text: 'vdeo',
              status: ZdsChatMessageStatus.read,
            ),
            onFileDownload: () {},
          ),
          ZdsChatMessage(
            message: ZdsMessage.imageBase64(
              time: DateTime.now(),
              image:
                  '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',
              status: ZdsChatMessageStatus.read,
              reacts: {'😂': 2, '😅': 2, '🦓': 1},
            ),
            onFileDownload: () {},
          )
        ],
      ),
    );
  }
}
