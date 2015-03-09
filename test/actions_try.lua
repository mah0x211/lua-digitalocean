local cli = require('./setup');
local res;

-- List all Actions
res = ifNil( cli.actions:getList() );
ifNotEqual( res.status, 200 );

-- Retrieve an existing Action
for _, action in ipairs( res.body.actions ) do
    res = ifNil( cli.actions:get( action.id ) );
    ifNotEqual( res.status, 200 );
    break;
end
