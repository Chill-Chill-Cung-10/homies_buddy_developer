import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale =
        (size.shortestSide / _HelpSizes.baseWidth).clamp(0.88, 1.08).toDouble();
    double s(double value) => value * scale;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: _HelpColors.backgroundGradient,
            ),
          ),
          SafeArea(
            bottom: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stackCards =
                    constraints.maxWidth < _HelpSizes.twoCardMinWidth;
                final gap = s(_HelpSizes.cardGap);

                final verticalPadding =
                    s(_HelpSizes.topPadding + _HelpSizes.bottomPadding);
                final minHeight = (constraints.maxHeight - verticalPadding)
                    .clamp(0.0, double.infinity)
                    .toDouble();

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minHeight),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        s(_HelpSizes.horizontalPadding),
                        s(_HelpSizes.topPadding),
                        s(_HelpSizes.horizontalPadding),
                        s(_HelpSizes.bottomPadding),
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _TopBar(scale: scale),
                            SizedBox(height: s(_HelpSizes.heroTopSpacing)),
                            _HeroCat(size: s(_HelpSizes.heroSize)),
                            SizedBox(height: s(_HelpSizes.titleTopSpacing)),
                            _TitleBlock(scale: scale),
                            SizedBox(height: s(_HelpSizes.searchTopSpacing)),
                            _SearchBar(scale: scale),
                            const Spacer(),
                            SizedBox(height: s(_HelpSizes.cardsTopSpacing)),
                            _RecommendationCards(
                              scale: scale,
                              gap: gap,
                              stack: stackCards,
                            ),
                            SizedBox(height: s(_HelpSizes.bottomSpacer)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final double scale;

  const _TopBar({required this.scale});

  @override
  Widget build(BuildContext context) {
    final fontSize = (_HelpTextStyles.topBar.fontSize ?? 20) * scale;
    final iconSize = 22 * scale;

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Ask For Help',
                style: _HelpTextStyles.topBar.copyWith(fontSize: fontSize),
              ),
              SizedBox(width: 4 * scale),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: iconSize,
                color: _HelpColors.iconDark,
              ),
            ],
          ),
          Icon(
            Icons.notifications_none_rounded,
            size: iconSize,
            color: _HelpColors.iconDark,
          ),
        ],
      ),
    );
  }
}

class _HeroCat extends StatelessWidget {
  final double size;

