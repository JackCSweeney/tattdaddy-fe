# TattDaddy

## Table of Contents
- [Getting Started](#getting-started)
- [Project Description](#project-description)
- [Learning Goals for Project](#learning-goals-for-project)
- [Setup](#setup)
- [Contributors](#contributors)
- [BE Repo](https://github.com/JackCSweeney/tattdaddy-be)
- [Deployment (not up to date)](https://tattdaddy-be.onrender.com/)

## Getting Started
### Versions
- Ruby: 3.2.2
- Rails: 7.1.3

## Project Description

Tatt Daddy is an app designed to connect users with tattoo artists in order to get pre-designed, flash tattoos in a quick and easy fashion. Users will scroll through different available designs that licensed tattoo artists will upload to the application, select tattoos they would like to get, and get connected with the artist to schedule an appointment, chat about small details of the work, and finalize payment. The goal is to allow tattoo collectors to easily add to their collection and provide artists an opportunity to fill more of their schedule with quick and efficient appointments.

This app was built with a team of 5 developers as the consultancy project for MOD 3 2311, from Turing School of Software and Design.

<details>
  <summary>Learning Goals for Project</summary>
- To learn how to build something custom from an idea, going from conceptualization to a final product.
- Better time estimates and reasonable goals for project tasks.
- Experience to build a collaborative Full stack app.
- Creating a unique app and managing tasks as a team.
- Get experience to create and build a project from scratch.
</details>

<details>
  <summary>Setup</summary>
  1. Fork and/or Clone this Repo from GitHub.
  2. In your terminal use `$ git clone <ssh or https path>`.
  3. Change into the cloned directory using `$ cd example`.
  4. Install the gem packages using `$ bundle install`.
  5. Database Migrations can be set up by running: 
  ``` bash 
  $ rails rake db:{drop,create,migrate,seed}
  ```
</details>

<details>
  <summary>Testing</summary>

  Test using the terminal utilizing RSpec:

  ```bash
  $ bundle exec rspec spec/<follow directory path to test specific files>
  ```

  or test the whole suite with `$ bundle exec rspec`
</details>

## External APIs/Services
#### AWS S3 API
  - In our application, we leverage AWS S3 to manage user-uploaded image files. By storing these files in an S3 bucket, we effectively reduce the size of our database, containing only essential data. This approach is particularly beneficial given the potentially large sizes of image files. Storing them in an external database like S3 enables us to store secure URLs in our database queries, rather than cumbersome image data. This optimization enhances the efficiency of our database operations while ensuring the security and accessibility of our image assets. 

  - [AWS S3 documentation](https://aws.amazon.com/s3/)

#### GitHub OAuth
- We integrated GitHub OAuth into our application to streamline the user authentication process and enhance security. By utilizing GitHub OAuth, we leverage the robust authentication infrastructure provided by GitHub, a trusted platform widely used by developers. This approach not only simplifies the login experience for our users by allowing them to use their GitHub credentials but also ensures a higher level of security by delegating the authentication process to GitHub's servers. Additionally, GitHub OAuth provides us with access to user profile information, enabling us to personalize the user experience and tailor our application's functionality based on their GitHub identity and permissions. Overall, integrating GitHub OAuth enhances both the usability and security of our application, contributing to a more seamless and trustworthy user experience.

- [GitHub Documentation](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#web-application-flow)

#### Mozilla Geolocation API
- Enhances Tattoo Artist Discovery: Utilizing the Geolocation API, Tatt Daddy can offer users personalized recommendations for nearby tattoo artists based on their current location. This feature enables users to easily discover and connect with talented artists in their vicinity, fostering a sense of community and accessibility within the tattooing industry.

- Location-based Appointment Scheduling: With the Geolocation API, Tatt Daddy can facilitate location-aware appointment scheduling, allowing users to find and book appointments with nearby tattoo artists conveniently. This functionality streamlines the booking process, making it quick and efficient for both users and artists while maximizing the utilization of artists' schedules.

- [Geolocation Documentation](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/getCurrentPosition)

#### Google Map Geolocator API
- Accurate Address-to-Location Conversion: The Google Geolocator API ensures accurate geocoding of user-provided addresses, enabling Tatt Daddy to precisely pinpoint the location of tattoo artists and studios. This capability enhances the reliability of location-based services within the app, ensuring that users can easily locate and navigate to their desired tattoo destinations.

- Detailed Location Information for Artists: By integrating the Google Geolocator API, Tatt Daddy gains access to detailed location information for registered tattoo artists, including their studio addresses and geographic coordinates. This information enriches the user experience by providing users with comprehensive details about each artist's location, facilitating informed decision-making when selecting artists for their tattoo appointments.

- [Geolocator Documentation](https://developers.google.com/maps/documentation/geolocation/overview)

## Contributors
#### Jack Sweeney   	 
- [Github](https://github.com/JackCSweeney) [LinkedIn](https://www.linkedin.com/in/jack-sweeney-024043274/)

#### Laura R Vega V 	 
- [Github](https://github.com/laurarvegav) [LinkedIn](https://www.linkedin.com/in/laurarvegav/) 

#### Joey Reyes 		 
- [Github](https://github.com/JRIV-10) [LinkedIn](https://www.linkedin.com/in/josereyes10/)

#### Jessica Kohl 		 
- [Github](https://github.com/kohljd) [LinkedIn](https://www.linkedin.com/in/jessica-kohl-545785113/)

#### Faisal Nazari 		 
- [Github](https://github.com/mfaisalnazari) [LinkedIn](https://www.linkedin.com/in/mfaisalnazari/) 
