enum LottieAnimation {
  backgroundAnimation(name: 'background'),
  darkLoadingAnimation(name: 'dark_loading'),
  lightLoadingAnimation(name: 'light_loading'),
  emptyAnimation(name: 'empty'),
  errorAnimation(name: 'error'),
  smallErrorAnimation(name: 'small_error');

  final String name;
  const LottieAnimation({
    required this.name,
  });
}
