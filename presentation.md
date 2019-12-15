<style type="text/css">
.reveal table{
  font-size:0.6em;
}
.section .reveal .state-background {
    background-repeat: no-repeat;
    background-position: center;
    background-size: cover;
    background-blend-mode:darken;
    background-image:url('https://drive.google.com/uc?id=1s_tNafyahy0hSzEF881mZWniOANeJ9kJ'),url('/Users/ahmad/Documents/RRR/Shiny/git/pds-imdb/presentation-figure/test.jpg'), url('presentation-figure/test.jpg');
}


</style>
The Reel Deal: A Look into Modern Cinema 
========================================================
date: December 16, 2019
width:1300
author: 
<div class="custom">
<h4 style="color:white;font-weight:bolder;font-size:40px;font-family:'News Cycle', Impact, sans-serif;">The Reelers</h4>
<ul class="custom">
<li style="font-family:sans-serif; color:white;">Ahmad Zamrik (WQD190033)</li>
<li style="font-family:sans-serif; color:white;">Wong Wai Cheng (WQD190015)</li>
<li style="font-family:sans-serif; color:white;">Wei Chee San (WQD190010)</li>
<li style="font-family:sans-serif; color:white;">Nik Syen Chyn (WQD190006)</li>
</ul>
</div>

Introduction
========================================================
transition: concave
left: 50%

<style>

/* slide titles */
.reveal h3 { 
  font-size: 50px;
  color: black;
}

/* heading for slides with two hashes ## */
.reveal .slides section .slideContent h2 {
   font-size: 30px;
   font-weight: bold;
   color: black;
}

/* ordered and unordered list styles */
.reveal ul, 
.reveal ol {
    font-size: 20px;
    color: black;
    list-style-type: square;
}

</style>

## Motivation
- Culture industry is the concept of capitalization of popular culture into a profit industry with production of standardized cultural products as well as standardized consumers that are mold to feed into this system (Adorno and Horkheimer, 1944).
- In Malaysia, the film industry is a growing asset in this country's creative industry.
- Film industry also contributes to economic growth of a country.

## Goal
 - Create and application that allow users to visualize the ups and downs of the film industry through IMDB data.

***

| Total/Year                             | 2015  | 2016  | 2017  | 2018  |
| ---------------------------------------|:-----:| -----:| -----:| -----:|
| Gross collection (MYR in millions)     | 869.10| 915.30| 983.64|1004.00| 
| Number of cinemas                      | 141   | 144   | 151   | 156   |
| Number of screens                      | 944   | 991   | 1094  | 1094  |
| Number of seats (in thousands)         | 163   | 172   | 185   | 186   |
| Admissions collection (MYR in millions)| 68.11 | 71.63 | 72.84 | 77.31 |

## FINAS: Collection and Admission For All Local and Foreign Films In Cinema: 2015 - 2018</p>

Methodology
========================================================
transition: concave
left: 40%
<style>

/* slide titles */
.reveal h3 { 
  font-size: 50px;
  color: black;
}

/* heading for slides with two hashes ## */
.reveal .slides section .slideContent h2 {
   font-size: 30px;
   font-weight: bold;
   color: black;
}

/* ordered and unordered list styles */
.reveal ul, 
.reveal ol {
    font-size: 20px;
    color: black;
    list-style-type: square;
}

</style>

![](https://drive.google.com/uc?id=19DgsKwIuLuk_yjR6XvFFlHO34LCEec8h)

![](https://drive.google.com/uc?id=137oLBe0pKL4qPX-AOc78A9G6zd8okbww)


***

## Questions
- What is the distribution of movie counts for each rating for different genres of films?
- What is the trend of average ratings over a period of time for different genres of films?
- What is the average ratings of cast members and the number of movies that they have worked on?
- How does the network relationship between cast members look like?

Visualization
========================================================
transition: concave
left: 40%
Our analysis is done via R Shiny app. You can interact with the app in the following ways:
 - Filter by minimum review votes a movie must have
 - Filter by production year range
 - Filter by movie genre(s)
 - Select movies from the table to see more details about their cast (ratings and network)

***

![](https://drive.google.com/uc?id=1trjZWMEbyUoCQ6EG_1o43RrypKfMmbKJ)


Conclusion
========================================================
transition: concave
left: 50%

|CHALLENGES                        |SOLUTIONS                                                   |
|-----------------------------------|------------------------------------------------------------|
|First time building an application.|Go through various blogs and Shiny documentation.           |
|Files too large to work with.      |Reduce dataset to include only important info.              |
|R coding level: Beginner           |Go through tutorials online and consult experienced friends.|
|Business understanding: Average    |Talk to friends/colleague and read articles/papers.         |
|Difficulty in meeting as a team    |Update each other regularly online and meet physically whenever we can.|

***

We have:
  + became more experienced in R coding.
  + learned more about the trends in film industry.
  + learned how to build a Shiny application.
  + became more familiar with the Data Science pipeline and mindset.

Links:
  + Dataset: <a href="https://datasets.imdbws.com/">Click here for IMDB raw datasets</a><br/>
  + Shinyapp: <a href="https://azamrik.shinyapps.io/pds-imdb/">Click here for our Shiny app</a><br/>
  + Code: <a href="https://github.com/azamrik/pds-imdb">Click here for our code on GitHub</a>
