import React from "react";
import { Marker, Popup } from "react-leaflet";
import L from "leaflet";

import {
  Box,
  Button,
  useTheme,
  Container,
  Card,
  CardContent,
  CardMedia,
  Typography,
  IconButton,
  Tooltip,
  Avatar,
} from "@mui/material";



// const customMarkerStyle = {
//     color: '#ffffff', 
//     borderRadius: '50%', 
//     width: '30px', 
//     height: '30px', 
//     textAlign: 'center', 
//     lineHeight: '30px', 
//     fontSize: '16px', 
//   };


  const customIcon = (number) =>
  L.divIcon({
    className: 'custom-marker',
    html: `<div style='background-color:#c30b82; color: #ffffff; border-radius:50%; width:30px; height:30px; text-align: center; font-size: 20px;' >${number}</div>`,
    iconAnchor: [15, 15], // Adjust the icon anchor for proper positioning
    // iconSize: [30, 30], // Adjust the icon size for proper positioning
  });

const CustomMarker = ({ position, order, description,imageUrl,address,formattedTime  }) => (
  <Marker position={position} icon={customIcon(order)}>
    <Popup>
       <MarkerPopup
                                    description={description}
                                    imageUrl={imageUrl}
                                    address={address}
                                    formattedTime={formattedTime}
                                  />
    </Popup>
  </Marker>
);

export default CustomMarker;


const MarkerPopup = ({ imageUrl, description, formattedTime, address }) => {
  const theme = useTheme();

  return (
    // <div style={{ height: '200px', maxWidth: '200px' }}>
    <Box
      sx={{
        backgroundColor: theme.palette.background.alt,
        "& .MuiTypography-root": {
          margin: 0, // Remove default margin for Typography components
        },
        "& .MuiBox-root": {
          margin: 0, // Remove default margin for Typography components
        },
        width: "300px",
        height: "200px",
      }}
    >
      <Box
        sx={{
          display: "flex",
          // flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <img
          src={imageUrl}
          alt=""
          srcSet=""
          style={{ width: "100%", height: "100px", maxWidth: "100px" }}
        />
      </Box>

      <Box mt={2} display="flex">
        <Box>
          <Typography
            variant="body1"
            mr={1}
            sx={{ color: theme.palette.secondary[500] }}
          >
            Description:
          </Typography>
        </Box>
        <Box>
          <Typography
            variant="body1"
            sx={{ color: theme.palette.secondary[100] }}
          >
            {description}
          </Typography>
        </Box>
      </Box>

      <Box mt={2} display="flex">
        <Box>
          <Typography
            variant="body1"
            mr={2}
            sx={{ color: theme.palette.secondary[500] }}
          >
            Time:
          </Typography>
        </Box>
        <Box>
          <Typography
            variant="body1"
            sx={{ color: theme.palette.secondary[100] }}
          >
            {formattedTime}
          </Typography>
        </Box>
      </Box>

      <Box mt={2} display="flex">
        <Box>
          <Typography
            variant="body1"
            mr={1}
            sx={{ color: theme.palette.secondary[500] }}
          >
            Address:
          </Typography>
        </Box>
        <Box>
          <Typography
            variant="body1"
            sx={{ color: theme.palette.secondary[100] }}
          >
            {address}
          </Typography>
        </Box>
      </Box>
    </Box>
  );
};
