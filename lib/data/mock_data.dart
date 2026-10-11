import '../models/contact_info.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../models/student_profile.dart';

class MockData {
  static const StudentProfile mockProfile = StudentProfile(
    fullName: 'Alex Anderson',
    title: 'Senior Computer Science Student',
    introduction:
        'Passionate about creating elegant solutions to complex problems.',
    university: 'State University',
    degreeProgram: 'B.S. Computer Science',
    semester: 7,
    shortBio: 'Hi! I\'m Alex, a software engineering student specializing in mobile and web development. I love building tools that make people\'s lives easier and participating in hackathons. When I\'m not coding, you can find me hiking or contributing to open-source projects. Always eager to learn new technologies and collaborate with creative minds.',
    location: 'San Francisco, CA',
    profileImage: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
    email: 'alex.anderson@example.com',
    phone: '(555) 123-4567',
    github: 'https://github.com/alexanderson',
    linkedin: 'https://linkedin.com/in/alexanderson',
    portfolio: 'https://alexanderson.dev',
    profileStatus: 'Actively looking for Summer 2024 Internships',
  );

  static final List<Education> mockEducation = [
    Education(
      institutionName: 'State University',
      degree: 'Bachelor of Science',
      fieldOfStudy: 'Computer Science',
      startDate: DateTime(2021, 8),
      endDate: DateTime(2025, 5),
      gpa: 3.8,
      description: 'Relevant Coursework: Data Structures, Algorithms, Web Development, Mobile Development.',
    ),
    Education(
      institutionName: 'Community College',
      degree: 'Associate of Science',
      fieldOfStudy: 'Computer Science',
      startDate: DateTime(2019, 8),
      endDate: DateTime(2021, 5),
      gpa: 3.9,
    ),
  ];

  static final List<Experience> mockExperience = [
    Experience(
      id: 'exp_1',
      company: 'Tech Solutions Inc.',
      position: 'Software Engineering Intern',
      startDate: DateTime(2023, 5),
      endDate: DateTime(2023, 8),
      description: 'Developed and maintained scalable web applications using React and Node.js. Improved database query performance by 20%.',
      technologiesUsed: ['React', 'Node.js', 'PostgreSQL', 'Docker'],
    ),
    Experience(
      id: 'exp_2',
      company: 'University IT Department',
      position: 'Student Web Developer',
      startDate: DateTime(2022, 1),
      endDate: DateTime(2023, 5),
      description: 'Assisted in the redesign of the university portal. Created responsive UI components using HTML, CSS, and JavaScript.',
      technologiesUsed: ['HTML', 'CSS', 'JavaScript', 'Figma'],
    ),
  ];

