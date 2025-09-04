import 'package:flutter/material.dart';
import 'package:intuition/core/theme/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 12.0,
    this.padding,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? AppTheme.primaryColor,
      end: (widget.backgroundColor ?? AppTheme.primaryColor).withValues(
        alpha: 0.8,
      ),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color:
                    widget.isOutlined
                        ? (widget.backgroundColor ?? AppTheme.primaryColor)
                            .withValues(alpha: 0.1)
                        : _colorAnimation.value,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border:
                    widget.isOutlined
                        ? Border.all(
                          color:
                              widget.backgroundColor ?? AppTheme.primaryColor,
                          width: 1.5,
                        )
                        : null,
                boxShadow:
                    widget.isOutlined
                        ? null
                        : [
                          BoxShadow(
                            color: (widget.backgroundColor ??
                                    AppTheme.primaryColor)
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    padding:
                        widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                    child: widget.text.isEmpty && widget.icon != null
                        ? Center(
                            child: Icon(
                              widget.icon,
                              color:
                                  widget.foregroundColor ??
                                  (widget.isOutlined
                                      ? (widget.backgroundColor ??
                                          AppTheme.primaryColor)
                                      : Colors.white),
                              size: 18,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.isLoading) ...[
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      widget.foregroundColor ?? Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ] else if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color:
                                      widget.foregroundColor ??
                                      (widget.isOutlined
                                          ? (widget.backgroundColor ??
                                              AppTheme.primaryColor)
                                          : Colors.white),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.text,
                                style: TextStyle(
                                  color:
                                      widget.foregroundColor ??
                                      (widget.isOutlined
                                          ? (widget.backgroundColor ??
                                              AppTheme.primaryColor)
                                          : Colors.white),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Специализированные кнопки
class AddPersonButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddPersonButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Добавить персонажа',
      icon: Icons.person_add,
      onPressed: onPressed,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      isOutlined: false,
    );
  }
}

class AddFactButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddFactButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Добавить факт',
      icon: Icons.add,
      onPressed: onPressed,
      backgroundColor: AppTheme.secondaryColor,
      foregroundColor: Colors.white,
      isOutlined: false,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;

  const DeleteButton({super.key, this.onPressed, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? 'Удалить',
      child: CustomButton(
        text: '',
        icon: Icons.delete_outline,
        onPressed: onPressed,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        width: 40,
        height: 40,
        borderRadius: 8,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
