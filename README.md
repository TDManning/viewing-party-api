# Viewing Part API - Solo Project

This is the base repo for the Viewing Party Solo Project for Module 3 in Turing's Software Engineering Program. 

## About this Application

Viewing Party is an application that allows users to explore movies and create a Viewing Party Event that invites users and keeps track of a host. Once completed, this application will collect relevant information about movies from an external API, provide CRUD functionality for creating a Viewing Party and restrict its use to only verified users. 

## Setup

1. Fork and clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{drop,create,migrate,seed}`

Spend some time familiarizing yourself with the functionality and structure of the application so far.

Run the application and test out some endpoints: `rails s`

## Endpoints

1. Top Rated Movies: This endpoint retrieves up to 20 top rated movies from The Movie DB API. 

Deployed:
https://nameless-shore-40626-fbe4f336a2fe.herokuapp.com/api/v1/movies?filter=top_rated
Postman:
http://localhost:3000/api/v1/movies?filter=top_rated