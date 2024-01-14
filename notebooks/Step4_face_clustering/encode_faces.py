## imports
import os
import pickle
from imutils import paths

import cv2
import face_recognition

from Utils import face_alignment, logger

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

def encode_face(
    dataset:str,
    # encoding_path:str='./encoding.pickle',
    detection_method:str="cnn"
    )->dict:
	"""Encode faces into a list of CV2 matrices  

	Args:
		dataset (str): Path of Images
		encoding_path (str, optional): Saved encoding path. Defaults to './encoding.pickle'.
		detection_method (str, optional): Detection method. Defaults to "cnn" or "hog".
	"""
	logger.info("Quantifying faces...")
 
	try:
		imagePaths = list(paths.list_images(dataset))
		logger.debug(f"Images loaded: {len(imagePaths)}")

		data = []
		
		for (i, imagePath) in enumerate(imagePaths):
			
			aligned_img_path = os.path.join(os.getcwd(),"Temp",os.path.basename(imagePath))
			logger.debug(aligned_img_path)
			logger.debug("Processing image {}/{}".format(i + 1, len(imagePaths)))
			logger.debug(imagePath)

			image_ip = face_alignment(imagePath)
			cv2.imwrite(aligned_img_path, image_ip)
			image_ = cv2.cvtColor(image_ip, cv2.COLOR_BGR2GRAY)
			image = cv2.cvtColor(image_, cv2.COLOR_GRAY2BGR)

			boxes = face_recognition.face_locations(
	      		image,
				model=detection_method
	   		)

			encodings = face_recognition.face_encodings(image, boxes)

			d = [{
       			"coorectedImagePath":aligned_img_path,
         		"imagePath": imagePath, 
				"id": os.path.basename(imagePath)[:-4],
           		"loc": box, 
             	"encoding": enc
              	} for (box, enc) in zip(boxes, encodings)]
   
			data.extend(d)

		logger.debug("serializing encodings...")
		# logger.debug(data)
		# f = open(encoding_path, "wb")
		# f.write(pickle.dumps(data))
		# f.close()
		# logger.info("Encodings of images saved in {}".format(encoding_path))
		return data
              
	except Exception as e:
		logger.critical(f"An error occurred: {str(e)}")
