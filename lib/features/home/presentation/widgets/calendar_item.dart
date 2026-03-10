import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/home_providers.dart';

class CozyCalendar extends ConsumerStatefulWidget {
  const CozyCalendar({super.key});

  @override
  ConsumerState<CozyCalendar> createState() => _CozyCalendarState();
}

class _CozyCalendarState extends ConsumerState<CozyCalendar> {
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    final selected = ref.read(selectedDateProvider);
    currentMonth = DateTime(selected.year, selected.month);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final isExpanded = ref.watch(calendarExpandedProvider);
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
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month - 1,
                      1,
                    );
                  });
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left -> tháng sau
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month + 1,
                      1,
                    );
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
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month - 1,
                      1,
                    );
                  });
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left -> tháng sau
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month + 1,
                      1,
                    );
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
                              _buildGrid(days, selectedDate),
                              // Today button at bottom-right
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: _resetToToday,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Today',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.calendarSelectedDay,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    final selectedDate = ref.read(selectedDateProvider);
    final headerText = _getHeaderText(selectedDate);

    return GestureDetector(
      onTap: () {
        ref.read(calendarExpandedProvider.notifier).state = 
            !ref.read(calendarExpandedProvider);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            iconSize: 20,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                currentMonth = DateTime(
                  currentMonth.year,
                  currentMonth.month - 1,
                  1,
                );
              });
            },
          ),
          Flexible(
            child: Text(
              headerText,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            iconSize: 20,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                currentMonth = DateTime(
                  currentMonth.year,
                  currentMonth.month + 1,
                  1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  /// Header text: "Today" if selectedDate == today, otherwise "MMM d yyyy"
  String _getHeaderText(DateTime selectedDate) {
    final now = DateTime.now();
    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      return 'Today';
    }
    return '${_monthName(selectedDate.month)} ${selectedDate.day} ${selectedDate.year}';
  }

  /// Reset selectedDate to today and navigate calendar to current month
  void _resetToToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    ref.read(selectedDateProvider.notifier).state = today;
    setState(() {
      currentMonth = DateTime(now.year, now.month);
    });
  }

  // ================= WEEK =================
  Widget _buildWeekDays() {
    final days = ["M", "Tu", "We", "Th", "Fri", "Sat", "Su"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map(
            (d) => Text(
              d,
              style: TextStyle(color: AppColors.calendarWeekHeader, fontSize: 12),
            ),
          )
          .toList(),
    );
  }

  // ================= GRID =================
  Widget _buildGrid(List<DateTime?> days, DateTime selectedDate) {
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
            day.day == selectedDate.day &&
            day.month == selectedDate.month &&
            day.year == selectedDate.year;

        return GestureDetector(
          onTap: () {
            ref.read(selectedDateProvider.notifier).state = day;
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.calendarSelectedDay : Colors.transparent,
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
                    Text("${day.day}", style: TextStyle(fontSize: 10)),
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
          color: AppColors.calendarSelectedDay,
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
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

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
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "July",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return names[m];
  }
}
