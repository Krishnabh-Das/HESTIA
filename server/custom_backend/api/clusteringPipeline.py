import io
import os
import tempfile
import traceback

import numpy as np
from PIL import Image

from fastapi.responses import JSONResponse
from fastapi import APIRouter, UploadFile, File

import requests
import face_recognition

from utils.logingUtils import logger
from db.bigQueryClient import getBigQueryTableStep3
from core.config import GCP_STEP3_CLUSTERING_PIPELINE_TABLE



@router.post("/get")
async def chat_send(img: UploadFile = File(...)):
    """
    This Route takes an uploaded image and compares it to a set of known images to determine which cluster the uploaded image belongs to.

    Args:
        img (UploadFile): The uploaded image

    Returns:
        JSONResponse: The cluster ID of the uploaded image, or -1 if no match is found

    Raises:
        Exception: If an error occurs
    """
    try:
        filename = img.filename
        contents = await img.read()
        with tempfile.TemporaryDirectory() as temp_dir:
            # Specify the file path within the temporary directory
            uk_file_path = os.path.join(temp_dir, filename)  # type: ignore
            logger.debug(uk_file_path)

            # Write the contents of the uploaded image to the temporary file
            with open(uk_file_path, "wb") as file:
                file.write(contents)

            pil_image = Image.open(io.BytesIO(contents))
            img = pil_image.convert("RGB")  # type: ignore
            img = np.array(img)  # type: ignore

            df = getBigQueryTableStep3(GCP_STEP3_CLUSTERING_PIPELINE_TABLE)

            unique_clusters = df["cluster"].unique().tolist()

            clusters = {str(key): [] for key in unique_clusters}

            for _, row in df.iterrows():
                id = row["markedId"]
                url = row["gcsUrl"]
                imgs = Image.open(requests.get(url, stream=True).raw)
                imgs.save(os.path.join(temp_dir, f"{id}.png"))
                img_path = os.path.join(temp_dir, f"{id}.png")
                logger.debug(img_path)
                clusters[str(row["cluster"])].append([img_path, id])

            known_encodings = {str(key): [] for key in unique_clusters}
            for key in clusters.keys():
                if key != "-1":
                    for imgs in clusters[key]:
                        logger.debug(imgs[0])
                        known_img = face_recognition.load_image_file(imgs[0])
                        encodings = face_recognition.face_encodings(
                            known_img, num_jitters=2
                        )
                        known_encodings[key].append(encodings)

            uk_img = face_recognition.load_image_file(uk_file_path)
            encoding_uk = face_recognition.face_encodings(uk_img)

            for key in known_encodings.keys():
                res = face_recognition.compare_faces(
                    known_encodings[key], np.array(encoding_uk), tolerance=0.6
                )
                print()
                if res:
                    return JSONResponse(content={"ClusterID": key}, status_code=200)

            return JSONResponse(content={"ClusterID": -1}, status_code=200)

    except Exception as e:
        traceback_str = traceback.format_exc()
        logger.error(traceback_str)
        return JSONResponse(content={"error": str(e)}, status_code=500)

