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
   
  api/domains.lua
  lua-digitalocean
  
  Created by Masatoshi Teruya on 15/03/09.
  
--]]

-- class
local Records = require('halo').class.Records;

Records.inherits {
    'digitalocean.unchangeable.Unchangeable'
};

function Records:init( cli, domain )
    local own = protected( self );
    
    own.cli = cli;
    own.baseURL = '/domains/' .. tostring( domain.name ) .. '/records';
    own.name = domain.name;
    -- set properties
    for k, v in pairs( domain ) do
        rawset( self, k, v );
    end
    
    return self;
end


local function request( own, method, url, qry, body, opts )
    return own.cli[method](
        own.cli, own.baseURL .. url, qry, body, opts
    );
end


function Records:selfUpdate( opts )
    local own = protected( self );
    local res, err = own.cli:get( '/domains/' .. own.name, nil, nil, opts );
    
    if res and res.status == 200 then
        -- set properties
        for k, v in pairs( res.body.domain ) do
            rawset( self, k, v );
        end
    end
    
    return res, err;
end


function Records:getList( qry, opts )
    return request( protected(self), 'get', '', qry, nil, opts );
end


function Records:get( id, opts )
    return request(
        protected(self), 'get', '/' .. tostring( id ), nil, nil, opts
    );
end


function Records:create( body, opts )
    return request( protected(self), 'post', '', nil, body, opts );
end


function Records:update( id, body, opts )
    return request(
        protected(self), 'put', '/' .. tostring(id), nil, body, opts
    );
end


function Records:delete( id, opts )
    return request(
        protected(self), 'delete', '/' .. tostring(id), nil, nil, opts
    );
end

Records = Records.exports;


-- class
local Domains = require('halo').class.Domains;

Domains.inherits {
    'digitalocean.unchangeable.Unchangeable'
};

function Domains:init( cli )
    protected(self).cli = cli;
    
    return self;
end

function Domains:getList( qry, opts )
    local own = protected( self );
    local res, err = own.cli:get( '/domains', qry, nil, opts );
    
    if res and res.status == 200 then
        local records = {};
        
        for idx, domain in ipairs( res.body.domains ) do
            records[idx] = Records.new( own.cli, domain );
        end
        res.body.domains = records;
    end
    
    return res, err;
end


function Domains:get( name, opts )
    local own = protected( self );
    local res, err = own.cli:get(
        '/domains/' .. tostring(name), nil, nil, opts
    );
    
    if res and res.status == 200 then
        res.body.domain = Records.new( own.cli, res.body.domain );
    end
    
    return res, err;
end


function Domains:create( body, opts )
    local own = protected( self );
    local res, err = own.cli:post( '/domains', nil, body, opts );
    
    if res and res.status == 201 then
        res.body.domain = Records.new( own.cli, res.body.domain );
    end
    
    return res, err;
end


function Domains:delete( name, opts )
    return protected(self).cli:delete(
        '/domains/' .. tostring(name), nil, nil, opts
    );
end


return Domains.exports;
