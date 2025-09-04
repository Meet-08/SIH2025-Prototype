import 'package:flutter/material.dart';

import '../core/core.dart';

class FeatureDemoPage extends StatefulWidget {
  const FeatureDemoPage({super.key});

  @override
  State<FeatureDemoPage> createState() => _FeatureDemoPageState();
}

class _FeatureDemoPageState extends State<FeatureDemoPage> {
  int _selectedQuizOption = -1;
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lakshya Features Demo'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Section
            _buildSectionTitle('Aptitude Quiz'),
            FeatureWidgets.quizQuestionCard(
              question:
                  "Do you enjoy solving mathematical puzzles and logical problems?",
              options: [
                "Yes, I love mathematical challenges",
                "Sometimes, depending on the complexity",
                "No, I prefer other types of problems",
                "I'm not sure about my preference",
              ],
              onOptionSelected: (index) {
                setState(() {
                  _selectedQuizOption = index;
                });
              },
              selectedOption: _selectedQuizOption,
            ),
            const SizedBox(height: 24),

            // Interest Domains Section
            _buildSectionTitle('Interest Domain Analysis'),
            _buildInterestDomains(),
            const SizedBox(height: 24),

            // Career Roadmap Section
            _buildSectionTitle('Career Roadmap'),
            _buildCareerRoadmap(),
            const SizedBox(height: 24),

            // Colleges Section
            _buildSectionTitle('Nearby Government Colleges'),
            _buildCollegesDemo(),
            const SizedBox(height: 24),

            // Scholarships Section
            _buildSectionTitle('Scholarships & Government Schemes'),
            _buildScholarshipsDemo(),
            const SizedBox(height: 24),

            // Timeline Section
            _buildSectionTitle('Important Timeline'),
            _buildTimelineDemo(),
            const SizedBox(height: 24),

            // Parent Dashboard Section
            _buildSectionTitle('For Parents'),
            _buildParentDashboardDemo(),
            const SizedBox(height: 24),

