# Define questions
QUESTION_SET = {
    0: "How do you prefer to solve problems?",
    1: "What motivates you most in your career goals?",
    2: "Which subjects fascinate you most?",
    3: "What balance do you prefer between stability and innovation?",
    4: "How do you learn best?",
    5: "What kind of impact do you want to make in your career?",
    6: "What are your strongest natural abilities?",
    7: "How do you define career success?",
    8: "What do you prefer working with?",
    9: "Which activity sounds most fun to you?",
    10: "On a scale of 1 to 5: I enjoy planning or organizing events (like a class project or club activity).",
    11: "On a scale of 1 to 5: I enjoy looking at or creating art (painting, drawing, crafting).",
    12: "On a scale of 1 to 5: I enjoy helping or teaching other people (explaining, tutoring, volunteering).",
    13: "On a scale of 1 to 5: I enjoy experimenting with new technology or gadgets (like coding a simple program, building a model robot).",
    14: "On a scale of 1 to 5: I enjoy analyzing problems and finding logical solutions (solving puzzles, troubleshooting, researching).",
}

roadmaps = [
    {
        "careerField": "Mathematics & Computer Science",
        "after10th": {
            "recommendedStream": "Science (PCM)",
            "subjects": ["Physics", "Chemistry", "Mathematics", "English"],
        },
        "after12th": {
            "entranceExams": ["JEE Main", "State CET", "University Entrance"],
        },
        "courses": {
            "B.Sc Mathematics": {
                "name": "B.Sc Mathematics",
                "duration": "3 years",
                "specializations": [
                    "Pure Mathematics",
                    "Applied Mathematics",
                    "Statistics",
                ],
                "keySubjects": [
                    "Calculus",
                    "Algebra",
                    "Statistics",
                    "Differential Equations",
                ],
                "careerPaths": {
                    "industries": [
                        "Education",
                        "Finance",
                        "Data Science",
                        "Research",
                        "Technology",
                    ],
                    "jobRoles": [
                        "Statistician",
                        "Data Analyst",
                        "Actuarial Scientist",
                        "Math Teacher",
                        "Research Analyst",
                    ],
                    "governmentExams": [
                        "NET (Math)",
                        "GATE (Math)",
                        "Civil Services",
                        "Banking Exams",
                    ],
                    "entrepreneurialOptions": [
                        "Education Startup",
                        "Tutoring Center",
                        "Analytics Consultancy",
                    ],
                    "higherEducation": [
                        "M.Sc Mathematics",
                        "MBA",
                        "M.Tech Data Science",
                        "PhD Mathematics",
                    ],
                },
            },
            "B.Tech Computer Science": {
                "name": "B.Tech Computer Science",
                "duration": "4 years",
                "specializations": ["AI & ML", "Networks", "Software Engineering"],
                "keySubjects": ["Programming", "Data Structures", "Algorithms", "DBMS"],
                "careerPaths": {
                    "industries": ["Technology", "SaaS", "Fintech"],
                    "jobRoles": [
                        "Software Engineer",
                        "System Architect",
                        "DevOps Engineer",
                    ],
                    "governmentExams": ["GATE", "ESE"],
                    "entrepreneurialOptions": ["Tech Startup", "Product Company"],
                    "higherEducation": ["M.Tech", "MS abroad", "MBA"],
                },
            },
        },
    },
    {
        "careerField": "Biological Sciences & Biotechnology",
        "after10th": {
            "recommendedStream": "Science (PCB)",
            "subjects": ["Biology", "Chemistry", "Physics", "English"],
        },
        "after12th": {
            "entranceExams": ["NEET", "AIIMS", "JIPMER", "State/University CET"],
        },
        "courses": {
            "B.Sc Biotechnology": {
                "name": "B.Sc Biotechnology",
                "duration": "3 years",
                "specializations": [
                    "Molecular Biology",
                    "Genetic Engineering",
                    "Industrial Biotechnology",
                ],
                "keySubjects": [
                    "Cell Biology",
                    "Genetics",
                    "Biochemistry",
                    "Microbiology",
                ],
                "careerPaths": {
                    "industries": ["Pharma", "Agribiotech", "Healthcare", "Research"],
                    "jobRoles": [
                        "Lab Technician",
                        "Research Associate",
                        "Quality Analyst",
                        "Clinical Research Coordinator",
                    ],
                    "governmentExams": ["NET (Life Sciences)", "PSC Lab Posts"],
                    "entrepreneurialOptions": ["Biotech Startup", "Diagnostics Lab"],
                    "higherEducation": ["M.Sc Biotechnology", "M.Tech Biotech", "PhD"],
                },
            },
            "B.Pharm": {
                "name": "B.Pharm",
                "duration": "4 years",
                "specializations": ["Pharmaceutics", "Pharmacology"],
                "keySubjects": [
                    "Pharmaceutical Chemistry",
                    "Human Anatomy",
                    "Pharmacology",
                ],
                "careerPaths": {
                    "industries": ["Pharmaceuticals", "Hospitals", "Regulatory"],
                    "jobRoles": [
                        "Pharmacist",
                        "Formulation Chemist",
                        "Regulatory Affairs Executive",
                    ],
                    "governmentExams": ["Pharmacy Council Registrations"],
                    "entrepreneurialOptions": [
                        "Community Pharmacy",
                        "Pharma Distribution",
                    ],
                    "higherEducation": ["M.Pharm", "MBA Pharma"],
                },
            },
        },
    },
    {
        "careerField": "Commerce & Finance",
        "after10th": {
            "recommendedStream": "Commerce",
            "subjects": [
                "Accountancy",
                "Business Studies",
                "Economics",
                "Mathematics/English",
            ],
        },
        "after12th": {
            "entranceExams": ["CA Foundation", "CUET", "University admissions"],
        },
        "courses": {
            "B.Com": {
                "name": "B.Com",
                "duration": "3 years",
                "specializations": ["Accounting", "Finance", "Taxation"],
                "keySubjects": ["Accounting", "Business Law", "Economics", "Taxation"],
                "careerPaths": {
                    "industries": [
                        "Banking",
                        "Accounting Firms",
                        "Finance",
                        "Corporate",
                    ],
                    "jobRoles": [
                        "Accountant",
                        "Financial Analyst",
                        "Tax Consultant",
                        "Auditor",
                    ],
                    "governmentExams": ["CA", "CS", "Banking PO", "SSC CGL"],
                    "entrepreneurialOptions": ["Accounting Firm", "Financial Advisory"],
                    "higherEducation": ["M.Com", "MBA", "CA"],
                },
            },
            "BBA": {
                "name": "BBA",
                "duration": "3 years",
                "specializations": ["Marketing", "Finance", "HR"],
                "keySubjects": ["Management", "Marketing", "Finance", "Statistics"],
                "careerPaths": {
                    "industries": ["Consulting", "Corporate", "Startups"],
                    "jobRoles": [
                        "Business Analyst",
                        "HR Executive",
                        "Marketing Executive",
                    ],
                    "governmentExams": ["State PSC jobs", "Banking exams"],
                    "entrepreneurialOptions": ["Consultancy", "Startup"],
                    "higherEducation": ["MBA", "PGDM"],
                },
            },
        },
    },
    {
        "careerField": "Arts, Design & Creative Media",
        "after10th": {
            "recommendedStream": "Arts",
            "subjects": [
                "History",
                "Political Science",
                "English",
                "Sociology/Optional Arts",
            ],
        },
        "after12th": {
            "entranceExams": [
                "NID Entrance",
                "NIFT Entrance",
                "CUET",
                "State Design Entrance",
            ],
        },
        "courses": {
            "B.Des": {
                "name": "B.Des",
                "duration": "4 years",
                "specializations": [
                    "Fashion Design",
                    "Industrial Design",
                    "Graphic Design",
                ],
                "keySubjects": [
                    "Design Fundamentals",
                    "Visual Communication",
                    "Product Design",
                ],
                "careerPaths": {
                    "industries": ["Fashion", "Advertising", "Media", "Entertainment"],
                    "jobRoles": [
                        "Graphic Designer",
                        "Fashion Designer",
                        "Art Director",
                    ],
                    "governmentExams": [],
                    "entrepreneurialOptions": [
                        "Design Studio",
                        "Freelancing",
                        "Creative Agency",
                    ],
                    "higherEducation": ["M.Des", "MBA Design Management"],
                },
            },
            "BFA": {
                "name": "BFA",
                "duration": "4 years",
                "specializations": ["Painting", "Sculpture", "Applied Arts"],
                "keySubjects": ["Fine Arts", "Art History", "Drawing & Painting"],
                "careerPaths": {
                    "industries": [
                        "Art Galleries",
                        "Education",
                        "Media",
                        "Entertainment",
                    ],
                    "jobRoles": ["Artist", "Art Teacher", "Illustrator"],
                    "governmentExams": ["State Art Grants", "UGC NET (Fine Arts)"],
                    "entrepreneurialOptions": ["Art Studio", "Freelance Artist"],
                    "higherEducation": ["MFA", "PhD in Arts"],
                },
            },
        },
    },
    {
        "careerField": "Health & Medicine",
        "after10th": {
            "recommendedStream": "Science (PCB)",
            "subjects": ["Biology", "Chemistry", "Physics", "English"],
        },
        "after12th": {
            "entranceExams": ["NEET", "AIIMS", "State medical entrances"],
        },
        "courses": {
            "MBBS": {
                "name": "MBBS",
                "duration": "5.5 years",
                "specializations": ["General Medicine", "Surgery", "Pediatrics"],
                "keySubjects": [
                    "Anatomy",
                    "Physiology",
                    "Biochemistry",
                    "Clinical Subjects",
                ],
                "careerPaths": {
                    "industries": ["Hospitals", "Clinical Research", "Public Health"],
                    "jobRoles": ["Doctor/Physician", "Surgeon", "Medical Researcher"],
                    "governmentExams": ["NEET-PG", "State Medical PSC"],
                    "entrepreneurialOptions": ["Private Clinic", "Diagnostic Center"],
                    "higherEducation": ["MD/MS", "DM/MCh", "PhD"],
                },
            },
            "B.Sc Nursing": {
                "name": "B.Sc Nursing",
                "duration": "4 years",
                "specializations": ["Critical Care", "Community Health"],
                "keySubjects": [
                    "Nursing Foundations",
                    "Pharmacology",
                    "Community Health",
                ],
                "careerPaths": {
                    "industries": ["Hospitals", "Home Care", "NGOs"],
                    "jobRoles": [
                        "Staff Nurse",
                        "Nurse Educator",
                        "Clinical Coordinator",
                    ],
                    "governmentExams": ["Nursing Council Registrations"],
                    "entrepreneurialOptions": [
                        "Home Care Services",
                        "Nursing Training Institute",
                    ],
                    "higherEducation": ["M.Sc Nursing", "PG Diplomas"],
                },
            },
        },
    },
    {
        "careerField": "Engineering - Civil & Mechanical",
        "after10th": {
            "recommendedStream": "Science (PCM)",
            "subjects": ["Mathematics", "Physics", "Chemistry", "English"],
        },
        "after12th": {
            "entranceExams": ["JEE Main", "State Engineering CET"],
        },
        "courses": {
            "B.Tech Civil": {
                "name": "B.Tech Civil",
                "duration": "4 years",
                "specializations": ["Structural", "Geotechnical", "Transportation"],
                "keySubjects": [
                    "Mechanics",
                    "Concrete Technology",
                    "Surveying",
                    "Structural Analysis",
                ],
                "careerPaths": {
                    "industries": ["Construction", "Infrastructure", "Consulting"],
                    "jobRoles": [
                        "Site Engineer",
                        "Project Manager",
                        "Structural Engineer",
                    ],
                    "governmentExams": ["GATE", "ESE"],
                    "entrepreneurialOptions": ["Construction Firm", "Consultancy"],
                    "higherEducation": ["M.Tech Civil", "MBA"],
                },
            },
            "B.Tech Mechanical": {
                "name": "B.Tech Mechanical",
                "duration": "4 years",
                "specializations": ["Automotive", "Thermal", "Robotics"],
                "keySubjects": [
                    "Thermodynamics",
                    "Machine Design",
                    "Manufacturing Processes",
                ],
                "careerPaths": {
                    "industries": ["Automotive", "Aerospace", "Manufacturing"],
                    "jobRoles": [
                        "Mechanical Engineer",
                        "R&D Engineer",
                        "Maintenance Engineer",
                    ],
                    "governmentExams": ["GATE", "DRDO"],
                    "entrepreneurialOptions": [
                        "Manufacturing Startup",
                        "Repair Workshop",
                    ],
                    "higherEducation": ["M.Tech", "MBA"],
                },
            },
        },
    },
    {
        "careerField": "Law & Legal Studies",
        "after10th": {
            "recommendedStream": "Arts/Commerce",
            "subjects": [
                "Political Science",
                "History",
                "English",
                "Sociology/Economics",
            ],
        },
        "after12th": {
            "entranceExams": ["CLAT", "LSAT India", "State Law Entrance Exams"],
        },
        "courses": {
            "BA LLB": {
                "name": "BA LLB",
                "duration": "5 years",
                "specializations": [
                    "Corporate Law",
                    "Criminal Law",
                    "Constitutional Law",
                ],
                "keySubjects": [
                    "Law of Contracts",
                    "Criminal Law",
                    "Constitutional Law",
                    "Legal Ethics",
                ],
                "careerPaths": {
                    "industries": ["Legal Firms", "Corporate Legal Department", "NGOs"],
                    "jobRoles": ["Lawyer", "Legal Advisor", "Public Prosecutor"],
                    "governmentExams": ["Judicial Services", "UPSC Legal Exams"],
                    "entrepreneurialOptions": ["Law Firm", "Legal Consultancy"],
                    "higherEducation": ["LLM", "PhD Law"],
                },
            },
        },
    },
    {
        "careerField": "Hospitality, Travel & Tourism",
        "after10th": {
            "recommendedStream": "Arts/Commerce",
            "subjects": [
                "English",
                "Geography",
                "History",
                "Basic Accounting/Commerce",
            ],
        },
        "after12th": {
            "entranceExams": ["NCHMCT JEE", "Institute-level Entrance Exams"],
        },
        "courses": {
            "BHM": {
                "name": "Bachelor of Hotel Management (BHM)",
                "duration": "3-4 years",
                "specializations": [
                    "Hotel Operations",
                    "Food & Beverage",
                    "Event Management",
                ],
                "keySubjects": [
                    "Hospitality Management",
                    "Tourism Studies",
                    "Culinary Arts",
                ],
                "careerPaths": {
                    "industries": ["Hotels", "Cruise Lines", "Travel Agencies"],
                    "jobRoles": ["Hotel Manager", "Event Manager", "Travel Consultant"],
                    "governmentExams": [],
                    "entrepreneurialOptions": ["Hotel Startup", "Travel Agency"],
                    "higherEducation": [
                        "MBA Hospitality",
                        "Diplomas in Tourism Management",
                    ],
                },
            },
        },
    },
    {
        "careerField": "Agriculture & Allied Sciences",
        "after10th": {
            "recommendedStream": "Science/Arts",
            "subjects": ["Biology", "Chemistry", "Physics", "Agriculture Studies"],
        },
        "after12th": {
            "entranceExams": ["ICAR AIEEA", "State Agriculture Entrance Exams"],
        },
        "courses": {
            "B.Sc Agriculture": {
                "name": "B.Sc Agriculture",
                "duration": "4 years",
                "specializations": ["Horticulture", "Agronomy", "Soil Science"],
                "keySubjects": [
                    "Plant Science",
                    "Soil Science",
                    "Agricultural Economics",
                ],
                "careerPaths": {
                    "industries": ["Farming", "Agri-business", "Research"],
                    "jobRoles": ["Agronomist", "Soil Scientist", "Farm Manager"],
                    "governmentExams": ["ICAR NET", "State Agriculture Jobs"],
                    "entrepreneurialOptions": ["Organic Farm", "Agri-Tech Startup"],
                    "higherEducation": ["M.Sc Agriculture", "PhD Agriculture"],
                },
            },
        },
    },
    {
        "careerField": "Media, Content & Performing Arts",
        "after10th": {
            "recommendedStream": "Arts",
            "subjects": ["English", "History", "Media Studies", "Optional Arts"],
        },
        "after12th": {
            "entranceExams": ["Film Institutes", "Media Schools", "CUET Arts"],
        },
        "courses": {
            "B.A. Mass Communication": {
                "name": "B.A. Mass Communication",
                "duration": "3 years",
                "specializations": ["Journalism", "Digital Media", "Advertising"],
                "keySubjects": [
                    "Media Studies",
                    "Communication Theory",
                    "Content Creation",
                ],
                "careerPaths": {
                    "industries": ["Media", "Broadcasting", "Digital Marketing"],
                    "jobRoles": ["Journalist", "Content Creator", "PR Executive"],
                    "governmentExams": ["Press Information Officer Exams"],
                    "entrepreneurialOptions": [
                        "Digital Media Agency",
                        "Content Studio",
                    ],
                    "higherEducation": [
                        "MA Mass Communication",
                        "MBA Media Management",
                    ],
                },
            },
            "BFA Performing Arts": {
                "name": "BFA Performing Arts",
                "duration": "3-4 years",
                "specializations": ["Dance", "Music", "Theater"],
                "keySubjects": ["Performance Studies", "Theater Arts", "Music Theory"],
                "careerPaths": {
                    "industries": ["Theater", "Film", "Music Industry"],
                    "jobRoles": ["Performer", "Music Teacher", "Stage Manager"],
                    "governmentExams": [
                        "State Cultural Jobs",
                        "National Scholarships for Arts",
                    ],
                    "entrepreneurialOptions": [
                        "Dance/Music School",
                        "Performance Troupe",
                    ],
                    "higherEducation": ["MFA", "PhD Performing Arts"],
                },
            },
        },
    },
    {
        "careerField": "Environmental Science & Sustainability",
        "after10th": {
            "recommendedStream": "Science",
            "subjects": ["Biology", "Chemistry", "Physics", "Geography"],
        },
        "after12th": {
            "entranceExams": [
                "IIT JEE (for environmental engineering)",
                "State University Entrance",
            ],
        },
        "courses": {
            "B.Sc Environmental Science": {
                "name": "B.Sc Environmental Science",
                "duration": "3 years",
                "specializations": [
                    "Ecology",
                    "Climate Science",
                    "Sustainable Development",
                ],
                "keySubjects": [
                    "Environmental Chemistry",
                    "Ecology",
                    "Pollution Management",
                ],
                "careerPaths": {
                    "industries": ["NGOs", "Environmental Consultancy", "Government"],
                    "jobRoles": [
                        "Environmental Analyst",
                        "Sustainability Consultant",
                        "Researcher",
                    ],
                    "governmentExams": [
                        "UPSC Environmental Services",
                        "State PSC Environment",
                    ],
                    "entrepreneurialOptions": [
                        "Eco-consultancy",
                        "Sustainable Solutions Startup",
                    ],
                    "higherEducation": [
                        "M.Sc Environmental Science",
                        "MBA Sustainability",
                    ],
                },
            },
        },
    },
]
