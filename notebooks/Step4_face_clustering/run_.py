from face_cluser import FaceCluster
if __name__ == '__main__':
    data = FaceCluster()
    res = data.getClusters(dataset=r'/run/media/spritan/New Volume/Github/Google_Solution/HESTIA/notebooks/Step4_face_clustering/dataset')
    print(res)
