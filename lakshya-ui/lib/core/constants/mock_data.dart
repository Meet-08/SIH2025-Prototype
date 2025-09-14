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

final Map<DateTime, List<String>> eventsData = {
  DateTime.utc(2025, 10, 15): ['Govt College Admission Deadline'],
  DateTime.utc(2025, 11, 1): ['Merit-based Scholarship Application Deadline'],
  DateTime.utc(2025, 12, 5): ['NEET Registration Closes'],
  DateTime.utc(2026, 1, 10): ['College Counseling Starts'],
};
