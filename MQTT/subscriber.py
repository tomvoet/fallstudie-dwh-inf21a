import paho.mqtt.client as mqtt
import psycopg2
import os
from dotenv import load_dotenv

def on_message(client, userdata, message):
    
    print(message.payload)
    print(type(message.payload))
    msg = message.payload.decode("utf-8")
    print(msg)
    cursor.execute("INSERT INTO staging.messung (payload) VALUES (%s)", (msg,))
    
    # persist new data
    dbConnection.commit()


load_dotenv()

# connect to postgre db
#dbConnection = psycopg2.connect("dbname=postgres user=postgres")
dbConnection = psycopg2.connect(
    #host= ,
    database="postgres",
    user=os.environ.get("USER_NAME"),
    password=os.environ.get("USER_PW")
    )

# Open a cursor to perform database operations
cursor = dbConnection.cursor()

# prepare database with schema and table
cursor.execute("drop schema if exists staging cascade;")
cursor.execute("create schema staging;")
cursor.execute("create table staging.messung (messung_id serial, payload JSON not null, empfangen TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, CONSTRAINT pk_messung PRIMARY KEY(messung_id));")


# subscribe to topic
mqttClient = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2, client_id="30112021", clean_session=False)
mqttClient.on_message = on_message
#mqttClient.username_pw_set(os.environ.get("USER_NAME"), os.environ.get("USER_PW"))
mqttClient.connect(host="broker.hivemq.com", port=1883, keepalive=60)
mqttClient.subscribe("DataMgmt", qos=1)

mqttClient.loop_forever()