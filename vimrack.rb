#!/usr/bin/ruby
require 'rubygems'
require 'rack'
require 'json/pure'

include Rack

Encoding.default_external = Encoding.find('UTF-8')

class VimRack
  def call(env)
    str = JSON.generate({
        "uri" => env['PATH_INFO'],
        "method" => env['REQUEST_METHOD'],
        "headers" => env.to_a.map{|n,v| "#{n}: #{v}"}.select{|x| x =~ /^[A-Z0-9_\-]+:/},
        "content" => env['rack.input'].read,
    }).gsub(/'/, '\x27').gsub(/"/, '\x22')
    if !!(RUBY_PLATFORM.downcase =~ /mswin(?!ce)|mingw|bccwin|cygwin/)
      res = JSON.parse(`vim --servername VIM --remote-expr "vimplack#handle("""#{str}""")"`)
    else
      res = JSON.parse(`vim --servername VIM --remote-expr 'vimplack#handle("#{str}")'`)
    end
    if res && !res[1].has_key?("Content-Type")
      res[1]["Content-Type"] = "text/plain"
    end
    res
  end
end
