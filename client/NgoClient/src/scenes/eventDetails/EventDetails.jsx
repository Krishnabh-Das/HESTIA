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
import {
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
} from "firebase/firestore";

import destination from "../../assets/map_image.jpg";

import RoomIcon from '@mui/icons-material/Room';

import AlarmIcon from '@mui/icons-material/Alarm';

import EmailIcon from '@mui/icons-material/Email';

import EditIcon from '@mui/icons-material/Edit';

import HandshakeIcon from '@mui/icons-material/Handshake';

function EventDetails() {
  const theme = useTheme();

  const isNonMobile = useMediaQuery("(min-width: 1000px)");

  const handleAddressClick = () => { 
    // window.location.href = 'https://www.google.com/maps?q=51.917168,-0.227051'
    window.open('https://www.google.com/maps?q=51.917168,-0.227051', '_blank');
   } 

  return (
    <Box m="1.5rem 2.5rem">
      <Header
        title="Event Details"
        subtitle="all events organized by your ngo"
      />
      <Box
        mt="20px"
        display="grid"
        gridTemplateColumns="repeat(4, minmax(0, 1fr))"
        justifyContent="space-between"
        rowGap="20px"
        columnGap="1.33%"
        sx={{
          "& > div": { gridColumn:  "span 4" },
        }}
      >
        <Card
          //   key={id}
        //   sx={{
        //     backgroundImage: "none",
        //     backgroundColor: theme.palette.background.alt,
        //     borderRadius: "0.55rem",
        //     // width: "600px",
        //     // width: "600px",
        //     height: "700px",
        //   }}
        sx={{
            backgroundImage: 'none',
            backgroundColor: theme.palette.background.alt,
            borderRadius: '0.55rem',
            marginTop: '20px', // Adjust margin top as needed
            maxWidth: '400px', // Adjust the width as needed
            width: '100%',
            padding: "0px", // Ensures the Card takes full width if maxWidth is not reached
            // margin: '0 auto', // Center the Card horizontally
          }}
        >
          <CardMedia
            component="img"
            alt="event"
            height="300"
            // width='500'
            image={destination}
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
            Event ka name
            </Typography>
        </Box>



<Box display='flex' justifyContent='space-between' alignItems='center'>
<Box>
    <Box display='flex' gap={1}>
    <AlarmIcon color="secondary" sx={{ height: '100%', width: '20px'}}/>
<Typography variant="h5" >7:00 PM - 8:00 PM</Typography>
    </Box>

</Box>

<Box>
    <IconButton sx={{backgroundColor: '#33de9a'}} onClick={handleAddressClick}>
        <RoomIcon sx={{color: 'white'}}/>
    </IconButton>
</Box>
</Box>


<Box display='flex' justifyContent='space-between' alignItems='center'>
<Box>
    <Box display='flex' gap={1}>
    <EmailIcon color="secondary" sx={{ height: '100%', width: '20px'}}/>
<Typography variant="h5" >test@gmail.com</Typography>
    </Box>

</Box>  

<Box>
    <Box display='flex' gap={1} alignItems='center' >
    <HandshakeIcon color="secondary" sx={{ height: '100%'}}/>
    <Box width='100px' display='flex' alignItems='flex-start' justifyContent='flex-start'>
<Typography variant="h5" >type </Typography>
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
                    defaultValue={'hi'}
                    // onChange={(e) => setEventDescription(e.target.value)}
                    multiline
                    rows={4}
                    InputProps={{
                      readOnly: true,
                    }}
                  />
                </Box>


{/* 
<Box
        sx={{
            borderColor: '#fff',
            border: '200px',
        }}
        display='flex'
        justifyContent='center'
        alignItems='center'
        flexDirection='column'>

<Typography
              sx={{ fontSize: 20 }}
              color={theme.palette.grey[50]}
              gutterBottom
            >
            Description
            </Typography>

            <Box
        sx={{
            width: '100px',
            backgroundColor:'#fff',
            height: '10em',
            width: '100%',
            padding: '1rem',
            color: '#000'
        }}
        >
            hi
        </Box>



        </Box>
 */}

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

        </Card>
        

        {/* <Card sx={{ maxWidth: 345 }}>
      <CardMedia
        component="img"
        alt="event"
        height="140"
        image={destination}
      />
      <CardContent>
        <Typography gutterBottom variant="h5" component="div">
          Lizard
        </Typography>
        <Typography variant="body2" color="text.secondary">
          Lizards are a widespread group of squamate reptiles, with over 6,000
          species, ranging across all continents except Antarctica
        </Typography>
      </CardContent>
      <CardActions>
        <Button size="small">Share</Button>
        <Button size="small">Learn More</Button>
      </CardActions>
    </Card> */}
      </Box>

      <IconButton>
      <EditIcon/>
      </IconButton>

    </Box>
  );
}

export default EventDetails;
