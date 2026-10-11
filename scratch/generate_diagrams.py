import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

os.makedirs('assets/screenshots', exist_ok=True)

def generate_architecture_diagram():
    fig, ax = plt.subplots(figsize=(10, 6), dpi=300)
    fig.patch.set_facecolor('#0B0F19')
    ax.set_facecolor('#0B0F19')
    ax.axis('off')

    # Title
    ax.text(5, 5.7, "STUDENT PROFILE APP - LAYERED ARCHITECTURE", 
            ha='center', va='center', color='#FFFFFF', fontsize=14, fontweight='bold', family='sans-serif')
    ax.text(5, 5.4, "Devixo Solutions Internship • Clean Layered Separation of Concerns", 
            ha='center', va='center', color='#94A3B8', fontsize=10, family='sans-serif')

    layers = [
        ("Presentation Layer (Flutter UI & Widgets)", 
         "#6366F1", 4.2, 
         ["Screens: Splash, Home, Profile, Skills, Education, Projects, Contact, Analytics",
          "Widgets: AnimatedBottomNav, AppNavigationDrawer, QuickNavGrid, GlassCard, RainbowBorder",
          "Design Tokens: SpaceGrotesk Font, Aurora Color System, Adaptive Responsive Layouts"]),
        
        ("State Management & Business Logic (Provider)", 
         "#3B82F6", 2.9, 
         ["ProfileController: Academic/Student State, Bi-directional updates, Offline Cache Sync",
          "ThemeProvider: Dynamic Aurora Dark/Light Theme Switching",
          "AuthService: Biometric Authentication, Session Management & Password Reset",
          "RemoteConfigService: Dynamic Feature Flags & Feature Toggles"]),
        
        ("Data & Persistence Layer", 
         "#10B981", 1.6, 
         ["Mock Data Store: Curated Profile, Education Timeline, Projects, Skills Catalog",
          "SQLite Database (sqflite): Offline Local Cache for Instant Resilient Access",
          "SharedPreferences & SecureStorage: Biometrics, Credentials & Preferences"]),
        
        ("Hardware & Platform Integration Services", 
         "#F59E0B", 0.3, 
         ["url_launcher: Email (mailto:), Phone (tel:), Web Portfolio & Google Maps Geo-intent",
          "pdf & printing: Customized PDF Resume & Portfolio Generation",
          "local_auth: Biometric Fingerprint / Face Unlock",
          "flutter_local_notifications: Internship Task & Reminder Alerts"])
    ]

    for title, color, y, items in layers:
        rect = patches.FancyBboxPatch((0.5, y), 9.0, 1.05,
                                      boxstyle="round,pad=0.08,rounding_size=0.15",
                                      facecolor='#1E293B', edgecolor=color, linewidth=2)
        ax.add_patch(rect)
        
        # Layer Header badge
        badge = patches.FancyBboxPatch((0.7, y + 0.8), 4.2, 0.22,
                                       boxstyle="round,pad=0.04,rounding_size=0.06",
                                       facecolor=color, edgecolor='none')
        ax.add_patch(badge)
        ax.text(0.8, y + 0.91, title, color='#FFFFFF', fontsize=9, fontweight='bold', va='center')

        # Item bullets
        item_y = y + 0.65
        for item in items:
            ax.text(0.9, item_y, f"•  {item}", color='#E2E8F0', fontsize=7.5, va='center')
            item_y -= 0.22

    # Draw connection arrows
    for y_arrow in [4.2, 2.9, 1.6]:
        ax.annotate('', xy=(5, y_arrow - 0.05), xytext=(5, y_arrow),
                    arrowprops=dict(arrowstyle="->", color="#94A3B8", lw=1.5))

    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    plt.tight_layout()
    output_path = 'assets/screenshots/architecture_diagram.png'
    plt.savefig(output_path, bbox_inches='tight', facecolor=fig.get_facecolor(), dpi=300)
    plt.close()
    print(f"Generated {output_path}")

