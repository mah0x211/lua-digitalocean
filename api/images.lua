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
   
  api/images.lua
  lua-digitalocean
  
  Created by Masatoshi Teruya on 15/03/09.
  
--]]

-- class
local Actions = require('halo').class.Actions;

Actions.inherits {
    'digitalocean.unchangeable.Unchangeable'
};

function Actions:init( cli, image )
    local own = protected( self );
    
    own.cli = cli;
    own.baseURL = '/images/' .. tostring( image.id ) .. '/actions';
    print( own.baseURL );
    own.id = image.id;
    -- set properties
    for k, v in pairs( image ) do
        rawset( self, k, v );
    end
    
    return self;
end


local function request( own, method, url, body, opts )
    return own.cli[method](
        own.cli, own.baseURL .. url, body, opts
    );
end


function Actions:selfUpdate( opts )
    local own = protected( self );
    local res, err = own.cli:get( '/images/' .. own.id, nil, nil, opts );
    
    if res and res.status == 200 then
        -- set properties
        for k, v in pairs( res.body.domain ) do
            rawset( self, k, v );
        end
    end
    
    return res, err;
end


function Actions:getList( qry, opts )
    return request( protected(self), 'get', '', qry, nil, opts );
end


function Actions:get( id, opts )
    return request(
        protected(self), 'get', '/' .. tostring( id ), nil, nil, opts
    );
end


function Actions:tranfer( body, opts )
    return request( protected(self), 'post', '', nil, body, opts );
end


Actions = Actions.exports;


-- class
local Images = require('halo').class.Images;

Images.inherits {
    'digitalocean.unchangeable.Unchangeable'
};

function Images:init( cli )
    protected(self).cli = cli;
    
    return self;
end

function Images:getList( qry, opts )
    local own = protected( self );
    local res, err = own.cli:get( '/images', qry, nil, opts );
    
    if res and res.status == 200 then
        local actions = {};
        
        for idx, image in ipairs( res.body.images ) do
            actions[idx] = Actions.new( own.cli, image );
        end
        res.body.images = actions;
    end
    
    return res, err;
end


function Images:get( id, opts )
    local own = protected( self );
    local res, err = own.cli:get( '/images/' .. tostring(id), nil, nil, opts );
    
    if res and res.status == 200 then
        res.body.image = Actions.new( own.cli, res.body.image );
    end
    
    return res, err;
end


function Images:update( id, body, opts )
    local own = protected( self );
    local res, err = own.cli:put( '/images/' .. tostring(id), nil, body, opts );
    
    if res and res.status == 201 then
        res.body.image = Actions.new( own.cli, res.body.image );
    end
    
    return res, err;
end


function Images:delete( id, opts )
    return protected(self).cli:delete(
        '/images/' .. tostring(id), nil, nil, opts
    );
end


return Images.exports;
