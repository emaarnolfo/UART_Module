import serial

# Configuración del puerto serial
ser = serial.Serial('COM13', 19200, timeout=0)

# Valor en hexadecimal para el carácter 'a'
hex_value = '0a'

# Convertir el valor hexadecimal a bytes
data = bytes.fromhex(hex_value)

# Envío de datos
ser.write(data)

# Leer datos recibidos
received_data = ser.read(100)

# Imprimir datos recibidos
print(received_data)

# Cerrar el puerto serial
ser.close()