def generate_navigation_diagram():
    fig, ax = plt.subplots(figsize=(10, 5.5), dpi=300)
    fig.patch.set_facecolor('#0B0F19')
    ax.set_facecolor('#0B0F19')
    ax.axis('off')

    ax.text(5, 5.2, "APP NAVIGATION ARCHITECTURE & ROUTING GRAPH", 
            ha='center', va='center', color='#FFFFFF', fontsize=14, fontweight='bold')
    ax.text(5, 4.9, "Declarative GoRouter Routes • Multi-Modal Navigation Pattern", 
            ha='center', va='center', color='#94A3B8', fontsize=9.5)

    # Entry points
    nodes = [
        ("SplashScreen\n(/splash)", 1.2, 3.8, "#6366F1"),
        ("AuthScreen\n(/auth)", 1.2, 2.2, "#8B5CF6"),
        ("HomeScreen\n(Main Hub /)", 4.0, 3.0, "#3B82F6"),
        ("Student Profile\n(/profile)", 7.8, 4.6, "#10B981"),
        ("Skills Matrix\n(/skills)", 7.8, 3.8, "#10B981"),
        ("Education Timeline\n(/education)", 7.8, 3.0, "#10B981"),
        ("Projects Portfolio\n(/projects)", 7.8, 2.2, "#10B981"),
        ("Contact & Social\n(/contact)", 7.8, 1.4, "#10B981"),
        ("Analytics Dashboard\n(/analytics)", 7.8, 0.6, "#F59E0B"),
    ]

    for label, x, y, color in nodes:
        w = 1.8 if x != 4.0 else 2.2
        h = 0.65 if x != 4.0 else 0.85
        rect = patches.FancyBboxPatch((x - w/2, y - h/2), w, h,
                                      boxstyle="round,pad=0.05,rounding_size=0.1",
                                      facecolor='#1E293B', edgecolor=color, linewidth=2)
        ax.add_patch(rect)
        ax.text(x, y, label, ha='center', va='center', color='#FFFFFF', fontsize=8, fontweight='bold')

    # Arrows
    # Splash -> Auth -> Home
    ax.annotate('', xy=(1.2, 2.6), xytext=(1.2, 3.4), arrowprops=dict(arrowstyle="->", color="#A5B4FC", lw=1.5))
    ax.annotate('', xy=(2.9, 3.0), xytext=(2.1, 2.4), arrowprops=dict(arrowstyle="->", color="#A5B4FC", lw=1.5))
    ax.annotate('', xy=(2.9, 3.1), xytext=(2.1, 3.7), arrowprops=dict(arrowstyle="->", color="#A5B4FC", lw=1.5, ls='--'))

    # Home to Destinations
    dests = [4.6, 3.8, 3.0, 2.2, 1.4, 0.6]
    for dy in dests:
        ax.annotate('', xy=(6.9, dy), xytext=(5.1, 3.0),
                    arrowprops=dict(arrowstyle="->", color="#60A5FA", lw=1.2))

    # Legend / Annotation of Nav mechanisms
    ax.text(5.0, 4.2, "Navigation Options:\n• Bottom Navigation Bar (5 Main Tabs)\n• Navigation Drawer (All Modules & Toggles)\n• Home Quick Navigation Grid (6 Direct Cards)\n• Named Routes via GoRouter",
            ha='center', va='center', color='#CBD5E1', fontsize=8,
            bbox=dict(boxstyle="round,pad=0.4", facecolor='#0F172A', edgecolor='#334155', lw=1))

    ax.set_xlim(0, 10)
    ax.set_ylim(0, 5.5)
    plt.tight_layout()
    output_path = 'assets/screenshots/navigation_diagram.png'
    plt.savefig(output_path, bbox_inches='tight', facecolor=fig.get_facecolor(), dpi=300)
    plt.close()
    print(f"Generated {output_path}")

