import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection/injection.dart';
import '../../domain/entities/city_suggestion.dart';
import '../bloc/city_search/city_search_bloc.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final bool enabled;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.enabled = true,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  late final CitySearchBloc _citySearchBloc;
  late final AnimationController _animController;
  late final Animation<double> _borderAnim;
  OverlayEntry? _overlayEntry;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _citySearchBloc = getIt<CitySearchBloc>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _borderAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
      if (_focusNode.hasFocus) {
        _animController.forward();
      } else {
        _animController.reverse();
        Future.delayed(const Duration(milliseconds: 200), () {
          _removeOverlay();
          _citySearchBloc.add(const CitySearchCleared());
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animController.dispose();
    _removeOverlay();
    _citySearchBloc.close();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    _citySearchBloc.add(CitySearchQueryChanged(value));
    _showOverlay();
  }

  void _onSubmit() {
    _removeOverlay();
    _citySearchBloc.add(const CitySearchCleared());
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSearch(text);
      _focusNode.unfocus();
    }
  }

  void _onCitySelected(CitySuggestion city) {
    _controller.text = city.name;
    _removeOverlay();
    _citySearchBloc.add(const CitySearchCleared());
    widget.onSearch(city.name);
    _focusNode.unfocus();
  }

  void _onClear() {
    _controller.clear();
    _removeOverlay();
    _citySearchBloc.add(const CitySearchCleared());
    setState(() {});
    _focusNode.requestFocus();
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 8),
            child: Material(
              color: Colors.transparent,
              child: BlocProvider.value(
                value: _citySearchBloc,
                child: BlocBuilder<CitySearchBloc, CitySearchState>(
                  builder: (context, state) {
                    if (state is CitySearchLoading) {
                      return _buildDropdown(
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      );
                    }
                    if (state is CitySearchLoaded &&
                        state.suggestions.isNotEmpty) {
                      return _buildDropdown(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: state.suggestions
                              .map(_buildSuggestionTile)
                              .toList(),
                        ),
                      );
                    }
                    if (state is CitySearchEmpty) {
                      return _buildDropdown(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No cities found for "${state.query}"',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown({required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2040) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkGlassBorder : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(child: child),
      ),
    );
  }

  Widget _buildSuggestionTile(CitySuggestion city) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return InkWell(
      onTap: () => _onCitySelected(city),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  isDark ? AppColors.darkGlassBorder : const Color(0xFFF1F5F9),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.location_on_rounded, color: accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    [
                      if (city.state != null && city.state!.isNotEmpty)
                        city.state!,
                      city.country,
                    ].join(', '),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.north_west_rounded,
              color: (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary)
                  .withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final bgColor =
        isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface;

    return CompositedTransformTarget(
      link: _layerLink,
      child: AnimatedBuilder(
        animation: _borderAnim,
        builder: (context, child) {
          return Container(
            height: 58,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Color.lerp(
                  isDark
                      ? AppColors.darkGlassBorder
                      : AppColors.lightGlassBorder,
                  accent,
                  _borderAnim.value,
                )!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.15 * _borderAnim.value),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          );
        },
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search_rounded,
              color: _isFocused
                  ? accent
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                onChanged: _onChanged,
                onSubmitted: (_) => _onSubmit(),
                textInputAction: TextInputAction.search,
                style: AppTextStyles.searchInput(
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search for a city...',
                  hintStyle: AppTextStyles.searchHint(
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_controller.text.isNotEmpty) ...[
              GestureDetector(
                onTap: _onClear,
                child: Icon(
                  Icons.close_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
            ],
            GestureDetector(
              onTap: widget.enabled ? _onSubmit : null,
              child: Container(
                margin: const EdgeInsets.all(6),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent, accent.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
