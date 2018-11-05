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

special_words = ['subtotal', 'tax', 'total']

with open('config.json') as f:
    data = f.read()
config = json.loads(data)
# [END functions_ocr_setup]


def valid_line_match(price_bounds, word_bounds):
    price_min, price_max = price_bounds
    word_min, word_max = word_bounds

    if word_min > price_max or word_max < price_min:
        return 0
    else:
        overlap = min(price_max - word_min, word_max - price_min)
        overlap_percent = overlap / (price_max - price_min) 
        if overlap_percent > .25:
            return overlap_percent
        else:
            return 0

def dict_to_json(d):
    result = "{\n"

    for key, value in d.items():
        result += "\"{}\":\"{}\",\n".format(key, value.strip())
    
    result = result[:-2]
    result += "}"
    return result

def combine_to_json(items, special):
    result = "{\n"
    result += "\"items\": {},\n".format(items)
    result += "\"special\": {}\n".format(special)
    result += "}"
    return result
    


# [START functions_ocr_detect]
def detect_text(bucket, filename):
    print('Looking for text in image {}'.format(filename))

    futures = []

    text_detection_response = vision_client.text_detection({
        'source': {'image_uri': 'gs://{}/{}'.format(bucket, filename)}
    })
    annotations = text_detection_response.full_text_annotation

    price_pattern = r"\d*\.\d\d"
    price_dict = {}
    word_dict = {}
    word_keys = []

    i = 0
    text = ""

    price_word_pairing = {}
    special_dict = {}
    
    for page in annotations.pages:
        for block in page.blocks:
            # text += block.blockType
            for paragraph in block.paragraphs:
                for word in paragraph.words:
                    word_text = ""
                    for symbol in word.symbols:
                        word_text += symbol.text

                    bbox = word.bounding_box

                    ys = [vertex.x for vertex in bbox.vertices]
                    min_y = min(ys)
                    max_y = max(ys)
                    
                    # If we found a price
                    if re.fullmatch(price_pattern, word_text):
                        price_dict[(min_y, max_y)] = word_text
                    else:
                        # avg_x = sum([vertex.x for vertex in bounding_box.vertices]) / len(bounding_box.vertices)
                        word_dict[word_text] = [min_y, max_y]
                        word_keys.append(word_text)

    for price_bounds in price_dict:
        price = price_dict[price_bounds]
        price_word_pairing[price] = ""

        for word in word_keys:
            word_bounds = word_dict[word]
            line_score = valid_line_match(price_bounds, word_bounds)

            if line_score:
                if word.lower() in special_words:
                    special_dict[word] = price
                    price_word_pairing.pop(price, None)
                elif price in price_word_pairing:                
                    print("{}: {} \n word {}: {}".format(price, price_bounds, word, word_bounds))
                    price_word_pairing[price] += word + " "

    items_str = dict_to_json(price_word_pairing)
    special_str = dict_to_json(special_dict)
    json_string = combine_to_json(items_str, special_str)

    bucket_name = config['RESULT_BUCKET']
    result_filename = '{}_items.json'.format(filename)

    bucket = storage_client.get_bucket(bucket_name)
    file = bucket.blob(result_filename)
    print('Saving result to {} in bucket {}.'.format(result_filename,
                                                     bucket_name))
    file.upload_from_string(json_string)
    print('File saved.')

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


# def parse_receipt(event, context):
#     if event.get('data'):
#         message_data = base64.b64decode(event['data']).decode('utf-8')
#         message = json.loads(message_data)
#     else:
#         raise ValueError('Data sector is missing in the Pub/Sub message.')

#     text = validate_message(message, 'text')
#     filename = validate_message(message, 'filename')

#     pattern = "\d*\.\d\d"
#     matches = re.findall(pattern, text)

#     # matches = ["6.00", "10.00", "3.00"]


# [START functions_ocr_save]
# def save_result(event, context):
    
#     if event.get('data'):
#         message_data = base64.b64decode(event['data']).decode('utf-8')
#         message = json.loads(message_data)
#     else:
#         raise ValueError('Data sector is missing in the Pub/Sub message.')
    
#     print('we here now')
#     filename = validate_message(message, 'filename')
#     text = validate_message(message, 'text')

#     print('Received request to save file {}.'.format(filename))

#     bucket_name = config['RESULT_BUCKET']
#     result_filename = '{}_text.txt'.format(filename)

#     bucket = storage_client.get_bucket(bucket_name)

#     file = bucket.blob(result_filename)

#     print('Saving result to {} in bucket {}.'.format(result_filename,
#                                                      bucket_name))

#     file.upload_from_string(text)

#     print('File saved.')
# [END functions_ocr_save]
