local cli = require('./setup');
local res;

-- List all Sizes
res = ifNil( cli.sizes:getList() );
ifNotEqual( res.status, 200 );

