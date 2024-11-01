import 'dart:async';

import 'package:flutter/material.dart';

class DropletCorossolCardWidget extends StatefulWidget {
  const DropletCorossolCardWidget({super.key});

  @override
  State<DropletCorossolCardWidget> createState() =>
      _DropletCorossolCardWidgetState();
}

class _DropletCorossolCardWidgetState extends State<DropletCorossolCardWidget> {
  final List<Map<String, dynamic>> items = [
    {
      'title': 'Blonkisoaz',
      'subtitle': 'Omuke trughte a otufta',
      'image':
          'https://66.media.tumblr.com/6fb397d822f4f9f4596dff2085b18f2e/tumblr_nzsvb4p6xS1qho82wo1_1280.jpg',
      'icon': Icons.directions_walk,
      'color': const Color(0xFFED5565),
    },
    {
      'title': 'Oretemauw',
      'subtitle': 'Omuke trughte a otufta',
      'image':
          'https://66.media.tumblr.com/8b69cdde47aa952e4176b4200052abf4/tumblr_o51p7mFFF21qho82wo1_1280.jpg',
      'icon': Icons.ac_unit,
      'color': const Color(0xFFFC6E51)
    },
    {
      'title': 'Iteresuselle',
      'subtitle': 'Omuke trughte a otufta',
      'image':
          'https://66.media.tumblr.com/5af3f8303456e376ceda1517553ba786/tumblr_o4986gakjh1qho82wo1_1280.jpg',
      'icon': Icons.park,
      'color': const Color(0xFFFFCE54)
    },
    {
      'title': 'Idiefe',
      'subtitle': 'Omuke trughte a otufta',
      'image':
          'https://66.media.tumblr.com/5516a22e0cdacaa85311ec3f8fd1e9ef/tumblr_o45jwvdsL11qho82wo1_1280.jpg',
      'icon': Icons.water_drop,
      'color': const Color(0xFF2ECC71)
    },
    {
      'title': 'Inatethi',
      'subtitle': 'Omuke trughte a otufta',
      'image':
          'https://66.media.tumblr.com/f19901f50b79604839ca761cd6d74748/tumblr_o65rohhkQL1qho82wo1_1280.jpg',
      'icon': Icons.sunny,
      'color': const Color(0xFF5D9CEC)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: _ExpandingCards(
          height: 400,
          items: items,
        ),
      ),
    );
  }
}

class _ExpandingCards extends StatefulWidget {
  final double height;
  final List<Map<String, dynamic>> items;

  const _ExpandingCards({
    required this.height,
    required this.items,
  });

  @override
  State<_ExpandingCards> createState() => _ExpandingCardsState();
}

class _ExpandingCardsState extends State<_ExpandingCards>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    autoStuffle();
  }

  int _index = 0;

  void autoStuffle() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      onExpand(_index == _selectedIndex.value ? -1 : _index);
      _index = (_index + 1) % widget.items.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, selIndx, _) {
        return SizedBox(
          height: 450,
          child: ListView.builder(
            itemCount: widget.items.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 56),
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              final item = widget.items[index % widget.items.length];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: AnimatedCardItem(
                  key: ValueKey(index),
                  title: item['title'],
                  subtitle: item['subtitle'],
                  image: item['image'],
                  icon: item['icon'] as IconData,
                  iconColor: item['color'] as Color,
                  isExpanded: selIndx == index,
                  animation: _controller,
                  onTap: () => onExpand(selIndx == index ? -1 : index),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void onExpand(int index) {
    _selectedIndex.value = index;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedCardItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;
  final IconData icon;
  final Animation<double> animation;
  final bool isExpanded;
  final VoidCallback onTap;
  final Color iconColor;

  const AnimatedCardItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.icon,
    required this.animation,
    required this.isExpanded,
    required this.onTap,
    required this.iconColor,
  });

  @override
  State<AnimatedCardItem> createState() => _AnimatedCardItemState();
}

class _AnimatedCardItemState extends State<AnimatedCardItem> {
  bool shouldRect = false;

  @override
  void didUpdateWidget(covariant AnimatedCardItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      shouldRect = true;
    } else {
      shouldRect = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double collapsedWidth = 70;
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            double value = shouldRect
                ? widget.isExpanded
                    ? widget.animation.value
                    : 1 - widget.animation.value
                : widget.isExpanded
                    ? 1
                    : 0;

            final double animValue = widget.isExpanded
                ? const Interval(0, 0.5, curve: Curves.fastOutSlowIn)
                    .transform(value)
                : Interval(0.5, 1, curve: Curves.fastOutSlowIn.flipped)
                    .transform(value);

            final imageScaleValue = widget.isExpanded
                ? const Interval(0.2, 1, curve: Curves.easeOut).transform(value)
                : const Interval(0.8, 1, curve: Curves.easeOut)
                    .transform(value);

            final titleValue = widget.isExpanded
                ? const Interval(0.2, 0.8, curve: Curves.easeOut)
                    .transform(value)
                : const Interval(0.2, 0.8, curve: Curves.easeOut)
                    .transform(value);

            final subtitleValue = widget.isExpanded
                ? const Interval(0.4, 0.8, curve: Curves.easeOut)
                    .transform(value)
                : const Interval(0.4, 0.8, curve: Curves.easeOut)
                    .transform(value);

            return Transform.scale(
              scale: 1 + animValue * 0.02,
              child: Container(
                width: collapsedWidth + animValue * (600 - collapsedWidth),
                height: 400 + (animValue * 20),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(collapsedWidth / 2),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Transform.scale(
                        scale: 1.2 - imageScaleValue * 0.03,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          foregroundDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0),
                                Colors.black.withOpacity(1),
                              ],
                              stops: const [0.7, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10 + animValue * 10,
                          vertical: 10 + animValue * 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: SizedBox.square(
                                dimension: 50,
                                child: Center(
                                  child: Icon(
                                    widget.icon,
                                    color: widget.iconColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            if (widget.isExpanded)
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Opacity(
                                        opacity: titleValue,
                                        child: Transform.translate(
                                          offset: Offset(
                                            20 * (1 - titleValue),
                                            0,
                                          ),
                                          child: Text(
                                            widget.title,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(height: 2),
                                      Opacity(
                                        opacity: subtitleValue,
                                        child: Transform.translate(
                                          offset: Offset(
                                            20 * (1 - subtitleValue),
                                            0,
                                          ),
                                          child: Text(
                                            widget.subtitle,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
