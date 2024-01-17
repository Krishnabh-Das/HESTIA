import os
from imutils import paths

import cv2
import dlib
import numpy as np
from PIL import Image
import face_recognition
from imutils import build_montages

from sklearn.cluster import DBSCAN

from Utils import logger, load_img, show_img, move_image

class FaceCluster:
    def __init__(self, jobs: int = 1, metric: str = 'euclidean', save: bool = False, show: bool = False) -> None:
        """
        Initialize the FaceCluster object.

        Parameters:
        - jobs (int): Number of parallel jobs to run for DBSCAN (default is 1).
        - metric (str): Metric used for clustering (default is 'euclidean').
        - save (bool): Whether to save the clustered images (default is False).
        - show (bool): Whether to display the clustered faces montage (default is False).

        Returns:
        - None
        """
        self.metric = metric
        self.clt = DBSCAN(metric=self.metric, n_jobs=jobs)
        self.save = save
        self.show = show

    def rotate_opencv(self, img: cv2.typing.MatLike, nose_center: tuple, angle: float) -> cv2.typing.MatLike:
        """
        Rotate an image using OpenCV.

        Parameters:
        - img (cv2.typing.MatLike): Input image.
        - nose_center (tuple): Coordinates of the nose center.
        - angle (float): Rotation angle.

        Returns:
        - cv2.typing.MatLike: Rotated image.
        """
        M = cv2.getRotationMatrix2D(nose_center, angle, 1)
        rotated = cv2.warpAffine(img, M, (img.shape[1], img.shape[0]), flags=cv2.INTER_CUBIC)
        return rotated
    
    def is_between(self, point1: tuple, point2: tuple, point3: tuple, extra_point: tuple) -> bool:
        """
        Check if extra_point lies between point1, point2, and point3.

        Parameters:
        - point1 (tuple): Coordinates of the first point.
        - point2 (tuple): Coordinates of the second point.
        - point3 (tuple): Coordinates of the third point.
        - extra_point (tuple): Coordinates of the extra point.

        Returns:
        - bool: True if extra_point is between the three points, False otherwise.
        """
        c1 = (point2[0] - point1[0]) * (extra_point[1] - point1[1]) - (point2[1] - point1[1]) * (extra_point[0] - point1[0])
        c2 = (point3[0] - point2[0]) * (extra_point[1] - point2[1]) - (point3[1] - point2[1]) * (extra_point[0] - point2[0])
        c3 = (point1[0] - point3[0]) * (extra_point[1] - point3[1]) - (point1[1] - point3[1]) * (extra_point[0] - point3[0])
        if (c1 < 0 and c2 < 0 and c3 < 0) or (c1 > 0 and c2 > 0 and c3 > 0):
            return True
        else:
            return False
    
    def rotate_point(self, origin: tuple, point: tuple, angle: float) -> tuple:
        """
        Rotate a point around an origin by a specified angle.

        Parameters:
        - origin (tuple): Coordinates of the origin.
        - point (tuple): Coordinates of the point to be rotated.
        - angle (float): Rotation angle.

        Returns:
        - tuple: Coordinates of the rotated point.
        """
        ox, oy = origin
        px, py = point

        qx = ox + np.cos(angle) * (px - ox) - np.sin(angle) * (py - oy)
        qy = oy + np.sin(angle) * (px - ox) + np.cos(angle) * (py - oy)
        return qx, qy
     
    def cosine_formula(self, length_line1: float, length_line2: float, length_line3: float) -> float:
        """
        Compute the cosine of an angle using the cosine formula.

        Parameters:
        - length_line1 (float): Length of the first line.
        - length_line2 (float): Length of the second line.
        - length_line3 (float): Length of the third line.

        Returns:
        - float: Cosine of the angle.
        """
        cos_a = -(length_line3 ** 2 - length_line2 ** 2 - length_line1 ** 2) / (2 * length_line2 * length_line1)
        return cos_a
    
    def distance(self, a: tuple, b: tuple) -> float:
        """
        Calculate the Euclidean distance between two points.

        Parameters:
        - a (tuple): Coordinates of the first point.
        - b (tuple): Coordinates of the second point.

        Returns:
        - float: Euclidean distance between the two points.
        """
        return np.sqrt((a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2)

    def get_eyes_nose_dlib(self, shape: dlib.full_object_detection) -> tuple: # type: ignore
        """
        Extract coordinates of nose, left eye, and right eye from dlib shape object.

        Parameters:
        - shape (dlib.full_object_detection): Detected facial landmarks.

        Returns:
        - tuple: Tuple containing coordinates of nose, left eye, and right eye.
        """
        nose = shape[4][1]
        left_eye_x = int(shape[3][1][0] + shape[2][1][0]) // 2
        left_eye_y = int(shape[3][1][1] + shape[2][1][1]) // 2
        right_eyes_x = int(shape[1][1][0] + shape[0][1][0]) // 2
        right_eyes_y = int(shape[1][1][1] + shape[0][1][1]) // 2
        
        return nose, (left_eye_x, left_eye_y), (right_eyes_x, right_eyes_y)
    
    def shape_to_normal(self, shape: dlib.full_object_detection) -> list: # type: ignore
        """
        Convert dlib shape object to a list of tuples.

        Parameters:
        - shape (dlib.full_object_detection): Detected facial landmarks.

        Returns:
        - list: List of tuples representing coordinates of facial landmarks.
        """
        shape_normal = []
        for i in range(0, 5):
            shape_normal.append((i, (shape.part(i).x, shape.part(i).y)))
        return shape_normal

    def rotation_detection_dlib(self, img: cv2.typing.MatLike, mode: int, show: bool = False) -> cv2.typing.MatLike:
        """
        Perform rotation detection using dlib's facial landmarks.

        Parameters:
        - img (cv2.typing.MatLike): Input image.
        - mode (int): Rotation mode (0: no rotation, 1: rotate).
        - show (bool): Whether to display the rotated image (default is False).

        Returns:
        - cv2
        """
        detector = dlib.get_frontal_face_detector() # type: ignore
        predictor = dlib.shape_predictor('./Utils/shape_predictor_5_face_landmarks.dat') # type: ignore
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        rects = detector(gray, 0)
        if len(rects) > 0:
            for rect in rects:
                x = rect.left()
                y = rect.top()
                w = rect.right()
                h = rect.bottom()
                shape = predictor(gray, rect)
                shape = self.shape_to_normal(shape)
                nose, left_eye, right_eye = self.get_eyes_nose_dlib(shape)
                center_of_forehead = ((left_eye[0] + right_eye[0]) // 2, (left_eye[1] + right_eye[1]) // 2)
                center_pred = (int((x + w) / 2), int((y + y) / 2))
                length_line1 = self.distance(center_of_forehead, nose)
                length_line2 = self.distance(center_pred, nose)
                length_line3 = self.distance(center_pred, center_of_forehead)
                cos_a = self.cosine_formula(length_line1, length_line2, length_line3)
                angle = np.arccos(cos_a)
                rotated_point = self.rotate_point(nose, center_of_forehead, angle)
                rotated_point = (int(rotated_point[0]), int(rotated_point[1]))
                if self.is_between(nose, center_of_forehead, center_pred, rotated_point):
                    angle = np.degrees(-angle)
                else:
                    angle = np.degrees(angle)

                if mode:
                    img = self.rotate_opencv(img, nose, angle)
                else:
                    img = Image.fromarray(img)  # type: ignore
                    img = np.array(img.rotate(angle)) # type: ignore
            if show:
                show_img(img)
            return img
        else:
            return img
    
    def face_align(self, imagePath: str, mode: int = 0, show: bool = False) -> cv2.typing.MatLike:
        """
        Perform face alignment using rotation detection.

        Parameters:
        - imagePath (str): Path to the input image.
        - mode (int): Rotation mode (0: no rotation, 1: rotate).
        - show (bool): Whether to display the aligned image (default is False).

        Returns:
        - cv2.typing.MatLike: Aligned face image.
        """
        img = load_img(imagePath)
        img_rot = self.rotation_detection_dlib(img, mode, show)
        return img_rot
    
    def getEncodings(self, dataset: str, detection_method: str = "cnn") -> list|None:
        """
        Extract facial encodings from a dataset of images.

        Parameters:
        - dataset (str): Path to the dataset directory.
        - detection_method (str): Face detection method (default is "cnn").

        Returns:
        - list: List of dictionaries containing image information and encodings.
        """
        logger.info("Quantifying faces...")
        try:
            imagePaths = list(paths.list_images(dataset))
            logger.debug(f"Images loaded: {len(imagePaths)}")

            data = []
            
            for (i, imagePath) in enumerate(imagePaths):
                
                # aligned_img_path = os.path.join(os.getcwd(),"Temp",os.path.basename(imagePath))
                # logger.debug(aligned_img_path)
                logger.debug("Processing image {}/{}".format(i + 1, len(imagePaths)))
                logger.debug(imagePath)

                image_ip = self.face_align(imagePath)
                # cv2.imwrite(aligned_img_path, image_ip)
                image_ = cv2.cvtColor(image_ip, cv2.COLOR_BGR2GRAY)
                image = cv2.cvtColor(image_, cv2.COLOR_GRAY2BGR)

                boxes = face_recognition.face_locations(
                    image,
                    model=detection_method
                )

                encodings = face_recognition.face_encodings(image, boxes)

                d = [{
                    # "coorectedImagePath":aligned_img_path,
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
            return data # type: ignore
                
        except Exception as e:
            logger.critical(f"An error occurred: {str(e)}")
    
    def getClusters(self, dataset: str) -> dict|None:
        """
        Perform face clustering on a dataset and return the clustered results.

        Parameters:
        - dataset (str): Path to the dataset directory.

        Returns:
        - dict: Dictionary containing clustered face IDs.
        """
        self.encodings = self.getEncodings(dataset=dataset)
        try:
            logger.info("Loading encodings...")
            # data = pickle.loads(open(encoding_path, "rb").read())
            # data = np.array(data)
            data = self.encodings
            encodings = [d["encoding"] for d in data] #type:ignore

            logger.info("Clustering ...")

            self.clt.fit(encodings) # type: ignore

            labelIDs = np.unique(self.clt.labels_)

            self.numUniqueFaces = len(np.where(labelIDs > -1)[0])
            logger.info("# unique faces: {}".format(self.numUniqueFaces))

            res_dict = {}
    
            for labelID in labelIDs:
                logger.info("Faces for face ID: {}".format(labelID))
                idxs = np.where(self.clt.labels_ == labelID)[0]
                idxs = np.random.choice(idxs, size=min(25, len(idxs)), replace=False)
                logger.debug(self.clt.labels_)

                faces = []

                ids = []
                for i in idxs:
                    image = cv2.imread(data[i]["imagePath"])#type:ignore
                    
                    ids.append(data[i]["id"])#type:ignore
                    top, right, bottom, left = data[i]["loc"]#type:ignore
                    face = image[top:bottom, left:right]
                    
                    if self.save:
                        move_image(image, i, labelID)

                    face = cv2.resize(face, (96, 96))
                    faces.append(face)
                
                res_dict[str(labelID)] = ids


                if self.save:
                    montage = build_montages(faces, (96, 96), (5, 5))[0]
                    title = "Face ID #{}".format(labelID)
                    title = "Unknown Faces" if labelID == -1 else title

                    if self.show:
                        cv2.imshow(title, montage)
                        cv2.waitKey(0)
                    cv2.imwrite(os.path.join(os.getcwd(), title+'.jpg'), montage)
            
            return res_dict

        except Exception as e:
            logger.critical(f"An error occurred: {str(e)}")