# [START functions_ocr_setup]
import base64
import json
import os
import re

from google.cloud import pubsub_v1
from google.cloud import storage
from google.cloud import translate
from google.cloud import vision

vision_client = vision.ImageAnnotatorClient()
translate_client = translate.Client()
publisher = pubsub_v1.PublisherClient()
storage_client = storage.Client()

project_id = os.environ['GCP_PROJECT']

with open('config.json') as f:
    data = f.read()
config = json.loads(data)
# [END functions_ocr_setup]



# [START functions_ocr_detect]
def detect_text(bucket, filename):
    print('Looking for text in image {}'.format(filename))

    futures = []

    text_detection_response = vision_client.text_detection({
        'source': {'image_uri': 'gs://{}/{}'.format(bucket, filename)}
    })
    annotations = text_detection_response.full_text_annotation

    text = ""
    print('ALRIGHT ALRIGHT ALRIGHT')
    for page in annotations.pages:
        for block in page.blocks:
            print(type(block))



    # if len(annotations) > 0:
    #     text = annotations[0].description
    # else:
    #     text = ''
    #
    print('Extracted text {} from image ({} chars).'.format(text, len(text)))

    detect_language_response = translate_client.detect_language(text)
    lang = detect_language_response['language']
    print('Detected language {} for text {}.'.format(lang, text))

    topic_name = config['RESULT_TOPIC']
    message = {
        "text": text,
        "filename": filename,
        "lang": lang
    }
    message_data = json.dumps(message).encode('utf-8')
    topic_path = publisher.topic_path(project_id, topic_name)
    future = publisher.publish(topic_path, data=message_data)

    futures.append(future)

# [END functions_ocr_detect]


# [START message_validatation_helper]
def validate_message(message, param):
    var = message.get(param)
    if not var:
        raise ValueError('{} is not provided. Make sure you have \
                          property {} in the request'.format(param, param))
    return var
# [END message_validatation_helper]


# [START functions_ocr_process]
def process_image(file, context):
    """Cloud Function triggered by Cloud Storage when a file is changed.
    Args:
        file (dict): Metadata of the changed file, provided by the triggering
                                 Cloud Storage event.
        context (google.cloud.functions.Context): Metadata of triggering event.
    Returns:
        None; the output is written to stdout and Stackdriver Logging
    """
    bucket = validate_message(file, 'bucket')
    name = validate_message(file, 'name')

    detect_text(bucket, name)

    print('File {} processed.'.format(file['name']))
# [END functions_ocr_process]


def parse_receipt(event, context):
    if event.get('data'):
        message_data = base64.b64decode(event['data']).decode('utf-8')
        message = json.loads(message_data)
    else:
        raise ValueError('Data sector is missing in the Pub/Sub message.')

    text = validate_message(message, 'text')
    filename = validate_message(message, 'filename')

    pattern = "\d*\.\d\d"
    matches = re.findall(pattern, text)

    # matches = ["6.00", "10.00", "3.00"]







# [START functions_ocr_save]
def save_result(event, context):
    if event.get('data'):
        message_data = base64.b64decode(event['data']).decode('utf-8')
        message = json.loads(message_data)
    else:
        raise ValueError('Data sector is missing in the Pub/Sub message.')

    text = validate_message(message, 'text')
    filename = validate_message(message, 'filename')

    print('Received request to save file {}.'.format(filename))

    bucket_name = config['RESULT_BUCKET']
    result_filename = '{}_text.txt'.format(filename)

    bucket = storage_client.get_bucket(bucket_name)

    file = bucket.blob(result_filename)

    print('Saving result to {} in bucket {}.'.format(result_filename,
                                                     bucket_name))

    file.upload_from_string(text)

    print('File saved.')
# [END functions_ocr_save]
