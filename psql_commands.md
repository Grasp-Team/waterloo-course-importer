# GpsApp-Server

Setup for Postgres locally on Mac OS X
* brew update
	* if homebrew doesn't work, it's prob an issue with el capitan, google it.
* brew doctor
	* fix any issues reported
* brew install postgresql
* initdb /usr/local/var/postgres -E utf8
* gem install lunchy
	* helpful gem that allows you to easily start and stop postgres
* mkdir -p ~/Library/LaunchAgents
* cp /usr/local/Cellar/postgresql/9.2.1/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/

Now ready:
* lunchy start postgres
	* to start postgres, you should now be able to run the rake commands to create database
* lunchy stop postgres
	* to stop postgres

Rake command to create database:
* rake db:create db:migrate

Postgres
* psql
	* to start the postgres console
* \list
	* to view psql dbs on local machine
* \connect db_name
	* to connect to a database
* \dt
	* to view tables in database
* \d table_name
	* to view columns and propertie of table
* \q
	* to quit postgres
* bin/rails generate migration MigrationName
	* we don't want this, we want to generate a model, next command
	* to generate a migration (change to db) in root of folder
	* more on migrations here: http://guides.rubyonrails.org/active_record_migrations.html
* rails generate model User first_name:string last_name:string email:string
        * this is how we generated the User model
* rake db:migrate
	* to update db after new migration file is created

Rails
* rails c, to start rails console, quit to exit
* me = User.new(first_name: "Jitin", last_name: "Dodd", location_latitude: "-45.234", location_longitude: "98.234") followed by me.save!
	* to create a new User and save it
* User.all
	* shows all content of User model/table
* User.delete_all
	* deletes all data in User model
* rails generate migration add_columnname_to_tablename columnname:datatype
	* to add a property to a model

SQL
* INSERT INTO persons (fname, lname, email) VALUES ('Jitin','Dodd','jitindodd@gmail.com');
	* example of inserting fake data into table
* SELECT * FROM table_name;
	* view data in a table
* ALTER TABLE "locations" ADD CONSTRAINT "bid_fk" FOREIGN KEY ("bid") REFERENCES "persons"(id);
	* Example showing how to add a foreign key to a column

HEROKU
* herou restart
	* to restart server dynos
* heroku logs (or heroku logs --tail)
	* to view server logs (or live logs)
* heroku pg:reset DATABASE_URL, heroku run rake db:migrate
	* equivalent to rake db:drop, rake db:create, aka, destroys db then recreates it

