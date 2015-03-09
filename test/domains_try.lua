local cli = require('./setup');
local res, domain, rec;

math.randomseed( os.time() );
domain = ('example%d.com'):format( math.random(1000000) );

-- List all Domains
res = ifNil( cli.domains:getList() );
ifNotEqual( res.status, 200 );


-- Create a new Domain
res = ifNil( cli.domains:create({
    name = domain,
    ip_address = '127.0.0.1'
}));
ifNotEqual( res.status, 201 );


-- Retrieve an existing Domain
res = ifNil( cli.domains:get( res.body.domain.name ) );
ifNotEqual( res.status, 200 );


-- List all Domain Records
rec = res.body.domain;
res = ifNil( rec:getList() );
ifNotEqual( res.status, 200 );


-- Create a new Domain Record
res = ifNil( rec:create({
  ['type'] = 'A',
  name = 'customdomainrecord.com',
  data = '127.0.0.1',
}));
ifNotEqual( res.status, 201 );


-- Retrieve an existing Domain Record
res = ifNil( rec:get( res.body.domain_record.id ) );
ifNotEqual( res.status, 200 );


-- Update a Domain Record
res = ifNil( rec:update( res.body.domain_record.id, {
    name = 'customdomainrecord-update.com'
}));
ifNotEqual( res.status, 200 );


-- Delete a Domain Record
res = ifNil( rec:delete( res.body.domain_record.id ) );
ifNotEqual( res.status, 204 );


-- Delete a Domain
res = ifNil( cli.domains:delete( domain ) );
ifNotEqual( res.status, 204 );


