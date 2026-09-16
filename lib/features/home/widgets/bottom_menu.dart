import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 850,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 14,
            children: const [
              _NovaMenuCard(
                icon: Icons.psychology_outlined,
                title: 'MEMORY',
                subtitle: 'Context & memories',
              ),
              _NovaMenuCard(
                icon: Icons.history_rounded,
                title: 'HISTORY',
                subtitle: 'Previous conversations',
              ),
              _NovaMenuCard(
                icon: Icons.tune_rounded,
                title: 'SETTINGS',
                subtitle: 'Configure NOVA',
              ),
              _NovaMenuCard(
                icon: Icons.info_outline_rounded,
                title: 'ABOUT',
                subtitle: 'NOVA Quantum',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NovaMenuCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _NovaMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_NovaMenuCard> createState() => _NovaMenuCardState();
}

class _NovaMenuCardState extends State<_NovaMenuCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => hovering = true);
      },
      onExit: (_) {
        setState(() => hovering = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 195,
        height: 82,
        transform: Matrix4.identity()
          ..translate(0.0, hovering ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: const Color(0xFF09071B).withOpacity(
            hovering ? .88 : .65,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF8A4DFF).withOpacity(
              hovering ? .75 : .28,
            ),
            width: 1,
          ),
          boxShadow: [
            if (hovering)
              BoxShadow(
                color: const Color(0xFF8A4DFF).withOpacity(.28),
                blurRadius: 24,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),

            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8A4DFF).withOpacity(
                  hovering ? .18 : .08,
                ),
                border: Border.all(
                  color: const Color(0xFF8A4DFF).withOpacity(
                    hovering ? .65 : .3,
                  ),
                ),
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: hovering
                    ? const Color(0xFFB98CFF)
                    : const Color(0xFF8D7CA8),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.48),
                      fontSize: 10,
                      letterSpacing: .3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Icon(
              Icons.chevron_right_rounded,
              size: 17,
              color: Colors.white.withOpacity(
                hovering ? .7 : .25,
              ),
            ),

            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}