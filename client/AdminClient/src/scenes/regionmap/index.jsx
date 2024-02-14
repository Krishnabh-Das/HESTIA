import { useEffect, useState } from "react";
import {
  Box,
  Card,
  CardActions,
  CardContent,
  CardMedia,
  Typography,
  useTheme,
  useMediaQuery,
} from "@mui/material";


import {
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
  writeBatch
} from "firebase/firestore";


import mapImage from '../../assets/map_image.jpg'
import CircularProgress from '@mui/material/CircularProgress';
import { db} from "../../config/firebase";
import Header from "../../components/Header";
import axios from 'axios';


// import { useNavigate } from 'react-router-dom'; // Import useNavigate hook


//------------------------leaflet config------------------------
import "../../leaflet_myconfig.css"
import "leaflet/dist/leaflet.css";
import { MapContainer, TileLayer, Marker, Popup, Polygon } from "react-leaflet";
import MarkerClusterGroup from "react-leaflet-cluster";
import { useMapEvents } from 'react-leaflet/hooks'


import pinIcon1 from '../../assets/placeholder.png'
import pinIcon2 from '../../assets/pin.png'
import pinIcon3 from '../../assets/destination.png'

import { Icon, divIcon, point } from "leaflet";

const Product = ({
address
}) => {
  const theme = useTheme();
  const [isExpanded, setIsExpanded] = useState(false);
  return (

    <Card
      sx={{
        backgroundImage: "none",
        backgroundColor: theme.palette.background.alt,
        borderRadius: "0.55rem",
      }}
    >
                   <CardMedia
        sx={{ height: 600, width:"100%", margin:3, objectFit: 'contain' }}
        image={mapImage}

        title="green iguana"
      />
      <CardContent>
        <Typography
          sx={{ fontSize: 14 }}
          color={theme.palette.secondary[300]}
          gutterBottom
        >
          {address}
        </Typography>
      </CardContent>
    </Card>
  );
};

const RegionMap = () => {
  // const theme = useTheme();

  
   //region state

   const [regionList, setRegionList] = useState([])
   const regionRef = collection(db, "RegionMap")

   const getRegion = async ()=>{
    try{
      const data = await getDocs(regionRef);

      const filteredData = data.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      console.log("data in Region>>>>>>>>", data);
    //   setRegionList(filteredData);

    // const batch = writeBatch(db);


      console.log("filtered data in Region>>>>>>>>", filteredData);



      console.log("regionList in Region>>>>>>>>", regionList);

  setRegionList(filteredData)

  console.log("||||||||||||||||||||||||||");

    }catch(err){
      console.error(err)
    }
   }
  



  useEffect(() => {
    getRegion();
  }, []);

  console.log("regionList in outside", regionList);


  const isNonMobile = useMediaQuery("(min-width: 1000px)");

  const theme = useTheme();


//------------------leaflet--------------------


const purpleOptions = { color: 'purple' }
const redOptions = {color: 'red'}


//icons
const pin1 = new Icon({

  iconUrl: pinIcon1,
  iconSize: [38, 38] // size of the icon
});


const pin2 = new Icon({
  iconUrl: pinIcon2,
  iconSize: [38, 38] // size of the icon
});

const pin3 = new Icon({
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



  return (
    <Box
    m="1.5rem 2.5rem"
    w="100%"
    h="100%">
      <Header title="REGION MAP" subtitle="See all the region maps here." />  

      <Box
      display="flex"
      flexWrap="wrap"
      gap={5}
      justifyContent="center"
      alignItems="center"
        >
        {regionList.length ===0 ? <CircularProgress/> : (



                  regionList.map((e) => (
      <Card
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
         <CardContent>
            <Box mb={4}>
              <MapContainer center={[e.central_coord._lat , e.central_coord._long]} zoom={15}>
                <TileLayer
                  attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                  url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                />
                <MarkerClusterGroup
                  chunkedLoading
                  iconCreateFunction={createClusterCustomIcon}
                >
                    <Polygon
                      pathOptions={purpleOptions}
                      positions={e.coords.map(({ _lat, _long }) => [_lat, _long])}
                    >
                      <Popup>Popup in Polygon</Popup>
                    </Polygon>
                </MarkerClusterGroup>
              </MapContainer>
            </Box>
            <Typography
              sx={{ fontSize: 16, color: theme.palette.secondary[300], marginBottom: '20px', textAlign: "center" }}
              gutterBottom
            >
              Address: {e.location}
            </Typography>
          </CardContent>
      </Card>
                  ))

         )}

</Box>

    </Box>
  );
};

export default RegionMap;
