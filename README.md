# Viewing Part API - Solo Project

This is the base repo for the Viewing Party Solo Project for Module 3 in Turing's Software Engineering Program. 

## About this Application

Viewing Party is an application that allows users to explore movies and create a Viewing Party Event that invites users and keeps track of a host. Once completed, this application will collect relevant information about movies from an external API, provide CRUD functionality for creating a Viewing Party and restrict its use to only verified users. 

## Setup

1. Fork and clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{drop,create,migrate,seed}`

Run the application and test out some endpoints: `rails s`

## Endpoints

Full endpoints for example: 

Deployed:
https://nameless-shore-40626-fbe4f336a2fe.herokuapp.com/api/v1/movies?filter=top_rated
Local:
http://localhost:3000/api/v1/movies?filter=top_rated

# Endpoint 1
# GET- /api/v1/movies?filter=top_rated -> Fetches top-rated movies

# Endpoint 2
# GET - /api/v1/movies?query=<search_term> -> Fetches movies based on specified search term

# Endpoint 3
# POST /api/v1/viewing_parties -> Create a viewing party
Content-Type: application/json

{
  "name": "Movie Night",
  "date": "2024-12-31",
  "time": "20:00",
  "movie_id": 123
}

# Endpoint 4
# POST /api/v1/viewing_parties/:viewing_party_id/invitees -> Add user to a viewing party by viewing party id
Content-Type: application/json
{
  "user_id": 456
}

# Endpoint 5
# GET api/v1/movies/:id -> Fetch specific movie details by movie id

# Endpoint 6
# GET /api/v1/users/:id -> Retrieve user profile by user id
