# Application Bulletin Board

Bulletin Board is an application-clone of the famous service [Avito](https://www.avito.ru/). Each authorized user can 
publish their ads and any user can contact the seller via the feedback form. Each ad is pre-moderated by the 
administrators of the service. Administrators can return an ad for revision, publish it, or archive it.

[![Actions Status](https://github.com/cuurjol/rails-project-lvl3/workflows/hexlet-check/badge.svg)](https://github.com/cuurjol/rails-project-lvl3/actions)
[![CI](https://github.com/cuurjol/rails-project-lvl3/actions/workflows/main.yml/badge.svg)](https://github.com/cuurjol/rails-project-lvl3/actions/workflows/main.yml)

## Installation and running

To run the application, do the following commands in your terminal window:

* Clone the repository from GitHub and navigate to the application folder:
```
git clone https://github.com/cuurjol/rails-project-lvl3.git
cd rails-project-lvl3
```

* Install the necessary application gems specified in the `Gemfile`:
```
bundle install
```

* Create a database, run database migrations and a `seeds.rb` file to create database records:
```
# Make command:
make db-setup

# Run each command separately:
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
```

The application uses the `SQLite` database for development/test environment and the `Postgresql` database for
production environment.

* Set up ENV settings in `.env` file:
```
# .env.example:
# For development and production environments:
GITHUB_CLIENT_ID=GITHUB_CLIENT_ID
GITHUB_CLIENT_SECRET=GITHUB_CLIENT_SECRET
GOOGLE_CLIENT_ID=GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET=GOOGLE_CLIENT_SECRET
ADMIN_EMAIL=ADMIN_EMAIL
ADMIN_PASSWORD=ADMIN_PASSWORD

# For production environment:
APP_PRODUCTION_HOST=APP_PRODUCTION_HOST
FILEBASE_S3_ACCESS_KEY=FILEBASE_S3_ACCESS_KEY
FILEBASE_S3_SECRET_KEY=FILEBASE_S3_SECRET_KEY
FILEBASE_S3_REGION=FILEBASE_S3_REGION
FILEBASE_S3_BUCKET=FILEBASE_S3_BUCKET
GOOGLE_SMTP_USER_NAME=GOOGLE_SMTP_USER_NAME
GOOGLE_SMTP_PASSWORD=GOOGLE_SMTP_PASSWORD
```

The application uses the `Google` and `Github` authentication from [Omniauth](https://github.com/omniauth/omniauth) gem,
`Google` SMTP server and [Filebase](https://filebase.com/) storage database for images.

* Launch the application (local server):
```
bundle exec rails server
```

## Heroku deployment

Study project is ready for deployment on the Heroku. The working version of the project can be viewed at
[Heroku website](https://cuurjol-hexlet-bulletin-board.herokuapp.com/).

## Author

**Kirill Ilyin**, study project from [Hexlet](https://ru.hexlet.io/)
