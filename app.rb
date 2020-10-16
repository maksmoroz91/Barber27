require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' 
require 'sqlite3'

def get_db
	@db = SQLite3::Database.new 'barbershop.db'
	@db.results_as_hash = true
	return @db
end	

configure do
	@db = get_db
	@db.execute 'CREATE TABLE IF NOT EXISTS
		 "Users" 
		 (
		 	"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
		 	 "username" TEXT,
		 	 "phone" TEXT,
		 	 "datestamp" TEXT,
		 	 "barber" TEXT,
		 	 "color" TEXT
		 )' 
end	

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a> !!!"			
end

get '/about' do 
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@username = params[:username]
	@username.capitalize!
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]
	
	hh = {  :username => 'Введите имя',
			:phone => 'Введите номер телефона',
			:datetime => 'Введите дату и время'}

	hh.each do |key, value|
		if params[key] == ''
			@error = value
			return erb :visit	
		end
	end					

	@db = get_db
	@db.execute 'insert into Users ( username, phone, datestamp, barber, color) 
		values ( ?,?,?,?,?)', [@username, @phone, @datetime, @barber, @color]

	erb "#{@username}, мы Вас записали!"
end	

get '/showusers' do
  	
		
end


get '/contacts' do
	erb :contacts
end	

post '/contacts' do
	@e_mail = params[:e_mail]
	@text = params[:text]

	hh = { :e_mail => 'Введите E-mail', :text => 'Введите сообщение'}

	hh.each do |k, v|
		if params[k] == ''
			@error = v
			return erb :contacts
		end		
	end
	
	d = File.open './public/contacts.txt', 'a'
	d.write "E-mail: #{@e_mail}, SMS: #{@text}\n"
	d.close

	erb "Собщение отпрвлено"
end	

