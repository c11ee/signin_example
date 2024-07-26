# 描述

web端

1. 路由配置
```Dart
return MaterialApp(routes: {
    "/": (context) => const SignUpScreen(),
    "/welcome": (context) => const WelcomeScreen()
})
```
2. 表单和文本输入
- `TextEditingController`: 用于管理和监听文本输入字段的内容
```Dart
final _firstNameTextController = TextEditingController();
final _lastNameTextController = TextEditingController();
final _usernameTextController = TextEditingController();
```
3. 动画
- `AnimationController`: 控制动画的时长和同步
- `TweenSequence` 和 `ColorTween`: 定义颜色渐变动画
- `CurveTween`: 应用动画曲线，使动画效果更平滑
- `AnimatedBuilder`: 用于监听动画控制器并重建部件以反映动画的变化