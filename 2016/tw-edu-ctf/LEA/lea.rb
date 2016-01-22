#!/usr/bin/env ruby

require 'openssl'
require 'webrick'
load './secret.rb' # KEY, FLAG

fail if KEY.size < 30 || KEY.size > 50 

def strxor(a, b)
  a = a.bytes
  b = b.bytes
  [a.size, b.size].max.times.map{|i| (a[i] || 0) ^ (b[i] || 0)}.pack('C*')
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

server.mount_proc('/sign') do |req, res|
  data = req.query['data']

  res.body = if data.nil? || data.include?('flag')
               'huh...?'
             elsif req.query['deprecated']
               OpenSSL::Digest::SHA1.hexdigest(strxor(KEY, data))
             else
               OpenSSL::HMAC.hexdigest('SHA1', KEY, data)
             end
end

server.mount_proc('/verify') do |req, res|
  sig = req.query['sig'] 
  data = req.query['data']

  res.body = if sig.nil? || data.nil?
               'huh...?'
             elsif sig == OpenSSL::HMAC.hexdigest('SHA1', KEY, data)
               if data.include?('flag')
                 $stderr.puts "\e[32;1m#{req.remote_ip} get flag!\e[0m"
                 FLAG
               else
                 'verified, but no flag :('
               end
             else
               'OAQ...?'
             end
end

server.start
