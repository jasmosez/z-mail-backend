# README

## OVERVIEW
Z-mail is a tool to Visualize your Gmail in support of ‘Inbox Zero’ methodology

This backend is an API that pulls data from the Gmail API. You will need your own Google Client ID and Secret. 

You will also need to use ngrok or some other way to tunnel out to the web from your local development server because Google won't accept localhost as an approved 'javascript origin' or 'redirect URI', each of which must be listed for the OAuth process. 

The frontend can be found here: https://github.com/jasmosez/z-mail-frontend. It visualizes email throughput and inbox contents using c3.

## Ruby/Rails versions
Uses Ruby 2.6.1 and Rails 6.0.2.1

## Configuration
create `config/application.rb` file defining the following: 

* `GOOGLE_CLIENT_ID`
* `GOOGLE_CLIENT_SECRET`

## Database creation
### Migrate the database
rails db:migrate

### Seed the database
There is no need to seed the database -- 
The backend grabs updated data from Gmail every time the app reloads

## How to run the test suite
There is not test coverage at this time

# Let me know what you think!
Z-mail was built in collaboration with github.com/Zman613
