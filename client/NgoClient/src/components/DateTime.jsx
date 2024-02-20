import * as React from "react";
import Stack from "@mui/material/Stack";
import TextField from "@mui/material/TextField";
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { DesktopTimePicker } from "@mui/x-date-pickers/DesktopTimePicker";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";
import { DesktopDatePicker } from "@mui/x-date-pickers/DesktopDatePicker";
import CalendarMonthIcon from "@mui/icons-material/CalendarMonth";
import ArrowLeftIcon from "@mui/icons-material/ArrowLeft";
import ArrowRightIcon from "@mui/icons-material/ArrowRight";

import dayjs from 'dayjs';


import { Button,  Grid, Typography, Container, Box } from '@mui/material';
// import { SxProps } from "@mui/system";

export default function MaterialUIPickers() {
  //const [value, setValue] = React.useState(new Date("04/01/2022 12:00:00"));
  const [value, setValue] = React.useState(new Date());

  const handleChange = (newValue) => {
    setValue(newValue);
  };

  const popperSx= {
    "& .MuiPaper-root": {
      border: "1px solid black",
      padding: 2,
      marginTop: 1,
      backgroundColor: "rgba(120, 120, 120, 0.2)"
    },
    "& .MuiCalendarPicker-root": {
      backgroundColor: "rgba(45, 85, 255, 0.4)"
    },
    "& .PrivatePickersSlideTransition-root": {},
    "& .MuiPickersDay-dayWithMargin": {
      color: "rgb(229,228,226)",
      backgroundColor: "rgba(50, 136, 153)"
    },
    "& .MuiTabs-root": { backgroundColor: "rgba(120, 120, 120, 0.4)" }
  };

  return (
    <>
      <LocalizationProvider dateAdapter={AdapterDayjs}>
        <Stack spacing={3}>
          <DesktopDatePicker
            label="Date"
            inputFormat="MM/DD/YYYY" //depends on date lib
            value={dayjs(value)}
            //                   value={dayjs(values.dob)}
            onChange={setValue}
            renderInput={(params) => {
              return <TextField {...params} />;
            }}
            views={["day", "month"]}
            showDaysOutsideCurrentMonth //very useful
            //@ts-ignore
            clearable //Typing seems to be missing for this
          />
          <DesktopTimePicker
            label="Time"
            value={dayjs(value)}
            onChange={handleChange}
            renderInput={(params) => <TextField {...params} />}
          />
          <DateTimePicker
            label="Date And Time Picker"
            value={dayjs(value)}
            onChange={handleChange}
            components={{
              OpenPickerIcon: CalendarMonthIcon,
              LeftArrowIcon: ArrowLeftIcon,
              RightArrowIcon: ArrowRightIcon
            }}
            InputProps={{ sx: { "& .MuiSvgIcon-root": { color: "blue" } } }}
            PopperProps={{
              sx: popperSx
            }}
            renderInput={(params) => <TextField {...params} />}
          />
          <Button onClick={()=>setValue(null)}>Clear</Button>
        </Stack>
      </LocalizationProvider>
      <div style={{ marginTop: 50 }}>
        <a
          target="_blank"
          href="https://smartdevpreneur.com/the-ultimate-material-ui-v5-datepicker-and-timepicker-tutorial/"
        >
          Here's everything to know about styling the Date Picker!
        </a>
      </div>
    </>
  );
}

//===============================


// import * as React from 'react';
// import { DemoContainer } from '@mui/x-date-pickers/internals/demo';
// import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
// import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
// import { DatePicker } from '@mui/x-date-pickers/DatePicker';

// import { DesktopTimePicker } from "@mui/x-date-pickers/DesktopTimePicker";

// import { Button,  Grid, Typography, Container, Box } from '@mui/material';
// export default function BasicDatePicker() {
//     const [value, setValue] = React.useState(new Date());

//       const handleChange = (newValue) => {
//     setValue(newValue);
//   };
//   return (
//     <>
//     <LocalizationProvider dateAdapter={AdapterDayjs}>
//         <DatePicker label="Basic date picker" />

//         <DesktopTimePicker
//             label="Time"
//             value={value}
//             onChange={handleChange}
//             slotProps={{ textField: { variant: 'outlined' } }}
//           />
//     </LocalizationProvider>


//     <Box>

//     </Box>
//     </>
//   );
// }



// import React from "react";
// import { Formik } from "formik";
// import { Box, Button, Paper, Stack, TextField, styled } from "@mui/material";
// import { Lock } from "@mui/icons-material";
// import * as yup from "yup";
// import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
// import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
// import { DatePicker } from "@mui/x-date-pickers/DatePicker";
// import dayjs from 'dayjs';

// const LoginPage = () => {
//   const StyledPaper = styled(Paper)({
//     width: "500px",
//     borderRadius: "10px",
//     backgroundColor: "white",
//     padding: "30px",
//     position: "absolute",
//     top: "50%",
//     left: "50%",
//     transform: "translate(-50%, -50%)"
//   });

//   //----VALIDATION-----//

//   const userSchema = yup.object().shape({
//     userName: yup.string().required("required"),
//     dob: yup.date().required("required")
//   });

//   const handleFormSubmit = (values, onSubmitProps) => {
//     console.log(values);
//   };

//   return (
//     <Formik
//       onSubmit={handleFormSubmit}
//       initialValues={{ userName: "", dob: new Date() }}
//       validationSchema={userSchema}
//     >
//       {({
//         values,
//         errors,
//         touched,
//         handleBlur,
//         handleChange,
//         handleSubmit,
//         resetForm
//       }) => (
//         <form onSubmit={handleSubmit}>
//           <StyledPaper elevation={3}>
//             <Box
//               sx={{
//                 display: "flex",
//                 justifyContent: "center",
//                 alignItems: "center",
//                 margin: "10px"
//               }}
//             >
//               <Lock color="primary" fontSize="large" />
//             </Box>
//             <Stack direction="column" gap={2}>
//               <TextField
//                 label="User Name"
//                 value={values.userName}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 name="userName"
//                 error={Boolean(touched.userName) && Boolean(errors.userName)}
//                 helperText={touched.userName && errors.userName}
//               />

//               <LocalizationProvider dateAdapter={AdapterDayjs}>
//                 <DatePicker
//                   label="Date of birth"
//                   value={dayjs(values.dob)}
//                   onChange={handleChange}
//                   onBlur={handleBlur}
//                   name="dob"
//                   error={Boolean(touched.dob) && Boolean(errors.dob)}
//                   helperText={touched.dob && errors.dob}
//                 />
//               </LocalizationProvider>

//               <Button variant="contained" type="submit">
//                 Submit
//                 </Button>
//             </Stack>
//           </StyledPaper>
//         </form>
//       )}
//     </Formik>
//   );
// };



// export default LoginPage;