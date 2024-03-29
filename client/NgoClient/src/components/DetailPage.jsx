// DetailPage.js

import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import {
  Box,
  Card,
  CardHeader,
  Avatar,
  CardContent,
  CardMedia,
  Typography,
  Button,
  useTheme,
  Container,
} from "@mui/material";
import { collection, getDoc, doc } from "firebase/firestore";
import { db } from "../config/firebase";
import CircularProgress from "@mui/material/CircularProgress";

// import { Toaster, toast } from 'sonner'


//------------------------leaflet config------------------------
import "../leaflet_myconfig.css";
import "leaflet/dist/leaflet.css";
import { MapContainer, TileLayer, Marker, Popup, Polygon } from "react-leaflet";
import MarkerClusterGroup from "react-leaflet-cluster";
import { useMapEvents } from "react-leaflet/hooks";

import CancelIcon from "@mui/icons-material/Cancel";
import HourglassTopIcon from "@mui/icons-material/HourglassTop";
import VerifiedUserIcon from "@mui/icons-material/VerifiedUser";

import pinIcon1 from "../assets/placeholder.png";
import pinIcon2 from "../assets/pin.png";
import pinIcon3 from "../assets/destination.png";

import { Icon, divIcon, point } from "leaflet";
import { fetchVolunteerById, fetchVolunteersByNgoId, updateVolunteerStatusById } from "../api/Ngo";


import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";


const  DetailPage = () => {

  const queryClient = useQueryClient();


  const updateVolunteerStatusMutation = useMutation({
    mutationFn: updateVolunteerStatusById,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['volunteers']});
      console.log("success bro!")
    }
  });

  const theme = useTheme();

  const { id, volunteerId } = useParams();

  const {
    isLoading,
    isError,
    data: volunteers,
    error,
  } = useQuery({
    queryKey: ["volunteers", id],
    queryFn: () => fetchVolunteersByNgoId(id)
  });


  const volunteer = volunteers?.find(e => e.userId === volunteerId)

  // console.log('volunteer>>>>>', volunteer);
  // const data = queryClient.getQueryData(["volunteer"])

  // console.log('cached>>>>>>>>>>>>>>', data);

  // const result = useQuery({
  //   queryKey: ['todo', todoId],
  //   queryFn: () => fetch(`/todos/${todoId}`),
  //   initialData: () => {
  //     // Use a todo from the 'todos' query as the initial data for this todo query
  //     return queryClient.getQueryData(['todos'])?.find((d) => d.id === todoId)
  //   },
  // })
  // console.log("volunteer id in page", id);
  // console.log("volunteer  data page", volunteer);

  const pin2 = new Icon({
    iconUrl: pinIcon2,
    iconSize: [38, 38], // size of the icon
  });
  // custom cluster icon
  const createClusterCustomIcon = function (cluster) {
    return new divIcon({
      html: `<span class="cluster-icon">${cluster.getChildCount()}</span>`,
      className: "custom-marker-cluster",
      iconSize: point(33, 33, true),
    });
  };

  const handleVolunteerStatus = ( status) => { 
    console.log('click id',volunteerId);
    console.log('click status',status);

    updateVolunteerStatusMutation.mutate({
      id,
      volunteerId,
      status
    })
   }

  return (
    <Container
      maxWidth="xl"
      // sx={{backgroundColor: theme.palette.background.alt,}}
    >
      <Box
        m="1.5rem 2.5rem"
        display="flex"
        alignItems="center"
        justifyContent="center"
        flexWrap="wrap"
        gap={3}
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
                  image={volunteer?.profileImageUrl}
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
                      {volunteer?.userName}
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
                      {volunteer?.email}
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
                      {volunteer?.phoneNumber}
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
                  image={volunteer?.idProofUrl}
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
                    {volunteer?.status === "pending" ? (
                      <Box display='flex' gap={1}>
                        <HourglassTopIcon sx={{ color: "#EDD000" }} />
                        <Typography>{volunteer.status}</Typography>
                      </Box>
                    ) : volunteer?.status === "accepted" ? (
                      <Box display='flex' gap={1}>
                        <VerifiedUserIcon sx={{ color: "#5bff86" }} />
                        <Typography>{volunteer?.status}</Typography>
                      </Box>
                    ) : (
                      <Box display='flex' gap={1}>
                        <CancelIcon sx={{ color: "red" }} />
                        <Typography>{volunteer?.status}</Typography>
                      </Box>
                    )}
                  </Box>
                </Box>
                {volunteer?.status === 'pending' && (
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

      </Container>
  )
        }




                    export default DetailPage;
        