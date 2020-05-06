# Important note: to make this file run make sure to download the python-docx library
import docx
import time
import math
import json
import os
from os import listdir
from os.path import isfile, join
from random import shuffle

#initialize some important global variables that will be used for semantic analysis of the text
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

''' 
Format for JSON obj

ID                      --> QuestionNumber
difficultyLevel         --> 0 for middleSchool, 1 for highschool 
subjectType             --> one from ['Biology','Math','Physics','Chemistry','Earth and Space'] for high school

tossup_question         --> 'What is 2+2?'
tossup_isShortAns       --> False
tossup_MCQoptions       --> W) 1      X) 2        Y) 3        Z) 4 
tossup_answer           --> Z) 4
tossup_imageURL         --> None or URL

bonus_question          --> Similar to tossup
bonus_isShortAns        --> Similar to tossup
bonus_MCQoptions        --> Similar to tossup
bonus_answer            --> Similar to tossup
bonus_image             --> Similar to tossup
'''

# Make JSON object out of question
def outjson(question, QuestionNumber, directory, ErrorLog):
    jsonQuestion = {}
 
    if question.tossUp.subtype == 'Earth and Space':
        question.tossUp.subtype = 'Earth_and_Space'

    jsonQuestion['id']                  = QuestionNumber 
    jsonQuestion['difficultyLevel']     = question.tossUp.level 
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

    # Error Checking: Do not make objects with unpopulated fields 
    if 'none' in jsonQuestion.values() or '' in jsonQuestion.values():
        print("Error: 'none' or empty string detected. Skipping question with information\n\t", jsonQuestion)
        ErrorLog['None'].append(jsonQuestion)
        return False

    # Error Checking: Check to make sure internal structure consistent
    if ((jsonQuestion['tossup_isShortAns'] == False) and (jsonQuestion['tossup_MCQoptions'] == None)) or ((jsonQuestion['bonus_isShortAns'] == False) and (jsonQuestion['bonus_MCQoptions'] == None)):
        print("Error: Internal Inconsistency detected. Question is MCQ but has no options in question\n\t", jsonQuestion)
        ErrorLog['noMCQoptions'].append(jsonQuestion)
        return False

    # Making of object    
    filename = question.tossUp.subtype + '_' + str(QuestionNumber) + '.json'
    with open(directory + '/' + filename,'w') as json_file:
        json.dump(jsonQuestion, json_file)
        return True

# remove everything after and including the word answer
def sanitize_ansOption(ansOption):
    lowered = ansOption.lower()
    pos = lowered.find('answer:')
    
    if pos != -1:
        return ansOption[:pos]
    else:
        return ansOption

# remove everything before the word answer
def sanitize_answer(ans):
    lowered = ans.lower()
    pos = lowered.find('answer:')
    
    if pos != -1:
        return ans[pos:]
    else:
        return ans

# Function to parse DOCX file and make Question objects 
def readDOCX(subjectArrays, input_filename,level, ErrorLog):

    global subjectList
    global questionType

    inDoc = docx.Document('./questionRepo/' + input_filename)
        
    tossUpEncounter = False

    for _, para in enumerate(inDoc.paragraphs):
        txt = para.text

        if 'TOSS-UP' in txt:                #  signals the start of a new question
            questionObj = question()
            tossUpEncounter = True           
            questionObj.tossUp.qtype = txt
            questionObj.tossUp.level = level

        if tossUpEncounter == False:
            continue
        
        elif 'BONUS' in txt:                #   initiates making bonus
            questionObj.bonusSwitch = True
            questionObj.bonus.qtype = txt
            questionObj.bonus.level = level

        if not questionObj.bonusSwitch:            #  tossUp question
            
            if 'W)' in txt and 'X)' in txt:
                questionObj.tossUp.ansOption = sanitize_ansOption(txt)
                #continue
            if 'ANSWER' in txt:
                questionObj.tossUp.answer = sanitize_answer(txt)
                #continue
            for _, sub in enumerate(subjectList):
                if sub.lower() in txt.lower():
                    questionObj.tossUp.subtype = sub
                    break
            for _, ques in enumerate(questionType):
                if ques.lower() in txt.lower():
                    questionObj.tossUp.form = ques

                    body = txt
                    body = body.replace(questionObj.tossUp.subtype,'', 1)
                    body = body.replace(ques,'',1)

                    questionObj.tossUp.qbody = body
                    break

        else:
            if 'W)' in txt and 'X)' in txt:
                questionObj.bonus.ansOption = sanitize_ansOption(txt)
                
            if 'ANSWER' in txt:
                questionObj.bonus.answer = sanitize_answer(txt)
                
                #add question to appropriate Array
                if (questionObj.tossUp.subtype != 'none'):
                    subjectArrays[questionObj.tossUp.subtype].append(questionObj)
                else:
                    ErrorLog['None_Subject'].append(input_filename)
                    print("ERROR: Cannot determine subject of file in:", input_filename)
                    print("Skipping Question")

            for _, sub in enumerate(subjectList):
                if sub.lower() in txt.lower():
                    questionObj.bonus.subtype = sub
                    break
            for _, ques in enumerate(questionType):
                if ques.lower() in txt.lower():
                    questionObj.bonus.form = ques

                    body = txt
                    body = body.replace(questionObj.bonus.subtype,'')
                    body = body.replace(ques,'')

                    questionObj.bonus.qbody = body
                    break

