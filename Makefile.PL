use inc::Module::Install;

name('Speech-Synthesis');
version_from('lib/Speech/Synthesis.pm');
abstract_from('lib/Speech/Synthesis.pm');
author('Jouke Visser <jouke@pvoice.org>');
license('perl');
check_nmake();
requires(perl => 5.006);
include_deps('Test::More', 5.004);
build_requires('Test::More');
if ($^O eq 'darwin')
{
    requires('Mac::Speech');
}
elsif ($^O eq 'MSWin32')
{
    my $ok = 0;
    eval "use Win32::SAPI5";
    $ok = 1 unless $@;
    eval "use Win32::SAPI4";
    $ok = 1 unless $@;
    eval "use Win32::MSAgent";
    $ok = 1 unless $@;
    recommends('Win32::SAPI5') unless $ok;
}
else
{
    print STDERR "Festival is not yet supported. Speech::Synthesis currently only works on OS X with Mac::Speech and Win32 with Win32::SAPI4, Win32::SAPI5 or Win32::MSAgent";
    print STDERR "Not writing a makefile";
    die;
}
&Meta->write();
&Makefile->write();
