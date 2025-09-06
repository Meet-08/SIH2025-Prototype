import 'package:lakshya/features/student/models/question_model.dart';

final List<QuestionModel> aptitudeQuestions = [
  QuestionModel(
    id: 'q1',
    question:
        'Do you enjoy problem-solving and logical thinking, especially in subjects like physics, chemistry, and mathematics?',
    type: QuestionType.multipleChoice,
    options: ['Yes', 'No'],
  ),
  QuestionModel(
    id: 'q2',
    question:
        'Do you fascinated by business, finance, and economics, and do you have strong mathematical or analytical skills?',
    type: QuestionType.multipleChoice,
    options: ['Yes', 'No'],
  ),
  QuestionModel(
    id: 'q3',
    question:
        'Are you creative, imaginative, and interested in subjects like literature, history, or political science?',
    type: QuestionType.multipleChoice,
    options: ['Yes', 'No'],
  ),
  QuestionModel(
    id: 'q4',
    question:
        'Do you prefer hands-on learning and practical skills over theoretical knowledge?',
    type: QuestionType.multipleChoice,
    options: ['Yes', 'No'],
  ),
  QuestionModel(
    id: 'q5',
    question: 'What kind of work environment do you prefer?',
    type: QuestionType.multipleChoice,
    options: ['Laboratory', 'Office', 'Creative Studio', 'Workshop'],
  ),
  QuestionModel(
    id: 'q6',
    question: 'What do you prefer in your job?',
    type: QuestionType.multipleChoice,
    options: [
      'High-paying and stable career',
      'Personal expression and social impact',
      'Start earning quickly after education',
    ],
  ),
  QuestionModel(
    id: 'q7',
    question: 'What do you prefer working with?',
    type: QuestionType.multipleChoice,
    options: ['People', 'Data', 'Machines'],
  ),
  QuestionModel(
    id: 'q8',
    question:
        'What are your natural skills and abilities? Are you better at working with?',
    type: QuestionType.multipleChoice,
    options: [
      'Your hands',
      'Solving abstract problems',
      'Communicating with people',
    ],
  ),
  QuestionModel(
    id: 'q9',
    question: 'What kind of learner are you? Do you learn best by?',
    type: QuestionType.multipleChoice,
    options: [
      'Reading and studying theory',
      'Doing and experiencing things firsthand',
    ],
  ),
  QuestionModel(
    id: 'q10',
    question:
        'I enjoy building or repairing things (e.g., making models, fixing gadgets).',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
  QuestionModel(
    id: 'q11',
    question:
        'I like solving puzzles, logical problems, or coding challenges just for fun.',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
  QuestionModel(
    id: 'q12',
    question:
        'I am excited by starting or running a small business or selling my ideas.',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
  QuestionModel(
    id: 'q13',
    question:
        'I prefer expressing myself through art, design, writing, or performance.',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
  QuestionModel(
    id: 'q14',
    question:
        'I want to start earning quickly after finishing school (prefer early employment).',
    type: QuestionType.rating,
    options: ['1', '2', '3', '4', '5'],
  ),
];