            // Language Support Section
            _buildSectionTitle('Multi-Language Support'),
            FeatureWidgets.languageSelector(
              currentLanguage: _selectedLanguage,
              languages: [
                {
                  'code': 'en',
                  'name': 'English',
                  'color': AppColors.languageEnglish,
                },
                {
                  'code': 'hi',
                  'name': 'हिन्दी',
                  'color': AppColors.languageHindi,
                },
                {
                  'code': 'te',
                  'name': 'తెలుగు',
                  'color': AppColors.languageRegional,
                },
                {
                  'code': 'ta',
                  'name': 'தமிழ்',
                  'color': AppColors.languageRegional,
                },
              ],
              onLanguageChanged: (language) {
                setState(() {
                  _selectedLanguage = language;
                });
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInterestDomains() {
    final domains = [
      {
        'domain': 'Logical & Analytical',
        'description': 'Problem-solving, mathematics, data analysis',
        'percentage': 85.0,
        'color': AppColors.logicalDomain,
        'icon': Icons.psychology,
      },
      {
        'domain': 'Technical & Engineering',
        'description': 'Technology, programming, engineering concepts',
        'percentage': 72.0,
        'color': AppColors.technicalDomain,
        'icon': Icons.engineering,
      },
      {
        'domain': 'Creative & Design',
        'description': 'Art, design, creative expression',
        'percentage': 58.0,
        'color': AppColors.creativeDomain,
        'icon': Icons.palette,
      },
      {
        'domain': 'Social & Communication',
        'description': 'People interaction, social causes',
        'percentage': 64.0,
        'color': AppColors.socialDomain,
        'icon': Icons.groups,
      },
    ];

    return Column(
      children: domains
          .map(
            (domain) => FeatureWidgets.interestDomainCard(
              domain: domain['domain'] as String,
              description: domain['description'] as String,
              percentage: domain['percentage'] as double,
              domainColor: domain['color'] as Color,
              icon: domain['icon'] as IconData,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Exploring ${domain['domain']} careers...'),
                    backgroundColor: domain['color'] as Color,
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildCareerRoadmap() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.careerRoadmapGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Your Career Journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FeatureWidgets.careerRoadmapNode(
                  title: '12th Grade',
                  subtitle: 'Completed',
                  isCompleted: true,
                  isCurrent: false,
                  isAccessible: true,
                  onTap: () {},
                ),
                Container(
                  width: 20,
                  height: 2,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                FeatureWidgets.careerRoadmapNode(
                  title: 'Entrance Exams',
                  subtitle: 'In Progress',
                  isCompleted: false,
                  isCurrent: true,
                  isAccessible: true,
                  onTap: () {},
                ),
                Container(
                  width: 20,
                  height: 2,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                FeatureWidgets.careerRoadmapNode(
                  title: 'College',
                  subtitle: 'Upcoming',
                  isCompleted: false,
                  isCurrent: false,
                  isAccessible: true,
                  onTap: () {},
                ),
                Container(
                  width: 20,
                  height: 2,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                FeatureWidgets.careerRoadmapNode(
                  title: 'Career',
                  subtitle: 'Future',
                  isCompleted: false,
                  isCurrent: false,
                  isAccessible: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollegesDemo() {
    final colleges = [
      {
        'name': 'IIT Delhi',
        'location': 'New Delhi, Delhi',
        'distance': 15.2,
        'streams': ['Computer Science', 'Mechanical', 'Electrical', 'Civil'],
        'isGovernment': true,
        'fees': '₹2,50,000/year',
      },
      {
        'name': 'Delhi Technological University',
        'location': 'Shahbad Daulatpur, Delhi',
        'distance': 22.8,
        'streams': ['IT', 'ECE', 'Mechanical', 'Chemical'],
        'isGovernment': true,
        'fees': '₹1,50,000/year',
      },
      {
        'name': 'Jamia Millia Islamia',
        'location': 'Okhla, New Delhi',
        'distance': 28.5,
        'streams': ['Engineering', 'Architecture', 'Mass Communication'],
        'isGovernment': true,
        'fees': '₹85,000/year',
      },
    ];

    return Column(
      children: colleges
          .map(
            (college) => FeatureWidgets.collegeCard(
              name: college['name'] as String,
              location: college['location'] as String,
              distance: college['distance'] as double,
              streams: List<String>.from(college['streams'] as List),
              isGovernment: college['isGovernment'] as bool,
              fees: college['fees'] as String,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${college['name']} details...'),
                    backgroundColor: AppColors.collegeGovt,
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildScholarshipsDemo() {
    final scholarships = [
      {
        'name': 'National Talent Search Examination (NTSE)',
        'eligibility': 'Class 10 students with 60% marks',
        'deadline': DateTime(2025, 11, 30),
        'amount': '₹1,250/month (Class 11-12), ₹2,000/month (UG/PG)',
        'isActive': true,
      },
      {
        'name': 'Central Sector Scholarship Scheme',
        'eligibility':
            'Class 12 passed with 80% marks, family income < ₹2.5 lakh',
        'deadline': DateTime(2025, 10, 31),
        'amount': '₹20,000/year',
        'isActive': true,
      },
      {
        'name': 'Post Matric Scholarship for SC Students',
        'eligibility': 'SC category students, family income < ₹2.5 lakh',
        'deadline': DateTime(2025, 12, 15),
        'amount': '₹35,000/year for engineering',
        'isActive': true,
      },
    ];

    return Column(
      children: scholarships
          .map(
            (scholarship) => FeatureWidgets.scholarshipCard(
              name: scholarship['name'] as String,
              eligibility: scholarship['eligibility'] as String,
              deadline: scholarship['deadline'] as DateTime,
              amount: scholarship['amount'] as String,
              isActive: scholarship['isActive'] as bool,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${scholarship['name']} details...'),
                    backgroundColor: AppColors.scholarshipActive,
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildTimelineDemo() {
    final events = [
      {
        'title': 'JEE Main Application',
        'description': 'Last date to apply for JEE Main examination',
        'date': DateTime(2025, 12, 15),
        'isCompleted': false,
        'isUpcoming': true,
      },
      {
        'title': 'NEET 2026 Registration',
        'description': 'Registration opens for NEET UG 2026',
        'date': DateTime(2025, 11, 1),
        'isCompleted': true,
        'isUpcoming': false,
      },
      {
        'title': 'Board Exam Results',
        'description': 'Class 12 board examination results declaration',
        'date': DateTime(2026, 5, 20),
        'isCompleted': false,
        'isUpcoming': false,
      },
    ];

    return Column(
      children: events
          .map(
            (event) => FeatureWidgets.timelineEventCard(
              title: event['title'] as String,
              description: event['description'] as String,
              date: event['date'] as DateTime,
              isCompleted: event['isCompleted'] as bool,
              isUpcoming: event['isUpcoming'] as bool,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${event['title']} details...'),
                    backgroundColor: AppColors.timelineActive,
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildParentDashboardDemo() {
    final parentCards = [
      {
        'title': 'Career Path Analysis',
        'content':
            'Understand your child\'s interests and potential career paths based on their aptitude test results.',
        'icon': Icons.trending_up,
        'color': AppColors.parentPrimary,
      },
      {
        'title': 'Progress Tracking',
        'content':
            'Monitor your child\'s academic progress, skill development, and career preparation milestones.',
        'icon': Icons.track_changes,
        'color': AppColors.parentSecondary,
      },
      {
        'title': 'Educational Investment',
        'content':
            'Get insights on educational costs, scholarships, and ROI for different career paths.',
        'icon': Icons.account_balance,
        'color': AppColors.parentAccent,
      },
      {
        'title': 'Guidance Resources',
        'content':
            'Access expert advice, counseling sessions, and educational resources for informed decisions.',
        'icon': Icons.support_agent,
        'color': AppColors.parentInfo,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: parentCards.length,
      itemBuilder: (context, index) {
        final card = parentCards[index];
        return FeatureWidgets.parentInfoCard(
          title: card['title'] as String,
          content: card['content'] as String,
          icon: card['icon'] as IconData,
          color: card['color'] as Color,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${card['title']}...'),
                backgroundColor: card['color'] as Color,
              ),
            );
          },
        );
      },
    );
  }
}
