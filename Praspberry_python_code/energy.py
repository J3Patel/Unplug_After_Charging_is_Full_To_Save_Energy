from simple_firebase_realtime_db import FirebaseRealtimeDB as DB
import time
import threading
import RPi.GPIO as GPIO
# import snowboydecoder
import sys
import signal
import os
import pyaudio
import numpy as np
import json

CHUNK = 2**11
RATE = 44100
interrupted = False
charged_full = False
threads = list()

DB.initialize(
    certificate_path='cert.json',
    database_url='https://energysaver29-e6778-default-rtdb.firebaseio.com'
)

path = 'charging_status'

def signal_handler(signal, frame):
    # example.stop()
    global interrupted
    interrupted = True

def interrupt_callback():
    global interrupted
    return interrupted

def playintro():
    os.system('aplay -d 20 charged.wav')

def fireSolenoid():
    GPIO.output(24, GPIO.LOW)


def chargingCompleted():
    x = threading.Thread(target=playintro, args=())
    threads.append(x)
    x.start()
    time.sleep(2)
    fireSolenoid()
    time.sleep(1)
    os.system('aplay -d 20 discon.wav')

def audioDetect():
    global charged_full
    while not interrupted and not charged_full:
        data = DB.get(path)
        print(data)
        if data == 3:
            charged_full = True
            chargingCompleted()

GPIO.setmode(GPIO.BCM)
GPIO.setup(24, GPIO.OUT)
GPIO.output(24, GPIO.HIGH)

time.sleep(2)

y = threading.Thread(target=audioDetect, args=())
threads.append(y)
y.start()

signal.signal(signal.SIGINT, signal_handler)
# GPIO.cleanup()
# time.sleep(10)