def generate_screen_mockups():
    # Helper to create mobile UI mockup cards
    screens = [
        ("Splash Screen", "splash_screen_mockup.png", "#4F46E5", [
            ("Header", "DEVIXO SOLUTIONS INTERNSHIP"),
            ("Logo", "[ App Logo & Branding Icon ]"),
            ("Title", "STUDENTS PROFILE"),
            ("Subtitle", "Task 01 Mobile Application"),
            ("Student", "Developed by: Abdullah Azeem"),
            ("Loader", "•••• Progress Ring ••••")
        ]),
        ("Home Screen", "home_screen_mockup.png", "#2563EB", [
            ("Header", "Home Dashboard • Aurora Theme"),
            ("Profile Header", "Abdullah Azeem • Flutter Developer"),
            ("Bio Snippet", "Passionate software engineer building cross-platform apps"),
            ("Quick Nav Grid", "[ Profile ] [ Skills ] [ Education ]"),
            ("Quick Nav Grid", "[ Projects ] [ Contact ] [ Analytics ]"),
            ("Stats Row", "GPA: 3.85 | Projects: 4+ | Skills: 9+")
        ]),
        ("Student Profile", "profile_screen_mockup.png", "#059669", [
            ("Top Card", "Abdullah Azeem (Full Name)"),
            ("Degree & Sem", "B.Sc. Software Engineering • Semester 6"),
            ("Institute", "Devixo Institute of Technology"),
            ("Bio", "Dedicated mobile developer with strong UI/UX focus"),
            ("Location", "Islamabad, Pakistan [Map Link]"),
            ("Actions", "[ Edit Profile ]  [ Export PDF Resume ]")
        ]),
        ("Skills Matrix", "skills_screen_mockup.png", "#7C3AED", [
            ("Required Skills", "Flutter (90%) • Dart (88%) • Python (82%)"),
            ("Additional Skills", "C++ (80%) • Java (78%) • Git/GitHub (86%)"),
            ("Web & Design", "JavaScript (85%) • React (80%) • Figma (84%)"),
            ("Skill Chips", "[ Mobile Dev ] [ Cross-Platform ] [ Clean Architecture ]"),
            ("UI Component", "Interactive Animated Progress Rings & Sliders")
        ]),
        ("Education Timeline", "education_screen_mockup.png", "#0284C7", [
            ("Degree Title", "Bachelor of Science in Software Engineering"),
            ("Institution", "Devixo Institute of Technology"),
            ("Start Year", "Start Year: 2021"),
            ("Expected Grad", "Expected Graduation: 2025"),
            ("Current Semester", "Current Semester: 6th Semester"),
            ("Status Badge", "Honor Roll • Dean's List Awardee")
        ]),
        ("Projects Portfolio", "projects_screen_mockup.png", "#D97706", [
            ("Project 1", "Students Profile App (Flutter, Dart, Provider)"),
            ("Project 2", "E-Commerce Mobile Store (Flutter, Firebase, Stripe)"),
            ("Project 3", "AI Smart Task & Notes Organizer (Flutter, Gemini AI)"),
            ("Project 4", "Devixo Campus Event Tracker (Flutter, Supabase)"),
            ("Action Buttons", "[ GitHub Code Link ]  [ Live Demo Video ]")
        ]),
        ("Contact & Social", "contact_screen_mockup.png", "#DC2626", [
            ("Email", "abdullah.azeem@devixo.com [Tap to Compose]"),
            ("Phone", "+92 300 1234567 [Tap to Dial]"),
            ("Location", "Islamabad, Pakistan [Open in Google Maps]"),
            ("GitHub", "https://github.com/abdullahazeem [Interactive]"),
            ("LinkedIn", "https://linkedin.com/in/abdullahazeem [Interactive]"),
            ("Portfolio", "https://abdullahazeem.dev [Interactive]")
        ]),
        ("Navigation Options", "navigation_options_mockup.png", "#4338CA", [
            ("Bottom Bar", "5 Main Tabs: Home, Profile, Skills, Projects, Contact"),
            ("Drawer Menu", "Drawer: Full Navigation, Education, Analytics, Theme"),
            ("Home Grid", "6 Prominent Quick-Action Cards on Home Screen"),
            ("Named Routing", "GoRouter Declarative URLs & Back Stack Handling"),
            ("Theme Toggle", "Aurora Dark Mode / Clean Light Mode Switching")
        ])
    ]

    for title, filename, primary_color, items in screens:
        fig, ax = plt.subplots(figsize=(6, 8.5), dpi=300)
        fig.patch.set_facecolor('#0F172A')
        ax.set_facecolor('#0F172A')
        ax.axis('off')

        # Outer Mobile Phone Mockup Border
        outer_frame = patches.FancyBboxPatch((0.5, 0.5), 5.0, 7.5,
                                            boxstyle="round,pad=0.1,rounding_size=0.4",
                                            facecolor='#1E293B', edgecolor='#475569', linewidth=2.5)
        ax.add_patch(outer_frame)

        # Phone notch / Dynamic Island
        notch = patches.FancyBboxPatch((2.2, 7.6), 1.6, 0.2,
                                       boxstyle="round,pad=0.03,rounding_size=0.08",
                                       facecolor='#020617', edgecolor='none')
        ax.add_patch(notch)

        # Screen Header
        header = patches.FancyBboxPatch((0.7, 6.7), 4.6, 0.7,
                                        boxstyle="round,pad=0.05,rounding_size=0.1",
                                        facecolor=primary_color, edgecolor='none')
        ax.add_patch(header)
        ax.text(3.0, 7.05, title.upper(), ha='center', va='center',
                color='#FFFFFF', fontsize=12, fontweight='bold')

        # Screen content cards
        curr_y = 5.8
        for label, text in items:
            card = patches.FancyBboxPatch((0.75, curr_y - 0.35), 4.5, 0.65,
                                          boxstyle="round,pad=0.04,rounding_size=0.08",
                                          facecolor='#0F172A', edgecolor=primary_color, linewidth=1.2)
            ax.add_patch(card)
            ax.text(0.9, curr_y + 0.1, label, color=primary_color, fontsize=8, fontweight='bold')
            ax.text(0.9, curr_y - 0.15, text, color='#E2E8F0', fontsize=8)
            curr_y -= 0.85

        # Footer Navigation bar simulation
        nav_bg = patches.FancyBboxPatch((0.7, 0.7), 4.6, 0.5,
                                        boxstyle="round,pad=0.04,rounding_size=0.1",
                                        facecolor='#020617', edgecolor='#334155', linewidth=1)
        ax.add_patch(nav_bg)
        ax.text(3.0, 0.95, "⌂ Home    👤 Profile    ⚡ Skills    💼 Projects    ✉ Contact",
                ha='center', va='center', color='#94A3B8', fontsize=8)

        ax.set_xlim(0, 6)
        ax.set_ylim(0, 8.5)
        plt.tight_layout()
        out_path = f'assets/screenshots/{filename}'
        plt.savefig(out_path, bbox_inches='tight', facecolor=fig.get_facecolor(), dpi=300)
        plt.close()
        print(f"Generated {out_path}")

if __name__ == '__main__':
    generate_architecture_diagram()
    generate_navigation_diagram()
    generate_screen_mockups()
    print("All diagrams and screen representations generated successfully!")
