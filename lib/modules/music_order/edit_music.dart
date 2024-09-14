import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/music_order/model.dart';
import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:provider/provider.dart';

// 编辑歌单内的歌曲信息
class EditMusic extends StatefulWidget {
  final String musicOrderId; // 歌单 ID
  final MusicItem data;
  final UserMusicOrderOrigin service;
  final Function(MusicItem music) onOk;

  const EditMusic({
    super.key,
    required this.musicOrderId,
    required this.data,
    required this.service,
    required this.onOk,
  });

  @override
  State<EditMusic> createState() => _EditMusicState();
}

class _EditMusicState extends State<EditMusic> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.data.name;
      _authorController.text = widget.data.author;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修改歌曲'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("歌曲名称"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _authorController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("歌曲作者"),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final cancel = BotToast.showLoading();
                  final music = MusicItem(
                    id: widget.data.id,
                    origin: widget.data.origin,
                    duration: widget.data.duration,
                    cover: widget.data.cover,
                    name: _nameController.text,
                    author: _authorController.text,
                  );
                  await widget.service.updateMusic(
                    widget.musicOrderId,
                    [music],
                  );
                  cancel();
                  if (context.mounted) {
                    Provider.of<UserMusicOrderModel>(context, listen: false)
                        .load(widget.service.name);
                    Navigator.of(context).pop();
                  }
                  widget.onOk(music);
                },
                child: const Text('确 认'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}