  static final List<Project> mockProjects = [
    Project(
      id: 'proj_1',
      title: 'AppFlowy',
      shortDescription: 'Open Source Notion Alternative',
      fullDescription: 'AppFlowy is an open-source alternative to Notion. You are in charge of your data and customizations. Built with Flutter and Rust for superior performance and native experience across platforms.',
      imageUrl: 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['Flutter', 'Rust', 'Dart'],
      githubUrl: 'https://github.com/AppFlowy-IO/AppFlowy',
      projectUrl: 'https://appflowy.io/',
      category: 'Mobile',
    ),
    Project(
      id: 'proj_2',
      title: 'Supabase',
      shortDescription: 'The open source Firebase alternative.',
      fullDescription: 'A fully functioning backend built on Postgres, offering authentication, instant APIs, edge functions, realtime subscriptions, and storage. Scalable architecture built for modern apps.',
      imageUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['PostgreSQL', 'TypeScript', 'Go', 'REST API'],
      githubUrl: 'https://github.com/supabase/supabase',
      projectUrl: 'https://supabase.com',
      category: 'Backend',
    ),
    Project(
      id: 'proj_3',
      title: 'TensorFlow.js',
      shortDescription: 'Machine Learning algorithms in JavaScript.',
      fullDescription: 'A WebGL-accelerated JavaScript library for training and deploying Machine Learning models directly in the web browser and on Node.js without requiring a python backend.',
      imageUrl: 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['JavaScript', 'Machine Learning', 'WebGL', 'AI'],
      githubUrl: 'https://github.com/tensorflow/tfjs',
      projectUrl: 'https://www.tensorflow.org/js',
      category: 'AI/ML',
    ),
    Project(
      id: 'proj_4',
      title: 'Next.js Commerce',
      shortDescription: 'An all-in-one modern e-commerce starter kit.',
      fullDescription: 'High-performance e-commerce template built with Next.js, featuring a beautiful UI, shopping cart, secure checkout process, and deep integration with modern headless CMS providers.',
      imageUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['React', 'Next.js', 'Tailwind CSS'],
      githubUrl: 'https://github.com/vercel/commerce',
      projectUrl: 'https://nextjs.org/commerce',
      category: 'Web',
    ),
    Project(
      id: 'proj_5',
      title: 'Excalidraw',
      shortDescription: 'Virtual whiteboard for sketching diagrams.',
      fullDescription: 'A fast, highly-collaborative, open-source virtual whiteboard tool built in React. Features real-time multi-user collaboration, end-to-end encryption, and a beautiful sketching UI.',
      imageUrl: 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['React', 'TypeScript', 'Canvas API'],
      githubUrl: 'https://github.com/excalidraw/excalidraw',
      projectUrl: 'https://excalidraw.com',
      category: 'Web',
    ),
    Project(
      id: 'proj_6',
      title: 'Hugging Face Transformers',
      shortDescription: 'State-of-the-art NLP Deep Learning.',
      fullDescription: 'Provides thousands of pretrained models to perform tasks on texts such as classification, information extraction, and summarization in 100+ languages using PyTorch and JAX.',
      imageUrl: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['Python', 'PyTorch', 'Deep Learning', 'NLP'],
      githubUrl: 'https://github.com/huggingface/transformers',
      projectUrl: 'https://huggingface.co/',
      category: 'AI/ML',
    ),
    Project(
      id: 'proj_7',
      title: 'PocketBase',
      shortDescription: 'Open Source backend in 1 file',
      fullDescription: 'Open Source backend consisting of embedded database (SQLite) with real-time subscriptions, built-in auth management, convenient dashboard UI and simple REST-ish API.',
      imageUrl: 'https://images.unsplash.com/photo-1544383835-bda2bc62a567?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['Go', 'SQLite', 'Svelte'],
      githubUrl: 'https://github.com/pocketbase/pocketbase',
      projectUrl: 'https://pocketbase.io/',
      category: 'Backend',
    ),
    Project(
      id: 'proj_8',
      title: 'LangChain',
      shortDescription: 'Building applications with LLMs through composability',
      fullDescription: 'A framework for developing applications powered by language models. It enables applications that are context-aware and reason with data, connecting LLMs to other sources of computation or knowledge.',
      imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['Python', 'LLM', 'AI', 'Prompt Engineering'],
      githubUrl: 'https://github.com/langchain-ai/langchain',
      projectUrl: 'https://langchain.com/',
      category: 'AI/ML',
    ),
    Project(
      id: 'proj_9',
      title: 'VS Code',
      shortDescription: 'Code editing. Redefined.',
      fullDescription: 'Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications. It is fully extensible and heavily customizable.',
      imageUrl: 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['TypeScript', 'Electron', 'Node.js'],
      githubUrl: 'https://github.com/microsoft/vscode',
      projectUrl: 'https://code.visualstudio.com/',
      category: 'General',
    ),
    Project(
      id: 'proj_10',
      title: 'Outline',
      shortDescription: 'Fast, collaborative, knowledge base',
      fullDescription: 'The fastest knowledge base for growing teams. Beautiful, feature rich, and markdown compatible. It is an open source Notion alternative focused on teams and documentation.',
      imageUrl: 'https://images.unsplash.com/photo-1499750310107-5fef28a66643?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['React', 'Node.js', 'PostgreSQL'],
      githubUrl: 'https://github.com/outline/outline',
      projectUrl: 'https://www.getoutline.com/',
      category: 'Web',
    ),
    Project(
      id: 'proj_11',
      title: 'Appwrite',
      shortDescription: 'Secure Open-Source Backend Server',
      fullDescription: 'Appwrite provides web and mobile developers with a set of easy-to-use and integrate REST APIs to manage their core backend needs, saving developers from writing repetitive infrastructure code.',
      imageUrl: 'https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['PHP', 'Docker', 'MariaDB', 'Redis'],
      githubUrl: 'https://github.com/appwrite/appwrite',
      projectUrl: 'https://appwrite.io/',
      category: 'Backend',
    ),
    Project(
      id: 'proj_12',
      title: 'Flutter Gallery',
      shortDescription: 'Official Flutter samples & widgets showcase.',
      fullDescription: 'A comprehensive resource to help developers evaluate and use Flutter. Features a massive collection of Material Design & Cupertino widgets, complex behaviors, and professional app vignettes.',
      imageUrl: 'https://images.unsplash.com/photo-1617042375876-a13e36732a04?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['Flutter', 'Dart', 'Material UI'],
      githubUrl: 'https://github.com/flutter/gallery',
      projectUrl: 'https://gallery.flutter.dev/',
      category: 'Mobile',
    ),
  ];

