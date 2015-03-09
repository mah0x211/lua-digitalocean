local cli = require('./setup');
local res;

-- Get User Information
res = ifNil( cli.account:get() );
ifNotEqual( res.status, 200 );
