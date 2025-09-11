const Map<int, Map<int, Map<String, int>>> scoringRules = {
  0: {
    0: {'Science': 2},
    1: {},
  },
  1: {
    0: {'Commerce': 2},
    1: {},
  },
  2: {
    0: {'Art': 2},
    1: {},
  },
  3: {
    0: {'ITI/Diploma': 2},
    1: {'Science': 1},
  },
  4: {
    0: {'Science': 2},
    1: {'Commerce': 2},
    2: {'Art': 2},
    3: {'ITI/Diploma': 2},
  },
  5: {
    0: {'Commerce': 2},
    1: {'Art': 2},
    2: {'ITI/Diploma': 2},
  },
  6: {
    0: {'Art': 2},
    1: {'Commerce': 2},
    2: {'Science': 2},
  },
  7: {
    0: {'ITI/Diploma': 2},
    1: {'Science': 2},
    2: {'Art': 2},
  },
  8: {
    0: {'Science': 2},
    1: {'ITI/Diploma': 2},
  },
  9: {
    1: {'ITI/Diploma': 1},
    2: {'ITI/Diploma': 1},
    3: {'ITI/Diploma': 2},
    4: {'ITI/Diploma': 3},
    5: {'ITI/Diploma': 4},
  },
  10: {
    1: {'Science': 1},
    2: {'Science': 1},
    3: {'Science': 2},
    4: {'Science': 3},
    5: {'Science': 4},
  },
  11: {
    1: {'Commerce': 1},
    2: {'Commerce': 1},
    3: {'Commerce': 2},
    4: {'Commerce': 3},
    5: {'Commerce': 4},
  },
  12: {
    1: {'Art': 1},
    2: {'Art': 1},
    3: {'Art': 2},
    4: {'Art': 3},
    5: {'Art': 4},
  },
  13: {
    1: {'ITI/Diploma': 1},
    2: {'ITI/Diploma': 1},
    3: {'ITI/Diploma': 2},
    4: {'ITI/Diploma': 3},
    5: {'ITI/Diploma': 4},
  },
};

const Map<int, Map<int, Map<String, int>>> domainScoringRules = {
  0: {
    // Q1
    0: {'Logical': 2},
    1: {},
  },
  1: {
    // Q2
    0: {'Logical': 2, 'Social': 1},
    1: {},
  },
  2: {
    // Q3
    0: {'Creative': 2},
    1: {},
  },
  3: {
    // Q4
    0: {'Technical': 2},
    1: {'Logical': 1},
  },
  4: {
    // Q5
    0: {'Technical': 2}, // Laboratory
    1: {'Logical': 2}, // Office
    2: {'Creative': 2}, // Creative Studio
    3: {'Technical': 2}, // Workshop
  },
  5: {
    // Q6
    0: {'Logical': 2}, // High-paying career
    1: {'Creative': 2}, // Personal expression
    2: {'Technical': 2}, // Early earning
  },
  6: {
    // Q7
    0: {'Social': 2}, // People
    1: {'Logical': 2}, // Data
    2: {'Technical': 2}, // Machines
  },
  7: {
    // Q8
    0: {'Technical': 2}, // Hands
    1: {'Logical': 2}, // Abstract problems
    2: {'Social': 2}, // Communicating with people
  },
  8: {
    // Q9
    0: {'Logical': 2}, // Studying theory
    1: {'Technical': 2}, // Experiencing things
  },
  9: {
    // Q10 Rating
    1: {'Technical': 1},
    2: {'Technical': 1},
    3: {'Technical': 2},
    4: {'Technical': 3},
    5: {'Technical': 4},
  },
  10: {
    // Q11 Rating
    1: {'Logical': 1},
    2: {'Logical': 1},
    3: {'Logical': 2},
    4: {'Logical': 3},
    5: {'Logical': 4},
  },
  11: {
    // Q12 Rating
    1: {'Social': 1},
    2: {'Social': 1},
    3: {'Social': 2},
    4: {'Social': 3},
    5: {'Social': 4},
  },
  12: {
    // Q13 Rating
    1: {'Creative': 1},
    2: {'Creative': 1},
    3: {'Creative': 2},
    4: {'Creative': 3},
    5: {'Creative': 4},
  },
  13: {
    // Q14 Rating
    1: {'Technical': 1},
    2: {'Technical': 1},
    3: {'Technical': 2},
    4: {'Technical': 3},
    5: {'Technical': 4},
  },
};
