require 'faye'
require 'redis'
require 'rubygems'
require 'active_record'
require 'yaml'
require 'json'
require 'logger'
require 'digest/md5'

$redis = Redis.new(:host => "localhost", :port => 6379) # Redis server
$server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25) # Faye server

# Initialize connection with db
dbconfig = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig['development'])
ActiveRecord::Base.logger = Logger.new(STDERR)

class User < ActiveRecord::Base
end

class SubscribeUser
  def incoming(message, callback)
    # Let non-subscribe messages through
    unless message['channel'] == '/meta/subscribe'
      return callback.call(message)
    end
    
    p "******************"

    # Get subscribed channel and auth token
    subscription = message['subscription']
    
    # Verificar que se incluyan los datos requeridos
    unless message.include? 'user_id' and message.include? 'company_id' and message.include? 'user_email'
      p "~> Peticion ignorada, falta 'company_id, 'user_id' o 'user_email'" 
      return;
    end
    
    # Obtener el id del usuario y compañia
    company_id = Digest::MD5.hexdigest(message['company_id'])
    user_id = message['user_id']
    user_email = message['user_email']
    
    # Verificar que exista la compañia
    if $redis.exists company_id
      members = $redis.smembers company_id # Obtener los miembros del canal de la empresa
      
      # Verificar que exista el id del usuario
      unless members.include? user_id
        $redis.sadd company_id, user_id # Sí no existe, se añade
        members = $redis.smembers company_id # Obtener los miembros del canal de la empresa
        members_mapped = User.where(:id => members).select([:id, :email]); # Se mapean los miembros con usuarios
        
        faye_client.publish(subscription, { 'type' => 'attached', 'usr_id' => user_id, 'usr_email' => user_email, 'msg' => "Se ha conectado el usuario: #{user_email}.", 'members' => members_mapped })
        
        p "~> Se agrego el usuario '#{user_email}' a la compañia compañia '#{company_id}'."
      else
        p "~> El usuario '#{user_email}' ya existe en la compañia '#{company_id}'."
        faye_client.publish(subscription, { 'type' => 'exists', 'usr_id' => user_id, 'usr_email' => user_email, 'members' => members_mapped })
      end
    else
      $redis.sadd company_id, user_id # Se crea el canal para la compañia y sus usuarios
      members = $redis.smembers company_id # Obtener los miembros del canal de la empresa
      members_mapped = User.where(:id => members).select([:id, :email]); # Se mapean los miembros con usuarios
      
      faye_client.publish(subscription, { 'type' => 'attached', 'usr_id' => user_id, 'usr_email' => user_email, 'msg' => "Se ha conectado el usuario: #{user_email}.", 'members' => members_mapped })
      
      p "~> Se creo el canal para la compañia '#{company_id} y se agrego el usuario '#{user_email}'"
    end

    # Call the server back now we're done
    callback.call(message)
  end
  
  def faye_client
    @faye_client ||= Faye::Client.new('http://localhost:9292/faye')
  end
end

class DisconnectUser
  def incoming(message, callback)
    # Let non-subscribe messages through
    unless message['channel'] == '/meta/disconnect'
      return callback.call(message)
    end
    
    p "******************"

    # Get subscribed channel and auth token
    subscription = message['subscription']
    
    # Verificar que se incluyan los datos requeridos
    unless message.include? 'user_id' and message.include? 'company_id' and message.include? 'user_email'
      p "~> Peticion ignorada, falta 'company_id, 'user_id' o 'user_email'" 
      return;
    end
    
    # Obtener el id del usuario y compañia
    company_id = Digest::MD5.hexdigest(message['company_id'])
    user_id = message['user_id']
    user_email = message['user_email']
    
    # Verificar que exista la compañia
    if $redis.exists company_id
      members = $redis.smembers company_id # Obtener los miembros del canal de la empresa
      
      # Verificar que exista el id del usuario
      if members.include? user_id
        $redis.srem company_id, user_id # Remover el usuario del canal
        
        p "~> El usuario con id '#{user_id}' se removio de la compañia '#{company_id}'."
        faye_client.publish('/chats/public/' + company_id, { 'type' => 'abandon', 'usr_id' => user_id, 'msg' => "Se ha desconectado el usuario: #{user_email}." })
      end
    end

    # Call the server back now we're done
    callback.call(message)
  end
  
  def faye_client
    @faye_client ||= Faye::Client.new('http://localhost:9292/faye')
  end
end

$server.add_extension(SubscribeUser.new)
$server.add_extension(DisconnectUser.new)
$server.listen(9292)