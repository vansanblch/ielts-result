### jshint node: true ###
###
ielts-result
https://github.com/vansanblch/ielts-result

Copyright (c) 2013 Ivan Nikulin
Licensed under the MIT license.
###
"use strict"

argv = require('optimist')
    .usage('Get ielts exam result.\nUsage: $0')
    .describe({
        smsru: 'Path to smsru config'
        ielts: 'Path to exam data'
    })
    .demand([ 'smsru', 'ielts' ])
    .argv

Smsru = require 'smsru'
path = require 'path'
request = require 'request'

# create smsru service instance
smsru = new Smsru argv.smsru

# get data for request
data = require argv.ielts

main = ->
    request {
        url: 'http://ielts-moscow.ru/ajax/get_results.php'
        qs: data
    }, (error, response, body) ->
        if ~body.indexOf('color:red') is 0
            smsru.send response.request.href, ->
                process.abort()
        else
            setTimeout ->
                main()
            , 2000

main()
