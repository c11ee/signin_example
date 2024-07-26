import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (context) => const SignUpScreen(),
      '/welcome': (context) => const WelcomeScreen()
    });
  }
}

// 表单
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: SizedBox(
            width: 400,
            child: Card(
              child: SignUpForm(),
            ),
          ),
        ));
  }
}

// 欢迎页面
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void back() {
      Navigator.pop(context);
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome!', style: Theme.of(context).textTheme.displayMedium),
            TextButton(
              onPressed: back,
              child: const Text("back"),
            )
          ],
        ),
      ),
    );
  }
}

// 有状态 Widget Form
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // 为可编辑文本字段创建一个控制器
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0.0;

  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
  }

  void _updateFormProgress() {
    double progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        // 巧妙的代码 1/3 = 0.33
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        onChanged: _updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // 0-1 进度
          AnimatedProgressIndicator(value: _formProgress),
          Text(
            "Sign up",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: "First name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: "Last name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: "Username"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.disabled)
                      ? null
                      : Colors.white;
                }), backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.disabled)
                      ? null
                      : Colors.blue;
                })),
                onPressed: _formProgress == 1 ? _showWelcomeScreen : null,
                child: const Text("Sign up")),
          )
        ]));
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    super.key,
    // 必须参数
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    // 调用父类的 `initState` 方法，确保父类的初始化逻辑被执行
    // 这个步骤非常重要，因为 `State` 类的初始化可能包含一些必要的设置
    super.initState();
    // `AnimationController` 控制动画的时长和同步
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      // `vsync` 使用 `SingleTickerProviderStateMixin` 来防止动画在
      // 不显示时消耗资源.
      vsync: this,
    );

    // `TweenSequence` 定义了颜色渐变序列
    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        // 确保每个渐变段的相对持续时间
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.yellow, end: Colors.green), weight: 1)
    ]);

    // `_colorAnimation` 和 `_curveAnimation`
    // 分别驱动颜色变化和曲线变化:
    _colorAnimation = _controller.drive(colorTween);
    // `CurveTween` 使用 `Curves.easeIn` 曲线，使动画效果更平滑
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  // `didUpdateWidget` 用于在 `AnimatedProgressIndicator` 的 `value`
  // 发生变化时更新动画
  // 每当 `value` 发生变化时，动画控制器会更新到新的进度值.
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    // `AnimatedBuilder` 用于监听动画控制器并构建 `LinearProgressIndicator`
    return AnimatedBuilder(
        // `animation` 设置为 `_controller` 使得 `LinearProgressIndicator`
        // 在动画更新时重新构建
        animation: _controller,
        builder: (context, child) => LinearProgressIndicator(
            // 控制进度值
            value: _curveAnimation.value,
            // 控制前景色和背景色
            valueColor: _colorAnimation,
            backgroundColor: _colorAnimation.value?.withOpacity(0.4)));
  }
}
