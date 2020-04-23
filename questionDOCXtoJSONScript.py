import docx
import os
import time
import math
import json
from docx.shared import Pt
from docx.enum.text import WD_ALIGN_PARAGRAPH
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
        self.level = 'none'              # difficulty level: 1 -> easy, 2 -> hard

class question:                         # A question has a TOSS-UP and a BONUS
    def __init__(self):              
        self.tossUp = qstruct()
        self.bonus = qstruct()
        self.bonusSwitch = False

# input question and question number to convert to JSON obj -> Output JSON 
''' 
Format:

ID                      --> QuestionNumber
Difficultylevel         --> 0 for middleSchool, 1 for highschool 
subjecttype             --> one from ['Biology','Math','Physics','Chemistry','Earth and Space'] for high school

tossup_question         --> 'What is 2+2?'
tossup_isShortAns       --> True
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
    
    question.tossUp.



# input qstruct and the doc -> output qstruct on     
def out_qstruct(q,outDoc):
    
    # Output 'TOSS-UP' or 'BONUS'
    qtype = outDoc.add_paragraph()
    qtype.add_run(q.qtype).bold = True
    qtype_format = qtype.paragraph_format
    qtype_format.alignment = WD_ALIGN_PARAGRAPH.CENTER

    # Output question body
    qbody = outDoc.add_paragraph()
    qbody.add_run(q.subtype)
    qbody.add_run(' - ')
    qbody.add_run(q.form).italic = True
    qbody.add_run(' ')
    qbody.add_run(q.qbody)

    # Output ansOptions if any
    if q.ansOption != 'none':
        outDoc.add_paragraph(q.ansOption)
    
    # Output Answer
    outDoc.add_paragraph(q.answer)
    
    level = "LEVEL: " + q.level
    lvl = outDoc.add_paragraph(level)
    lvl_format = lvl.paragraph_format
    lvl_format.alignment = WD_ALIGN_PARAGRAPH.RIGHT

def out_question(questionObj,outDoc):
    out_qstruct(questionObj.tossUp,outDoc)
    out_qstruct(questionObj.bonus,outDoc)
    outDoc.add_page_break()

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
    if level == "EASY":
        easyList.append(demo)
    elif level == "HARD":
        hardList.append(demo)

def askDifficulty(sub,easy, hard) :
    print("for", sub)

    while True:
        try:
            level_sel = int(input("How difficult do you want questions to be? (input 1 for easy, 2 for hard):"))
        except ValueError:
            print("ERROR: Please input integers only.")
            continue

        if level_sel == 1:
            return easy
        elif level_sel == 2:
            return hard                
        else:
            print("Please try again")

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

    # Input File
    unUsedStoreUsed = False

    if os.path.isfile('&unusedQuestions.docx'):
        print("I've found an unused questions store in the directory.\nIf you're continuing the same tourny it is recommended you start the unused file sequence.")
        unusedSeq = input("Input 'y' to start unused file sequence else press anything to continue to eat sequence:")
        if unusedSeq == 'y' or unusedSeq == 'Y':
            unUsedStoreUsed = True
            print("\n============Unused Question Sequence============\n")
            inDoc = docx.Document('&unusedQuestions.docx')
            for _, para in enumerate(inDoc.paragraphs):
                txt = para.text

                if 'TOSS-UP' in txt:                #  signals the start of a new question
                    demo = question()           
                    demo.tossUp.qtype = txt
                    levelset = False

                elif 'BONUS' in txt:                #   initiates making bonus
                    demo.bonusSwitch = True
                    demo.bonus.qtype = txt

                if not demo.bonusSwitch:            #  tossUp question
                    
                    if 'W)' in txt and 'X)' in txt:
                        demo.tossUp.ansOption = sanitize_ansOption(txt)
                        #continue
                    if 'LEVEL: EASY' in txt:
                        demo.tossUp.level = "EASY"
                    if 'LEVEL: HARD' in txt:
                        demo.tossUp.level = "HARD"
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
                        #continue
                        pass
                    if 'ANSWER' in txt:
                        demo.bonus.answer = sanitize_answer(txt)
                        
                        # Master List
                    if 'LEVEL: EASY' in txt:
                        demo.bonus.level = "EASY"
                        levelset = True
                    if 'LEVEL: HARD' in txt:
                        demo.bonus.level = "HARD"
                        levelset = True
                    
                    if levelset:
                        levelset = False
                        Qlist.append(demo)

                        if 'Biology' in demo.tossUp.subtype:
                            if demo.tossUp.level == "EASY":
                                bioList_easy.append(demo)
                            elif demo.tossUp.level == "HARD":
                                bioList_hard.append(demo)
                        
                        if 'Math' in demo.tossUp.subtype:
                            if demo.tossUp.level == "EASY":
                                mathList_easy.append(demo)
                            elif demo.tossUp.level == "HARD":
                                mathList_hard.append(demo)
                        
                        if 'Physics' in demo.tossUp.subtype:
                            if demo.tossUp.level == "EASY":
                                phyList_easy.append(demo)
                            elif demo.tossUp.level == "HARD":
                                phyList_hard.append(demo)
                        
                        if 'Chemistry' in demo.tossUp.subtype:
                            if demo.tossUp.level == "EASY":
                                chemList_easy.append(demo)
                            elif demo.tossUp.level == "HARD":
                                chemList_hard.append(demo)
                        
                        if 'Earth and Space' in demo.tossUp.subtype:
                            if demo.tossUp.level == "EASY":
                                EnSList_easy.append(demo)
                            elif demo.tossUp.level == "HARD":
                                EnSList_hard.append(demo)
                    
                   

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
    
    filesRead = []
    while 1 and not unUsedStoreUsed:
        print("\n============Input Sequence============\n")
        print("Gobble gobble. Here's what I've found in this directory:")
        directory = []

        for file in os.listdir():
            if file == "&unusedQuestions.docx":
                continue

            _, e = os.path.splitext(file)
            if e == ".docx":
                directory.append(file)
        
        for i, file in enumerate(directory):
            print(i,": ", file)

        if not unUsedStoreUsed:
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
                    level_sel = int(input("How difficult are these questions? (input 1 for easy, 2 for hard):"))
                except ValueError:
                    print("ERROR: Please input integers only.")
                    continue

                if level_sel == 1:
                    level = "EASY"
                    incorrectAns = False
                elif level_sel == 2:
                    level = "HARD"
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
        
    

    # Randomize Questions
    print("\n(~'^')~ Shuffling Questions...", end =" ")
    
    # shuffle(phyList_easy)
    # shuffle(phyList_hard)
    
    # shuffle(chemList_easy)
    # shuffle(chemList_hard)

    # shuffle(bioList_easy)
    # shuffle(bioList_hard)
    
    # shuffle(mathList_easy)
    # shuffle(mathList_hard)
    
    # shuffle(EnSList_easy)
    # shuffle(EnSList_hard)
    
    time.sleep(1)
    print("done\n")
    
    nextRound = True
    
    while nextRound:
        os.system('cls')
        
        if len(Qlist) == 0:
            byeChicken()
            input("No (more) questions found :O. Shocking, how I can't make a round w/o questions. Enter anything to Exit")
            return
            
        print(len(Qlist), "total questions found!")
        print()
        print("\t","Easy\t", "Hard")
        print("Bio:\t", len(bioList_easy),"\t", len(bioList_hard))
        print("Chem:\t", len(chemList_easy), "\t", len(chemList_hard))
        print("Math:\t", len(mathList_easy), "\t",len(mathList_hard))
        print("Phys:\t", len(phyList_easy), "\t",len(phyList_hard))
        print("EnS:\t", len(EnSList_easy), "\t",len(EnSList_hard))
        print("\n============Output Sequence============\n")
        
        
        incorrectAns = True
        choice = 'none'
        while incorrectAns:
            gameName = input("Please input what you would like to call the game file OR input -1 to exit safely: ")

            if gameName == '-1':
                nextRound = False
                break

            if '.docx' not in gameName:
                gameName = gameName + '.docx'
            
            if os.path.isfile(gameName):
                print("WARNING: You will be overwriting a previous file")
                choice = input("Input 'y' if you're sure. Input anything else to retry: ")

                if choice == 'y' or choice == 'Y':
                    incorrectAns = False
            else:
                incorrectAns = False
        
        out_count = 0
        thisGameQs = 0

        if nextRound == True:
            
        # difficulty level
            phyList     = askDifficulty("PHYSICS", phyList_easy,phyList_hard)
            chemList    = askDifficulty("CHEMISTRY", chemList_easy,chemList_hard)
            bioList     = askDifficulty("BIOLOGY", bioList_easy,bioList_hard)
            mathList    = askDifficulty("MATH",mathList_easy,mathList_hard)
            EnSList     = askDifficulty("EARTH AND SPACE",EnSList_easy,EnSList_hard)
            
                
            # Count of questions
            bio_count   = 0 
            chem_count  = 0
            phy_count   = 0
            math_count  = 0
            EnS_count   = 0
            
           
            
            # Output doc
            doc = docx.Document()

            # set document style: Times New Roman with size 12 pt
            style = doc.styles['Normal']
            font = style.font
            font.name = 'Times New Roman'
            font.size = Pt(12)

            incorrectAns = True
            while incorrectAns:
                try:
                    print("\nHow many questions would you like to output?\n(My birdy wisdom is to keep a little extra. You can always recycle unused questions by manually copy-pasting them to the unused file store.)")
                    limit = int(input("Input here: "))
                except ValueError:
                    print("ERROR: Please input integers only.")
                    continue
                if limit > 0:
                    incorrectAns = False
                else:
                    print("Value cannot be zero or below")
            

            print("Attempting to output an even split")
            

            while len(phyList) or len(chemList) or len(bioList) or len(mathList) or len(EnSList):
                if out_count >= limit:
                    break
                    
                if len(phyList):
                    phy_count += 1
                    obj = phyList.pop(0)
                    Qlist.remove(obj)
                    out_question(obj,doc)
                    out_count += 1
                
                if len(chemList):
                    chem_count += 1
                    obj = chemList.pop(0)
                    Qlist.remove(obj)
                    out_question(obj,doc)
                    out_count += 1

                if len(bioList):
                    bio_count += 1 
                    obj = bioList.pop(0)
                    Qlist.remove(obj)
                    out_question(obj,doc)
                    out_count += 1

                if len(mathList):
                    math_count += 1
                    obj = mathList.pop(0)
                    Qlist.remove(obj)
                    out_question(obj,doc)
                    out_count += 1

                if len(EnSList): 
                    EnS_count += 1
                    obj = EnSList.pop(0)
                    Qlist.remove(obj)
                    out_question(obj,doc)
                    out_count += 1

            
        
            thisGameQs = out_count
            print("Game file with ",thisGameQs,"questions made with:")
            print("",bio_count,"bio quesitons\n",chem_count,"chem quesitons\n",phy_count,"phy quesitons\n",math_count,"math quesitons\n",EnS_count,"EnS quesitons",)         
            doc.save(gameName)
        
            ask4Next = input("Do you want to continue to next round? Input 'y' to continue to make next round. Input anything else to exit. ")
            
            if ask4Next == 'y' or ask4Next == 'Y':
                nextRound = True
            else:
                nextRound = False
      
    # Make unusedQuestion doc
    doc = docx.Document()
    style = doc.styles['Normal']
    font = style.font
    font.name = 'Times New Roman'
    font.size = Pt(12)

    print("\nStoring any reserves to unusedQuestion store")
    
    while len(phyList_easy) or len(chemList_easy) or len(bioList_easy) or len(mathList_easy) or len(EnSList_easy) or len(phyList_hard) or len(chemList_hard) or len(bioList_hard) or len(mathList_hard) or len(EnSList_hard):
        if len(phyList_easy):
            obj = phyList_easy.pop(0)
            out_question(obj,doc)
            out_count += 1
        
        if len(phyList_hard):
            obj = phyList_hard.pop(0)
            out_question(obj,doc)
            out_count += 1
            
        if len(chemList_easy):
            obj = chemList_easy.pop(0)
            out_question(obj,doc)
            out_count += 1

        if len(chemList_hard):
            obj = chemList_hard.pop(0)
            out_question(obj,doc)
            out_count += 1
            
        if len(bioList_easy):
            obj = bioList_easy.pop(0)
            out_question(obj,doc)
            out_count += 1
            
        if len(bioList_hard):
            obj = bioList_hard.pop(0)
            out_question(obj,doc)
            out_count += 1

        if len(mathList_easy):
            obj = mathList_easy.pop(0)
            out_question(obj,doc)
            out_count += 1

        if len(mathList_hard):
            obj = mathList_hard.pop(0)
            out_question(obj,doc)
            out_count += 1

        if len(EnSList_easy): 
            obj = EnSList_easy.pop(0)
            out_question(obj,doc)
            out_count += 1
        
        if len(EnSList_hard): 
            obj = EnSList_hard.pop(0)
            out_question(obj,doc)
            out_count += 1
    try:
        doc.save('&unusedQuestions.docx')
    except PermissionError:
        print("ERROR: please close the file '&unusedQuestions.docx' if it is open and try again.") 
        input("Enter anything to exit the program")
        return
        

    print("Unused questions file with",out_count - thisGameQs,"questions made")
    
    byeChicken()
    time.sleep(1)
    input("Enter anything to exit.")
    
main()
