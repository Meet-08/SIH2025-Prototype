import 'package:lakshya/features/student/models/question_model.dart';

final List<QuestionModel> aptitudeQuestions = [
  QuestionModel(
    id: 'q1',
    question: 'How do you prefer to solve problems?',
    type: QuestionType.multipleChoice,
    options: [
      'Using logical thinking, mathematics, and scientific methods',
      'Analyzing data, market trends, and financial information',
      'Using creativity, imagination, and artistic expression',
      'Working directly with people to address their needs',
      'Using practical skills and hands-on approaches',
    ],
  ),
  QuestionModel(
    id: 'q2',
    question: 'What motivates you most in your career goals?',
    type: QuestionType.multipleChoice,
    options: [
      'Discovering new knowledge and solving complex problems',
      'Achieving financial success and business growth',
      'Personal expression and making social impact',
      'Serving others and contributing to community welfare',
      'Quick employment and practical skill application',
    ],
  ),
  QuestionModel(
    id: 'q3',
    question: 'Which subjects fascinate you most?',
    type: QuestionType.multipleChoice,
    options: [
      'Physics, Chemistry, Mathematics, Biology',
      'Business Studies, Economics, Accounting, Statistics',
      'Literature, History, Political Science, Philosophy',
      'Psychology, Sociology, Social Work, Public Administration',
      'Technical skills, hands-on learning, practical applications',
    ],
  ),
  QuestionModel(
    id: 'q4',
    question: 'What balance do you prefer between stability and innovation?',
    type: QuestionType.multipleChoice,
    options: [
      'High innovation with research and technological advancement',
      'Balanced approach with financial stability and business growth',
      'Creative freedom with potential for artistic recognition',
      'Stable service roles with community impact',
      'Stable technical roles with hands-on expertise',
    ],
  ),
  QuestionModel(
    id: 'q5',
    question: 'How do you learn best?',
    type: QuestionType.multipleChoice,
    options: [
      'Through experimentation, hypothesis testing, and research',
      'Through case studies, market analysis, and practical applications',
      'Through creative exploration, artistic practice, and self-expression',
      'Through direct experience helping others and community involvement',
      'Through hands-on practice and apprenticeship-style learning',
    ],
  ),
  QuestionModel(
    id: 'q6',
    question: 'What kind of impact do you want to make in your career?',
    type: QuestionType.multipleChoice,
    options: [
      'Advance scientific knowledge or technological innovation',
      'Build successful businesses or manage financial growth',
      'Create meaningful art or cultural contributions',
      'Improve lives through service and community support',
      'Maintain and improve technical infrastructure',
    ],
  ),
  QuestionModel(
    id: 'q7',
    question: 'What are your strongest natural abilities?',
    type: QuestionType.multipleChoice,
    options: [
      'Analytical thinking, mathematical reasoning, scientific curiosity',
      'Strategic thinking, negotiation, financial analysis',
      'Creative expression, artistic vision, communication',
      'Empathy, communication, problem-solving for people',
      'Mechanical skills, practical problem-solving, technical expertise',
    ],
  ),
  QuestionModel(
    id: 'q8',
    question: 'How do you define career success?',
    type: QuestionType.multipleChoice,
    options: [
      'Scientific breakthroughs, published research, innovation',
      'Financial growth, business expansion, market leadership',
      'Artistic recognition, creative fulfillment, cultural impact',
      'Lives improved, communities served, social change',
      'Technical mastery, system reliability, practical problem-solving',
    ],
  ),
  QuestionModel(
    id: 'q9',
    question: 'What do you prefer working with?',
    type: QuestionType.multipleChoice,
    options: [
      'People — collaboration, expression, interpersonal interaction',
      'Data — analysis, trends, decision-making',
      'Machines — experimentation, problem-solving, technical systems',
    ],
  ),
  QuestionModel(
    id: 'q10',
    question: 'Which activity sounds most fun to you?',
    type: QuestionType.multipleChoice,
    options: [
      'Designing and building a model (e.g., a bridge, robot, or structure)',
      'Marketing plan for a school event',
      'Writing or illustrating a story/comic',
      'Organizing a charity drive or school club',
    ],
  ),
  QuestionModel(
    id: 'q11',
    question:
        'On a scale of 1 to 5: I enjoy planning or organizing events (like a class project or club activity).',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
  QuestionModel(
    id: 'q12',
    question:
        'On a scale of 1 to 5: I enjoy looking at or creating art (painting, drawing, crafting).',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
  QuestionModel(
    id: 'q13',
    question:
        'On a scale of 1 to 5: I enjoy helping or teaching other people (explaining, tutoring, volunteering).',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
  QuestionModel(
    id: 'q14',
    question:
        'On a scale of 1 to 5: I enjoy experimenting with new technology or gadgets (like coding a simple program, building a model robot).',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
  QuestionModel(
    id: 'q15',
    question:
        'On a scale of 1 to 5: I enjoy analyzing problems and finding logical solutions (solving puzzles, troubleshooting, researching).',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
];

const List<String> careerFields = [
  'Mathematics & Computer Science',
  'Biological Sciences & Biotechnology',
  'Commerce & Finance',
  'Arts, Design & Creative Media',
  'Health & Medicine',
  'Engineering - Civil & Mechanical',
  'Law & Legal Studies',
  'Hospitality, Travel & Tourism',
  'Agriculture & Allied Sciences',
  'Media, Content & Performing Arts',
  'Environmental Science & Sustainability',
];

// Timeline Event Model
class TimelineEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimelineEventType type;
  final TimelineEventStatus status;
  final String? actionUrl;
  final String? location;

  const TimelineEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.status,
    this.actionUrl,
    this.location,
  });
}

enum TimelineEventType {
  admission,
  scholarship,
  exam,
  counseling,
  deadline,
  announcement,
  workshop,
  career,
}

enum TimelineEventStatus { completed, active, upcoming }

final List<TimelineEvent> timelineEvents = [
  // Past Events
  TimelineEvent(
    id: 'te001',
    title: 'Class 12 Result Declaration',
    description: 'Board examination results announced for all streams',
    date: DateTime(2025, 5, 20),
    type: TimelineEventType.announcement,
    status: TimelineEventStatus.completed,
  ),

  TimelineEvent(
    id: 'te002',
    title: 'Career Counseling Workshop',
    description: 'Free career guidance session for science stream students',
    date: DateTime(2025, 6, 15),
    type: TimelineEventType.workshop,
    status: TimelineEventStatus.completed,
    location: 'Government Higher Secondary School, District Center',
  ),

  TimelineEvent(
    id: 'te003',
    title: 'Early Bird Scholarship Registration',
    description:
        'Merit-based scholarship applications opened for government colleges',
    date: DateTime(2025, 7, 1),
    type: TimelineEventType.scholarship,
    status: TimelineEventStatus.completed,
  ),

  // Current/Active Events
  TimelineEvent(
    id: 'te004',
    title: 'Government College Admission Form',
    description:
        'Last week to submit admission applications for degree programs',
    date: DateTime(2025, 10, 15),
    type: TimelineEventType.admission,
    status: TimelineEventStatus.active,
    actionUrl: 'https://admissions.jkbose.ac.in',
  ),

  TimelineEvent(
    id: 'te005',
    title: 'Document Verification Drive',
    description:
        'Bring original certificates for verification at designated centers',
    date: DateTime(2025, 10, 25),
    type: TimelineEventType.deadline,
    status: TimelineEventStatus.active,
    location: 'All District Collectorate Offices',
  ),

  // Upcoming Events
  TimelineEvent(
    id: 'te006',
    title: 'Merit-based Scholarship Deadline',
    description: 'Final date to apply for state government merit scholarships',
    date: DateTime(2025, 11, 1),
    type: TimelineEventType.scholarship,
    status: TimelineEventStatus.upcoming,
    actionUrl: 'https://scholarships.gov.in',
  ),

  TimelineEvent(
    id: 'te007',
    title: 'Engineering Entrance Exam Registration',
    description: 'JEE Main 2026 registration opens for engineering aspirants',
    date: DateTime(2025, 11, 15),
    type: TimelineEventType.exam,
    status: TimelineEventStatus.upcoming,
    actionUrl: 'https://jeemain.nta.nic.in',
  ),

  TimelineEvent(
    id: 'te008',
    title: 'NEET Registration Opens',
    description: 'Medical entrance exam registration for MBBS/BDS programs',
    date: DateTime(2025, 12, 1),
    type: TimelineEventType.exam,
    status: TimelineEventStatus.upcoming,
    actionUrl: 'https://neet.nta.nic.in',
  ),

  TimelineEvent(
    id: 'te009',
    title: 'College Counseling Session',
    description: 'Interactive session on course selection and career prospects',
    date: DateTime(2025, 12, 10),
    type: TimelineEventType.counseling,
    status: TimelineEventStatus.upcoming,
    location: 'Government Degree College, Jammu',
  ),

  TimelineEvent(
    id: 'te010',
    title: 'NEET Registration Deadline',
    description: 'Last date to register for medical entrance examination',
    date: DateTime(2025, 12, 31),
    type: TimelineEventType.deadline,
    status: TimelineEventStatus.upcoming,
  ),

  TimelineEvent(
    id: 'te011',
    title: 'First Semester Classes Begin',
    description: 'Academic session starts for all degree programs',
    date: DateTime(2026, 1, 15),
    type: TimelineEventType.announcement,
    status: TimelineEventStatus.upcoming,
  ),

  TimelineEvent(
    id: 'te012',
    title: 'Career Fair 2026',
    description: 'Job opportunities and higher education expo for graduates',
    date: DateTime(2026, 2, 20),
    type: TimelineEventType.career,
    status: TimelineEventStatus.upcoming,
    location: 'SKICC Convention Center, Srinagar',
  ),

  TimelineEvent(
    id: 'te013',
    title: 'Summer Internship Applications',
    description:
        'Apply for government department internships and skill programs',
    date: DateTime(2026, 3, 1),
    type: TimelineEventType.career,
    status: TimelineEventStatus.upcoming,
  ),
];

// Legacy support for existing calendar widget
final Map<DateTime, List<String>> eventsData = {
  DateTime.utc(2025, 10, 15): ['Govt College Admission Deadline'],
  DateTime.utc(2025, 11, 1): ['Merit-based Scholarship Application Deadline'],
  DateTime.utc(2025, 12, 5): ['NEET Registration Closes'],
  DateTime.utc(2026, 1, 10): ['College Counseling Starts'],
};
