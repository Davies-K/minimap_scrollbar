import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/htmlbars.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/css.dart';
import 'package:minimap_scrollbar/minimap_scrollbar.dart';

class CodeEditorFile {
  final String name;
  final String content;
  final String? parent;
  final bool isFolder;
  final List<String> children;
  final String language;

  CodeEditorFile({
    required this.name,
    this.content = '',
    this.parent,
    this.isFolder = false,
    this.children = const [],
    this.language = 'dart',
  });
}

class CodeEditor extends StatefulWidget {
  const CodeEditor({super.key});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  CodeController? _codeController;
  final Map<String, CodeEditorFile> files = {
    'lib': CodeEditorFile(
      name: 'lib',
      isFolder: true,
      children: ['main.dart', 'home_page.dart'],
    ),
    'web': CodeEditorFile(
      name: 'web',
      isFolder: true,
      children: ['styles.css', 'index.html', 'script.js'],
    ),
    'main.dart': CodeEditorFile(
      name: 'main.dart',
      content: '''void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}''',
      parent: 'lib',
      language: 'dart',
    ),
    'home_page.dart': CodeEditorFile(
      name: 'home_page.dart',
      content: '''class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}''',
      parent: 'lib',
      language: 'dart',
    ),
    'styles.css': CodeEditorFile(
      name: 'styles.css',
      content: '''body {
  margin: 0;
  padding: 20px;
  font-family: Arial, sans-serif;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
}''',
      parent: 'web',
      language: 'css',
    ),
    'index.html': CodeEditorFile(
      name: 'index.html',
      content: '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Modern web application showcasing responsive design and interactive features">
    <title>Modern Web Application</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Header Section -->
    <header class="main-header">
        <nav class="navbar">
            <div class="logo">
                <img src="assets/logo.svg" alt="Company Logo" width="120" height="40">
            </div>
            <ul class="nav-links">
                <li><a href="#home" class="active">Home</a></li>
                <li><a href="#features">Features</a></li>
                <li><a href="#pricing">Pricing</a></li>
                <li><a href="#about">About</a></li>
                <li><a href="#contact">Contact</a></li>
            </ul>
            <div class="auth-buttons">
                <button class="btn btn-login">Log In</button>
                <button class="btn btn-signup">Sign Up</button>
            </div>
            <button class="mobile-menu-toggle">
                <span class="hamburger"></span>
            </button>
        </nav>
    </header>

    <!-- Hero Section -->
    <section id="home" class="hero">
        <div class="container">
            <div class="hero-content">
                <h1>Transform Your Digital Experience</h1>
                <p class="hero-description">
                    Discover a new way to manage your digital presence with our innovative platform.
                    Built for modern businesses, designed for success.
                </p>
                <div class="cta-buttons">
                    <button class="btn btn-primary">Get Started</button>
                    <button class="btn btn-secondary">Watch Demo</button>
                </div>
            </div>
            <div class="hero-image">
                <img src="assets/hero-image.png" alt="Platform Preview" loading="lazy">
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features">
        <div class="container">
            <h2>Key Features</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <i class="fas fa-rocket"></i>
                    <h3>Lightning Fast</h3>
                    <p>Optimized performance for seamless user experience</p>
                </div>
                <div class="feature-card">
                    <i class="fas fa-shield-alt"></i>
                    <h3>Secure</h3>
                    <p>Enterprise-grade security for your peace of mind</p>
                </div>
                <div class="feature-card">
                    <i class="fas fa-sync"></i>
                    <h3>Real-time Updates</h3>
                    <p>Stay synchronized across all your devices</p>
                </div>
                <div class="feature-card">
                    <i class="fas fa-chart-line"></i>
                    <h3>Analytics</h3>
                    <p>Comprehensive insights into your performance</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Pricing Section -->
    <section id="pricing" class="pricing">
        <div class="container">
            <h2>Flexible Pricing Plans</h2>
            <div class="pricing-grid">
                <div class="pricing-card starter">
                    <h3>Starter</h3>
                    <div class="price">\$29<span>/month</span></div>
                    <ul class="features-list">
                        <li><i class="fas fa-check"></i> Basic Features</li>
                        <li><i class="fas fa-check"></i> 5 Team Members</li>
                        <li><i class="fas fa-check"></i> 10GB Storage</li>
                        <li><i class="fas fa-check"></i> Basic Support</li>
                    </ul>
                    <button class="btn btn-outline">Choose Plan</button>
                </div>
                <div class="pricing-card professional">
                    <div class="popular-tag">Most Popular</div>
                    <h3>Professional</h3>
                    <div class="price">\$99<span>/month</span></div>
                    <ul class="features-list">
                        <li><i class="fas fa-check"></i> Advanced Features</li>
                        <li><i class="fas fa-check"></i> Unlimited Team Members</li>
                        <li><i class="fas fa-check"></i> 100GB Storage</li>
                        <li><i class="fas fa-check"></i> Priority Support</li>
                    </ul>
                    <button class="btn btn-primary">Choose Plan</button>
                </div>
                <div class="pricing-card enterprise">
                    <h3>Enterprise</h3>
                    <div class="price">Custom</div>
                    <ul class="features-list">
                        <li><i class="fas fa-check"></i> Custom Features</li>
                        <li><i class="fas fa-check"></i> Unlimited Everything</li>
                        <li><i class="fas fa-check"></i> 1TB Storage</li>
                        <li><i class="fas fa-check"></i> 24/7 Support</li>
                    </ul>
                    <button class="btn btn-outline">Contact Sales</button>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonials">
        <div class="container">
            <h2>What Our Clients Say</h2>
            <div class="testimonials-slider">
                <div class="testimonial-card">
                    <div class="quote">
                        <i class="fas fa-quote-left"></i>
                        <p>"This platform has transformed how we manage our digital presence. Couldn't be happier!"</p>
                    </div>
                    <div class="author">
                        <img src="assets/testimonial-1.jpg" alt="Sarah Johnson" class="author-image">
                        <div class="author-info">
                            <h4>Sarah Johnson</h4>
                            <p>CEO, TechStart</p>
                        </div>
                    </div>
                </div>
                <!-- More testimonials... -->
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="contact">
        <div class="container">
            <h2>Get in Touch</h2>
            <div class="contact-grid">
                <div class="contact-form">
                    <form id="contactForm">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        <div class="form-group">
                            <label for="message">Message</label>
                            <textarea id="message" name="message" rows="5" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Send Message</button>
                    </form>
                </div>
                <div class="contact-info">
                    <div class="info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <p>123 Business Street<br>San Francisco, CA 94111</p>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-phone"></i>
                        <p>+1 (555) 123-4567</p>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <p>contact@example.com</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="main-footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <h4>Company</h4>
                    <ul>
                        <li><a href="#about">About Us</a></li>
                        <li><a href="#careers">Careers</a></li>
                        <li><a href="#blog">Blog</a></li>
                        <li><a href="#press">Press</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Resources</h4>
                    <ul>
                        <li><a href="#docs">Documentation</a></li>
                        <li><a href="#support">Support</a></li>
                        <li><a href="#tutorials">Tutorials</a></li>
                        <li><a href="#api">API</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Legal</h4>
                    <ul>
                        <li><a href="#privacy">Privacy Policy</a></li>
                        <li><a href="#terms">Terms of Service</a></li>
                        <li><a href="#security">Security</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Connect</h4>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                        <a href="#"><i class="fab fa-github"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                    </div>
                    <div class="newsletter">
                        <h4>Subscribe to Our Newsletter</h4>
                        <form class="newsletter-form">
                            <input type="email" placeholder="Enter your email">
                            <button type="submit" class="btn btn-primary">Subscribe</button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Your Company. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="script.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
</body>
</html>''',
      parent: 'web',
      language: 'html',
    ),
    'script.js': CodeEditorFile(
      name: 'script.js',
      content: '''document.addEventListener('DOMContentLoaded', function() {
    console.log('Page loaded!');
});''',
      parent: 'web',
      language: 'javascript',
    ),
  };

  String? selectedFile;
  bool showFileExplorer = true;

  Widget _buildFileExplorer() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          right: BorderSide(
            color: Colors.grey[850]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[850],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EXPLORER',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      showFileExplorer = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildFileTree(''),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTree(String? parent) {
    final items = files.values.where((file) => file.parent == parent).toList()
      ..sort((a, b) {
        if (a.isFolder && !b.isFolder) return -1;
        if (!a.isFolder && b.isFolder) return 1;
        return a.name.compareTo(b.name);
      });

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final file = items[index];
        return _buildFileItem(file);
      },
    );
  }

  Widget _buildFileItem(CodeEditorFile file) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (!file.isFolder) {
              setState(() {
                selectedFile = file.name;
                _updateCodeController(file.name);
              });
            }
          },
          child: Container(
            color: selectedFile == file.name
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent,
            padding: EdgeInsets.only(
              left: file.parent == null ? 8.0 : 24.0,
              right: 8.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: Row(
              children: [
                if (file.isFolder)
                  const Icon(
                    Icons.folder,
                    size: 16,
                    color: Colors.amber,
                  )
                else
                  const Icon(
                    Icons.description,
                    size: 16,
                    color: Colors.blue,
                  ),
                const SizedBox(width: 8),
                Text(
                  file.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (file.isFolder)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: _buildFileTree(file.name),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeLanguages();
    selectedFile = 'index.html';
    _updateCodeController(selectedFile);
  }

  void _initializeLanguages() {
    // Register languages
    highlight.registerLanguage('dart', dart);
    highlight.registerLanguage('javascript', javascript);
    highlight.registerLanguage('css', css);
    highlight.registerLanguage('html', htmlbars);
    highlight.registerLanguage('python', python);
  }

  void _updateCodeController(String? fileName) {
    if (_codeController != null) {
      _codeController!.dispose();
    }

    if (fileName != null && files.containsKey(fileName)) {
      final file = files[fileName]!;
      Mode? languageMode;

      switch (file.language) {
        case 'dart':
          languageMode = dart;
          break;
        case 'javascript':
          languageMode = javascript;
          break;
        case 'css':
          languageMode = css;
          break;
        case 'html':
          languageMode = htmlbars;
          break;
        case 'python':
          languageMode = python;
          break;
        default:
          languageMode = dart;
      }

      setState(() {
        _codeController = CodeController(
          text: file.content,
          language: languageMode,
          params: const EditorParams(
            tabSpaces: 2,
          ),
        );
      });
    }
  }

  Widget _buildEditor() {
    if (selectedFile == null) {
      return const Expanded(
        child: Center(
          child: Text(
            'Select a file to edit',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final currentFile = files[selectedFile]!;
    _updateCodeController(selectedFile);

    return Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                currentFile.name,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                currentFile.language.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: MinimapScrollbarWidget(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF272822),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _codeController != null
                    ? CodeField(
                        controller: _codeController!,
                        textStyle: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                        lineNumberStyle: LineNumberStyle(
                          textStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mini Code Editor',
          style: GoogleFonts.lato(fontSize: 18),
        ),
        actions: [
          if (!showFileExplorer)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  showFileExplorer = true;
                });
              },
            ),
        ],
      ),
      body: Row(
        children: [
          if (showFileExplorer) _buildFileExplorer(),
          Expanded(child: _buildEditor()),
        ],
      ),
    );
  }
}
