import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor = const Color(0xFF162232),
    this.highlightColor = const Color(0xFF2A3A4A),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(
                _animation.value - 1,
                0,
              ),
              end: Alignment(
                _animation.value + 1,
                0,
              ),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Placeholder widgets for shimmer effect
class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ShimmerListItem extends StatelessWidget {
  final double height;

  const ShimmerListItem({
    super.key,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerPlaceholder(
            width: 50,
            height: 50,
            borderRadius: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerPlaceholder(
                  width: double.infinity,
                  height: 16,
                ),
                const SizedBox(height: 8),
                ShimmerPlaceholder(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 12,
                ),
                const SizedBox(height: 8),
                ShimmerPlaceholder(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCardGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double height;

  const ShimmerCardGrid({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ShimmerPlaceholder(
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }
}
