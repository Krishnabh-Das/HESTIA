from encode_faces import encode_face
from cluster_faces import cluster_face_fn

if __name__ == '__main__':
    data = encode_face(dataset=r'/run/media/spritan/New Volume/Github/Google_Solution/HESTIA/notebooks/test/Face-Clustering/dataset')
    res = cluster_face_fn(encoding=data)
    print(res)
