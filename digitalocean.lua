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
   
  digitalocean.lua
  lua-digitalocean
  
  Created by Masatoshi Teruya on 15/03/09.
  
--]]
-- modules
local API = require('digitalocean.api');
-- constants
local BASE_URI = 'https://api.digitalocean.com/v2';
-- class
local DigitalOcean = require('halo').class.DigitalOcean;

DigitalOcean.inherits {
    'digitalocean.unchangeable.Unchangeable'
};


function DigitalOcean:__index( method )
    local own = protected( self );
    
    if own.cli[method] then
        return function( _, uri, query, body, opts )
            if type( opts ) ~= 'table' then
                opts = {
                    header = {};
                };
            elseif type( opts.header ) ~= 'table' then
                opts.header = {};
            end
            -- set headers
            opts.header["Accept"] = "application/json";
            opts.header['Authorization'] = own.header;
            opts.query = query;
            opts.enctype = "application/json";
            opts.body = body;
            
            return own.cli[method](
                own.cli, BASE_URI .. tostring( uri == nil and '' or uri ), opts
            );
        end
    end
end


function DigitalOcean:init( httpcli, token )
    local own = protected( self );
    local index = getmetatable( self ).__index;
    
    -- check token
    if type( token ) ~= 'table' then
        return nil, 'token must be table';
    elseif type( token.access_token ) ~= 'string' then
        return nil, 'access_token must be string';
    end
    
    own.cli = httpcli;
    own.token = token;
    own.header = 'Bearer ' .. token.access_token;
    -- add api
    for name, api in pairs( API ) do
        index[name] = assert( api.new( self ) );
    end
    
    return self;
end

return DigitalOcean.exports;
