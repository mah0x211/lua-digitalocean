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
   
  api/keys.lua
  lua-digitalocean
  
  Created by Masatoshi Teruya on 15/03/09.
  
--]]

-- class
local Keys = require('halo').class.Keys;


Keys.inherits {
    'digitalocean.unchangeable.Unchangeable'
};


function Keys:init( cli )
    protected(self).cli = cli;
    
    return self;
end


function Keys:getList( opts )
    return protected(self).cli:get( '/account/keys', nil, opts );
end


function Keys:get( id, opts )
    return protected(self).cli:get(
        '/account/keys/' .. tostring( id ), nil, opts
    );
end


function Keys:create( body, opts )
    return protected(self).cli:post( '/account/keys', body, opts );
end


function Keys:update( body, opts )
    return protected(self).cli:put( '/account/keys', body, opts );
end


function Keys:delete( id, opts )
    return protected(self).cli:delete(
        '/account/keys/' .. tostring( id ), nil, opts
    );
end


return Keys.exports;
