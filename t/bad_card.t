BEGIN {$| = 1; print "1..1\n"; }

print "ok 1 # Skipped: No way to get a decline response out of test account";
exit;

eval "use Net::SSLeay;";
if ( $@ ) {
  print "ok 1 # Skipped: Net::SSLeay is not installed\n"; exit;
}

use Business::OnlinePayment;

require "t/lib/test_account.pl";
my($login, $regkey) = test_account_or_skip();

my $tx = new Business::OnlinePayment("TransactionCentral");

#$Business::OnlinePayment::HTTPS::DEBUG = 1;
#$Business::OnlinePayment::HTTPS::DEBUG = 1;
$Business::OnlinePayment::TransactionCentral::DEBUG = 1;
$Business::OnlinePayment::TransactionCentral::DEBUG = 1;

$tx->content(
    type           => 'VISA',
    login          => $login,
    password       => $regkey,
    action         => 'Normal Authorization',
    amount         => '32.32',
    #card_number    => '4012000000001',
    #card_number    => '4342424242424242',
    card_number    => '1',
    expiration     => '08/06',
    cvv2           => '420',
    name           => 'Tofu Beast',
    address        => '123 Anystreet',
    city           => 'Anywhere',
    state          => 'UT',
    zip            => '84058',
    country        => 'US',
    email          => 'ivan-transactioncentral-test@420.am',
);
$tx->test_transaction(1); # test, dont really charge
$tx->submit();

if($tx->is_success()) {
    print "not ok 1\n";
} else {
    #warn $tx->server_response."\n";
    #warn  $tx->error_message. "\n";
    print "ok 1\n";
}