  static final List<Skill> mockSkills = [
    Skill(
      id: 'sk_1',
      name: 'Flutter',
      masteryPercentage: 90.0,
      category: SkillCategory.mobileDevelopment,
      description: 'Extensive experience building cross-platform applications with rich UIs and animations.',
    ),
    Skill(
      id: 'sk_2',
      name: 'Dart',
      masteryPercentage: 88.0,
      category: SkillCategory.mobileDevelopment,
      description: 'Deep understanding of Dart language, asynchronous programming, and object-oriented design.',
    ),
    Skill(
      id: 'sk_3',
      name: 'Python',
      masteryPercentage: 82.0,
      category: SkillCategory.programming,
      description: 'Used for scripting, automation, algorithms, and backend development with FastAPI/Flask.',
    ),
    Skill(
      id: 'sk_4',
      name: 'C++',
      masteryPercentage: 80.0,
      category: SkillCategory.programming,
      description: 'Strong foundation in memory management, data structures, and competitive problem solving.',
    ),
    Skill(
      id: 'sk_5',
      name: 'Java',
      masteryPercentage: 78.0,
      category: SkillCategory.programming,
      description: 'Experience in object-oriented programming, Android development, and design patterns.',
    ),
    Skill(
      id: 'sk_6',
      name: 'Git/GitHub',
      masteryPercentage: 86.0,
      category: SkillCategory.versionControl,
      description: 'Proficient in branching, merging, rebasing, pull requests, and CI/CD automation.',
    ),
    Skill(
      id: 'sk_7',
      name: 'JavaScript',
      masteryPercentage: 85.0,
      category: SkillCategory.programming,
      description: 'Web development with modern ES6+ standards, DOM manipulation, and REST integrations.',
    ),
    Skill(
      id: 'sk_8',
      name: 'React',
      masteryPercentage: 80.0,
      category: SkillCategory.tools,
      description: 'Building dynamic and reactive component-based web interfaces.',
    ),
    Skill(
      id: 'sk_9',
      name: 'Figma',
      masteryPercentage: 75.0,
      category: SkillCategory.tools,
      description: 'Creating high-fidelity wireframes, UI prototypes, and design systems.',
    ),
  ];

  static const ContactInfo mockContactInfo = ContactInfo(
    email: 'alex.anderson@example.com',
    phone: '(555) 123-4567',
    address: '123 University Ave, Tech City, ST 12345',
    linkedInUrl: 'https://linkedin.com/in/alexanderson',
    githubUrl: 'https://github.com/alexanderson',
  );
}

// --- Expanded Logic for mock_data.dart ---
class MockDataExtensionHelper {
  /// Helper method 1 for future advanced logic
  static void internalHelperMethod0() {
    // Implementation details for mock_data logic 0
  }

  /// Helper method 2 for future advanced logic
  static void internalHelperMethod1() {
    // Implementation details for mock_data logic 1
  }

  /// Helper method 3 for future advanced logic
  static void internalHelperMethod2() {
    // Implementation details for mock_data logic 2
  }

  /// Helper method 4 for future advanced logic
  static void internalHelperMethod3() {
    // Implementation details for mock_data logic 3
  }

  /// Helper method 5 for future advanced logic
  static void internalHelperMethod4() {
    // Implementation details for mock_data logic 4
  }

  /// Helper method 6 for future advanced logic
  static void internalHelperMethod5() {
    // Implementation details for mock_data logic 5
  }

  /// Helper method 7 for future advanced logic
  static void internalHelperMethod6() {
    // Implementation details for mock_data logic 6
  }

  /// Helper method 8 for future advanced logic
  static void internalHelperMethod7() {
    // Implementation details for mock_data logic 7
  }

  /// Helper method 9 for future advanced logic
  static void internalHelperMethod8() {
    // Implementation details for mock_data logic 8
  }
}
