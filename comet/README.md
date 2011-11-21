Comet KVS
=========

run server
----------

    % ruby server.rb 8080 10


sample client
-------------

    % ruby client 15


post, then get
--------------

    % curl -d 'hello' http://localhost:8080/message
    % curl http://localhost:8080/message
     => 'hello'

get and wait, then post
-----------------------

### get (comet)

    % curl http://localhost:8080/username

wait response 60 sec.

### post

    % curl -d 'shokai' http://localhost:8080/username
