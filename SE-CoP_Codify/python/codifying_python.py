import pika
import json

# Define the RabbitMQ connection parameters
connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

# Define the exchange and queue names
exchange_name = 'my_exchange'
command_queue_name = 'command_queue'
event_queue_name = 'event_queue'

# Declare the exchange and queues
channel.exchange_declare(exchange=exchange_name, exchange_type='topic')
channel.queue_declare(queue=command_queue_name)
channel.queue_declare(queue=event_queue_name)

# Bind the queues to the exchange
channel.queue_bind(exchange=exchange_name, queue=command_queue_name, routing_key='command.*')
channel.queue_bind(exchange=exchange_name, queue=event_queue_name, routing_key='event.*')

# Define the command handler function
def handle_command(ch, method, properties, body):
    command = json.loads(body)
    # TODO: Handle the command and publish an event

# Define the event handler function
def handle_event(ch, method, properties, body):
    event = json.loads(body)
    # TODO: Handle the event

# Start consuming messages from the command queue
channel.basic_consume(queue=command_queue_name, on_message_callback=handle_command, auto_ack=True)

# Start consuming messages from the event queue
channel.basic_consume(queue=event_queue_name, on_message_callback=handle_event, auto_ack=True)

# Start consuming messages
channel.start_consuming()
