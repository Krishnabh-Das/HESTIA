import React from "react";
import Header from "../../components/Header";
import { useEffect, useState } from "react";
import {
  Box,
  Button,
  CardMedia,
  CardActions,
  Card,
  CardContent,
  Snackbar,
  Typography,
  useTheme,
  useMediaQuery,
  IconButton,
  Tooltip, 
  TextField
} from "@mui/material";

import CircularProgress from '@mui/material/CircularProgress';

import { useNavigate } from 'react-router-dom';

import destination from "../../assets/map_image.jpg";
import RoomIcon from '@mui/icons-material/Room';
import AlarmIcon from '@mui/icons-material/Alarm';
import EmailIcon from '@mui/icons-material/Email';
import EditIcon from '@mui/icons-material/Edit';
import HandshakeIcon from '@mui/icons-material/Handshake';

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { fetchEvents, fetchEventsById } from "../../api/Ngo";
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth';
import { useDispatch, useSelector } from "react-redux";
import { setUser, setAuthChecked, selectUser, selectAuthChecked } from "../../state/userSlice";

function EventDetails() {

  const navigate = useNavigate();
  const queryClient = useQueryClient();


  const handleVolunteerClick = (option, id) => { 
    navigate(`/eventdetailsvolunteer/${id}/${option}`)
    // navigate(`/eventdetailsvolunteer`)
   }
   const user = useSelector(selectUser);
   console.log("<>userid?>>>>>>>>>>>>>>>>>>>>>>>>>",user?.uid);
  const theme = useTheme();

  const isNonMobile = useMediaQuery("(min-width: 1000px)");
  const handleAddressClick = (lat,long) => { 
    // window.location.href = 'https://www.google.com/maps?q=51.917168,-0.227051'
    window.open(`https://www.google.com/maps?q=${lat},${long}`, '_blank');
    // window.open('https://www.google.com/maps?q=51.917168,-0.227051', '_blank');
   } 

   const {
    isLoading,
    isError,
    data: events,
    error,
  } = useQuery({
    queryKey: ["events", user?.uid], // Include user.uid in the query key
    queryFn: () => fetchEventsById(user?.uid), // Call fetchEventsById with user.uid
  });

  return (
    <Box m="1.5rem 2.5rem">
      <Header
        title="Event Details"
        subtitle="all events organized by your ngo"
      />
      <Box
        mt="20px"
        display="flex"
        flexWrap="wrap"
        alignItems="center"
        justifyContent="center"
        gap={3}
        sx={{
          "& > div": { gridColumn:  "span 4" },
        }}
      >
   {isLoading ? <CircularProgress/> : 
    events.map((event) =>(

      <Card
        key={event.event_id}
      sx={{
          backgroundImage: 'none',
          backgroundColor: theme.palette.background.alt,
          borderRadius: '0.55rem',
          marginTop: '20px', // Adjust margin top as needed
          maxWidth: '400px', // Adjust the width as needed
          width: '100%',
          padding: "0px", // Ensures the Card takes full width if maxWidth is not reached
          // margin: '0 auto', // Center the Card horizontally
        position: 'relative'
        }}
      >
        <CardMedia
          component="img"
          alt="event"
          height="300"
          // width='500'
          image={event.poster}
          //1
          // image={event.poster}
          sx={{
            padding: "1em 1em ",
            objectFit: "cover",
            borderRadius: "20px",
          }}
        />
  
        <CardContent>
  
        <Box display='flex' flexDirection='column' gap={3}>
  
          <Box
      sx={{
          borderColor: '#fff',
          border: '200px',
      }}
      display='flex'
      justifyContent='center'
      alignItems='center'>
  
  <Typography
            sx={{ fontSize: 20 }}
            color={theme.palette.grey[50]}
            gutterBottom
          >
          {event.eventName}
          </Typography>
      </Box>
  
  
  
  <Box display='flex' justifyContent='space-between' alignItems='center'>
  <Box>
  <Box display='flex' gap={1}>
  <CalendarMonthIcon color="secondary" sx={{ height: '100%', width: '20px'}}/>
  <Typography variant="h5" >{event.fromDate}- {event.toDate}</Typography>
  </Box>
  
  </Box>
  
  <Box>
  <IconButton sx={{backgroundColor: '#33de9a'}} onClick={ () => handleAddressClick
    (event.location._lat, event.location._long)
    }>
      <RoomIcon sx={{color: 'white'}}/>
  </IconButton>
  </Box>
  </Box>
  
  <Box display='flex' justifyContent='space-between' alignItems='center'>
  <Box display='flex' gap={1}>
  <AlarmIcon color="secondary" sx={{ height: '100%', width: '20px'}}/>
  <Typography variant="h5" >{event.time}</Typography>
  </Box>
  </Box>
  
  <Box display='flex' justifyContent='space-between' alignItems='center'>
  <Box>
  <Box display='flex' gap={1}>
  <EmailIcon color="secondary" sx={{ height: '100%', width: '20px'}}/>
  <Typography variant="h5" >{event.eventContact}</Typography>
  </Box>
  
  </Box>  
  
  <Box>
  <Box display='flex' gap={1} alignItems='center' >
  <HandshakeIcon color="secondary" sx={{ height: '100%'}}/>
  <Box width='100px' display='flex' alignItems='flex-start' justifyContent='flex-start'>
  <Typography variant="h5" >{event.type} </Typography>
  </Box>
  </Box>
  </Box> 
  
  
  </Box>
  
  
  <Box>
                <TextField
                  fullWidth
                  size="medium"
                  label="Event Description"
                  variant="filled"
                  value={event.eventDescription}
                  // onChange={(e) => setEventDescription(e.target.value)}
                  multiline
                  rows={4}
                  InputProps={{
                    readOnly: true,
                  }}
                />
              </Box>
  
  
  
  <Box
      sx={{
          borderColor: '#fff',
          border: '200px',
      }}
      display='flex'
      justifyContent='center'
      alignItems='center'>
  
  <Typography
            sx={{ fontSize: 20 }}
            color={theme.palette.grey[50]}
            gutterBottom
          >
          Volunteer List
          </Typography>
      </Box>
  
  
  
  <Box display='flex' justifyContent='space-between' gap={3}>
  <Button
                    variant="contained"
                    color="secondary"
  
                    sx={{
                      fontSize: "14px",
                      fontWeight: "bold",
                      padding: "10px 20px",
                    }}
  
                    onClick={() => handleVolunteerClick('pending', event.event_id)}
         >
           Pending
         </Button>
  
         <Button
                    variant="contained"
                    color="secondary"
  
                    sx={{
                      fontSize: "14px",
                      fontWeight: "bold",
                      padding: "10px 20px",
                    }}
                    onClick={() => handleVolunteerClick('accepted',event.event_id)}
         >
           Accepted
         </Button>
  </Box>
  
  
  
  
  
  </Box>
  
          {/* <Box
                    display="flex"
                    alignItems="center"
                    justifyContent="flex-end"
                  >
                  </Box> */}
  
  
  
        </CardContent>
  
        <Box position="absolute" top={10} right={10}> {/* Positioned the EditIcon button */}
  <IconButton sx={{
  background: '#fff',
  '&:hover': {
    background: '#eee', // Change the hover background color as needed
  },
  }}>
  <EditIcon sx={{
    color: '#000'
  }}/>
  </IconButton>
  </Box>
  
      </Card>


    ))
}

        
      </Box>



    </Box>
  );
}

export default EventDetails;
