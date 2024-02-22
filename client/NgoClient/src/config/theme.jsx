// color design tokens export
export const tokensDark = {

  grey: {
    0: "#ffffff", // manually adjusted
    10: "#f6f6f6", // manually adjusted
    50: "#f0f0f0", // manually adjusted
    100: "#e0e0e0",
    200: "#c2c2c2",
    300: "#a3a3a3",
    400: "#858585",
    500: "#666666",
    600: "#525252",
    700: "#3d3d3d",
    800: "#292929",
    900: "#141414",
    1000: "#000000", // manually adjusted
  },

  blue: {
    // blue
    100: "#d3d4de",
    200: "#a6a9be",
    300: "#7a7f9d",
    400: "#4d547d",
    500: "#21295c",
    600: "#191F45", // manually adjusted
    700: "#141937",
    800: "#0d1025",
    900: "#070812",
  },


  
// grey: {
//   0: "#ffffff",
//   10: "#ffffff",
//   50: "#ffffff",
//   100: "#ffffff",
//     500: "#ffffff",//main
//     600: "#cccccc",
//     700: "#999999",
//     800: "#666666",
//     900: "#333333"
// },

//dark green
background: {
    0: "#d2dfe1",
    50: "#a5c0c4",
    300: "#79a0a6",
    400: "#4c8189",
    500: "#1f616b",//main
    600: "#194e56",
    700: "#133a40",
    800: "#0c272b",
    900: "#061315"
},

//light green
primary: {
    100: "#ccf7e6",
    200: "#99efcd",
    300: "#66e6b3",
    400: "#33de9a",
    500: "#00d681",//main
    600: "#00ab67",
    700: "#00804d",
    800: "#005634",
    900: "#002b1a"
},

//grey
secondary: {
    50: "#efefef",
    200: "#dfdfdf",
    300: "#cecece",
    400: "#bebebe",
    500: "#aeaeae",//main
    600: "#8b8b8b",
    700: "#686868",
    800: "#464646",
    900: "#232323"
},

//even lighter green used for action buttons
accent: {
    0: "#e0faf0",
    50: "#c2f5e1",
    300: "#a3f0d1",
    400: "#85ebc2",
    500: "#66e6b3",//main
    600: "#52b88f",
    700: "#3d8a6b",
    800: "#295c48",
    900: "#142e24"
},

}

// function that reverses the color palette
function reverseTokens(tokensDark) {
    const reversedTokens = {};
    Object.entries(tokensDark).forEach(([key, val]) => {
      const keys = Object.keys(val);
      const values = Object.values(val);
      const length = keys.length;
      const reversedObj = {};
      for (let i = 0; i < length; i++) {
        reversedObj[keys[i]] = values[length - i - 1];
      }
      reversedTokens[key] = reversedObj;
    });
    return reversedTokens;
  }


  export const tokensLight = reverseTokens(tokensDark);




  // mui theme settings
export const themeSettings = (mode) => {
    return {
      palette: {
        mode: mode,
        ...(mode === "dark"
          ? {
              // palette values for dark mode
              primary: {
                ...tokensDark.background,
                main: tokensDark.background[500],
                light: tokensDark.background[500],
              },
              secondary: {
                ...tokensDark.primary,
                main: tokensDark.primary[500],
              },
              neutral: {
                ...tokensDark.grey,
                main: tokensDark.grey[500],
              },
              background: {
                default: tokensDark.background[600],
                alt: tokensDark.background[500],
              },
            }
          : {
              // palette values for light mode
              primary: {
                ...tokensLight.background,
                main: tokensDark.grey[50],
                light: tokensDark.grey[100],
              },
              secondary: {
                ...tokensLight.primary,
                main: tokensDark.primary[600],
                light: tokensDark.primary[700],
              },
              neutral: {
                ...tokensLight.grey,
                main: tokensDark.grey[500],
              },
              background: {
                default: tokensDark.background[0],
                alt: tokensDark.grey[50],
              },
            }),
      },
      typography: {
        fontFamily: ["Inter", "sans-serif"].join(","),
        fontSize: 12,
        h1: {
          fontFamily: ["Inter", "sans-serif"].join(","),
          fontSize: 40,
        },
        h2: {
          fontFamily: ["Inter", "sans-serif"].join(","),
          fontSize: 32,
        },
        h3: {
          fontFamily: ["Inter", "sans-serif"].join(","),
          fontSize: 24,
        },
        h4: {
          fontFamily: ["Inter", "sans-serif"].join(","),
          fontSize: 20,
        },
        h5: {
          fontFamily: ["Inter", "sans-serif"].join(","),
          fontSize: 16,
        },
        h6: {
          fontFamily: ["Inter", "sans-serif"].join(","),
          fontSize: 14,
        },
      },
    };
  };
  