import 'package:flutter/material.dart';

class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF126E82), width: 2),
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/bono.png',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.person),
      ),
    );
  }
}

class ConversationStepLayout extends StatelessWidget {
  const ConversationStepLayout({
    super.key,
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompactHeight = constraints.maxHeight < 620;
        final double avatarSize = isCompactHeight ? 72 : 132;
        final double gapAfterBubble = isCompactHeight ? 12 : 16;
        final double gapBeforePanel = isCompactHeight ? 8 : 12;

        return Column(
          children: <Widget>[
            CharacterBubble(message: message),
            SizedBox(height: gapAfterBubble),
            Flexible(
              child: Center(child: CharacterAvatar(size: avatarSize)),
            ),
            SizedBox(height: gapBeforePanel),
            Flexible(
              flex: isCompactHeight ? 5 : 4,
              child: InputPanel(child: child),
            ),
          ],
        );
      },
    );
  }
}

class CharacterBubble extends StatelessWidget {
  const CharacterBubble({
    super.key,
    required this.message,
    this.caption = '보노',
  });

  final String caption;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          caption,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: const Color(0xFF126E82),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class InputPanel extends StatelessWidget {
  const InputPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(top: false, child: SingleChildScrollView(child: child)),
    );
  }
}
