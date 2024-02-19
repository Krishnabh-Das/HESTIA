import { useSnackbar } from 'notistack';
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/material/SvgIcon/SvgIcon";
import React, {Fragment, useEffect, useState} from "react";


const useNotification = () => {
    const [conf, setConf] = useState({});
    const { enqueueSnackbar, closeSnackbar } = useSnackbar();
    const action = key => (
        <Fragment>
            <IconButton onClick={() => { closeSnackbar(key) }}>
                <CloseIcon />
            </IconButton>
        </Fragment>
    );
    useEffect(()=>{
        if(conf?.msg){
            let variant = 'info';
            if(conf.variant){
                variant = conf.variant;
            }
            enqueueSnackbar(conf.msg, {
                variant: variant,
                autoHideDuration: 5000,
                action
            });
        }
    },[conf]);
    return [conf, setConf];
};

export default useNotification;