import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var Question = [
  {
    "id": 1,
    "difficultyLevel": 1,
    "subjectType": "Biology",
    "tossup_question":
        "1) BIOLOGY  The common cold is an infection caused by which of the following?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions": "W) Virus\nX) Bacteria\nY) Fungi\nZ) Protist",
    "tossup_answer": "ANSWER: W) Virus",
    "tossup_imageURL": null,
    "bonus_question":
        "1) BIOLOGY  A mammalian cell is enucleated, what is the most likely identity of this cell?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: Erythrocyte",
    "bonus_image": null
  },
  {
    "id": 2,
    "difficultyLevel": 1,
    "subjectType": "Biology",
    "tossup_question":
        "6) BIOLOGY  What organelle is responsible for the creation of proteins?",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: Ribosome",
    "tossup_imageURL": null,
    "bonus_question":
        "6) BIOLOGY  If you mark a tree at 20 ft, and subsequently the tree grows 15 ft, how high is the original mark?",
    "bonus_isShortAns": false,
    "bonus_MCQoptions": "W) 20 ft\nX) 25 ft\nY) 30 ft\nZ) 35 ft",
    "bonus_answer": "ANSWER: W) 20 ft",
    "bonus_image": null
  },
  {
    "id": 3,
    "difficultyLevel": 1,
    "subjectType": "Biology",
    "tossup_question": "11) BIOLOGY  What type of bacteria is circular shaped?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions": "W) Bacillus\nX) Spirillum\nY) Coccus\nZ) Icosahedral",
    "tossup_answer": "ANSWER: Y) Coccus",
    "tossup_imageURL": null,
    "bonus_question": "11) BIOLOGY  Which part of the flower produces pollen",
    "bonus_isShortAns": false,
    "bonus_MCQoptions": "W) Filament\nX) Anther\nY) Stigma\nZ) Ovary",
    "bonus_answer": "ANSWER: X) Anther",
    "bonus_image": null
  },
  {
    "id": 4,
    "difficultyLevel": 1,
    "subjectType": "Biology",
    "tossup_question": "16) BIOLOGY  From what organ does insulin come?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions": "W) Liver\nX) Pancreas\nY) Heart \nZ) Lungs",
    "tossup_answer": "ANSWER: X) Pancreas",
    "tossup_imageURL": null,
    "bonus_question":
        "16) BIOLOGY  What molecule, consisting of a modified adenine nucleotide and three phosphates, is used as an energy source by all organisms?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: ATP (Adenosine triphosphate)",
    "bonus_image": null
  },
  {
    "id": 5,
    "difficultyLevel": 1,
    "subjectType": "Biology",
    "tossup_question":
        "21) BIOLOGY  During what phase of mitosis does the replicating cell begin to separate sister chromatids?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions": "W) Prophase\nX) Metaphase\nY) Anaphase\nZ) Telophase",
    "tossup_answer": "ANSWER: Y) Anaphase",
    "tossup_imageURL": null,
    "bonus_question":
        "21) BIOLOGY  After mitosis occurs, what process ultimately splits the two daughter cells into two individual cells?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: Cytokinesis",
    "bonus_image": null
  },
  {
    "id": 1,
    "difficultyLevel": 1,
    "subjectType": "Chemistry",
    "tossup_question": "4) CHEMISTRY  What is the atomic number of oxygen? ",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: 8",
    "tossup_imageURL": null,
    "bonus_question":
        "4) CHEMISTRY  Which of the following particles is not found in a carbon atom?",
    "bonus_isShortAns": false,
    "bonus_MCQoptions": "W) Photon\nX) Neutron\nY) Proton\nZ) Electron",
    "bonus_answer": "ANSWER: W) Photon",
    "bonus_image": null
  },
  {
    "id": 2,
    "difficultyLevel": 1,
    "subjectType": "Chemistry",
    "tossup_question":
        "9) CHEMISTRY  Which of the following elements is a liquid at room temperature?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions": "W) Oxygen\nX) Carbon\nY) Gold\nZ) Mercury",
    "tossup_answer": "ANSWER: Z) Mercury",
    "tossup_imageURL": null,
    "bonus_question":
        "9) CHEMISTRY  How many atoms are in a single molecule of fluorine gas?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: 2",
    "bonus_image": null
  },
  {
    "id": 3,
    "difficultyLevel": 1,
    "subjectType": "Chemistry",
    "tossup_question":
        "14) CHEMISTRY  How many times more acidic is a pH of 4 than a pH of 6?",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: 100",
    "tossup_imageURL": null,
    "bonus_question": "14) CHEMISTRY  What is the charge of the phosphate ion?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: -3",
    "bonus_image": null
  },
  {
    "id": 4,
    "difficultyLevel": 1,
    "subjectType": "Chemistry",
    "tossup_question":
        "19) CHEMISTRY  Which of the following species is an acid?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions": "W) N2\nX) CH4\nY) CaCO3\nZ) H2SO4",
    "tossup_answer": "ANSWER: Z) H2SO4",
    "tossup_imageURL": null,
    "bonus_question":
        "19) CHEMISTRY  Ionization involves the removal of what fundamental particle from an atom?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: Electron",
    "bonus_image": null
  },
  {
    "id": 5,
    "difficultyLevel": 1,
    "subjectType": "Chemistry",
    "tossup_question":
        "24) CHEMISTRY  Which of the following is a chemical property of a substance?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions":
        "W) Melting point\nX) Density\nY) Color\nZ) Flammability",
    "tossup_answer": "ANSWER: Z) Flammability",
    "tossup_imageURL": null,
    "bonus_question":
        "24) CHEMISTRY  Propane is a gas with formula C3H8. What are the products of the combustion of propane in oxygen gas?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: Carbon dioxide and water",
    "bonus_image": null
  },
  {
    "id": 1,
    "difficultyLevel": 1,
    "subjectType": "Earth_and_Space",
    "tossup_question":
        "5) EARTH AND SPACE  Plate tectonics is driven by which of the following?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions":
        "W) Convection under the Earth\u2019s surface\nX) Conduction under the Earth\u2019s surface\nY) Radiation under the Earth\u2019s surface\nZ) Advection under the Earth\u2019s surface",
    "tossup_answer": "ANSWER: W) Convection under the Earth\u2019s surface",
    "tossup_imageURL": null,
    "bonus_question": "5) EARTH AND SPACE  What type of rock is sandstone?",
    "bonus_isShortAns": false,
    "bonus_MCQoptions":
        "W) Igneous\nX) Sedimentary\nY) Metamorphic\nZ) Mineral",
    "bonus_answer": "ANSWER: X) Sedimentary",
    "bonus_image": null
  },
  {
    "id": 2,
    "difficultyLevel": 1,
    "subjectType": "Earth_and_Space",
    "tossup_question":
        "10) EARTH AND SPACE  Which of the following is a type of precipitation where chunks of ice fall out the sky in solid form, often with multiple layers from intense updrafts in thunderstorms?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions": "W) Rain\nX) Sleet\nY) Glaze\nZ) Hail",
    "tossup_answer": "ANSWER: Z) Hail",
    "tossup_imageURL": null,
    "bonus_question":
        "10) EARTH AND SPACE  Order the following sediments in terms of grain size, from smallest to largest:",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: II, I, III",
    "bonus_image": null
  },
  {
    "id": 3,
    "difficultyLevel": 1,
    "subjectType": "Earth_and_Space",
    "tossup_question":
        "15) EARTH AND SPACE  The Coriolis effect is caused by which of the following?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions":
        "W) Earth\u2019s revolution\nX) Earth\u2019s rotation\nY) Earth\u2019s tilt\nZ) The Moon",
    "tossup_answer": "ANSWER: X) Earth\u2019s rotation",
    "tossup_imageURL": null,
    "bonus_question":
        "15) EARTH AND SPACE  Which of the following would increase air pressure?",
    "bonus_isShortAns": false,
    "bonus_MCQoptions":
        "W) Increasing temperature\nX) Decreasing altitude\nY) Increasing humidity\nZ) Decreasing gravity",
    "bonus_answer": "ANSWER: X) Decreasing altitude",
    "bonus_image": null
  },
  {
    "id": 4,
    "difficultyLevel": 1,
    "subjectType": "Earth_and_Space",
    "tossup_question":
        "20) EARTH AND SPACE  Which of the following ocean currents is warm?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions":
        "W) California Current\nX) North Pacific Current\nY) Antarctic Circumpolar Current\nZ) Gulf Stream",
    "tossup_answer": "ANSWER: Z) Gulf Stream",
    "tossup_imageURL": null,
    "bonus_question":
        "20) EARTH AND SPACE  Name which of the following three options are minerals:",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: I, III",
    "bonus_image": null
  },
  {
    "id": 5,
    "difficultyLevel": 1,
    "subjectType": "Earth_and_Space",
    "tossup_question":
        "25) EARTH AND SPACE  While you conduct a survey of the surrounding area after a volcanic eruption, which of the following rocks would you most likely encounter?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions": "W) Shale\nX) Slate\nY) Obsidian\nZ) Lignite",
    "tossup_answer": "ANSWER: Y) Obsidian",
    "tossup_imageURL": null,
    "bonus_question":
        "25) EARTH AND SPACE  While surveying the area, you noticed that the top of the volcano has collapsed, forming a large crater with a minimum diameter of 1 km. What would this crater be called?",
    "bonus_isShortAns": false,
    "bonus_MCQoptions": "W) Caldera\nX) Cirque\nY) Fumarole\nZ) Playa ",
    "bonus_answer": "ANSWER: W) Caldera ",
    "bonus_image": null
  },
  {
    "id": 1,
    "difficultyLevel": 1,
    "subjectType": "Math",
    "tossup_question":
        "2) MATH  Anka is creating an outfit out of hats and scarves. If she has 4 different hats and 5 different scarves, how many outfits can she make if she must choose one hat and one scarf?",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: 20",
    "tossup_imageURL": null,
    "bonus_question":
        "2) MATH  What is the sum of all odd integers between 1 and 11, inclusive?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: 36",
    "bonus_image": null
  },
  {
    "id": 2,
    "difficultyLevel": 1,
    "subjectType": "Math",
    "tossup_question": "7) MATH  Evaluate the following: 2(4+2)2",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: 72",
    "tossup_imageURL": null,
    "bonus_question":
        "7) MATH  Evaluate the following: 2cos(x)+7 when x=90\u0970",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: 9",
    "bonus_image": null
  },
  {
    "id": 3,
    "difficultyLevel": 1,
    "subjectType": "Math",
    "tossup_question":
        "12) MATH  What is the slope of the following line: 3x+4y=12",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: -3/4",
    "tossup_imageURL": null,
    "bonus_question":
        "12) MATH  Which of the following lines is perpendicular to 5x+2y=10?",
    "bonus_isShortAns": false,
    "bonus_MCQoptions":
        "W) y=(2x/5)+7\nX) y=(-2x/5)+9\nY) y=(5x/2)+11\nZ) y=(-5x/2)+13",
    "bonus_answer": "ANSWER: W) y=(2x/5)+7",
    "bonus_image": null
  },
  {
    "id": 4,
    "difficultyLevel": 1,
    "subjectType": "Math",
    "tossup_question":
        "17) MATH  How many different ways are there to arrange four distinct people around a circle?",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: 6",
    "tossup_imageURL": null,
    "bonus_question":
        "17) MATH  What is the probability that of the first two cards drawn out of a standard deck, at least one of the cards drawn is red?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: 23/26",
    "bonus_image": null
  },
  {
    "id": 5,
    "difficultyLevel": 1,
    "subjectType": "Math",
    "tossup_question":
        "22) MATH  In terms of pi, what is the area of a circle with a diameter of 10?",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: 25pi",
    "tossup_imageURL": null,
    "bonus_question":
        "22) MATH  What is the most common sum from rolling four number cubes?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: 14",
    "bonus_image": null
  },
  {
    "id": 1,
    "difficultyLevel": 1,
    "subjectType": "Physics",
    "tossup_question":
        "3) PHYSICS  What force perpendicular to a surface is responsible for keeping objects on the surface?",
    "tossup_isShortAns": false,
    "tossup_MCQoptions":
        "W) Friction\nX) Normal Force\nY) Gravity\nZ) Buoyancy",
    "tossup_answer": "ANSWER: X) Normal force",
    "tossup_imageURL": null,
    "bonus_question":
        "3) PHYSICS  A 10 kilogram ball is rolled along a frictionless surface at a constant velocity of 6 meters per second. What is the linear momentum of the ball?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: 60 kilograms meters per second",
    "bonus_image": null
  },
  {
    "id": 2,
    "difficultyLevel": 1,
    "subjectType": "Physics",
    "tossup_question":
        "8) PHYSICS  What type of heat transfer is the only type that cannot occur between solid objects? ",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: Convection",
    "tossup_imageURL": null,
    "bonus_question":
        "8) PHYSICS  What is the work done by lifting a 2 kilogram mass up by 6 meters? Assume that g = 10 m/s^2",
    "bonus_isShortAns": false,
    "bonus_MCQoptions":
        "W) 12   joules\nX)  60 joules\nY)  120 joules\nZ)  600 joules",
    "bonus_answer": "ANSWER: Y) 120 joules",
    "bonus_image": null
  },
  {
    "id": 3,
    "difficultyLevel": 1,
    "subjectType": "Physics",
    "tossup_question":
        "13) PHYSICS  The existence of the nucleus was shown by the bombardment of gold atoms with what particles?",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: Alpha particles",
    "tossup_imageURL": null,
    "bonus_question":
        "13) PHYSICS  Consider a circuit with resistors of equal resistance in parallel. What is the effect on the total resistance of the circuit if another equivalent resistor is added?",
    "bonus_isShortAns": false,
    "bonus_MCQoptions":
        "W) Increase\nX) Decrease\nY) No change\nZ) Depends on the resistance",
    "bonus_answer": "ANSWER: X) Decrease",
    "bonus_image": null
  },
  {
    "id": 4,
    "difficultyLevel": 1,
    "subjectType": "Physics",
    "tossup_question":
        "18) PHYSICS  What quantity is conserved in elastic collisions that makes them unique from inelastic collisions?",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: Kinetic energy",
    "tossup_imageURL": null,
    "bonus_question":
        "18) PHYSICS  Arrange the following three substances in order of increasing refractive index.",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: 3, 2, 1",
    "bonus_image": null
  },
  {
    "id": 5,
    "difficultyLevel": 1,
    "subjectType": "Physics",
    "tossup_question":
        "23) PHYSICS  If a force of 8 Newtons is applied to a 4 kg block for 6 seconds, what is the change in the block\u2019s momentum? ",
    "tossup_isShortAns": true,
    "tossup_MCQoptions": null,
    "tossup_answer": "ANSWER: 48 (Kg m/s)",
    "tossup_imageURL": null,
    "bonus_question":
        "23) PHYSICS  A 100 kilogram truck at an initial velocity of 5 meters per second and a constant acceleration of 2 meters per second squared slams into a wall and decelerates to rest in t seconds. What is the value of t?",
    "bonus_isShortAns": true,
    "bonus_MCQoptions": null,
    "bonus_answer": "ANSWER: 2.5",
    "bonus_image": null
  }
];

//void main() => runApp(new MediaQuery(
//    data: new MediaQueryData(), child: new MaterialApp(home: new MyApp())));

class MyApp extends StatelessWidget {
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireStore Demo'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text('Create Record'),
            onPressed: () {
              createRecord();
            },
          ),
        ],
      )), //center
    );
  }

  void createRecord() {
    Question.forEach((obj) async {
      await databaseReference.collection("Question").add(obj);
    });
  }
}
