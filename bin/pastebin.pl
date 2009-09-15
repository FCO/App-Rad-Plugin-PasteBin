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
            file   => {
                       type      => "str"  ,
                       to_stash  => 1      ,
                       condition => sub{-f},
                       argument  => 1      ,
                       required  => 1      ,
                       error_message => "File do not exists",
                      },
             -help => "Postar um arquivo no pastebin"
                   },
         "exec" => {
            author => {type => "str", to_stash => "poster", help => "Autor", default => $ENV{USERNAME}},
            syntax => {type => "str", to_stash => 1, help => "Sintaxe do codigo", default => "text"},
            cmd    => {type => "str", to_stash => 1, argument => 0, required => 1},
            -help  => "Postar um comando e a saida do comando no pastebin"
                   },
      }
   );
}

sub file {
   my $c = shift;

   open my $FILE, "<", $c->stash->{file};
   my $content = join "", <$FILE>;
   close $FILE;
   $c->pastebin($content);
}

sub exec {
   my $c = shift;

   my $content;
   die "TODO" if $c->stash->{cmd} =~ /["']/;
   for my $cmd (split /;/, $c->stash->{cmd}) {
      $content .= $c->stash->{poster} . "> $cmd$/";

      $content .= qx/$cmd 2>&1/ . $/;
   }
   $c->pastebin($content);
}
