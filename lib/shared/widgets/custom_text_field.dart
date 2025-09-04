import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onSuffixTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final Color? borderColor;
  final Color? focusColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool isHighlighted;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.borderColor,
    this.focusColor,
    this.borderRadius = 12.0,
    this.contentPadding,
    this.isHighlighted = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.01).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: widget.borderColor ?? AppTheme.accentColor.withValues(alpha: 0.5),
      end: widget.focusColor ?? AppTheme.primaryColor,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });

    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Color _getBorderColor() {
    if (widget.isHighlighted) {
      return AppTheme.primaryColor;
    }
    return widget.borderColor ?? AppTheme.accentColor.withValues(alpha: 0.6);
  }

  double _getBorderWidth() {
    if (widget.isHighlighted) {
      return 2.0;
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: TextFormField(
              controller: widget.controller,
              initialValue: widget.initialValue,
              validator: widget.validator,
              onChanged: widget.onChanged,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              enabled: widget.enabled,
              onTap: () => _onFocusChange(true),
              onTapOutside: (_) => _onFocusChange(false),
              style: TextStyle(
                color: widget.enabled ? Colors.black87 : Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
              textAlignVertical:
                  (widget.maxLines != null && widget.maxLines! > 1) ||
                          widget.maxLines == null
                      ? TextAlignVertical.center
                      : TextAlignVertical.center,
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                prefixIcon:
                    widget.prefixIcon != null
                        ? Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _colorAnimation.value?.withValues(alpha: 0.1) ??
                                AppTheme.accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            widget.prefixIcon,
                            color:
                                _colorAnimation.value ?? AppTheme.accentColor,
                            size: 20,
                          ),
                        )
                        : null,
                suffixIcon:
                    widget.suffixIcon != null
                        ? GestureDetector(
                          onTap: widget.onSuffixTap,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  _colorAnimation.value?.withValues(
                                    alpha: 0.1,
                                  ) ??
                                  AppTheme.accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.suffixIcon,
                              color:
                                  _colorAnimation.value ?? AppTheme.accentColor,
                              size: 20,
                            ),
                          ),
                        )
                        : null,
                filled: true,
                fillColor: widget.enabled ? Colors.white : Colors.grey[100],
                contentPadding:
                    widget.contentPadding ??
                    ((widget.maxLines != null && widget.maxLines! > 1) ||
                            widget.maxLines == null
                        ? const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        )
                        : const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: _getBorderColor(),
                    width: _getBorderWidth(),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: _getBorderColor(),
                    width: _getBorderWidth(),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: widget.focusColor ?? AppTheme.primaryColor,
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                ),
                floatingLabelStyle: TextStyle(
                  color: _colorAnimation.value ?? AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                labelStyle: TextStyle(
                  color:
                      _isFocused
                          ? (_colorAnimation.value ?? AppTheme.primaryColor)
                          : AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                errorStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                counterStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Специализированные варианты полей ввода
class GameNameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const GameNameTextField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      validator: validator,
      labelText: 'Название игры',
      hintText: 'Введите название игры',
      prefixIcon: Icons.games,
      focusColor: AppTheme.primaryColor,
      maxLength: 50,
    );
  }
}

class PersonNameTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int personIndex;

  const PersonNameTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.validator,
    required this.personIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      labelText: 'ФИО персонажа',
      hintText: 'Например: Иван Петров',
      prefixIcon: Icons.person,
      focusColor: AppTheme.primaryColor,
      maxLength: 100,
      isHighlighted: true,
    );
  }
}

class FactTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int factIndex;
  final bool isSecret;

  const FactTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.validator,
    required this.factIndex,
    this.isSecret = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      labelText: 'Факт ${factIndex + 1}',
      hintText: 'Введите факт о персонаже',
      prefixIcon: isSecret ? Icons.lock : Icons.info_outline,
      focusColor: isSecret ? AppTheme.secretCardColor : AppTheme.hintCardColor,
      maxLines: null,
      maxLength: 200,
    );
  }
}
