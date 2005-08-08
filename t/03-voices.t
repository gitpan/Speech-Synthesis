use Speech::Synthesis;
use Test::More;
use strict;
use warnings;
use Data::Dumper;
my @engines = Speech::Synthesis->InstalledEngines();
plan skip_all => "No Speech Engines installed" unless @engines;
plan tests => scalar(@engines);

foreach my $engine (@engines)
{
    my @voices = Speech::Synthesis->InstalledVoices(engine => $engine);
SKIP:{    skip "No voices installed for engine $engine", 1 unless @voices;
    ok(scalar(@voices) > 0, "You have installed voices for engine $engine");
#    diag(Dumper(\@voices));
};
}