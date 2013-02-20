use Net::Twitter;
use Scalar::Util 'blessed';
use WWW::Curl::Easy;
use DateTime;

while(){
	my $dt = DateTime->now(time_zone=>'local');

	my $update = "";

	my $curl = WWW::Curl::Easy->new;

	$curl->setopt(CURLOPT_HEADER,1);
	$curl->setopt(CURLOPT_URL, 'http://www.findmyip.org/');

	my $response_body;
	$curl->setopt(CURLOPT_WRITEDATA,\$response_body);

	my $retcode = $curl->perform;

	if ($retcode == 0) {
		my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
			if($response_body =~ m/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/){
				$update = $1;
			}else{
				$update = "Cannot locate IP";
			}	
	} else {
		$update = ("An error happened: $retcode ".$curl->strerror($retcode)." ".$curl->errbuf."\n");
	}

	my $nt = Net::Twitter->new(legacy => 0);

	my ($consumer_key,
	    $consumer_secret,
	    $token,
	    $token_secret) 
	= ("", 
	   "", 
	   "", 
	   "");

	my $nt = Net::Twitter->new(
		traits   => [qw/OAuth API::REST/],
		consumer_key        => $consumer_key,
		consumer_secret     => $consumer_secret,
		access_token        => $token,
		access_token_secret => $token_secret,
		);

	$update = ($update . " :: " . $dt);

	my $result = $nt->update($update);
	
	sleep(1800);	
}
