package App::Rad::Plugin::PasteBin;

use URI::Escape;
use LWP::UserAgent;

sub pastebin{
   my $c = shift;

   my $poster = $c->stash->{poster};
   my $code = shift || $c->stash->{code};

   my $syntax = $c->stash->{syntax} || "text";

   my @syn = qw/
                abap       actionscript ada       apache       applescript asm
                asp        autoit       bash      blitzbasic   bnf         c
                caddcl     cadlisp      cfm       c_mac        cpp         csharp
                css        d            delphi    diff         dos         eiffel 
                erlang     fortran      freebasic genero       gml         groovy
                haskell    html4strict  idl       ini          inno        java
                javascript latex        lisp      lsl2         lua         m68k
                matlab     mirc         mpasm     mysql        nsis        objc
                ocaml      oobas        oracle8   pascal       perl        php
                plswl      python       qbasic    rails        robots      ruby
                scheme     selected     smalltalk smarty       sql         tcl
                text       unreal       vb vbnet  visualfoxpro xml         z80
               /;

   die "Unknow syntax $syntax" unless scalar grep {m/^$syntax$/} @syn;

   $ua = LWP::UserAgent->new;
   $ua->agent("App::Rad::Plugin::PasteBin");

   my $req = HTTP::Request->new(POST => "http://pastebin.com/pastebin.php");
   $req->content_type("application/x-www-form-urlencoded");
   my %pars = (
                 poster     => uri_escape($poster),
                 code2      => uri_escape($code)  ,
                 format     => $syntax            ,
                 paste      => "Send"             ,
                 expiry_day => "d"                ,
              );
   $req->content(join("&", map({"$_=$pars{$_}"} keys %pars)));
   my $res = $ua->request($req);
   unless ($res->is_success) {
       if($res->as_string =~ /location: (.*)/i) {
          return $1;
       }
   }
}

42;
