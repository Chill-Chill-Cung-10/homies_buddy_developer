import 'package:flutter/material.dart';

class ExpBar extends StatelessWidget {
  final int current; // số block đã fill
  final int total;

  const ExpBar({super.key, required this.current, this.total = 8});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ===== Background =====
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xFFFFF4E8),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.08),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.favorite, size: 18, color: Colors.brown),
              SizedBox(width: 8),

              // ===== Segments =====
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(total, (index) {
                    final isActive = index < current;

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      width: 18,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? Color(0xFFE6B98A) : Color(0xFFDCC5AA),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(width: 36), // chừa chỗ cho avatar
            ],
          ),
        ),

        // ===== Avatar overlay =====
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFF4E8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/home/pets/lumni_idle.png", // avatar của bạn
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
