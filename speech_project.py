import speech_recognition as sr
import serial


# Initialize recognizer class (for recognizing the speech)
r = sr.Recognizer()

# Establishing Serial connection (Make sure to change 'COM3' to your specific port)
ser = serial.Serial('COM6', 9600)  # Establish the connection on a specific port
print("Connected to: " + ser.portstr)  # Print the port name

# Reading Microphone as source
# listening the speech and store in audio_text variable
while True:
    print("test")
    with sr.Microphone() as source:
        print("Talk")
        audio_text = r.listen(source)
        print("Time over, thanks")

        try:
            # using google speech recognition
            data = r.recognize_google(audio_text)
            byte_data = [ord(k) for k in data]
            print(byte_data)  # Print integer values of bytes
            print(bytes(byte_data))  # Print byte representation
            ser.write(bytes(byte_data) + b'\n')
 

        except:
            print("Sorry, I did not get that")

