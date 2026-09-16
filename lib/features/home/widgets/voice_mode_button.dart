import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../../../core/services/nova_api_service.dart';
import 'reactor/reactor_controller.dart';

enum _VoiceState {
  idle,
  listening,
  thinking,
  speaking,
}

class VoiceModeButton extends StatefulWidget {
  const VoiceModeButton({super.key});

  @override
  State<VoiceModeButton> createState() => _VoiceModeButtonState();
}

class _VoiceModeButtonState extends State<VoiceModeButton>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText speech = stt.SpeechToText();
  final FlutterTts tts = FlutterTts();

  late final AnimationController pulse;

  _VoiceState state = _VoiceState.idle;

  String transcript = '';

  bool speechReady = false;

  @override
  void initState() {
    super.initState();

    pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
      lowerBound: .88,
      upperBound: 1.08,
    )..repeat(reverse: true);

    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    speechReady = await speech.initialize(
      onStatus: (status) {
        if (!mounted) return;

        if (status == 'done' && state == _VoiceState.listening) {
          _processVoice();
        }
      },
      onError: (_) {
        if (!mounted) return;

        _setVoiceState(_VoiceState.idle);
      },
    );

    await tts.setLanguage('en-US');
    await tts.setSpeechRate(.48);
    await tts.setPitch(.95);

    tts.setStartHandler(() {
      if (!mounted) return;
      _setVoiceState(_VoiceState.speaking);
    });

    tts.setCompletionHandler(() {
      if (!mounted) return;
      _setVoiceState(_VoiceState.idle);
    });

    tts.setCancelHandler(() {
      if (!mounted) return;
      _setVoiceState(_VoiceState.idle);
    });

    if (mounted) {
      setState(() {});
    }
  }

  void _setVoiceState(_VoiceState newState) {
    if (!mounted) return;

    setState(() {
      state = newState;
    });

    switch (newState) {
      case _VoiceState.idle:
        ReactorStateBus.set(ReactorState.idle);
        break;

      case _VoiceState.listening:
        ReactorStateBus.set(ReactorState.listening);
        break;

      case _VoiceState.thinking:
        ReactorStateBus.set(ReactorState.thinking);
        break;

      case _VoiceState.speaking:
        ReactorStateBus.set(ReactorState.speaking);
        break;
    }
  }

  Future<void> _startListening() async {
    if (!speechReady) {
      await _initializeVoice();
    }

    if (!speechReady) {
      _showMessage('Microphone or speech recognition is unavailable.');
      return;
    }

    transcript = '';

    await tts.stop();

    _setVoiceState(_VoiceState.listening);

    await speech.listen(
      onResult: (result) {
        if (!mounted) return;

        setState(() {
          transcript = result.recognizedWords;
        });

        if (result.finalResult) {
          _processVoice();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 4),
      partialResults: true,
      cancelOnError: true,
    );
  }

  Future<void> _stopListening() async {
    await speech.stop();

    if (!mounted) return;

    if (transcript.trim().isEmpty) {
      _setVoiceState(_VoiceState.idle);
      return;
    }

    await _processVoice();
  }

  Future<void> _processVoice() async {
    if (state == _VoiceState.thinking) return;

    await speech.stop();

    final message = transcript.trim();

    if (message.isEmpty) {
      _setVoiceState(_VoiceState.idle);
      return;
    }

    _setVoiceState(_VoiceState.thinking);

    try {
      final result = await NovaApiService.sendMessage(message);

      if (!mounted) return;

      _setVoiceState(_VoiceState.speaking);

      await tts.speak(result);
    } catch (e) {
      if (!mounted) return;

      _setVoiceState(_VoiceState.idle);

      _showMessage('VOICE ERROR:\n\n$e');
    }
  }

  void _handleTap() {
    switch (state) {
      case _VoiceState.idle:
        _startListening();
        break;

      case _VoiceState.listening:
        _stopListening();
        break;

      case _VoiceState.thinking:
        break;

      case _VoiceState.speaking:
        tts.stop();
        _setVoiceState(_VoiceState.idle);
        break;
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF09071B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: const Color(0xFF8A4DFF).withOpacity(.45),
            ),
          ),
          title: const Text(
            'NOVA',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        );
      },
    );
  }

  String get label {
    switch (state) {
      case _VoiceState.idle:
        return 'VOICE MODE';
      case _VoiceState.listening:
        return 'LISTENING';
      case _VoiceState.thinking:
        return 'THINKING';
      case _VoiceState.speaking:
        return 'SPEAKING';
    }
  }

  IconData get icon {
    switch (state) {
      case _VoiceState.idle:
        return Icons.mic_none_rounded;
      case _VoiceState.listening:
        return Icons.mic_rounded;
      case _VoiceState.thinking:
        return Icons.psychology_rounded;
      case _VoiceState.speaking:
        return Icons.volume_up_rounded;
    }
  }

  Color get accent {
    switch (state) {
      case _VoiceState.idle:
        return const Color(0xFF8A4DFF);
      case _VoiceState.listening:
        return const Color(0xFF00D9FF);
      case _VoiceState.thinking:
        return const Color(0xFF9B63FF);
      case _VoiceState.speaking:
        return const Color(0xFF55F2B0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = state != _VoiceState.idle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: pulse,
            builder: (_, __) {
              return Transform.scale(
                scale: active ? pulse.value : 1.0,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accent.withOpacity(.42),
                        const Color(0xFF160C38),
                        const Color(0xFF080512),
                      ],
                    ),
                    border: Border.all(
                      color: accent,
                      width: 1.6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(.42),
                        blurRadius: active ? 32 : 22,
                        spreadRadius: active ? 5 : 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 9),

        Text(
          label,
          style: TextStyle(
            color: accent,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),

        if (transcript.isNotEmpty &&
            state == _VoiceState.listening) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              '"$transcript"',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(.65),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    speech.stop();
    tts.stop();
    pulse.dispose();
    super.dispose();
  }
}
