--[[
  
  Copyright (C) 2015 Masatoshi Teruya

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
 
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
 
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
   
  api/droplets.lua
  lua-digitalocean
  
  Created by Masatoshi Teruya on 15/03/09.
  
--]]
-- class
local Action = require('halo').class.Action;

Action.inherits {
    'digitalocean.unchangeable.Unchangeable'
};

function Action:init( cli, action )
    local own = protected( self );
    
    own.cli = cli;
    own.baseURL = '/droplets/' .. tostring( action.resource_id ) .. 
                  '/actions/' .. tostring( action.id );
    
    -- set properties
    for k, v in pairs( action ) do
        rawset( self, k, v );
    end
    
    return self;
end


function Action:update( opts )
    local own = protected( self );
    local res, err = own.cli:get( own.baseURL, nil, nil, opts );
    
    if res and res.status == 200 then
        -- set properties
        for k, v in pairs( res.body.action ) do
            rawset( self, k, v );
        end
    end
    
    return res, err;
end

Action = Action.exports;


-- class
local Droplet = require('halo').class.Droplet;


Droplet.inherits {
    'digitalocean.unchangeable.Unchangeable'
};


function Droplet:init( cli, droplet )
    local own = protected( self );
    
    own.cli = cli;
    own.baseURL = '/droplets/' .. tostring( droplet.id );
    own.id = droplet.id;
    -- set properties
    for k, v in pairs( droplet ) do
        rawset( self, k, v );
    end
    
    return self;
end


local function request( own, method, url, qry, body, opts )
    return own.cli[method](
        own.cli, own.baseURL .. url, qry, body, opts
    );
end


function Droplet:selfUpdate( opts )
    local own = protected( self );
    local res, err = own.cli:get( '/droplets/' .. own.id, nil, nil, opts );
    
    if res and res.status == 200 then
        -- set properties
        for k, v in pairs( res.body.droplets ) do
            rawset( self, k, v );
        end
    end
    
    return res, err;
end


function Droplet:getKernels( qry, opts )
    return request( protected(self), 'get', '/kernels', qry, nil, opts );
end


function Droplet:getSnapshots( qry, opts )
    return request( protected(self), 'get', '/snapshots', qry, nil, opts );
end


function Droplet:getBackups( qry, opts )
    return request( protected(self), 'get', '/backups', qry, nil, opts );
end


function Droplet:getActions( qry, opts )
    local own = protected( self );
    local res, err = request( own, 'get', '/actions', qry, nil, opts );
    
    if res and res.status == 200 then
        local actions = {};
        
        for idx, action in ipairs( res.body.actions ) do
            actions[idx] = Action.new( own.cli, action );
        end
        res.body.actions = actions;
    end
    
    return res, err;
end


function Droplet:getNeighbors( opts )
    return request( protected(self), 'get', '/neighbors', nil, nil, opts );
end


-- actions
local function postAction( own, body, opts )
    local res, err = request( own, 'post', '/actions', nil, body, opts );
    
    if res and res.status == 201 then
        res.body.action = Action.new( own.cli, res.body.action );
    end
    
    return res, err;
end


function Droplet:disableBackups( opts )
    return postAction( protected(self), {
        ['type'] = 'disable_backups'
    }, opts );
end


function Droplet:reboot( opts )
    return postAction( protected(self), {
        ['type'] = 'reboot'
    }, opts );
end


function Droplet:powerCycle( opts )
    return postAction( protected(self), {
        ['type'] = 'power_cycle'
    }, opts );
end


function Droplet:shutdown( opts )
    return postAction( protected(self), {
        ['type'] = 'shutdown'
    }, opts );
end


function Droplet:powerOff( opts )
    return postAction( protected(self), {
        ['type'] = 'power_off'
    }, opts );
end


function Droplet:powerOn( opts )
    return postAction( protected(self), {
        ['type'] = 'power_on'
    }, opts );
end


function Droplet:restore( image, opts )
    return postAction( protected(self), {
        ['type'] = 'restore',
        image = image
    }, opts );
end


function Droplet:passwordReset( opts )
    return postAction( protected(self), {
        ['type'] = 'password_reset'
    }, opts );
end


function Droplet:resize( size, opts )
    return postAction( protected(self), {
        ['type'] = 'resize',
        size = size
    }, opts );
end


function Droplet:rebuild( image, opts )
    return postAction( protected(self), {
        ['type'] = 'rebuild',
        image = image
    }, opts );
end


function Droplet:rename( name, opts )
    return postAction( protected(self), {
        ['type'] = 'rename',
        name = name
    }, opts );
end


function Droplet:changeKernel( kernel, opts )
    return postAction( protected(self), {
        ['type'] = 'change_kernel',
        kernel = kernel
    }, opts );
end


function Droplet:enableIPv6( kernel, opts )
    return postAction( protected(self), {
        ['type'] = 'enable_ipv6',
    }, opts );
end


function Droplet:enablePrivateNetworking( kernel, opts )
    return postAction( protected(self), {
        ['type'] = 'enable_private_networking',
    }, opts );
end


function Droplet:snapshot( kernel, opts )
    return postAction( protected(self), {
        ['type'] = 'snapshot',
    }, opts );
end


function Droplet:upgrade( kernel, opts )
    return postAction( protected(self), {
        ['type'] = 'upgrade',
    }, opts );
end


Droplet = Droplet.exports;



-- class
local Droplets = require('halo').class.Droplets;

Droplets.inherits {
    'digitalocean.unchangeable.Unchangeable'
};

function Droplets:init( cli )
    protected(self).cli = cli;
    
    return self;
end


function Droplets:getList( qry, opts )
    local own = protected( self );
    local res, err = own.cli:get( '/droplets', qry, nil, opts );
    
    if res and res.status == 200 then
        local droplet = {};
        
        for idx, droplet in ipairs( res.body.droplets ) do
            droplet[idx] = Droplet.new( own.cli, droplet );
        end
        res.body.droplets = droplets;
    end
    
    return res, err;
end


function Droplets:get( id, opts )
    local own = protected( self );
    local res, err = own.cli:get(
        '/droplets/' .. tostring(id), nil, nil, opts
    );
    
    if res and res.status == 200 then
        res.body.droplet = Droplet.new( own.cli, res.body.droplet );
    end
    
    return res, err;
end


function Droplets:create( body, opts )
    local own = protected( self );
    local res, err = own.cli:post( '/droplets', nil, body, opts );
    
    if res and res.status == 201 then
        res.body.droplet = Droplet.new( own.cli, res.body.droplet );
    end
    
    return res, err;
end


function Droplets:delete( id, opts )
    return protected(self).cli:delete(
        '/droplets/' .. tostring(id), nil, nil, opts
    );
end


return Droplets.exports;
