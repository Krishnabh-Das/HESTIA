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
import Header from "components/Header";
import axios from 'axios';


// import { useNavigate } from 'react-router-dom'; // Import useNavigate hook



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
        sx={{ height: 600, width:500, margin:3, objectFit: 'contain' }}
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

    const batch = writeBatch(db);


      console.log("filtered data in Region>>>>>>>>", filteredData);

      const regionStats = filteredData.length;

      console.log("regionStats------------------->", regionStats);



      console.log("regionList in Region>>>>>>>>", regionList);

  const coordinates = await Promise.all(
    filteredData.map(async (region) => {
      const lat = region.central_coord._lat;
      const lon = region.central_coord._long;
      const postData = {
        lat: lat.toString(),
        lon: lon.toString(),
      };

      try {
        let response = await axios.post(
          `${process.env.REACT_APP_API_BASE_URL}/location/get`,
          postData,
          {
            headers: {
              'Content-Type': "application/json",
            },
          }
        );

        console.log("address from the region map response -------------------->", response.data.address);
  
        // const regionDocRef = doc(db, "RegionMap", region.id);
        // batch.update(regionDocRef, { address: response.data.address });

        // console.log(`Successfully updated document ${region.id}`);


        return { lat, lon, address: response.data.address };
      } catch (err) {
        console.log(
          "Error in getting the address from coordinates: ",
          err.message
        );
        console.log(`Failed to update document ${region.id}`);
      }
    }))
  //coordinates that will be later used to display in the region map cards

  //  writeBatch(batch)
  
  // console.log("Batch write completed.");

  console.log('Coordinates for all regions:', coordinates);
  setRegionList(coordinates)

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


  return (
    <Box m="1.5rem 2.5rem">
      <Header title="REGION MAP" subtitle="See all the region maps here." />
      {regionList.length !== 0  ? (
        <Box
          mt="20px"
          display="grid"
          gridTemplateColumns="repeat(4, minmax(0, 1fr))"
          justifyContent="space-between"
          rowGap="20px"
          columnGap="1.33%"
          sx={{
            "& > div": { gridColumn: isNonMobile ? undefined : "span 4" },
          }}
        >
{regionList.map(({ address}) => (
    <Product
  address={address}
    />
))}
        </Box>
      ) : (
        <>
        <CircularProgress/>
        </>
      )}
    </Box>
  );
};

export default RegionMap;
