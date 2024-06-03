# README

### Postgres for Database
1. gem 'pg', '~> 1.1'
2. bundle install
3. create database.yml file
4. rails db:create
5. rails db:migrate


### Release Note
1. Create database.yml file inside config folder; by renaming database.yml.example file
2. Create database using command: rails db:create
3. Run migrations using command: rails db:migrate
4. Run rails db:seed to add records of seeds file (It will create test-user)
5. User can sign-up/login with his/her details
6. User can create a new video script by adding new video from his/her device or he/she can record video from app and create it.
7. User can publish his/her video, So other user can see that vides
8. Only owner of video can edit/delete video. 
