#!/usr/bin/perl
use App::Rad qw(PasteBin);
App::Rad->run;

sub setup {
   my $c = shift;

   $c->register_commands(
      {
         file   => {
            author => {type => "str", to_stash => "poster", help => "Autor", default => $ENV{USERNAME}},
            syntax => {type => "str", to_stash => 1, help => "Sintaxe do codigo", default => "text"},
             -help => "Postar um arquivo no pastebin"
                   },
         "exec" => {
            author => {type => "str", to_stash => "poster", help => "Autor", default => $ENV{USERNAME}},
            syntax => {type => "str", to_stash => 1, help => "Sintaxe do codigo", default => "text"},
            -help  => "Postar um comando e a saida do comando no pastebin"
                   },
         "download" => {
            file   => {type => "str", to_stash => ["file"]},
            -help  => "Postar um comando e a saida do comando no pastebin"
                       },
      }
   );
}

sub file {
   my $c = shift;

   open my $FILE, "<", $c->argv->[0];
   my $content = join "", <$FILE>;
   close $FILE;
   $c->pastebin($content);
}

sub exec {
   my $c = shift;

   my $content;
   die "TODO" if $c->argv->[0] =~ /["']/;
   for my $cmd (split /;/, join " ", @{$c->argv}) {
      $content .= $c->stash->{poster} . "> $cmd$/";

      $content .= qx/$cmd 2>&1/ . $/;
   }
   $c->pastebin($content);
}

sub download {
   my $c    = shift;
   my $code = $c->argv->[0];

   $code = $1 if $code =~ m{/?(\w{7,10})$};
   return "File " . $c->stash->{file} . " downloaded" if $c->pastebin_download($code);
   "error"
}
