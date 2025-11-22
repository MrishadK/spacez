import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SpacezApp());
}

class SpacezApp extends StatelessWidget {
  const SpacezApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spacez',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFC06C44),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC06C44),
          primary: const Color(0xFFC06C44),
          secondary: const Color(0xFF2E7D32),
        ),
        fontFamily: 'Roboto',
      ),
      home: const CouponsScreen(),
    );
  }
}

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final Set<int> _appliedCouponIndices = {};

  final coupons = [
    CouponData(
      amount: "₹6,900",
      code: "LONGSTAY",
      description:
          "15% off when you book for 5 days or more and 20% off when you book for 30 days or more.",
      type: "Coupon",
    ),
    CouponData(
      amount: "₹6,900",
      code: "LONGSTAY",
      description:
          "15% off when you book for 5 days or more and 20% off when you book for 30 days or more.",
      type: "Coupon",
    ),
    CouponData(
      amount: "₹3,000",
      code: "SUMMER",
      description: "Flat discount for summer bookings.",
      type: "Payment",
    ),
  ];

  void _toggleCoupon(int index) {
    setState(() {
      if (_appliedCouponIndices.contains(index)) {
        _appliedCouponIndices.remove(index);
      } else {
        _appliedCouponIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BrandBar(),
            const NavigationHeader(title: "Coupons"),
            Expanded(
              child: Container(
                color: const Color(0xFFFAFAFA),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  children: [
                    ...coupons
                        .asMap()
                        .entries
                        .where((e) => e.value.type == "Coupon")
                        .map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          return CouponTicket(
                            data: data,
                            isApplied: _appliedCouponIndices.contains(index),
                            onToggle: () => _toggleCoupon(index),
                          );
                        }),

                    const SizedBox(height: 24),

                    const Text(
                      "Payment offers:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...coupons
                        .asMap()
                        .entries
                        .where((e) => e.value.type == "Payment")
                        .map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          return CouponTicket(
                            data: data,
                            isApplied: _appliedCouponIndices.contains(index),
                            onToggle: () => _toggleCoupon(index),
                          );
                        }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const StickyFooter(),
          ],
        ),
      ),
    );
  }
}

class BrandBar extends StatefulWidget {
  const BrandBar({super.key});

  @override
  State<BrandBar> createState() => _BrandBarState();
}

class _BrandBarState extends State<BrandBar> {
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.cabin,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  );
                },
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/spacez.png',
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    "SPACEZ",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 22,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  );
                },
              ),
            ],
          ),
          InkWell(
            onTap: () {
              _debouncer.run(() {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Menu Clicked")));
              });
            },
            child: const Icon(Icons.menu, color: Color(0xFFC06C44), size: 26),
          ),
        ],
      ),
    );
  }
}

class NavigationHeader extends StatefulWidget {
  final String title;
  const NavigationHeader({super.key, required this.title});

  @override
  State<NavigationHeader> createState() => _NavigationHeaderState();
}

class _NavigationHeaderState extends State<NavigationHeader> {
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      color: Colors.white,
      width: double.infinity,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
            onPressed: () {
              _debouncer.run(() {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Back Clicked")));
              });
            },
          ),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

class StickyFooter extends StatefulWidget {
  const StickyFooter({super.key});

  @override
  State<StickyFooter> createState() => _StickyFooterState();
}

class _StickyFooterState extends State<StickyFooter> {
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFF388E3C),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.percent_rounded, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  "Book now & Unlock exclusive rewards!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "₹19,500",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Color(0xFFD32F2F),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "₹16,000",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "for 2 nights",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            "24 Apr - 26 Apr | 8 guests",
                            style: TextStyle(
                              color: Color(0xFF444444),
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dashed,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _debouncer.run(() {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Reserve Clicked!")),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC06C44),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Reserve",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CouponTicket extends StatefulWidget {
  final CouponData data;
  final bool isApplied;
  final VoidCallback onToggle;

  const CouponTicket({
    super.key,
    required this.data,
    required this.isApplied,
    required this.onToggle,
  });

  @override
  State<CouponTicket> createState() => _CouponTicketState();
}

class _CouponTicketState extends State<CouponTicket> {
  bool isExpanded = false;
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isApplied
        ? Theme.of(context).secondaryHeaderColor
        : Colors.transparent;

    final bgTint = widget.isApplied
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFDFDFD);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 20),
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        color: bgTint,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: widget.isApplied
                    ? const Color(0xFF2E7D32)
                    : Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
              ),
              child: Center(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    widget.data.amount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            CustomPaint(
              painter: DashedLinePainter(),
              size: const Size(1, double.infinity),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.data.code,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF424242),
                            letterSpacing: 0.5,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _debouncer.run(() {
                              widget.onToggle();
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.isApplied
                                        ? "Removed ${widget.data.code}"
                                        : "Applied ${widget.data.code}",
                                  ),
                                  backgroundColor: widget.isApplied
                                      ? Colors.grey
                                      : Colors.green,
                                  duration: const Duration(milliseconds: 1000),
                                ),
                              );
                            });
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: widget.isApplied
                                ? Row(
                                    key: const ValueKey("remove"),
                                    children: [
                                      const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        "Remove",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    key: const ValueKey("apply"),
                                    children: [
                                      Icon(
                                        Icons.sell_outlined,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Apply",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.data.description,
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        height: 1.5,
                        fontSize: 13.5,
                      ),
                    ),

                    const Spacer(),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? "Show less" : "Read more",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 5;
    double startY = 6;

    while (startY < size.height - 6) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CouponData {
  final String amount;
  final String code;
  final String description;
  final String type;

  CouponData({
    required this.amount,
    required this.code,
    required this.description,
    required this.type,
  });
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
