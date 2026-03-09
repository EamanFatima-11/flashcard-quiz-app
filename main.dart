import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FlashMind Quiz",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const FlashcardHome(),
    );
  }
}

// ─── Model ───────────────────────────────────────────────────────────────────

class Flashcard {
  String question;
  String answer;
  String category;
  bool isKnown;

  Flashcard(this.question, this.answer,
      {this.category = 'General', this.isKnown = false});
}

// ─── Home Screen ─────────────────────────────────────────────────────────────

class FlashcardHome extends StatefulWidget {
  const FlashcardHome({super.key});

  @override
  State<FlashcardHome> createState() => _FlashcardHomeState();
}

class _FlashcardHomeState extends State<FlashcardHome>
    with TickerProviderStateMixin {
  // ── Data ──────────────────────────────────────────────────────────────────

  List<Flashcard> cards = [
    // Web Basics
    Flashcard("What does HTML stand for?",
        "HyperText Markup Language — the standard language for creating web pages.",
        category: "Web Basics"),
    Flashcard("What is CSS used for?",
        "Cascading Style Sheets — controls the visual presentation (layout, colors, fonts) of HTML elements.",
        category: "Web Basics"),
    Flashcard("What is JavaScript?",
        "A high-level, interpreted scripting language that makes web pages interactive and dynamic.",
        category: "Web Basics"),
    Flashcard("What is a URL?",
        "Uniform Resource Locator — the address used to access a resource on the internet.",
        category: "Web Basics"),
    Flashcard("What is HTTP?",
        "HyperText Transfer Protocol — the foundation of data communication on the World Wide Web.",
        category: "Web Basics"),
    Flashcard("What is a web browser?",
        "Software that retrieves and displays web pages (e.g. Chrome, Firefox, Safari).",
        category: "Web Basics"),

    // Programming Concepts
    Flashcard("What is a variable?",
        "A named container in memory used to store and reference data values.",
        category: "Programming"),
    Flashcard("What is a function?",
        "A reusable block of code designed to perform a specific task when called.",
        category: "Programming"),
    Flashcard("What is an algorithm?",
        "A step-by-step set of instructions designed to solve a problem or complete a task.",
        category: "Programming"),
    Flashcard("What is OOP?",
        "Object-Oriented Programming — a paradigm that organizes code into objects containing data (attributes) and behavior (methods).",
        category: "Programming"),
    Flashcard("What is a loop?",
        "A control structure that repeats a block of code until a specified condition is met.",
        category: "Programming"),
    Flashcard("What is a null value?",
        "A special value representing the intentional absence of any object or data.",
        category: "Programming"),
    Flashcard("What is recursion?",
        "A technique where a function calls itself to solve smaller instances of the same problem.",
        category: "Programming"),
    Flashcard("What is debugging?",
        "The process of identifying, analyzing, and fixing errors (bugs) in code.",
        category: "Programming"),

    // Data Structures
    Flashcard("What is an array?",
        "A data structure that stores a collection of elements at contiguous memory locations.",
        category: "Data Structures"),
    Flashcard("What is a stack?",
        "A LIFO (Last-In-First-Out) data structure where elements are added and removed from the top.",
        category: "Data Structures"),
    Flashcard("What is a queue?",
        "A FIFO (First-In-First-Out) data structure where elements are added at the back and removed from the front.",
        category: "Data Structures"),
    Flashcard("What is a linked list?",
        "A linear data structure where each element (node) contains data and a reference to the next node.",
        category: "Data Structures"),
    Flashcard("What is a hash table?",
        "A data structure that maps keys to values using a hash function for fast lookups.",
        category: "Data Structures"),
    Flashcard("What is a binary tree?",
        "A hierarchical data structure where each node has at most two children: left and right.",
        category: "Data Structures"),

    // Networking
    Flashcard("What is an IP address?",
        "A unique numerical label assigned to each device connected to a computer network.",
        category: "Networking"),
    Flashcard("What is DNS?",
        "Domain Name System — translates human-readable domain names (google.com) into IP addresses.",
        category: "Networking"),
    Flashcard("What is a protocol?",
        "A set of rules that define how data is transmitted and received over a network.",
        category: "Networking"),
    Flashcard("What is a firewall?",
        "A network security system that monitors and controls incoming and outgoing network traffic.",
        category: "Networking"),

    // Databases
    Flashcard("What is SQL?",
        "Structured Query Language — used to manage and manipulate relational databases.",
        category: "Databases"),
    Flashcard("What is a primary key?",
        "A column (or set of columns) in a database table that uniquely identifies each row.",
        category: "Databases"),
    Flashcard("What is a JOIN in SQL?",
        "A clause used to combine rows from two or more tables based on a related column.",
        category: "Databases"),
    Flashcard("What is indexing in databases?",
        "A technique to speed up data retrieval by creating a data structure (index) on table columns.",
        category: "Databases"),

    // Flutter/Dart
    Flashcard("What is Flutter?",
        "Google's open-source UI toolkit for building natively compiled apps for mobile, web, and desktop from a single codebase.",
        category: "Flutter/Dart"),
    Flashcard("What is a Widget in Flutter?",
        "The basic building block of Flutter UI — everything visible on screen is a widget.",
        category: "Flutter/Dart"),
    Flashcard("What is setState() in Flutter?",
        "A method that notifies the framework that the internal state of a StatefulWidget has changed, triggering a rebuild.",
        category: "Flutter/Dart"),
    Flashcard("What is the difference between StatelessWidget and StatefulWidget?",
        "StatelessWidget has no mutable state (UI never changes). StatefulWidget holds state that can change over time.",
        category: "Flutter/Dart"),
  ];

  List<Flashcard> get filteredCards => selectedCategory == 'All'
      ? cards
      : cards.where((c) => c.category == selectedCategory).toList();

  /// Always returns a valid index for filteredCards (never out of bounds)
  int get safeIndex {
    final fc = filteredCards;
    if (fc.isEmpty) return 0;
    return currentIndex.clamp(0, fc.length - 1);
  }

  List<String> get categories {
    final seen = <String>{};
    final cats = <String>[];
    for (final c in cards) {
      if (seen.add(c.category)) cats.add(c.category);
    }
    cats.sort();
    return <String>['All', ...cats];
  }

  String selectedCategory = 'All';
  int currentIndex = 0;
  bool showAnswer = false;
  bool isShuffled = false;

  late AnimationController flipController;
  late AnimationController slideController;
  late Animation<double> slideAnimation;

  // ── Init / Dispose ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    flipController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: slideController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    flipController.dispose();
    slideController.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void flipCard() {
    setState(() => showAnswer = !showAnswer);
    showAnswer ? flipController.forward() : flipController.reverse();
  }

  void _goTo(int index) {
    setState(() {
      currentIndex = index;
      showAnswer = false;
      flipController.reset();
    });
    slideController.forward(from: 0);
  }

  void nextCard() {
    if (safeIndex < filteredCards.length - 1) _goTo(safeIndex + 1);
  }

  void prevCard() {
    if (safeIndex > 0) _goTo(safeIndex - 1);
  }

  void toggleKnown() {
    if (filteredCards.isEmpty) return;
    final card = filteredCards[safeIndex];
    final globalIndex = cards.indexOf(card);
    if (globalIndex < 0) return;
    final nowKnown = !cards[globalIndex].isKnown;
    setState(() => cards[globalIndex].isKnown = nowKnown);
    _showSnack(nowKnown ? "✅ Marked as Known!" : "📚 Moved back to Study");
  }

  void shuffleCards() {
    setState(() {
      cards.shuffle(Random());
      currentIndex = 0;
      showAnswer = false;
      flipController.reset();
      isShuffled = true;
    });
    _showSnack("🔀 Cards shuffled!");
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF6C63FF),
      ),
    );
  }

  void deleteCard() {
    if (cards.isEmpty || filteredCards.isEmpty) return;
    final card = filteredCards[safeIndex];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Card?",
            style: TextStyle(color: Colors.white)),
        content: const Text("This action cannot be undone.",
            style: TextStyle(color: Colors.white60)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cards.remove(card);
                if (currentIndex >= filteredCards.length && currentIndex > 0) {
                  currentIndex--;
                }
                showAnswer = false;
                flipController.reset();
              });
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Fixed list of allowed categories — used by both dialog and validation
  static const List<String> _allCategories = [
    'General',
    'Web Basics',
    'Programming',
    'Data Structures',
    'Networking',
    'Databases',
    'Flutter/Dart',
  ];

  void openCardDialog({bool isEdit = false}) {
    final qCtrl = TextEditingController();
    final aCtrl = TextEditingController();

    // Always pick a value that exists in _allCategories to avoid null mismatch
    String _safeCategory(String cat) =>
        _allCategories.contains(cat) ? cat : 'General';

    String dialogCategory = _safeCategory(
      selectedCategory == 'All' ? 'General' : selectedCategory,
    );

    if (isEdit && filteredCards.isNotEmpty) {
      final card = filteredCards[safeIndex];
      qCtrl.text = card.question;
      aCtrl.text = card.answer;
      dialogCategory = _safeCategory(card.category);
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E2E),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text(
              isEdit ? "✏️ Edit Flashcard" : "➕ New Flashcard",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField(qCtrl, "Question", Icons.help_outline),
                  const SizedBox(height: 12),
                  _dialogField(aCtrl, "Answer", Icons.lightbulb_outline),
                  const SizedBox(height: 12),
                  // ── Category Dropdown (null-safe) ──────────────────────
                  Theme(
                    data: Theme.of(ctx).copyWith(
                      canvasColor: const Color(0xFF2A2A3E),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: dialogCategory,
                      dropdownColor: const Color(0xFF2A2A3E),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: "Category",
                        labelStyle: const TextStyle(color: Colors.white60),
                        filled: true,
                        fillColor: const Color(0xFF2A2A3E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      items: _allCategories.map((String cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(
                            cat,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null &&
                            _allCategories.contains(newValue)) {
                          setDState(() => dialogCategory = newValue);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white60)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  final q = qCtrl.text.trim();
                  final a = aCtrl.text.trim();
                  if (q.isEmpty || a.isEmpty) return;

                  setState(() {
                    if (isEdit && filteredCards.isNotEmpty) {
                      final card = filteredCards[safeIndex];
                      final gi = cards.indexOf(card);
                      if (gi >= 0) {
                        cards[gi] =
                            Flashcard(q, a, category: dialogCategory);
                      }
                    } else {
                      cards.add(Flashcard(q, a, category: dialogCategory));
                      if (selectedCategory == dialogCategory ||
                          selectedCategory == 'All') {
                        currentIndex = filteredCards.length - 1;
                      }
                    }
                  });
                  Navigator.pop(ctx);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _dialogField(
      TextEditingController ctrl, String label, IconData icon) {
    return TextField(
      controller: ctrl,
      maxLines: label == "Answer" ? 3 : 1,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF2A2A3E),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final fc = filteredCards;
    final knownCount = cards.where((c) => c.isKnown).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "⚡ FlashMind",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle,
                color: isShuffled ? const Color(0xFF6C63FF) : Colors.white54),
            onPressed: shuffleCards,
            tooltip: "Shuffle",
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openCardDialog(),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Add Card"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      body: Column(
        children: [
          // ── Stats Bar ────────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statChip("📚 Total", "${cards.length}", Colors.white70),
                _statChip("✅ Known", "$knownCount", Colors.greenAccent),
                _statChip(
                    "🔥 Left",
                    "${cards.length - knownCount}",
                    Colors.orangeAccent),
              ],
            ),
          ),

          // ── Category Filter ───────────────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final List<String> catList = categories;
                final String cat = catList[i];
                final selected = cat == selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedCategory = cat;
                    currentIndex = 0;
                    showAnswer = false;
                    flipController.reset();
                    isShuffled = false;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF6C63FF)
                            : Colors.white24,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white60,
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Progress Bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: fc.isEmpty ? 0 : (safeIndex + 1) / fc.length,
                    minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF6C63FF)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${fc.isEmpty ? 0 : safeIndex + 1} / ${fc.length}  •  ${fc.isEmpty ? '' : fc[safeIndex].category}",
                  style:
                      const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Flashcard ─────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: fc.isEmpty
                  ? _emptyState()
                  : GestureDetector(
                      onTap: flipCard,
                      onHorizontalDragEnd: (d) {
                        final v = d.primaryVelocity ?? 0;
                        if (v < -200) nextCard();
                        if (v > 200) prevCard();
                      },
                      child: AnimatedBuilder(
                        animation: flipController,
                        builder: (_, __) {
                          final angle = flipController.value * pi;
                          final isFront = angle < pi / 2;

                          return Transform(
                            transform: Matrix4.rotationY(angle),
                            alignment: Alignment.center,
                            child: isFront
                                ? _cardFace(
                                    fc[safeIndex].question,
                                    isFront: true,
                                    isKnown: fc[safeIndex].isKnown,
                                  )
                                : Transform(
                                    transform: Matrix4.rotationY(pi),
                                    alignment: Alignment.center,
                                    child: _cardFace(
                                      fc[safeIndex].answer,
                                      isFront: false,
                                      isKnown: fc[safeIndex].isKnown,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
            ),
          ),

          // ── Controls ──────────────────────────────────────────────────────
          if (fc.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _navBtn(Icons.arrow_back_ios_rounded,
                      safeIndex > 0 ? prevCard : null),
                  // Action buttons
                  Row(
                    children: [
                      _actionBtn(
                        Icons.check_circle_outline,
                        fc[safeIndex].isKnown
                            ? Colors.greenAccent
                            : Colors.white38,
                        toggleKnown,
                        tooltip: "Mark Known",
                      ),
                      const SizedBox(width: 8),
                      _actionBtn(Icons.edit_outlined, Colors.blueAccent,
                          () => openCardDialog(isEdit: true),
                          tooltip: "Edit"),
                      const SizedBox(width: 8),
                      _actionBtn(
                          Icons.delete_outline, Colors.redAccent, deleteCard,
                          tooltip: "Delete"),
                    ],
                  ),
                  _navBtn(Icons.arrow_forward_ios_rounded,
                      safeIndex < fc.length - 1 ? nextCard : null),
                ],
              ),
            ),

            // Tap hint
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Text(
                showAnswer ? "Tap card to see question" : "Tap card to reveal answer  •  Swipe to navigate",
                style: const TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ),
          ] else
            const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────────────────────

  Widget _cardFace(String text,
      {required bool isFront, required bool isKnown}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isFront
            ? const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF1A1A3E), Color(0xFF2D2B55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        border: isKnown
            ? Border.all(color: Colors.greenAccent, width: 2)
            : Border.all(color: Colors.white12, width: 1),
        boxShadow: [
          BoxShadow(
            color: isFront
                ? const Color(0xFF6C63FF).withOpacity(0.4)
                : Colors.black45,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          // Label
          Positioned(
            top: 20,
            left: 24,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isFront ? "❓ QUESTION" : "💡 ANSWER",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          if (isKnown)
            const Positioned(
              top: 20,
              right: 20,
              child: Text("✅", style: TextStyle(fontSize: 18)),
            ),
          // Content
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isFront ? 22 : 18,
                  color: Colors.white,
                  fontWeight:
                      isFront ? FontWeight.bold : FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("📭", style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text(
            "No cards in this category",
            style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the button below to add one!",
            style: TextStyle(color: Colors.white30, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _navBtn(IconData icon, VoidCallback? onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null
            ? const Color(0xFF1A1A2E)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: onPressed != null ? Colors.white24 : Colors.transparent),
      ),
      child: IconButton(
        icon: Icon(icon,
            color: onPressed != null ? Colors.white70 : Colors.white24),
        onPressed: onPressed,
        iconSize: 24,
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onPressed,
      {String tooltip = ''}) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
          iconSize: 22,
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        ),
      ),
    );
  }
}