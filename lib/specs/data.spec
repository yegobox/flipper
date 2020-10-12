Specification Heading
=====================
Created by RICHARD MURAGIJIMANA on 21/03/2020

This is an executable specification file which follows markdown syntax.
Every heading in this file denotes a scenario. Every bulleted point denotes a step.
     
Storing data and sync
----------------
*On app start should connect to our centralized database that has
    channels filter on it so on start the app can not load unneded (unrelated data) data
    On user creation all data, business,branch etc..should first create in local database
    first Sqlite then couchDb for sync: do overrite the data on couchside to avoid 20MB limit of size of document on couchside
