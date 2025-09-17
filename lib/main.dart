import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const FDistroPickApp());
}

class FDistroPickApp extends StatelessWidget {
  const FDistroPickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.DistroPick',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.orange,
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// -------------------- WELCOME --------------------
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GlassCard(
          question: "🎉 Welcome to f.DistroPick!\n\nLet’s find the perfect Linux distro for you.",
          options: const ["START"],
          onOptionSelected: (opt) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuestionScreen()),
            );
          },
        ),
      ),
    );
  }
}

// -------------------- QUESTIONS --------------------
class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentQuestion = 0;

  final List<Map<String, dynamic>> questions = [
    {
      "q": "Q1: What is your Linux experience level?",
      "options": ["👶 Beginner", "⚡ Intermediate", "🧙 Expert"],
      "help": "Beginner → You are new to Linux.\nIntermediate → Some experience.\nExpert → You know your way around."
    },
    {
      "q": "Q2: What will you use Linux for?",
      "options": ["🎮 Gaming", "👨‍💻 Coding", "🌐 Server", "💻 Everyday use", "🖥️ Old hardware"],
      "help": "Gaming → Optimized for drivers, Steam.\nCoding → IDEs, compilers, dev tools.\nServer → Security, stability.\nEveryday → Easy and preinstalled apps.\nOld hardware → Lightweight distros."
    },
    {
      "q": "Q3: Do you prefer stability or the latest software?",
      "options": ["🛡️ Stable & Reliable", "🚀 Rolling Release"],
      "help": "Stable → Tested software, fewer bugs.\nRolling → Always up-to-date, risk of breakage."
    },
    {
      "q": "Q4: Are you okay with proprietary drivers/software?",
      "options": ["✅ Yes, I don’t mind", "🐧 No, only FLOSS"],
      "help": "Proprietary → Closed drivers/software.\nFLOSS → Strictly free and open source."
    },
    {
      "q": "Q5: What desktop experience do you prefer?",
      "options": ["🖼️ Classic (Windows-like)", "🌈 Modern & Simple", "🪶 Lightweight", "⌨️ Tiling (Power Users)"],
      "help": "Classic → KDE, Cinnamon, XFCE.\nModern → GNOME, Budgie, COSMIC.\nLightweight → LXQt, Openbox.\nTiling → i3, sway, bspwm."
    },
  ];

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var q = questions[currentQuestion];
    return Scaffold(
      body: Center(
        child: GlassCard(
          question: q["q"],
          options: List<String>.from(q["options"]),
          helpText: q["help"],
          onOptionSelected: (opt) {
            nextQuestion();
          },
        ),
      ),
    );
  }
}

// -------------------- RESULTS --------------------
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GlassCard(
          question: "🎯 Based on your answers, we recommend:\n\n🔥 Linux Mint Cinnamon\n\nBeginner-friendly • Stable • Classic desktop",
          options: const ["Download", "Compare Distros", "Surprise Me 🎲"],
          onOptionSelected: (opt) {},
        ),
      ),
    );
  }
}

// -------------------- GLASS CARD --------------------
class GlassCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? helpText;
  final void Function(String) onOptionSelected;

  const GlassCard({
    super.key,
    required this.question,
    required this.options,
    required this.onOptionSelected,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (helpText != null)
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white70),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.black87,
                            title: const Text("ℹ️ Help", style: TextStyle(color: Colors.white)),
                            content: Text(helpText!, style: const TextStyle(color: Colors.white70)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close", style: TextStyle(color: Colors.orange)),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ...options.map(
                (opt) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.25),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => onOptionSelected(opt),
                    child: Text(opt, textAlign: TextAlign.center),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
