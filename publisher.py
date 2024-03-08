import paho.mqtt.client as mqtt
import json
import time
import random


# Class to represent the message
class Message:
    def __init__(self, fin, zeit, geschwindigkeit):
        self.fin = fin
        self.zeit = zeit
        self.geschwindigkeit = geschwindigkeit

    def generate():
        fin = "ABCDEFGH55KLMNOPQ"
        zeit = int(time.time())
        geschwindigkeit = int(50 * random.random())

        return Message(fin, zeit, geschwindigkeit)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

    def __str__(self):
        return self.toJSON()


# Create a new instance of the client
mqttc = mqtt.Client(
    mqtt.CallbackAPIVersion.VERSION2, "florens_voet", clean_session=False
)

# Connect to the broker
mqttc.connect("broker.hivemq.com", 1883, 60)

while True:
    msg = Message.generate()

    send_msg = mqttc.publish(
        "DataMgmt",
        msg.toJSON(),
        qos=1,
    )

    print("Message sent: ", msg)

    # sleep for 5 seconds
    time.sleep(5)
