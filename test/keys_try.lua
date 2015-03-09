local cli = require('./setup');
local res;

-- List all Keys
res = ifNil( cli.keys:getList() );
ifNotEqual( res.status, 200 );


-- Create a new Key
res = ifNil( cli.keys:create({
    name = 'My SSH Public Key',
    public_key = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDDHr/jh2Jy4yALcK4JyWbVkPRaWmhck3IgCoeOO3z1e2dBowLh64QAM+Qb72pxekALga2oi4GvT+TlWNhzPH4V example'
}));
ifNotEqual( res.status, 201 );


-- Retrieve an existing Key
res = ifNil( cli.keys:get( res.body.ssh_key.id ) );
ifNotEqual( res.status, 200 );


-- Update a Key
res = ifNil( cli.keys:update( res.body.ssh_key.id, {
    name = 'Renamed SSH Key'
}));
ifNotEqual( res.status, 200 );


-- Destroy a Key
res = ifNil( cli.keys:delete( res.body.ssh_key.id ) );
ifNotEqual( res.status, 204 );


