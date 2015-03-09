local HttpCli = assert( require('httpcli.luasocket').new() );
local cli = assert( require('digitalocean').client.new( HttpCli, {
    access_token = os.getenv('DO_APIKEY');
}));

return cli;
