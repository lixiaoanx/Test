Red Refinery
====

Red Refinery OA, best mate of Redmine.

## Run the app

- Clone it
- `bundle`
- `yarn`
- `cp config/database.yml.example config/database.yml`
- `cp config/credentials.yml.example config/credentials.yml` & `rails credentials:encrypt`
- `cp config/mailer.yml.example config/mailer.yml`
- `rails db:migrate`
- `rails s`

### Receive Devise confirmation mail

In development, I use `mailcatcher` to receive mails,
run `gem install mailcatcher` to installed

Open a new terminal, run `mailcatcher`, then followed the instructions

### Set user as admin

- `cp config/settings.yml config/settings.local.yml`
- Put your email into `admin.emails`
- In user menu (right-top of pages), you should see `Administration`
