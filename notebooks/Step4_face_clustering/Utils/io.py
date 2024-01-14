import os
import cv2
from . import logger

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