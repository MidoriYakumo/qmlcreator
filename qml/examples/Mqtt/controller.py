#! /usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 17 08:32:37 2015

@author: macrobull
"""
import paho.mqtt.client as mqtt
import time


server = "localhost"
server = "45.79.81.190"

try:
	import RPi.GPIO as G
	G.setmode(G.BCM)
	G.setup(23, G.OUT)
	G.setup(24, G.IN, G.PUD_UP)
except Exception:
	mock = True
else:
	mock = False



# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
	print(msg.topic+" "+str(msg.payload))
	act(msg.payload==b'1')

def act(s):
	s = 1 if s else 0
	sender.publish("miso", "ACK", qos=1)
	if not mock:
		q = s
		while s==q:
			G.output(23,s)
			q = G.input(24)
			print(s,q)
			s = 1-q
	sender.publish("miso", s, qos=1)

receiver = mqtt.Client()
sender = mqtt.Client()
receiver.on_connect = lambda client, userdata, flags, rc:client.subscribe("mosi", qos=1)
receiver.on_message = on_message

receiver.connect(server, 1883, 60)
sender.connect(server, 1883, 60)
receiver.loop_forever()
