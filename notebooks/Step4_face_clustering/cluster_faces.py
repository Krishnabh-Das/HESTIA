import os

import cv2
import numpy as np
from imutils import build_montages
from sklearn.cluster import DBSCAN

from Utils import logger

def move_image(image: cv2.typing.MatLike, id: int, labelID: int) -> None:
    """
    Move the image to a labeled directory.

    Parameters:
    - image (cv2.typing.MatLike): The image data.
    - id (int): The identifier for the image.
    - labelID (int): The label identifier for the image.

    Returns:
    - None
    """
    try:
        path = os.getcwd() + '/label' + str(labelID)

        if os.path.exists(path) == False:
            os.mkdir(path)

        filename = str(id) + '.jpg'

        cv2.imwrite(os.path.join(path, filename), image)
    except Exception as e:
        logger.critical(f"An error occurred: {str(e)}")

def cluster_face_fn(
    encoding: dict, 
    show: bool = False, 
    jobs: int = 1,
    save:bool = False) -> dict:
    """
    Cluster faces based on facial encodings.

    Parameters:
    - encoding_path (str): The path to the facial encodings file.
    - show (bool): Whether to display the clustered faces montage (default is False).
    - jobs (int): The number of parallel jobs to run for DBSCAN (default is 1).

    Returns:
    - None
    """
    try:
        logger.info("Loading encodings...")
        # data = pickle.loads(open(encoding_path, "rb").read())
        # data = np.array(data)
        data = encoding
        encodings = [d["encoding"] for d in data]

        logger.info("Clustering ...")

        clt = DBSCAN(metric='euclidean', n_jobs=jobs)
        clt.fit(encodings)

        labelIDs = np.unique(clt.labels_)

        numUniqueFaces = len(np.where(labelIDs > -1)[0])
        logger.info("# unique faces: {}".format(numUniqueFaces))

        res_dict = {}
  
        for labelID in labelIDs:
            logger.info("Faces for face ID: {}".format(labelID))
            idxs = np.where(clt.labels_ == labelID)[0]
            idxs = np.random.choice(idxs, size=min(25, len(idxs)), replace=False)
            logger.debug(clt.labels_)

            faces = []

            ids = []
            for i in idxs:
                image = cv2.imread(data[i]["coorectedImagePath"])
                
                ids.append(data[i]["id"])
                top, right, bottom, left = data[i]["loc"]
                face = image[top:bottom, left:right]
                
                if save:
                	move_image(image, i, labelID)

                face = cv2.resize(face, (96, 96))
                faces.append(face)
            
            res_dict[str(labelID)] = ids


            if save:
                montage = build_montages(faces, (96, 96), (5, 5))[0]
                title = "Face ID #{}".format(labelID)
                title = "Unknown Faces" if labelID == -1 else title

                if show:
                    cv2.imshow(title, montage)
                    cv2.waitKey(0)
                cv2.imwrite(os.path.join(os.getcwd(), title+'.jpg'), montage)
        
        return res_dict

    except Exception as e:
        logger.critical(f"An error occurred: {str(e)}")