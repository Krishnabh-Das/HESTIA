// DetailPage.js

import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { Box, Card, CardContent, CardMedia , Typography, useTheme, Container } from '@mui/material';
import { collection, getDoc, doc } from 'firebase/firestore';
import { db } from '../config/firebase';
import CircularProgress from '@mui/material/CircularProgress';

//------------------------leaflet config------------------------
import "../leaflet_myconfig.css"
import "leaflet/dist/leaflet.css";
import { MapContainer, TileLayer, Marker, Popup, Polygon } from "react-leaflet";
import MarkerClusterGroup from "react-leaflet-cluster";
import { useMapEvents } from 'react-leaflet/hooks'


import pinIcon1 from '../assets/placeholder.png'
import pinIcon2 from '../assets/pin.png'
import pinIcon3 from '../assets/destination.png'

import { Icon, divIcon, point } from "leaflet";
import { fetchVolunteerById, updateVolunteerStatusById } from "../api/Ngo";



const DetailPage = () => {

  const queryClient = useQueryClient();


  const updateVolunteerStatusMutation = useMutation({
    mutationFn: updateVolunteerStatusById,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['volunteers']});
      console.log("success bro!")
    }
  });

  const theme = useTheme();

  const { id } = useParams(); 

  const [detailData, setDetailData] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const sosDocRef = doc(db, 'SOS_Reports', id);
        const sosDocSnapshot = await getDoc(sosDocRef);

        if (sosDocSnapshot.exists()) {
          setDetailData(sosDocSnapshot.data());
        } else {
          console.log('Document does not exist!');
        }
      } catch (error) {
        console.error('Error fetching detail data:', error);
      }
    };

    fetchData();
  }, [id]);

  console.log("detail>>>>>>>>>>>>>>>", detailData?.incidentPosition);
  console.log("detail>>>>>>>>>>>>>>>", detailData);

  // console.log("volunteer id in page", id);
  // console.log("volunteer  data page", volunteer);

  const pin2 = new Icon({
    iconUrl: pinIcon2,
    iconSize: [38, 38] // size of the icon
  });
  // custom cluster icon
  const createClusterCustomIcon = function (cluster) {
    return new divIcon({
      html: `<span class="cluster-icon">${cluster.getChildCount()}</span>`,
      className: "custom-marker-cluster",
      iconSize: point(33, 33, true)
    });
  };

  const handleVolunteerStatus = ( status) => { 
    console.log('click id',id);
    console.log('click status',status);

    updateVolunteerStatusMutation.mutate({
      id,
      status
    })
   }

  return (
    <Container maxWidth="xl" 
    // sx={{backgroundColor: theme.palette.background.alt,}}
    >
    <Box 
    m="1.5rem 2.5rem"
    // height='50%'
    // w="50rem"
    // minHeight="700px"
    // height="50rem"
    // position="relative"
    display="flex"
    alignItems="center"
    justifyContent="center"
    flexWrap="wrap"
    gap={3}

    >
          {detailData ? (
            <>

      <Card sx={{
         backgroundColor: theme.palette.background.alt,
         backgroundImage: 'none',
          backgroundColor: theme.palette.background.alt,
          borderRadius: '0.55rem',
          marginTop: '20px', // Adjust margin top as needed
          maxWidth: '400px', // Adjust the width as needed
          width: '1000px',
          padding: "0px", // Ensures the Card takes full width if maxWidth is not reached
          // margin: '0 
         }}>
        <CardContent>
               <CardMedia
        sx={{ height: "500px", width:"100%",  objectFit: 'contain', padding: '10px', marginBottom: '10px' }}
        image={detailData.incidentImageLink}
        title="green iguana"
      />



      <Box
        mt={2}
          display="flex"
      >
        {!isLoading ? (
          <>
            <Card
              sx={{
                backgroundColor: theme.palette.background.alt,
                backgroundImage: "none",
                backgroundColor: theme.palette.background.alt,
                borderRadius: "0.55rem",
                marginTop: "20px", // Adjust margin top as needed
                maxWidth: "400px", // Adjust the width as needed
                width: "1000px",
                padding: "0px", // Ensures the Card takes full width if maxWidth is not reached
                // margin: '0
              }}
            >
              <CardContent>
                <Box
                  display="flex"
                  justifyContent="center"
                  alignItems="center"
                  p={1}
                >
                  <Typography variant="h3">VOLUNTEER DETAILS</Typography>
                </Box>

                <CardMedia
                  sx={{
                    height: "500px",
                    width: "100%",
                    objectFit: "contain",
                    padding: "10px",
                    marginBottom: "10px",
                  }}
                  image={volunteer.imageURL}
                  title="volunteer"
                />

                <Box mt={2} display="flex">
                  <Box>
                    <Typography
                      variant="body1"
                      mr={1}
                      sx={{ color: theme.palette.secondary[500] }}
                    >
                      Name:
                    </Typography>
                  </Box>
                  <Box>
                    <Typography
                      variant="body1"
                      sx={{ color: theme.palette.secondary[100] }}
                    >
                      {volunteer.name}
                    </Typography>
                  </Box>
                </Box>

                <Box display="flex">
                  <Box>
                    <Typography
                      variant="body1"
                      mr={1}
                      sx={{ color: theme.palette.secondary[500] }}
                    >
                      Email
                    </Typography>
                  </Box>
                  <Box>
                    <Typography
                      variant="body1"
                      sx={{ color: theme.palette.secondary[100] }}
                    >
                      {volunteer.email}
                    </Typography>
                  </Box>
                </Box>

                <Box display="flex">
                  <Box>
                    <Typography
                      variant="body1"
                      mr={1}
                      sx={{
                        color: theme.palette.secondary[500],
                        display: "inline",
                      }}
                    >
                      Phone:
                    </Typography>
                  </Box>
                  <Box>
                    <Typography
                      variant="body1"
                      sx={{
                        color: theme.palette.secondary[100],
                        display: "inline",
                      }}
                    >
                      {volunteer.number}
                    </Typography>
                  </Box>
                </Box>
              </CardContent>
            </Card>

            <Card
              sx={{
                backgroundColor: theme.palette.background.alt,
                backgroundImage: "none",
                backgroundColor: theme.palette.background.alt,
                borderRadius: "0.55rem",
                marginTop: "20px", // Adjust margin top as needed
                maxWidth: "400px", // Adjust the width as needed
                width: "1000px",
                padding: "0px", // Ensures the Card takes full width if maxWidth is not reached
                // margin: '0
              }}
            >
              <CardContent>
                <Box
                  display="flex"
                  justifyContent="center"
                  alignItems="center"
                  p={1}
                >
                  <Typography variant="h3">ID PROOF</Typography>
                </Box>

                <CardMedia
                  sx={{
                    height: "500px",
                    width: "100%",
                    objectFit: "contain",
                    padding: "10px",
                    marginBottom: "10px",
                  }}
                  image={volunteer.idProof}
                  title="ID"
                />

                <Box  display="flex">
                  <Box>
                    <Typography
                      variant="body1"
                      mr={1}
                      sx={{ color: theme.palette.secondary[500] }}
                    >
                      Status:
                    </Typography>
                  </Box>
                  <Box display='flex'>
                    {volunteer.status === "pending" ? (
                      <Box display='flex' gap={1}>
                        <HourglassTopIcon sx={{ color: "#EDD000" }} />
                        <Typography>{volunteer.status}</Typography>
                      </Box>
                    ) : volunteer.status === "accepted" ? (
                      <Box display='flex' gap={1}>
                        <VerifiedUserIcon sx={{ color: "#5bff86" }} />
                        <Typography>{volunteer.status}</Typography>
                      </Box>
                    ) : (
                      <Box display='flex' gap={1}>
                        <CancelIcon sx={{ color: "red" }} />
                        <Typography>{volunteer.status}</Typography>
                      </Box>
                    )}
                  </Box>
                </Box>
                {volunteer.status === 'pending' && (
                    <Box display='flex' alignItems='center' justifyContent='space-between' mt={2}>
                    <Button
                      variant="contained"
                      color="secondary"
                      onClick={() =>
                        handleVolunteerStatus('accepted' )
                      }
                    >
                      Accept
                    </Button>

                    <Button
                      variant="contained"
                      color="error"
                      onClick={() =>
                        handleVolunteerStatus('rejected' )
                      }
                    >
                      Reject
                    </Button>
                    </Box>
                )}

              </CardContent>
            </Card>
          </>
        ) : (
          <CircularProgress />
        )}
      </Box>

      <Box
          display="flex"
      >
    <Box>
  <Typography variant="body1" mr={1} sx={{ color: theme.palette.secondary[500]}}>
  Created At:
                </Typography>
    </Box>
    <Box>
    <Typography variant="body1" sx={{ color: theme.palette.secondary[100]}}>
    {detailData.incidentTime.seconds}
                </Typography>
    </Box>
      </Box>

      <Box
          display="flex"
      >
    <Box>
  <Typography variant="body1" mr={1} sx={{ color: theme.palette.secondary[500], display: 'inline' }}>
  Category:
                </Typography>
    </Box>
    <Box>
    <Typography variant="body1" sx={{ color: theme.palette.secondary[100], display: 'inline' }}>
    {detailData.incidentCategory}
                </Typography>
    </Box>
      </Box>


      <Box
          display="flex"
      >
    <Box>
  <Typography variant="body1" mr={1} sx={{ color: theme.palette.secondary[500], display: 'inline' }}>
  Description:
                </Typography>
    </Box>
    <Box>
    <Typography variant="body1" sx={{ color: theme.palette.secondary[100], display: 'inline' }}>
    {detailData.incidentDescription}
                </Typography>
    </Box>
      </Box>

        </CardContent>
      </Card>

      <Card
        sx={{
          backgroundImage: 'none',
          backgroundColor: theme.palette.background.alt,
          borderRadius: '0.55rem',
          marginTop: '20px', // Adjust margin top as needed
          minWidth: '400px', // Adjust the width as needed
          width: '400px',
          // height: '650px',
          padding: "0px", // Ensures the Card takes full width if maxWidth is not reached
          // margin: '0 auto', // Center the Card horizontally
        }}
      >
         <CardContent>
            <Box mb={4}>
            <MapContainer center={[detailData.incidentPosition._lat, detailData.incidentPosition._long]} zoom={15}>
                <TileLayer
                  attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                  url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                />
                <MarkerClusterGroup
                  chunkedLoading
                  iconCreateFunction={createClusterCustomIcon}
                >
          {/* <Marker position={detailData.incidentPosition} icon={pin2}>
            <Popup>{detailData.incidentDescription}<h1>hi</h1></Popup>
          </Marker> */}
          <Marker position={[detailData.incidentPosition._lat, detailData.incidentPosition._long ]} icon={pin2}>
          <Popup>{detailData.incidentDescription}<h1>{detailData.incidentCategory}</h1></Popup>
        </Marker>
                </MarkerClusterGroup>
              </MapContainer>
            </Box>
            {/* <Typography
              sx={{ fontSize: 16, color: theme.palette.secondary[300], marginBottom: '20px', textAlign: "center" }}
              gutterBottom
            >
              Address: {detailData.incidentAddress}
            </Typography> */}
          </CardContent>
      </Card>
      </>
      ) : (
            <CircularProgress/>
          )}

    </Box>
  </Container>
  );
};

export default DetailPage;
