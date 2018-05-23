#!/usr/bin/env ruby

require 'optparse'
require 'json'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: aws-ip-to-ssh-host.rb [options]'
  opts.on('-pProfile', '--profile=Profile', 'Profile') do |v|
    options[:profile] = v
  end
end.parse!

aws_res = %x(aws ec2 describe-instances --profile "#{options[:profile]}" --query "Reservations[].Instances[].[PublicIpAddress,Tags[?Key=='Name'].Value]" --output=json)

hosts = JSON.parse(aws_res)

p hosts

prefix = 'alan'

File.open(File.expand_path("~/.ssh/conf.d/#{prefix}_hosts"), 'w') do |file|
  hosts.each do |v|
    if v[0]
      host = "#{prefix}-#{v[1][0]}"
      data = "Host #{host}\n  Hostname #{v[0]}\n\n"
      file.write(data)
      puts data
    end
  end
end

puts '[OK]'