  const _HeroCat({required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _HelpAssets.cat,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final double scale;

  const _TitleBlock({required this.scale});

  @override
  Widget build(BuildContext context) {
    final greetingSize = (_HelpTextStyles.greeting.fontSize ?? 24) * scale;
    final questionSize = (_HelpTextStyles.question.fontSize ?? 23) * scale;

    return Column(
      children: [
        Text(
          'Hello, Name',
          style: _HelpTextStyles.greeting.copyWith(fontSize: greetingSize),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4 * scale),
        Text(
          'How can I help you today?',
          style: _HelpTextStyles.question.copyWith(fontSize: questionSize),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final double scale;

  const _SearchBar({required this.scale});

  @override
  Widget build(BuildContext context) {
    final hintSize = (_HelpTextStyles.searchHint.fontSize ?? 14) * scale;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * scale,
              vertical: 4 * scale,
            ),
            decoration: BoxDecoration(
              color: _HelpColors.fieldBackground,
              borderRadius: BorderRadius.circular(
                _HelpSizes.searchRadius * scale,
              ),
              boxShadow: [
                BoxShadow(
                  color: _HelpColors.fieldShadow,
                  blurRadius: 10 * scale,
                  offset: Offset(0, 4 * scale),
                ),
              ],
            ),
            child: TextField(
              cursorColor: _HelpColors.titleOrange,
              decoration: InputDecoration(
                hintText: 'Ask anything',
                hintStyle:
                    _HelpTextStyles.searchHint.copyWith(fontSize: hintSize),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
              ),
              style: _HelpTextStyles.searchText.copyWith(fontSize: hintSize),
            ),
          ),
        ),
        SizedBox(width: 12 * scale),
        Container(
          width: _HelpSizes.sendButtonSize * scale,
          height: _HelpSizes.sendButtonSize * scale,
          decoration: BoxDecoration(
            color: _HelpColors.sendButton,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _HelpColors.cardShadow,
                blurRadius: 8 * scale,
                offset: Offset(0, 4 * scale),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              _HelpAssets.send,
              width: 18 * scale,
              height: 18 * scale,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendationCards extends StatelessWidget {
  final double scale;
  final double gap;
  final bool stack;

  const _RecommendationCards({
    required this.scale,
    required this.gap,
    required this.stack,
  });

  @override
  Widget build(BuildContext context) {
    final plantCard = _RecommendationCard(
      scale: scale,
      title: 'Watering Your Fern - Every 3 Days',
      headerGradient: _HelpColors.fernHeaderGradient,
      headerChild: _PlantHeader(scale: scale),
    );

    final sheepCard = _RecommendationCard(
      scale: scale,
      title: 'Brushing Your Sheep - Daily Connection',
      headerColor: _HelpColors.cardHeaderSheep,
      headerChild: _SheepHeader(scale: scale),
    );

    if (stack) {
      return Column(
        children: [
          plantCard,
          SizedBox(height: gap),
          sheepCard,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: plantCard),
        SizedBox(width: gap),
        Expanded(child: sheepCard),
      ],
    );
  }
}

class _PlantHeader extends StatelessWidget {
  final double scale;

  const _PlantHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    final plantSize = _HelpSizes.plantSize * scale;

    return Center(
      child: SizedBox(
        width: plantSize,
        height: plantSize,
        child: SvgPicture.asset(
          _HelpAssets.plant,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _SheepHeader extends StatelessWidget {
  final double scale;

  const _SheepHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    final sheepSize = _HelpSizes.sheepSize * scale;
    final brushSize = _HelpSizes.brushSize * scale;
    final gap = _HelpSizes.brushGap * scale;
    final brushDx = -(sheepSize / 2 + gap + brushSize / 2);
    final centerShift = _HelpSizes.sheepCenterShift * scale;
    final brushDy = -(sheepSize / 2 - brushSize / 2) -
        _HelpSizes.brushVerticalGap * scale +
        centerShift;

    return SizedBox(
      width: double.infinity,
      height: _HelpSizes.headerContentHeight * scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, centerShift),
            child: Image.asset(
              _HelpAssets.sheep,
              width: sheepSize,
              height: sheepSize,
              fit: BoxFit.contain,
            ),
          ),
          Transform.translate(
            offset: Offset(brushDx, brushDy),
            child: Image.asset(
              _HelpAssets.brush,
              width: brushSize,
              height: brushSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final double scale;
  final String title;
  final Color? headerColor;
  final Gradient? headerGradient;
  final Widget headerChild;

  const _RecommendationCard({
    required this.scale,
    required this.title,
    this.headerColor,
    this.headerGradient,
    required this.headerChild,
  });

  @override
  Widget build(BuildContext context) {
    final titleSize = (_HelpTextStyles.cardTitle.fontSize ?? 14) * scale;

    return Container(
      padding: EdgeInsets.all(_HelpSizes.cardPadding * scale),
      decoration: BoxDecoration(
        color: _HelpColors.cardBackground,
        borderRadius: BorderRadius.circular(_HelpSizes.cardRadius * scale),
        boxShadow: [
          BoxShadow(
            color: _HelpColors.cardShadow,
            blurRadius: 12 * scale,
            offset: Offset(0, 6 * scale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: _HelpSizes.cardHeaderHeight * scale,
            width: double.infinity,
            decoration: BoxDecoration(
              color: headerColor,
              gradient: headerGradient,
              borderRadius:
                  BorderRadius.circular(_HelpSizes.cardHeaderRadius * scale),
            ),
            alignment: Alignment.topCenter,
            child: headerChild,
          ),
          SizedBox(height: 12 * scale),
          Text(
            title,
            style: _HelpTextStyles.cardTitle.copyWith(fontSize: titleSize),
          ),
        ],
      ),
    );
  }
}

class _HelpAssets {
  static const String _base = 'lib/features/help/presentation/screens/img';
  static const String cat = '$_base/cat-img.png';
  static const String plant = '$_base/potted-plant.svg';
  static const String send = '$_base/sendIcon.png';
  static const String sheep = '$_base/sheep.png';
  static const String brush = '$_base/brush.png';
}

class _HelpColors {
  static const Color iconDark = Color(0xFF2F201A);
  static const Color iconLight = Color(0xFF2E2A23);

  static const Color titleOrange = Color(0xFFE08A2F);
  static const Color hintText = Color(0xFFB9A89B);
  static const Color fieldBackground = Color(0xFFFFFFFF);
  static const Color fieldShadow = Color(0x14000000);

  static const Color sendButton = Color(0xFFE6B267);

  static const Color cardBackground = Color(0xFFF1DDC7);
  static const Color cardShadow = Color(0x22000000);
  static const Color cardHeaderSheep = Color(0xFFE29C5F);

  static const LinearGradient fernHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF2F58A),
      Color(0xFF50AD3D),
    ],
    stops: [0.2, 1.0],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAD7D0),
      Color(0xFFF7E6CD),
    ],
  );
}

class _HelpTextStyles {
  static const TextStyle topBar = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: _HelpColors.iconDark,
  );

  static const TextStyle greeting = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: _HelpColors.titleOrange,
  );

  static const TextStyle question = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w700,
    color: _HelpColors.titleOrange,
  );

  static const TextStyle searchHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: _HelpColors.hintText,
  );

  static const TextStyle searchText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: _HelpColors.iconDark,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _HelpColors.iconDark,
    height: 1.25,
  );

}

class _HelpSizes {
  static const double baseWidth = 375;

  static const double horizontalPadding = 20;
  static const double topPadding = 8;
  static const double bottomPadding = 24;

  static const double heroTopSpacing = 14;
  static const double heroSize = 175;

  static const double titleTopSpacing = 10;
  static const double searchTopSpacing = 18;
  static const double cardsTopSpacing = 22;
  static const double bottomSpacer = 8;

  static const double searchRadius = 28;
  static const double sendButtonSize = 46;

  static const double cardGap = 16;
  static const double cardPadding = 14;
  static const double cardRadius = 22;
  static const double cardHeaderHeight = 110;
  static const double cardHeaderRadius = 18;

  static const double twoCardMinWidth = 360;

  static const double plantSize = 45;
  static const double sheepSize = 40;
  static const double brushSize = 18;
  static const double brushGap = 8;
  static const double sheepTop = 18;
  static const double brushTop = 6;
  static const double headerContentHeight = 90;
  static const double brushVerticalGap = 4;
  static const double sheepCenterShift = 12;
}
