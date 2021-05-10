import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteraudioplayer/data/model/AudioPlayerModel.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerBloc.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerEvent.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerState.dart';

import 'AudioPositionWidget.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        if (state is AudioPlayerInitial || state is AudioPlayerReady) {
          return SizedBox.shrink();
        }
        if (state is AudioPlayerPlaying) {
          return _showPlayer(context, state.playingEntity);
        }
        if (state is AudioPlayerPaused) {
          return _showPlayer(context, state.pausedEntity);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _showPlayer(BuildContext context, AudioPlayerModel model) {
    final player = BlocProvider.of<AudioPlayerBloc>(context).assetsAudioPlayer!;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            color: Colors.grey.shade200,
            child: Column(
              children: [
                //get real time playing info for position
                StreamBuilder(
                  stream: player.realtimePlayingInfos,
                  builder: (BuildContext context, AsyncSnapshot<RealtimePlayingInfos> snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    final playing = snapshot.data!;
                    return AudioPositionWidget(
                        currentPosition: playing.currentPosition,
                        duration: playing.duration,
                        seekTo: (to) => player.seek(to));
                  },
                ),
                //20210509 Alternativt sätt med mer abstraktion:
                // player.builderRealtimePlayingInfos(builder: (context, RealtimePlayingInfos? info) {
                //   if (info == null) {
                //     return SizedBox();
                //   }
                //   return AudioPositionWidget(
                //       currentPosition: info.currentPosition,
                //       duration: info.duration,
                //       seekTo: (to) => player.seek(to));
                // }),
                ListTile(
                  leading: setLeading(model),
                  title: setTitle(model),
                  subtitle: setSubtitle(model),
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  trailing: Wrap(
                    spacing: 12,
                    children: [
                      IconButton(
                          icon: Icon(Icons.fast_forward),
                          onPressed: () => skipAhead(context, model)),
                      IconButton(
                        icon: setIcon(model),
                        onPressed: setCallback(context, model) as void Function()?,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget setIcon(AudioPlayerModel model) {
    if (model.isPlaying!)
      return Icon(Icons.pause);
    else
      return Icon(Icons.play_arrow);
  }

  Widget setLeading(AudioPlayerModel model) {
    return new Image.asset(model.audio!.metas.image!.path);
  }

  Widget setTitle(AudioPlayerModel model) {
    return Text(model.audio!.metas.title!);
  }

  Widget setSubtitle(AudioPlayerModel model) {
    return Text(model.audio!.metas.artist!);
  }

  Function setCallback(BuildContext context, AudioPlayerModel model) {
    if (model.isPlaying!)
      return () {
        BlocProvider.of<AudioPlayerBloc>(context).add(TriggeredPauseAudio(model));
      };
    else
      return () {
        BlocProvider.of<AudioPlayerBloc>(context).add(TriggeredPlayAudio(model));
      };
  }

  Function skipAhead(BuildContext context, AudioPlayerModel model) {
    return () {
      BlocProvider.of<AudioPlayerBloc>(context).add(TriggeredSkipAhead(model));
    };
  }
}
