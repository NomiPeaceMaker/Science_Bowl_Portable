import docx
import os
import time
import math
import json
from random import shuffle

# to make this file run make sure to download the file dependencies (the imports)

subjectList = ['Biology','Math','Physics','Chemistry','Earth and Space']
questionType = ['Multiple Choice', 'Short Answer']


class qstruct:                          # Question Structure
    def __init__(self):
        self.qtype = 'none'             # TOSS-UP or BONUS
        self.form = 'none'              # MCQ or Short Answer
        self.subtype ='none'            # BIOLOGY, CHEMISTRY ...
        self.qbody ='none'              # What is 2+2?
        self.ansOption = 'none'         # W) 0      X) 1        Y) 2        Z) 3  
        self.answer = 'none'            # ANSWER: 2
        self.level = -1          # difficulty level: 0 -> middle, 1 -> highschool

class question:                         # A question has a TOSS-UP and a BONUS
    def __init__(self):              
        self.tossUp = qstruct()
        self.bonus = qstruct()
        self.bonusSwitch = False

# input question and question number to convert to JSON obj -> Output JSON 
''' 
Format:

ID                      --> QuestionNumber
difficultyLevel         --> 0 for middleSchool, 1 for highschool 
subjectType             --> one from ['Biology','Math','Physics','Chemistry','Earth and Space'] for high school

tossup_question         --> 'What is 2+2?'
tossup_isShortAns       --> False
tossup_MCQoptions       --> W) 1      X) 2        Y) 3        Z) 4 
tossup_answer           --> Z) 4
tossup_imageURL         --> None

bonus_question          
bonus_isShortAns
bonus_MCQoptions
bonus_answer
bonus_image
'''

def outjson(question, QuestionNumber):
    jsonQuestion = {}
    
    jsonQuestion['id']                  = QuestionNumber
    jsonQuestion['difficultyLevel']     = question.tossUp.level
    
    if question.tossUp.subtype == 'Earth and Space':
        question.tossUp.subtype = 'Earth_and_Space'

    jsonQuestion['subjectType']         = question.tossUp.subtype

    jsonQuestion['tossup_question']     = question.tossUp.qbody
    jsonQuestion['tossup_isShortAns']   = True if (question.tossUp.form == 'Short Answer') else False 
    jsonQuestion['tossup_MCQoptions']   = None if (question.tossUp.ansOption == 'none') else question.tossUp.ansOption 
    jsonQuestion['tossup_answer']       = question.tossUp.answer
    jsonQuestion['tossup_imageURL']     = None
    
    jsonQuestion['bonus_question']      = question.bonus.qbody
    jsonQuestion['bonus_isShortAns']    = True if (question.bonus.form == 'Short Answer') else False 
    jsonQuestion['bonus_MCQoptions']    = None if (question.bonus.ansOption == 'none') else question.bonus.ansOption
    jsonQuestion['bonus_answer']        = question.bonus.answer
    jsonQuestion['bonus_image']         = None

    dir = './jsonQuestions/'

    if not os.path.isdir(dir):
        print('Making directory ', dir)
        os.makedirs(dir)

    filename = question.tossUp.subtype + '_' + str(QuestionNumber) + '.json'
    with open(dir + filename,'w') as json_file:
        json.dump(jsonQuestion, json_file)

# remove everything after and including the word answer
def sanitize_ansOption(ansOption):
    pos = ansOption.find('ANSWER:')
    
    if pos != -1:
        return ansOption[:pos]
    else:
        return ansOption

# remove everything before the word answer
def sanitize_answer(ans):
    pos = ans.find('ANSWER:')
    
    if pos != -1:
        return ans[pos:]
    else:
        return ans

def putLevel(level, demo, easyList, hardList):
    if level == 0:
        easyList.append(demo)
    elif level == 1:
        hardList.append(demo)

def askDifficulty(sub,easy, hard,level) :
    if level == 0:
        return easy
    else:
        return hard                
    

