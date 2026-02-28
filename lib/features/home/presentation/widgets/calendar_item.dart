import 'package:flutter/material.dart';

class CozyCalendar extends StatefulWidget {
  const CozyCalendar({super.key});

  @override
  _CozyCalendarState createState() => _CozyCalendarState();
}
class _CozyCalendarState extends State<CozyCalendar> {
  DateTime currentMonth = DateTime(2026, 4);
  DateTime? selectedDate = DateTime.now(); // Mặc định chọn ngày hiện tại
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final days = _generateDays(currentMonth);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Component - độc lập
          Center(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swipe right -> tháng trước
                  setState(() {
                    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
                  });
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left -> tháng sau
                  setState(() {
                    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
                  });
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildHeader(),
              ),
            ),
          ),
          
          // Khoảng cách giữa header và grid
          SizedBox(height: 16),
          
          // Grid Component - độc lập
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swipe right -> tháng trước
                  setState(() {
                    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
                  });
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left -> tháng sau
                  setState(() {
                    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
                  });
                }
              },
              child: AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                clipBehavior: Clip.hardEdge,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 250),
                  opacity: isExpanded ? 1.0 : 0.0,
                  child: isExpanded 
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            _buildWeekDays(),
                            SizedBox(height: 8),
                            _buildGrid(days),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  // ================= HEADER =================
  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            iconSize: 20,
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(),
            onPressed: () {
              setState(() {
                currentMonth =
                    DateTime(currentMonth.year, currentMonth.month, currentMonth.day - 1);
              });
            },
          ),
          Flexible(
            child: Text(
              "${_monthName(currentMonth.month)} ${currentMonth.day} ${currentMonth.year}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 20,
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(),
            onPressed: () {
              setState(() {
                currentMonth = DateTime(currentMonth.year, currentMonth.month, currentMonth.day + 1);
              });
            },
          ),
        ],
      ),
    );
  }

  // ================= WEEK =================
  Widget _buildWeekDays() {
    final days = ["M", "Tu", "We", "Th", "Fri", "Sat", "Su"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((d) => Text(
                d,
                style: TextStyle(
                  color: Colors.brown.shade300,
                  fontSize: 12,
                ),
              ))
          .toList(),
    );
  }

  // ================= GRID =================
  Widget _buildGrid(List<DateTime?> days) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        if (day == null) return SizedBox();

        final isSelected =
            selectedDate != null &&
            day.day == selectedDate!.day &&
            day.month == selectedDate!.month;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = day;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xFFF2D6B3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${day.day}",
                      style: TextStyle(fontSize: 10),
                    ),
                    _buildMood(day),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= MOOD =================
  Widget _buildMood(DateTime day) {
    // fake data demo
    if (day.day == 1) {
      return Icon(Icons.pets, size: 8, color: Colors.orange);
    }
    if (day.day == 6) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 7, color: Colors.red),
          Icon(Icons.favorite, size: 7, color: Colors.red),
        ],
      );
    }
    if (day.day == 12) {
      return Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Color(0xFFF2D6B3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.sentiment_satisfied, size: 7),
      );
    }
    return SizedBox(height: 6);
  }

  // ================= LOGIC =================
  List<DateTime?> _generateDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final weekday = firstDay.weekday; // 1 = Mon
    final daysInMonth =
        DateTime(month.year, month.month + 1, 0).day;

    List<DateTime?> result = [];

    // padding trước
    for (int i = 0; i < weekday - 1; i++) {
      result.add(null);
    }

    // ngày thật
    for (int i = 1; i <= daysInMonth; i++) {
      result.add(DateTime(month.year, month.month, i));
    }

    return result;
  }

  String _monthName(int m) {
    const names = [
      "", "Jan", "Feb", "Mar", "Apr", "May",
      "Jun", "July", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[m];
  }
}