# Adding personality to Console Window with a chicken ASCII MASCOT on STARTUP
def chicken():
    print("      __//")
    print("    /.__.\\")
    print("    \\ \\/ /")
    print(" '__/    \\")
    print("  \\-      )")
    print("   \\_____/")
    print("_____|_|____")
    print('     " "')

# Adding personality to Console Window with a chicken ASCII MASCOT at THE END
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
    os.system('cls')
    print("Please make sure any docx file that will be written to is closed before using this program.")
    chicken()

    # lists that help categorise questions
    global subjectList
    global questionType

    print("\n============Input Sequence============\n")
    # Get questions level w/ Error Handing
    incorrectAns = True
    while incorrectAns:
        try:
            level_sel = int(input("What level are these questions? (input 0 for middleSchool, 1 for highSchool):"))
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


    if not os.path.exists('./questionRepo'):
        print('ERROR: Folder "questionRepo" NOT FOUND.\nCreating folder... please try again after populating the folder with docx files with your questions')
        os.makedirs('./questionRepo')
        return
        
    # Dictionary of array to append particular subjects questions
    subjectArrays = {}
    for subject in subjectList:
        subjectArrays[subject] = []
    
    # Set-up Cache for file indexing
    Cache = {}

    directory = './jsonQuestions/' 

    if (level == 0):
        directory += 'middleSchoolQuestions'
    elif (level == 1):
        directory += 'highSchoolQuestions'

    Cache['directory'] = directory
    

    if os.path.exists(directory+'/0cache.json'):
        with open(directory+'/0cache.json') as f:
            Cache = json.load(f)
    else:
        print("Creating cache...")
        Cache['filesRead'] = []
        for subject in subjectList:
            Cache[subject] = 0

    # Create dictionary for error log
    # Append to old dictionary if already found in dictionary, else create new
    ErrorLog = {}
    if os.path.exists(directory+'/1errorLog.json'):
        with open(directory+'/1errorLog.json') as f:
            ErrorLog = json.load(f)
    else:
        print("Creating error log...")
        ErrorLog['Info'] = 'None: Some missing information detected \nnoMCQoptions: Question is MCQ but does not have a MCQ field \nNone_Subject: Unable to find subject of Question'
        ErrorLog['None'] = []
        ErrorLog['noMCQoptions'] = []
        ErrorLog['None_Subject'] = []

        for subject in subjectList:
            Cache[subject] = 0

    if not os.path.exists(directory):
        print("Creating directory", directory)
        os.makedirs(directory)
    


    print("Gobble gobble. Here's what I've found in folder questionRepo:")

    # Make list of files found in directory that have not already been read
    filesInDirectory = []
    for file in listdir('./questionRepo'):
        _, e = os.path.splitext(file)
        if e == ".docx" and file not in Cache['filesRead']:
            filesInDirectory.append(file)
    
    # Error Message if no files found
    if (len(filesInDirectory) == 0):
        print("No new questions found, files already read include:",Cache['filesRead'])
        print("If you think this is an error, please delete 0Cache.json")
        print("WARNING: Action will reset indexes")
        return
    
    # List files found
    for i, file in enumerate(filesInDirectory):
        print(i,": ", file)
    
    # Read documents
    allchoice = input('INPUT: Press "A" if you want to read all of these files. If NO, press any other key. \nHINT: Add only those files you want to read into "questionsRepo" and try again. \nInput:') 
    if (allchoice.lower() == 'a'):
        for file in filesInDirectory:
            readDOCX(subjectArrays, file,level,ErrorLog)
            Cache['filesRead'].append(file)
    else:
        return

    # Print state before output
    print("\nBefore Output")
    beforetotal = 0
    afterCount = {}
    for subject in subjectList:
        numberofquestions = len(subjectArrays[subject])
        print("\t",subject,":", numberofquestions)
        afterCount[subject] = 0
        beforetotal += numberofquestions

    print("Total found ", beforetotal)

    #output to JSON while any question remain
    loop = True
    while loop:
        loop = False
        for subject in subjectList:
            if (subjectArrays[subject]):
                loop = True
                Cache[subject] += 1
                afterCount[subject] += 1
                if not (outjson(subjectArrays[subject].pop(), Cache[subject], directory, ErrorLog)):
                    Cache[subject] -= 1
                    afterCount[subject] -= 1

        if loop == False:
            break


    # Print Output State
    aftertotal = 0
    print("\nAfter Output: ")
    for subject in subjectList:
        numberofquestions = afterCount[subject]
        print("\t",subject,":", numberofquestions)
        aftertotal += numberofquestions
    print("Total used ", aftertotal)
    print("Questions skipped", beforetotal - aftertotal)

    # Print Output Index
    print("\nSubject Indexes at: ")
    for subject in subjectList:
        numberofquestions = Cache[subject]
        print("\t",subject,"at", numberofquestions)

    # Save Meta data
    with open(directory+'/0cache.json','w') as json_file:
        print("Saving indexes in Cache")
        json.dump(Cache,json_file)

    # Save Error log
    with open(directory+'/1errorlog.json','w') as json_file:
        print("Saving Error log")
        json.dump(ErrorLog,json_file)
        
# Driver of Program
main()
