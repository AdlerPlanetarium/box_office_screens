{exec} = require 'child_process'

run = (command, callback) ->
  exec command, (err, stdout, stderr) ->
    console.warn stderr if stderr
    callback?() unless err

task 'compile', 'Compile everything', ->
  invoke 'compile:coffee'
  invoke 'compile:stylus'


task 'compile:coffee', 'Compile the CoffeeScript files', ->
  console.log 'Compiling CoffeeScript files...'
  run 'coffee --join lib/application.js --compile src/*.coffee'

task 'compile:stylus', 'Compile the Stylus files', ->
  console.log 'Compiling Stylus files...'
  run 'stylus styles/ --out styles '`
