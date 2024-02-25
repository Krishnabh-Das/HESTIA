import cv2
import numpy as np
import traceback
from PIL import Image
from fastapi import APIRouter, UploadFile, File
from fastapi.responses import JSONResponse

from pprint import pformat
import face_recognition
import requests

from core.config import GCP_PROJECT_NAME, GCP_STEP3_CLUSTERING_PIPELINE_TABLE

from db.bigQueryClient import getBigQueryTableStep3
from db.fireStoreStorage import getClusterStorageStep3

from utils.logingUtils import logger

router = APIRouter(prefix="/clusterPipeline")

@router.post("/send")
async def chat_send(img: UploadFile = File(...)):
    try:
        contents = await img.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR) # type: ignore
        # rgb_img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)  # type: ignore
        
        cv2.imwrite(img=img, filename="test.jpg") # type: ignore
        
        df = getBigQueryTableStep3(GCP_STEP3_CLUSTERING_PIPELINE_TABLE)
        
        df.to_csv("test.csv")
        
        unique_clusters = df['cluster'].unique().tolist()
        
        clusters = {str(key): [] for key in unique_clusters }
        
        
        
        for _, row in df.iterrows():
            url = row['gcsUrl']
            image_data = Image.open(requests.get(url, stream=True).raw)
            im = image_data.convert("RGB")
            im = np.array(im)
            clusters[str(row['cluster'])].append([im, id])
        
        known_encodings = {str(key): [] for key in unique_clusters}
        for key in clusters.keys():
            if key != "-1":
                for imgs in clusters[key]:
                    known_img = imgs[0]
                    encodings = face_recognition.face_encodings(known_img, num_jitters=2)
                    known_encodings[key].append(encodings)
                    
        
        encoding_uk = face_recognition.face_encodings(img)
        
        for key in known_encodings.keys():
            logger.debug(type(known_encodings[key]))
            logger.debug(type(encoding_uk))
            known_encoding = np.array(known_encodings[key])
            encoding_uk_array = np.array(encoding_uk)
            res = face_recognition.compare_faces(known_encoding, encoding_uk_array, tolerance=0.4)
        if res:
            return JSONResponse(content={"response": res},
                            status_code=200)
        else:
            return JSONResponse(content={"response": "No Data"},
                            status_code=200)

    except Exception as e:
        traceback_str = traceback.format_exc()
        logger.error(traceback_str)
        return JSONResponse(content={"error": str(e)}, status_code=500)
    
from face_recognition import load_image_file