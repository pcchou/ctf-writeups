#!/usr/bin/env ruby

require 'base64'
require 'json'
require 'openssl'
require 'webrick'
load './secret.rb' # KEY, FLAG

fail if KEY.size != 16

def encode(user)
  c = OpenSSL::Cipher.new('AES-128-CTR')
  c.encrypt
  c.key = KEY
  iv = c.random_iv
  Base64.encode64(iv + c.update({user: user}.to_json) + c.final).delete("\n")
end

def decode(data)
  data = Base64.decode64(data)
  c = OpenSSL::Cipher.new('AES-128-CTR')
  c.decrypt
  c.key = KEY
  c.iv = data[0...16]
  s = c.update(data[16..-1]) + c.final
  JSON.parse(s)
rescue Exception => e
  {error: e.class.to_s}
end

log_file = open('access.log', 'a+')
log_file.sync = true

server = WEBrick::HTTPServer.new(
  Port: ARGV[0].to_i,
  AccessLog: [
    [$stderr, "\e[33;1m%t %a\e[0m \"%r\" %s %b %T"],
    [log_file, "%t %a \"%r\" %s %b %T"]
  ]
)

trap('INT') { server.shutdown }

server.mount_proc('/') do |req, res|
  res.body = IO.read(__FILE__)
end

server.mount_proc('/debug') do |req, res|
  res.body = req.query.inspect
end

server.mount_proc('/login') do |req, res|
  user = req.query['user']
  res.body = user ? encode(user) : 'huh...?'
end

server.mount_proc('/admin') do |req, res|
  token = req.query['token']
  data = decode(token)

  if data['admin'] == true
    server.logger << "\e[32;1m#{req.remote_ip} get flag!\e[0m"
    data['flag'] = FLAG
  end

  res.content_type = "application/json; charset=UTF-8"
  res.body = data.to_json
end

server.start