def chicken():
    print("      __//")
    print("    /.__.\\")
    print("    \\ \\/ /")
    print(" '__/    \\")
    print("  \\-      )")
    print("   \\_____/")
    print("_____|_|____")
    print('     " "')

def byeChicken():
    print("\t\t      __// Bye Bye")
    print("\t\t    /.__.\\")
    print("\t\t    \\ \\/ /")
    print("\t\t '__/    \\")
    print("\t\t  \\-      )")
    print("\t\t   \\_____/")
    print("\t\t_____|_|____")
    print('\t\t     " "')

def main():
    
    print("Please make sure any docx file that will be written to is closed before using this program.")
    chicken()
    # Question list contains all the question objects
    Qlist = []
 
    # Subject Lists
    phyList_easy     = []
    phyList_hard     = []
    chemList_easy    = []
    chemList_hard    = []
    bioList_easy     = []
    bioList_hard     = []
    mathList_easy    = []
    mathList_hard    = []
    EnSList_easy     = []
    EnSList_hard     = []
    
    # lists that help categorise questions
    global subjectList
    global questionType


    print("\n============Input Sequence============\n")
    print("Gobble gobble. Here's what I've found in this directory:")
    directory = []
    filesRead = []

    for file in os.listdir():
        _, e = os.path.splitext(file)
        if e == ".docx" and file not in filesRead:
            directory.append(file)
    
    for i, file in enumerate(directory):
        print(i,": ", file)
    
        incorrectAns = True
        while incorrectAns:
            try:
                ch_dir = int(input("Please input the number of the file you want me to eat (select index) OR input -1 to move to next sequnce: "))
                if ch_dir == -1:
                    break

                input_filename = directory[ch_dir]

                if input_filename in filesRead:
                    print("WARNING: You've already read this file.")
                    ch = input("Are you sure you want to continue? Input 'y' if you really want to do this:")
                    if ch == 'y' or ch == 'Y':
                        print("That's not weird at all.")
                        incorrectAns = False
                    else:
                        print("trying again")
                else:
                    incorrectAns = False
                        
            except IndexError:
                print("ERROR: Please select the an in range index.")
                continue
            except ValueError:
                print("ERROR: Please input integers only.")
                continue
            
            if ch_dir == -1:
                break
            
            filesRead.append(input_filename)
        
    incorrectAns = True
    while incorrectAns:
        try:
            level_sel = int(input("How difficult are these questions? (input 0 for easy, 1 for hard):"))
        except ValueError:
            print("ERROR: Please input integers only.")
            continue

        if level_sel == 0:
            level = 0
            incorrectAns = False
        elif level_sel == 1:
            level = 1
            incorrectAns = False
        else:
            print("Please try again")

    inDoc = docx.Document(input_filename)
    
    tossUpEncounter = False
    
    # mcqflag = False

    for _, para in enumerate(inDoc.paragraphs):
        txt = para.text

        if 'TOSS-UP' in txt:                #  signals the start of a new question
            demo = question()
            tossUpEncounter = True           
            demo.tossUp.qtype = txt
            demo.tossUp.level = level

        if tossUpEncounter == False:
            continue
        
        elif 'BONUS' in txt:                #   initiates making bonus
            demo.bonusSwitch = True
            demo.bonus.qtype = txt
            demo.bonus.level = level

        if not demo.bonusSwitch:            #  tossUp question
            
            if 'W)' in txt and 'X)' in txt:
                demo.tossUp.ansOption = sanitize_ansOption(txt)
                #continue
            if 'ANSWER' in txt:
                demo.tossUp.answer = sanitize_answer(txt)
                #continue
            for _, sub in enumerate(subjectList):
                if sub.lower() in txt.lower():
                    demo.tossUp.subtype = sub
                    break
            for _, ques in enumerate(questionType):
                if ques.lower() in txt.lower():
                    demo.tossUp.form = ques

                    body = txt
                    body = body.replace(demo.tossUp.subtype,'', 1)
                    body = body.replace(ques,'',1)

                    demo.tossUp.qbody = body
                    break

        else:
            if 'W)' in txt and 'X)' in txt:
                demo.bonus.ansOption = sanitize_ansOption(txt)
                
            if 'ANSWER' in txt:
                demo.bonus.answer = sanitize_answer(txt)
                
                # Master List
                Qlist.append(demo)
                
                if 'Biology' in demo.tossUp.subtype:
                    putLevel(level,demo,bioList_easy,bioList_hard)
                    
                if 'Math' in demo.tossUp.subtype:
                    putLevel(level,demo,mathList_easy,mathList_hard)
                
                if 'Physics' in demo.tossUp.subtype:
                    putLevel(level,demo,phyList_easy,phyList_hard)
                
                if 'Chemistry' in demo.tossUp.subtype:
                    putLevel(level,demo,chemList_easy,chemList_hard)

                if 'Earth and Space' in demo.tossUp.subtype:
                    putLevel(level,demo,EnSList_easy,EnSList_hard)

                #continue
            for _, sub in enumerate(subjectList):
                if sub.lower() in txt.lower():
                    demo.bonus.subtype = sub
                    #print("subject found", sub)
                    break
            for _, ques in enumerate(questionType):
                if ques.lower() in txt.lower():
                    demo.bonus.form = ques
                    #print("form found", ques)

                    body = txt
                    body = body.replace(demo.bonus.subtype,'')
                    body = body.replace(ques,'')

                    demo.bonus.qbody = body
                    #print("body found", body)
                    break
    os.system('cls')
    print(len(Qlist), "total questions found!")
    print()
    print("\t","Easy\t", "Hard")
    print("Bio:\t", len(bioList_easy),"\t", len(bioList_hard))
    print("Chem:\t", len(chemList_easy), "\t", len(chemList_hard))
    print("Math:\t", len(mathList_easy), "\t",len(mathList_hard))
    print("Phys:\t", len(phyList_easy), "\t",len(phyList_hard))
    print("EnS:\t", len(EnSList_easy), "\t",len(EnSList_hard))
    

    # os.system('cls')
    
    out_count = 0
        
    # difficulty level
    phyList     = askDifficulty("PHYSICS", phyList_easy,phyList_hard,level)
    chemList    = askDifficulty("CHEMISTRY", chemList_easy,chemList_hard,level)
    bioList     = askDifficulty("BIOLOGY", bioList_easy,bioList_hard,level)
    mathList    = askDifficulty("MATH",mathList_easy,mathList_hard,level)
    EnSList     = askDifficulty("EARTH AND SPACE",EnSList_easy,EnSList_hard,level)
    
        
    # Count of questions
    bio_count   = 0 
    chem_count  = 0
    phy_count   = 0
    math_count  = 0
    EnS_count   = 0
    

    while len(phyList) or len(chemList) or len(bioList) or len(mathList) or len(EnSList):
            
        if len(phyList):
            phy_count += 1
            obj = phyList.pop(0)
            Qlist.remove(obj)
            outjson(obj,phy_count)
            out_count += 1
        
        if len(chemList):
            chem_count += 1
            obj = chemList.pop(0)
            Qlist.remove(obj)
            outjson(obj,chem_count)
            out_count += 1

        if len(bioList):
            bio_count += 1 
            obj = bioList.pop(0)
            Qlist.remove(obj)
            outjson(obj,bio_count)
            out_count += 1

        if len(mathList):
            math_count += 1
            obj = mathList.pop(0)
            Qlist.remove(obj)
            outjson(obj,math_count)
            out_count += 1

        if len(EnSList): 
            EnS_count += 1
            obj = EnSList.pop(0)
            Qlist.remove(obj)
            outjson(obj,EnS_count)
            out_count += 1

    print("Outputting\n",bio_count,"bio quesitons\n",chem_count,"chem quesitons\n",phy_count,"phy quesitons\n",math_count,"math quesitons\n",EnS_count,"EnS quesitons",)         

        
          
  
    
main()
