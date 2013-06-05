use strict;
use Test::More;
use xt::CLI;

{
    my $app = cli();

    $app->dir->child("cpanfile")->spew(<<EOF);
requires 'Try::Tiny', '== 0.11';
EOF

    $app->run("check");
    like $app->stderr, qr/find carton\.lock/;

    $app->run("install");
    use Data::Dumper;
    warn Dumper $app;

    $app->run("check");
    like $app->stdout, qr/are satisfied/;

    $app->run("list");
    like $app->stdout, qr/Try-Tiny-0\.11/;

    $app->dir->child("cpanfile")->spew(<<EOF);
requires 'Try::Tiny', '0.12';
EOF

    $app->run("check");
    like $app->stdout, qr/not satisfied/;

    # TODO run exec and it will fail again

    $app->run("install");

    $app->run("check");
    like $app->stdout, qr/are satisfied/;

    $app->run("list");
    like $app->stdout, qr/Try-Tiny-0\.12/;
}


done_testing;

