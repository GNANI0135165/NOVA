import 'package:flutter/material.dart';
import '../../../core/services/nova_api_service.dart';

class TalkButton extends StatefulWidget {
  const TalkButton({super.key});

  @override
  State<TalkButton> createState() => _TalkButtonState();
}

class _TalkButtonState extends State<TalkButton> {
  final TextEditingController controller = TextEditingController();

  bool loading = false;

  Future<void> _talkToNova() async {
    controller.clear();

    final message = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF09071B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: const Color(0xFF8A4DFF).withOpacity(.45),
            ),
          ),
          title: const Text(
            'TALK TO NOVA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFF9B5CFF),
            decoration: InputDecoration(
              hintText: 'Message NOVA...',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(.35),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(.12),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF8A4DFF),
                ),
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.pop(context, value.trim());
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white54,
                  letterSpacing: 1,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A4DFF),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(
                    context,
                    controller.text.trim(),
                  );
                }
              },
              child: const Text('SEND'),
            ),
          ],
        );
      },
    );

    if (message == null || message.isEmpty) return;

    setState(() => loading = true);

    try {
      final response =
          await NovaApiService.sendMessage(message);

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF09071B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: const Color(0xFF8A4DFF).withOpacity(.45),
              ),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF00D9FF),
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  'NOVA',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            content: Text(
              response,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF120B24),
          content: Text(
            'NOVA connection error: $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: loading ? null : _talkToNova,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 300,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0D0924),
                Color(0xFF110A2E),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF914DFF),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A4DFF).withOpacity(.28),
                blurRadius: 28,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFB98CFF),
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Color(0xFFB98CFF),
                        size: 19,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'TALK TO NOVA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}