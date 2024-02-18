import React, {useState, useEffect} from "react";
import { ResponsivePie } from "@nivo/pie";
import { Box, Typography, useTheme } from "@mui/material";

import { db, auth, storage } from "../config/firebase";

import {
getDocs,
collection,
addDoc,
deleteDoc,
updateDoc,
doc,
} from "firebase/firestore";


const BreakdownChart = ({ isDashboard = false }) => {

  const [sosList, setSosList] = useState([])

  const [sosLen, setSosLen] = useState(0); // initialize with a default value
  
  
  const SosReportsRef = collection(db, "SOS_Reports")
  
  
    const getSosReportsList = async () => { 
      try {
        const data = await getDocs(SosReportsRef);
  
        const filteredData = data.docs.map((doc) => ({
          ...doc.data(),
          id: doc.id,
        }));

      const sosStats = filteredData.length;

        setSosList(filteredData);

      return {sosStats, filteredData};
  
  
      } catch (err) {
        console.error(err);
      }
    }


  useEffect(() => {
    const fetchData = async () => { 
      const {sosStats, filteredData}= await getSosReportsList();
      setSosLen(sosStats)
      setSosList(filteredData)
    };
    
    fetchData();
  }, []);
  
  
        // console.log("sosLen inside breakdown chart------->>>>>>>>>>>>>>>>>>", sosLen);
        // console.log("sosList in breakdown chart---------->>>>>>>>>>>>>>>>>>", sosList);



  // const { data, isLoading } = useGetSalesQuery();
  const theme = useTheme();

  // if (!data) return "Loading...";

  // const colors = [
  //   theme.palette.secondary[500],
  //   theme.palette.secondary[300],
  //   theme.palette.secondary[300],
  //   theme.palette.secondary[500],
  // ];


  // const formattedData = Object.entries(data.salesByCategory).map(
  //   ([category, sales], i) => ({
  //     id: category,
  //     label: category,
  //     value: sales,
  //     // color: colors[i],
  //   })
  // );

  // console.log("dashbaord => data in salesByCategory>>>>>>>>>>>>>>>",data.salesByCategory);
  // console.log("dashbaord => formatted data in pie---------------->", formattedData);

  const countIncidentCategories = (sosList) => {
    const categoryCounts = {};
  
    sosList.forEach((incident) => {
      const category = incident.incidentCategory;
  
      if (categoryCounts[category]) {
        categoryCounts[category]++;
      } else {
        categoryCounts[category] = 1;
      }
    });
  
    return categoryCounts;
  };


  return (
    <Box
      height={isDashboard ? "400px" : "100%"}
      width={undefined}
      minHeight={isDashboard ? "325px" : undefined}
      minWidth={isDashboard ? "325px" : undefined}
      position="relative"
    >
    </Box>
  );
};

export default BreakdownChart;
