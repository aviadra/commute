#!/usr/bin/env python3
import pyautogui
import pyperclip  # handy cross-platform clipboard text handler
import time
DEBUG = "True"

letters = {
    ";" : "ף",
    "a" : "ש",
    "A" : "ש",
    "b" : "נ",
    "B" : "נ",
    "c" : "ב",
    "C" : "ב",
    "d" : "ג",
    "D" : "ג",
    "e" : "ק",
    "E" : "ק",
    "f" : "כ",
    "F" : "כ",
    "g" : "ע",
    "G" : "ע",
    "h" : "י",
    "H" : "י",
    "i" : "ן",
    "I" : "ן",
    "j" : "ח",
    "J" : "ח",
    "k" : "ל",
    "K" : "ל",
    "l" : "ך",
    "L" : "ך",
    "m" : "צ",
    "M" : "צ",
    "n" : "מ",
    "N" : "מ",
    "o" : "ם",
    "O" : "ם",
    "p" : "פ",
    "P" : "פ",
    "q" : "/",
    "Q" : "/",
    "r" : "ר",
    "R" : "ר",
    "s" : "ד",
    "S" : "ד",
    "t" : "א",
    "T" : "א",
    "u" : "ו",
    "U" : "ו",
    "v" : "ה",
    "V" : "ה",
    "w" : "'",
    "W" : "'",
    "x" : "ס",
    "X" : "ס",
    "y" : "ט",
    "Y" : "ט",
    "z" : "ז",
    "Z" : "ז"
}

def get_key(search_letter): 
    for key, value in letters.items(): 
         if search_letter == " ":
             return " "
         if search_letter == value:
             return key
  
    return ""

def copy_clipboard():
    if "clip" in DEBUG:
        return "אחד שתים שלוש"
    else:
        pyautogui.hotkey('command', 'a', interval=0.1)
        pyautogui.hotkey('command', 'c')
        time.sleep(.1)  # ctrl-c is usually very fast but your program may execute faster
        return pyperclip.paste()

ENG = ""
HEB = ""
clip = copy_clipboard()
for letter in clip:
    # print(f"working on: {letter}")
    if letter == " ":
        mapping = letter
    else:
        mapping = letters.get(letter,"")
    HEB += mapping
    remapping = get_key(letter)
    ENG += remapping

if len(HEB) > len(ENG):
    return_str = clip
else:
    return_str = ENG

pyautogui.hotkey('ctrl', 'space')
time.sleep(.2)
pyautogui.write(return_str)