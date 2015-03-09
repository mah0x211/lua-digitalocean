local cli = require('./setup');
local res;

-- List all Regions
res = ifNil( cli.regions:getList() );
ifNotEqual( res.status, 200 );

