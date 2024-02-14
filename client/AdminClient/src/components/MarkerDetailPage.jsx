// DetailPage.js

import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { Box, Card, CardContent, CardMedia , Typography, useTheme, Container } from '@mui/material';
import { collection, getDoc, doc } from 'firebase/firestore';
import { db } from '../config/firebase';
import CircularProgress from '@mui/material/CircularProgress';


const MarkerDetailPage = () => {
  const theme = useTheme();

  const { id } = useParams(); // Get the ID from the URL

  const [detailData, setDetailData] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const markerDocRef = doc(db, 'Markers', id);
        const markerDocSnapshot = await getDoc(markerDocRef);

        if (markerDocSnapshot.exists()) {
          setDetailData(markerDocSnapshot.data());
        } else {
          console.log('Document does not exist!');
        }
      } catch (error) {
        console.error('Error fetching detail data:', error);
      }
    };
    
    fetchData();
  }, [id]);
  
  // console.log("detailData>>>>>>>>>>>>>>>>>>>>", detailData);
  return (
    <Container maxWidth="md" 
    // sx={{backgroundColor: theme.palette.background.alt,}}
    >
    <Box 
    m="1.5rem 2.5rem"
    height='80vh'
    // w="50rem"
    // minHeight="700px"
    // height="50rem"
    // position="relative"
    display="flex"
    alignItems="center"
    justifyContent="center"


    >
      <Card sx={{
         backgroundColor: theme.palette.background.alt,
         }}>
        <CardContent>
          {detailData ? (
            <>
               <CardMedia
        sx={{ height: 600, width:500, margin:3, objectFit: 'contain' }}
        image={detailData.imageUrl}
        title="green iguana"
      />



      <Box
          display="flex"
      >
    <Box>
  <Typography variant="body1" mr={1} sx={{ color: theme.palette.secondary[500], }}>
                  Address:
                </Typography>
    </Box>
    <Box>
    <Typography variant="body1" sx={{ color: theme.palette.secondary[100]}}>
                  {detailData.address}
                </Typography>
    </Box>
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
    {detailData.formattedTime}
                </Typography>
    </Box>
      </Box>
{/* 
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
      </Box> */}


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
    {detailData.description}
                </Typography>
    </Box>
      </Box>
            </>
          ) : (
<CircularProgress/>
          )}
        </CardContent>
      </Card>
    </Box>
  </Container>
  );
};

export default MarkerDetailPage;
