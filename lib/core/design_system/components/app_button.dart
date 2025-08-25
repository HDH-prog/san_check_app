import 'package:flutter/material.dart';
import '../foundation/app_colors.dart';
import '../foundation/app_spacing.dart';
import '../foundation/app_typography.dart';

enum ButtonVariant { primary, secondary, outline, text, danger }

enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  // Emergency Button (특별한 스타일)
  const AppButton.emergency({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : variant = ButtonVariant.danger,
       size = ButtonSize.large,
       isFullWidth = true;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final child = _buildChild();

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(buttonStyle, child),
    );
  }

  Widget _buildButton(ButtonStyle style, Widget child) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.danger:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        );
      case ButtonVariant.secondary:
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        );
    }
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _getLoadingColor(),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getButtonStyle() {
    final colors = _getColors();
    final padding = _getPadding();
    final textStyle = _getTextStyle();
    final minimumSize = _getMinimumSize();

    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return colors.disabledBackground;
        }
        return colors.background;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return colors.disabledForeground;
        }
        return colors.foreground;
      }),
      side: colors.border != null
          ? MaterialStateProperty.all(BorderSide(color: colors.border!))
          : null,
      elevation: MaterialStateProperty.all(colors.elevation),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
      padding: MaterialStateProperty.all(padding),
      minimumSize: MaterialStateProperty.all(minimumSize),
      textStyle: MaterialStateProperty.all(textStyle),
    );
  }

  _ButtonColors _getColors() {
    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonColors(
          background: AppColors.primary,
          foreground: AppColors.white,
          disabledBackground: AppColors.textDisabled,
          disabledForeground: AppColors.white,
          elevation: AppSpacing.elevation2,
        );
      case ButtonVariant.secondary:
        return _ButtonColors(
          background: AppColors.secondary,
          foreground: AppColors.white,
          disabledBackground: AppColors.textDisabled,
          disabledForeground: AppColors.white,
          elevation: AppSpacing.elevation2,
        );
      case ButtonVariant.outline:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.primary,
          border: AppColors.primary,
          disabledBackground: Colors.transparent,
          disabledForeground: AppColors.textDisabled,
          elevation: AppSpacing.elevation0,
        );
      case ButtonVariant.text:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.primary,
          disabledBackground: Colors.transparent,
          disabledForeground: AppColors.textDisabled,
          elevation: AppSpacing.elevation0,
        );
      case ButtonVariant.danger:
        return _ButtonColors(
          background: AppColors.error,
          foreground: AppColors.white,
          disabledBackground: AppColors.textDisabled,
          disabledForeground: AppColors.white,
          elevation: AppSpacing.elevation4,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case ButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case ButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.labelMedium;
      case ButtonSize.medium:
        return AppTypography.labelLarge;
      case ButtonSize.large:
        return AppTypography.titleMedium;
    }
  }

  Size _getMinimumSize() {
    final height = switch (size) {
      ButtonSize.small => 36.0,
      ButtonSize.medium => AppSpacing.minTouchTarget,
      ButtonSize.large =>
        variant == ButtonVariant.danger ? AppSpacing.emergencyButtonSize : 52.0,
    };

    return Size.fromHeight(height);
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 20.0;
      case ButtonSize.large:
        return 24.0;
    }
  }

  Color _getLoadingColor() {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.danger:
        return AppColors.white;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return AppColors.primary;
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color? border;
  final double elevation;

  _ButtonColors({
    required this.background,
    required this.foreground,
    required this.disabledBackground,
    required this.disabledForeground,
    this.border,
    required this.elevation,
  });
}
