# HESTIA

![HESTIA COVER IMAGE](./assets/cover_image.jpg)

## Table of Contents
1. [About HESTIA](#about-hestia)
2. [Features](#features)
3. [Project Structure](#project-structure)
4. [Diagrams](#diagrams)
5. [Kanban Board](#kanban-board)
6. [Technologies Used](#technologies-used)
7. [Future Plans](#future-plans)
8. [Team Members](#team-hestia)

## About HESTIA

### Problem Statement
Approximately 150 million people, or 2% of the world's population, are affected by homelessness, which is a global issue today. The fact that many are avoiding official registration out of fear of the law and social stigma make it difficult to accurately measure this situation. Poverty exacerbates the issue of homelessness in India, where over four million individuals are thought to be homeless; however, difficulties in gathering data may understate the issue. The situation is made worse by regional issues, such as the yearly floods in Assam, which force about 300,000 people into relief camps. In spite of the wonderful efforts made by many organizations, community involvement is essential. By encouraging community involvement and improving coordination across support systems, our prototype app aims to close this gap and address homelessness from a more inclusive perspective.
### Solution

We introduce **HESTIA**, a community based application that helps the community help homeless people by integrating various features that can help them.
Through HESTIA, we promote the United Nations's sustainable goals - _1. No Poverty, 10. Reduced Inequalities, 11. Sustainable Cities and Communities, and 16. Peace, Justice and Strong Institutions_.
![UN SDGs](./assets/UN_SDG_Banner.png)


## Features

Our range of features include -

* **Crowdsourced Geotag Time Series Database Creation** - Collaborative data collection for mapping homeless populations over time.
* **Visualization through Region Maps and Markers** - Intuitive visual representation of homelessness trends using interactive maps and markers. These cover the regional stats in the form of -  total homeless sightings, crime incidents upon homeless people, upcoming events and functions organised by NGOs or Government Agencies, and finally a rating of the region determined by comprehensing the other fields.
* **Awareness Chatbot** - A conversational interface providing general information, assistance, and awareness about homelessness. Also provides additional information regarding any schemes or subisidies announced for the benefit of the homeless.
* **SOS System** - A reporting system that can sends alerts to dedicated portals for prompt assistance.
* **Web Portals for Management** - Dedicated web portals for Admins and NGOs to interact with the database.
  * **Admin Portals** - Admins can initiate database operations and manages region map generation, verification of markers, handling of SOS alerts, and provide data visualizations.
  * **NGO Portals** - NGOs can create announcements or post events, query database for relevant information, and faciliate community interaction.
* **Face-Tagged Database** - Clustering of faces in the database by using supervised and unsupervised face clustering. These face tags can be used to locate missing individuals, identifying potential criminals, identification of specific people who are need of required resources by NGOs or Government Agencies, or monitor suspicious individuals.
* **Community Page** - Display events with address and time, post announcements, request donations, donate to causes, help find missing individuals, and general community engagement.
* **Gamification** - To further improve engagement with the community, points are rewarded to individuals by acts of volunteering, posting reports, helping in spreading awareness, etc. These points will be then posted on a regional and global leaderboards.

![Application Screens](./assets/FINAL%20FEATURE%20LIST.png)

## Project Structure
```
├── assets
├── client
│   ├── AdminClient
│   │   ├── jsconfig.json
│   │   ├── package.json
│   │   ├── package-lock.json
│   │   ├── public
│   │   └── src
│   └── UserClient
│       ├── analysis_options.yaml
│       ├── android
│       ├── assets
│       ├── ios
│       ├── lib
│       ├── linux
│       ├── macos
│       ├── pubspec.lock
│       ├── pubspec.yaml
│       ├── README.md
│       ├── test
│       ├── web
│       └── windows
├── docs
│   └── uml.wsd
├── environment_droplet.yml
├── HESTIA.code-workspace
├── notebooks
│   ├── data
│   ├── keys
│   ├── Step1_Firestore_regionmaps.ipynb
│   ├── Step2_chatbot.ipynb
│   ├── Step3_human_detection.ipynb
│   ├── Step4_face_clustering
│   ├── Step5_RegionMap_Scoring.ipynb
│   ├── Step6_RadialStats.ipynb
│   └── Step7_TakeInput.ipynb
├── README.md
└── server
    ├── cloudFunctions
    │   ├── firebase.json
    │   ├── functions
    │   └── README.md
    └── custom_backend
        ├── configs
        ├── custoimErrors
        ├── docker-compose_beta.yaml
        ├── docker-compose_dev.yaml
        ├── Dockerfile
        ├── docs
        ├── main.py
        ├── processor
        ├── __pycache__
        ├── requirements.txt
        ├── schemas
        └── utils
```

## Diagrams

### Class Diagram

![Class Diagram](./assets/class_diagram.png)

### Machine Learning Pipeline
![Machine Learning Pipeline](./assets/ML_Pipeline.png)

### App Architecture
![General App Architecture](./assets/app-arch.png)

## Kanban Board

![HESTIA Project Kanban Board](./assets/HESTIA%20Project%20Kanban%20Board.png)

## Technologies Used
* **Android** - Flutter
* **Frontend** - React, Redux, MUI
* **Backend** - Firebase, FastAPI
* **Database** - Firestore, AstraDB
* **DevOps** - GitHub, Google Cloud Platform, Docker
* **Design** - Figma, FigJam, PlantUML, Canva
* **Machine Learning** - TensorFlow, scikit-learn, OpenCV, Langchain, Gemini-Pro
* **Google Technologies Used** - Flutter, Firebase, Google Cloud Platform, Tensorflow, Google Colab, Google Maps Platform, Google Analytics, Gemini-Pro

## Future Plans
* Establish alliances with global organizations for increased use and promotion.
* Adapt the platform to make it relevant worldwide and accessible to people of different clutlure and background.
* Form business alliances to promote sponsorship and workforce collaboration.
* Integrate social media for optimal reach and simple sharing.
* Use innovative and advanced analytics tools to gain insights in realtime.
* Improve AI capabilities to provide more precise support.
* Create agreements for data exchange with organizations.
* Improve leaderboard functionality to maintain long-term user interest.
* Ally with government organizations to ensure that the transfer of resources to the homeless is properly monitored.
* Redeem HESTIA tokens to get merchandise featuring homelessness awareness on t-shirts and other items.


## Team Team HESTIA
<div style="max-width: 800px;">
<div style="display: flex; flex-direction: row; justify-content: space-around; align-items: center;">


  <div style="display: flex; flex-direction: column; align-items: center; padding:10px; border: 2px solid; border-radius: 8px;  background-color: #a399b2;
background-image: linear-gradient(147deg, #a399b2 0%, #4d4855 74%); height: 300px; width:150px
">
    <a href="https://github.com/Tirthankar03">
    <div style="">
      <img src="https://github.com/Tirthankar03.png" height="140" width="140" alt="image" style="border-radius:8px; overflow:hidden;"/>
  </div>
    </a>
    <div style="text-align: center; background-color:white; color:black; width:100px; border-radius: 20px">
      Tirthankar03
    </div>
    <div style="text-align: center; margin:10px">
      <a href="https://eggsy.xyz">🔗</a> -
      <a href="https://linkedin.com/in/abdulbaki-dursun">💼</a>
    </div>
    <div style="display:flex; gap: 5px; width:100px; flex-wrap:wrap">

  <img src="https://www.vectorlogo.zone/logos/figma/figma-icon.svg" alt="figma" width="25" height="25"/>


  <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="25" height="25"/>
  
 
  <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="25" height="25"/>

  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/javascript/javascript-original.svg" alt="javascript" width="25" height="25"/>


  <img src="https://www.vectorlogo.zone/logos/getpostman/getpostman-icon.svg" alt="postman" width="25" height="25"/>

  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original-wordmark.svg" alt="react" width="25" height="25"/>
 




  </div>
  </div>



  <div style="display: flex; flex-direction: column; align-items: center; padding:10px; border: 2px solid; border-radius: 8px;background-color: #015d00;
background-image: linear-gradient(314deg, #015d00 0%, #04bf00 74%); height: 300px; width:150px
">
    <a href="https://github.com/spritan">
      <img src="https://github.com/spritan.png" height="140" width="140" alt="image" style="border-radius:8px; overflow:hidden;"/>
    </a>
    <div style="text-align: center; background-color:white; color:black; width:60px; border-radius: 20px">
      spritan
    </div>
    <div style="text-align: center; margin:10px; display:flex">
      <a href="https://merloss.netlify.app">🔗 </a> 
      <div style="color:white; background-color:darkgreen; border:2px solid; border-radius:20px; width:50px">Leader</div>
      <a href="https://linkedin.com/in/kerimkara0">💼</a>
    </div>
        <div style="display:flex; gap: 5px; width:100px; flex-wrap:wrap">

  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/linux/linux-original.svg" alt="linux" width="25" height="25"/>

  <img src="https://www.vectorlogo.zone/logos/opencv/opencv-icon.svg" alt="opencv" width="25" height="25"/>


  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="25" height="25"/>
 
  <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="25" height="25"/>

  <img src="https://www.vectorlogo.zone/logos/google_cloud/google_cloud-icon.svg" alt="gcp" width="25" height="25"/>

  <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="25" height="25"/>



 <img src="https://www.vectorlogo.zone/logos/gnu_bash/gnu_bash-icon.svg" alt="bash" width="25" height="25"/>


  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="25" height="25"/>


  <img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Scikit_learn_logo_small.svg" alt="scikit_learn" width="25" height="25"/>

  </div>
  </div>



  <div style="display: flex; flex-direction: column; align-items: center; padding:10px; border: 2px solid; border-radius: 8px;  background-color: #bf033b;
background-image: linear-gradient(315deg, #bf033b 0%, #ffc719 74%); height: 300px; width:150px
 ">
     <a href="https://github.com/pparthiv">
    <img src="https://github.com/pparthiv.png" height="140" width="140" alt="image" style="border-radius:8px; overflow:hidden;"/>
    </a>
        <div style="text-align: center; background-color:white; color:black; width:64px; border-radius: 20px">
      pparthiv
    </div>
    <div style="text-align: center; margin:10px">
      <a href="https://semihozdas.com.tr/">🔗</a> -
      <a href="https://linkedin.com/in/semihozdas">💼</a>
    </div>
        <div style="display:flex; gap: 5px; width:100px; flex-wrap:wrap">

  <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="25" height="25"/>
 
  
  <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="25" height="25"/>
  
<img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="25" height="25"/>

<img src="https://www.vectorlogo.zone/logos/google_cloud/google_cloud-icon.svg" alt="gcp" width="25" height="25"/>


  <img src="https://www.vectorlogo.zone/logos/opencv/opencv-icon.svg" alt="opencv" width="25" height="25"/>

  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/photoshop/photoshop-line.svg" alt="photoshop" width="25" height="25"/>

  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="25" height="25"/>

  <img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Scikit_learn_logo_small.svg" alt="scikit_learn" width="25" height="25"/>

  <img src="https://www.vectorlogo.zone/logos/tensorflow/tensorflow-icon.svg" alt="tensorflow" width="25" height="25"/>

  </div>
  </div>



  <div style="display: flex; flex-direction: column; align-items: center; padding:10px; border: 2px solid; border-radius: 8px; background-color: #182b3a;
background-image: linear-gradient(315deg, #182b3a 0%, #20a4f3 74%); height: 300px; width:150px
">
     <a href="https://github.com/krishnabh-das">
    <img src="https://github.com/krishnabh-das.png" height="140" width="140"  alt="image" style="border-radius:8px; overflow:hidden;"/>
    </a>
    <div style="text-align: center; background-color:white; color:black; width:110px; border-radius: 20px">
      Krishnabh-Das
    </div>
    <div style="text-align: center; margin:10px">
      <a href="https://semihozdas.com.tr/">🔗</a> -
      <a href="https://linkedin.com/in/semihozdas">💼</a>
    </div>
      <div style="display:flex; gap: 5px; width:100px; flex-wrap:wrap">
  <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="25" height="25"/>

  <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="25" height="25"/> 

  <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="25" height="25"/>

  <img src="https://www.vectorlogo.zone/logos/google_cloud/google_cloud-icon.svg" alt="gcp" width="25" height="25"/>
  
  <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="25" height="25"/>
  
  <img src="https://www.vectorlogo.zone/logos/getpostman/getpostman-icon.svg" alt="postman" width="25" height="25"/>


  </div>
    


</div>




</div>