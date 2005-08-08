package Speech::Synthesis;

use warnings;
use strict;

our $VERSION = '0.01';

eval "use Win32::MSAgent 0.05";
eval "use Win32::SAPI4 0.07";
eval "use Win32::SAPI5 0.04";
eval "use Win32::OLE";
eval "use Win32::Locale";
eval "use Mac::Speech";
eval "use Festival::Client::Async";
use Locale::Language;
use Locale::Country;

use constant SUPPORTED_ENGINES => qw(MSAgent SAPI4 SAPI5 MacSpeech Festival);

my $LANGUAGES =  {
  0  => 'English',
  1  => 'French',
  2  => 'German',
  3  => 'Italian',
  4  => 'Dutch',
  5  => 'Swedish',
  6  => 'Spanish',
  7  => 'Danish',
  8  => 'Portuguese',
  9  => 'Norwegian',
  10 => 'Hebrew',
  11 => 'Japanese',
  12 => 'Arabic',
  13 => 'Finnish',
  14 => 'Greek',
  15 => 'Icelandic',
  16 => 'Maltese',
  17 => 'Turkish',
  18 => 'Croatian',
  19 => 'Traditional Chinese',
  20 => 'Urdu',
  21 => 'Hindi',
  22 => 'Thai',
  23 => 'Korean',   
  24 => 'Lithuanian',
  25 => 'Polish',
  26 => 'Hungarian',
  27 => 'Estonian',
  28 => 'Latvian',
  29 => 'Sami',
  30 => 'Faroese',
  31 => 'Farsi',
  31 => 'Persian',
  32 => 'Russian',
  33 => 'Simplified Chinese',
  34 => 'Dutch',
  35 => 'Irish Gaelic',
  36 => 'Albanian',
  37 => 'Romanian',
  38 => 'Czech',
  39 => 'Slovak',
  40 => 'Slovenian',
  41 => 'Yiddish',
  42 => 'Serbian',
  43 => 'Macedonian',
  44 => 'Bulgarian',
  45 => 'Ukrainian',
  46 => 'Byelorussian',
  46 => 'Belorussian',
  47 => 'Uzbek',
  48 => 'Kazakh',
  49 => 'Azerbaijani',
  50 => 'Azerbaijani',
  51 => 'Armenian',
  52 => 'Georgian',
  53 => 'Moldavian',
  54 => 'Kirghiz',
  55 => 'Tajiki',
  56 => 'Turkmen',
  57 => 'Mongolian',
  58 => 'Mongolian',
  59 => 'Pashto',
  60 => 'Kurdish',
  61 => 'Kashmiri',
  62 => 'Sindhi',
  63 => 'Tibetan',
  64 => 'Nepali',
  65 => 'Sanskrit',
  66 => 'Marathi',
  67 => 'Bengali',
  68 => 'Assamese',
  69 => 'Gujarati',
  70 => 'Punjabi',
  71 => 'Oriya',
  72 => 'Malayalam',
  73 => 'Kannada',
  74 => 'Tamil',
  75 => 'Telugu',
  76 => 'Sinhalese',
  77 => 'Burmese',
  78 => 'Khmer',
  79 => 'Lao',
  80 => 'Vietnamese',
  81 => 'Indonesian',
  82 => 'Tagalog',
  83 => 'Malaysian',
  84 => 'Malaysian',
  85 => 'Amharic',
  86 => 'Tigrinya',
  87 => 'Oromo',
  88 => 'Somali',
  89 => 'Swahili',
  90 => 'Kinyarwanda',
  90 => 'Ruanda',
  91 => 'Rundi',
  92 => 'Nyanja',
  92 => 'Chewa',
  93 => 'Malagasy',
  94 => 'Esperanto',
  128 => 'Welsh',
  129 => 'Basque',
  130 => 'Catalan',
  131 => 'Latin',
  132 => 'Quechua',
  133 => 'Guarani',
  134 => 'Aymara',
  135 => 'Tatar',
  136 => 'Uighur',
  137 => 'Dzongkha',
  138 => 'Javanese',
  139 => 'Sundanese',
  140 => 'Galician',
  141 => 'Afrikaans'

};

my $REGIONS = {
   0   => 'United States',
   1   => 'France',
   2   => 'Britain',
   3   => 'Germany',
   4   => 'Italy',
   5   => 'Netherlands',
   6   => 'Belgium',
   7   => 'Sweden',
   8   => 'Spain',
   9   => 'Denmark',
   10  => 'Portugal',
   11  => 'Canada',
   12  => 'Norway',
   13  => 'Israel',
   14  => 'Japan',
   15  => 'Australia',
   16  => 'Arabia',
   17  => 'Finland',
   18  => 'Switzerland',
   19  => 'Switzerland',
   20  => 'Greece',
   21  => 'Iceland',
   22  => 'Malta',
   23  => 'Cyprus',
   24  => 'Turkey',
   25  => 'Croatia',
   26  => 'Netherlands',
   27  => 'Belgium',
   28  => 'Canada',
   29  => 'Canada',
   30  => 'Portugal',
   31  => 'Norway',
   32  => 'Denmark',
   33  => 'India',
   34  => 'Pakistan',
   35  => 'Turkey',
   36  => 'Switzerland',
   37  => 'Unknown',
   39  => 'Romania',
   40  => 'Greece',
   41  => 'Lithuania',
   42  => 'Poland',
   43  => 'Hungary',
   44  => 'Estonia',
   45  => 'Latvia',
   46  => 'Sami',
   47  => 'Faroe Islands',
   48  => 'Iran',
   49  => 'Russia',
   50  => 'Ireland',
   51  => 'Korea',
   52  => 'China',
   53  => 'Taiwan',
   54  => 'Thailand',
   55  => 'Unknown',
   56  => 'Czech',
   57  => 'Slovenia',
   58  => 'Unknown',
   59  => 'Magyar',
   60  => 'Bengali',
   61  => 'ByeloRussian',
   62  => 'Ukraine',
   64  => 'GreeceAlt',
   65  => 'Serbian',
   66  => 'Slovenian',
   67  => 'Macedonian',
   68  => 'Croatia',
   70  => 'German',
   71  => 'Brazil',
   72  => 'Bulgaria',
   73  => 'Catalonia',
   74  => 'Unknown',
   75  => 'Scotland',
   76  => 'ManxGaelic', 
   77  => 'Breton', 
   78  => 'Nunavut',
   79  => 'Welsh',
   81  => 'Ireland',
   82  => 'Canada',
   83  => 'Bhutan',
   84  => 'Armenia',
   85  => 'Georgia',
   86  => 'Unknown',
   88  => 'Tonga',
   91  => 'Unknown',
   92  => 'Austria',
   94  => 'Gujarat',
   95  => 'Punjab',
   96  => 'India',
   97  => 'Vietnam',
   98  => 'Belgium',
   99  => 'Uzbekistan',
   100 => 'Singapore',
   101 => 'Norway',
   102 => 'South Africa',
   103 => 'Unknown',
   104 => 'Marathi',
   105 => 'Tibet',
   106 => 'Nepal',
   107 => 'Greenland',
   108 => 'Ireland'          
};

sub InstalledEngines
{
    my $class = shift;
    my @engines = ();
    my $engine;
    $engine = eval "Win32::MSAgent->new()";
    push @engines, 'MSAgent' unless $@;
    $engine = eval "Win32::SAPI4::DirectSpeechSynthesis->new()";
    push @engines, 'SAPI4' unless $@;
    $engine = eval "Win32::SAPI5::SpVoice->new()";
    push @engines, 'SAPI5' unless $@;
    $engine = eval "Mac::Speech::CountVoices()";
    push @engines, 'MacSpeech' unless $@;
    $engine = eval "Festival::Client::Async->new()";
    push @engines, 'Festival' unless $@;
    return @engines;
}

sub InstalledLanguages
{
    my $class = shift;
    my %params = @_;
    return unless (exists $params{engine}) && (grep {$_ eq $params{engine}} Speech::Synthesis->InstalledEngines());
    my @alllangs = ();
    if (($params{engine} eq 'MSAgent') || ($params{engine} eq 'SAPI4'))
    {
        my $sapi4 = Win32::SAPI4::VoiceText->new() || die "Can't start SAPI4: ".Win32::OLE->LastError();
        @alllangs = $sapi4->GetInstalledLanguages();
        @alllangs = grep {$params{engine} ne 'MSAgent' || $_ ne 'unknown'} @alllangs;
        @alllangs = map {/(.+?)\((.+)\)/;my $l = $1;chop $l;language2code($l).'_'.uc(country2code($2));} @alllangs;
    }
    elsif ($params{engine} eq 'SAPI5')
    {
        my $sapi5 ||= Win32::SAPI5::SpVoice->new() || die "Can't start SAPI5: ".Win32::OLE->LastError();
        @alllangs = $sapi5->GetInstalledLanguages();
        @alllangs = map {/(.+?)\((.+)\)/;my $l = $1;chop $l;language2code($l).'_'.uc(country2code($2));} @alllangs;
    }
    elsif ($params{engine} eq 'MacSpeech')
    {
        my $count = CountVoices();
        my %maclangs = ();        
        for (my $i = 0; $i++ < $count; )
        {
            my $voice = GetIndVoice($i);
            my $desc  = ${GetVoiceDescription($voice)};
            my ($synt, $id, $version,$nlen,$name,$clen,$comment,$gender,$age,$script,$language,$region)
                    = unpack("x4 a4 l l C a63 C a255 s s s s s", $desc);
            push @alllangs, "$LANGUAGES->{$language} ($REGIONS->{$region})";
        }
        @alllangs = map {/(.+?)\((.+)\)/;my $l = $1;chop $l;language2code($l).'_'.uc(country2code($2));} @alllangs;
    }
    elsif ($params{engine} eq 'Festival')
    {
        # TODO
    }
    return @alllangs;
}

sub InstalledVoices
{
    my $class = shift;
    my %params = @_;
    return unless (exists $params{engine}) && (grep {$_ eq $params{engine}} Speech::Synthesis->InstalledEngines());
    my @allvoices = ();
    if (($params{engine} eq 'MSAgent') || ($params{engine} eq 'SAPI4'))
    {
        my $sapi4 = Win32::SAPI4::VoiceText->new() || die "Can't start SAPI4: ".Win32::OLE->LastError();
        my $object = $sapi4->GetObject;
        for (my $i=1; $i <= $object->CountEngines; $i++)
        {
            my $lang = Win32::Locale::get_language($object->LanguageID($i));
            next if $params{engine} eq 'MSAgent' && not $lang;
            my ($l, $r) = split(/-/,$lang);
            if (exists $params{language})
            {
                next unless $params{language} eq lc($l)."_".uc($r);
            }
            my $gen = $object->Gender($i) == 1 ? 'female' : $object->Gender($i) == 2 ? 'male' : 'neutral';
            
            if (exists $params{gender})
            {
                next unless $gen eq $params{gender};
            }
            push @allvoices, { name   => $object->ModeName($i),
                               id     => $object->ModeID($i),
                               age    => eval "$object->Age($i)",
                               gender => $gen,
                               language=> lc($l)."_".uc($r),
                               description => $object->ProductName($i)
                             }
        }
    }
    elsif ($params{engine} eq 'SAPI5')
    {
        my $sapi5 ||= Win32::SAPI5::SpVoice->new() || die "Can't start SAPI5: ".Win32::OLE->LastError();
        my $object = $sapi5->GetObject();
        my $tokens = $object->GetVoices;
        for (my $i = 0; $i < $tokens->Count; $i++)
        {
            my ($lang, undef) = split(/;/,$tokens->Item($i)->GetAttribute('Language'));
            $lang = Win32::Locale::get_language(hex("0x$lang"));
            if ($lang)
            {
                my ($l, $r) = split(/-/,$lang);
                if (exists $params{language})
                {
                    next unless $params{language} eq lc($l)."_".uc($r);
                }
                my $gender = lc($tokens->Item($i)->GetAttribute('Gender'));
                
                if (exists $params{gender})
                {
                    next unless $gender eq $params{gender};
                }
                push @allvoices, { name   => $tokens->Item($i)->GetAttribute('Name'),
                                   id     => $tokens->Item($i)->Id,
                                   age    => eval("$tokens->Item($i)->GetAttribute('Age')"),
                                   gender => $gender,
                                   language=> lc($l)."_".uc($r),
                                   description => $tokens->Item($i)->GetDescription()
                                 }
            }
        }
    }
    elsif ($params{engine} eq 'MacSpeech')
    {
        my $count = CountVoices();
        for (my $i = 0; $i++ < $count; )
        {
            my $thislang;
            my $voice = GetIndVoice($i);
            my $desc  = ${GetVoiceDescription($voice)};
            my ($synt, $id, $version,$nlen,$name,$clen,$comment,$gender,$age,$script,$language,$region)
                    = unpack("x4 a4 l l C a63 C a255 s s s s s", $desc);
            $thislang = language2code($LANGUAGES->{$language}).'_'.uc(country2code($REGIONS->{$region}));
            if (exists $params{language})
            {
                next unless $thislang eq $params{language};
            }

            my $gen = $gender == 0 ? 'neutral' : $gender == 1 ? 'male' : 'female';
            if (exists $params{gender})
            {
                next unless $gen eq $params{gender};
            }

            $name = substr $name, 0, $nlen;
            $comment = substr $comment, 0, $clen;
            push @allvoices, { name   => $name,
                               id     => $id,
                               age    => $age,
                               gender => $gen,
                               language => $thislang,
                               description => $comment
                             };
        }
    }
    elsif ($params{engine} eq 'Festival')
    {
        #TODO
    }
    return @allvoices;
}

sub InstalledAvatars
{
    my $class = shift;
    my %params = @_;
    return () unless (exists $params{engine}) && ($params{engine} eq 'MSAgent');
    my $agent = Win32::MSAgent->new();
    return $agent->GetInstalledCharacters if defined $agent;
}

sub new
{
    my $proto = shift;
    my %params = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    unless (exists $params{engine})
    {
        warn "The 'engine' parameter is mandatory";
        return;
    }
    unless (grep {$params{engine} eq $_} SUPPORTED_ENGINES)
    {
        warn "Unknown 'engine': $params{engine}";
        return;
    }
    $self->{_engine} = $params{engine};
    $self->{_voice} = $params{voice};
    $self->{_async} = $params{async} || 1;
    if ($self->{_engine} eq 'MSAgent')
    {
        unless ((exists $params{language}) && (exists $params{avatar}))
        {
            warn "The 'language' parameter is mandatory if you specify 'MSAgent' as the engine type" unless exists $params{language};
            warn "The 'avatar' parameter is mandatory if you specify 'MSAgent' as the engine type" unless exists $params{avatar};
            return;
        }
        $self->{_language}  = $params{language};
        $self->{_avatar} = $params{avatar};
    }
    $self->_init();
    return $self;
}

sub getobject
{
    my $self = shift;
    return unless exists $self->{_engine};
    if ($self->{_engine} eq 'MSAgent')
    {
        return $self->{_char};
    }
    elsif ($self->{_engine} eq 'SAPI4')
    {
        return $self->{_sapi4};
    }
    elsif ($self->{_engine} eq 'SAPI5')
    {
        return $self->{_sapi5};
    }
    elsif ($self->{_engine} eq 'MacSpeech')
    {
        # Can't really return anything here, now can we?
    }
    elsif ($self->{_engine} eq 'Festival')
    {
        #TODO
    }
}

our $AUTOLOAD;
sub AUTOLOAD
{
    my $self = shift;
    return unless exists $self->{_engine};
    my @params = @_;
    (my $auto = $AUTOLOAD) =~ s/.*:://;
    if ($self->{_engine} eq 'MSAgent')
    {
        $self->{_char}->$auto(@params);
    }
    elsif ($self->{_engine} eq 'SAPI4')
    {
        $self->{_sapi4}->$auto(@params);
    }
    elsif ($self->{_engine} eq 'SAPI5')
    {
        $self->{_sapi5}->$auto(@params);
    }
    elsif ($self->{_engine} eq 'MacSpeech')
    {
        # Can't really autoload anything here, now can we?
    }
    elsif ($self->{_engine} eq 'Festival')
    {
        #TODO
    }
}

sub voice
{
    my $self = shift;
    my $id = shift;
    $self->{_voice} = $id if defined $id;
    $self->_init() if defined $id;
    return $self->{_voice};
}

sub speak
{
    my $self = shift;
    my $text = shift;
    if ($self->{_engine} eq 'MSAgent')
    {
        $self->{_char}->Speak($text);
    }
    elsif ($self->{_engine} eq 'SAPI4')
    {
        # Normally we would use the 'Speak' method, but it seems like
        # Fluency speechengines make the application crash when using Speak
        # if pVoice starts up using the Fluency engine. Very strange, but this
        # seems to be a workaround...
        $self->{_sapi4}->TextData(0,0,$text);
        unless ($self->{_async})
        {
            sleep(0.5) unless ($self->{_sapi4}->Speaking);
            do {} while ($self->{_sapi4}->Speaking);
        }
    }
    elsif ($self->{_engine} eq 'SAPI5')
    {
        $self->{_sapi5}->Speak($text);
        unless ($self->{_async})
        {
            my $status = $self->{_sapi5}->Status;
            do {} until ($status->{RunningState} == 2);
        }
    }
    elsif ($self->{_engine} eq 'MacSpeech')
    {
        unless ($self->{_async}){ do {} while (SpeechBusy())}
        SpeakText($self->{_macspeech}, $text);
        unless ($self->{_async}){ do {} while (SpeechBusy())}
    }
    elsif ($self->{_engine} eq 'Festival')
    {
        #TODO
    }
}

sub _init
{
    my $self = shift;
    $self->_initagent     if $self->{_engine} eq 'MSAgent';
    $self->_initsapi4     if $self->{_engine} eq 'SAPI4';
    $self->_initsapi5     if $self->{_engine} eq 'SAPI5';
    $self->_initmacspeech if $self->{_engine} eq 'MacSpeech';
    $self->_initfestival  if $self->{_engine} eq 'Festival';
}

sub _initagent
{
    my $self = shift;
    return unless $self->{_engine} eq 'MSAgent';
    if ((exists $self->{_agent}) && ($self->{_loadedchar} ne $self->{_avatar}))
    {
        $self->{_char}->Hide();
        $self->{_agent}->Characters->Unload($self->{_loadedchar});
    }
    else
    {
        $self->{_agent} = Win32::MSAgent->new()  || die "Can't start MSAgent: ".Win32::OLE->LastError();;
    }
    $self->{_agent}
         ->Characters->Load($self->{_avatar},
                            $self->{_avatar}.".acs");
    $self->{_loadedchar} = $self->{_avatar};
    # To be able to access the character from $self's
    # action methods, we have to define it as a property of that
    $self->{_char} = $self->{_agent}->Characters($self->{_avatar});
    my %langtag2msloc = reverse %Win32::Locale::MSLocale2LangTag;
    my $lang = lc($self->{_language});
    $lang =~ s/_/-/;
    $lang = $langtag2msloc{$lang};
    $self->{_char}->SetProperty('LanguageID',$lang);
    $self->{_char}->SetProperty('TTSModeID', "{".$self->{_voice}."}") 
        if exists $self->{_voice};
    $self->{_char}->MoveTo(0, 350);
    
    # Show the MS Agent
    $self->{_char}->Show();
}

sub _initsapi4
{
    my $self = shift;
    return unless $self->{_engine} eq 'SAPI4';
    $self->{_sapi4} = Win32::SAPI4::DirectSpeechSynthesis->new() || die "Can't start SAPI4: ".Win32::OLE->LastError();
    for (my $i=1; $i <= $self->{_sapi4}->CountEngines; $i++)
    {
        $self->{_sapi4}->Select($i) if $self->{_sapi4}->ModeID($i) eq $self->{_voice};
    }
    do {} until ($self->{_sapi4}->Initialized);
}

sub _initsapi5
{
    my $self = shift;
    return unless $self->{_engine} eq 'SAPI5';
    $self->{_sapi5} ||= Win32::SAPI5::SpVoice->new() || die "Can't start SAPI5: ".Win32::OLE->LastError();
    my $tokens = $self->{_sapi5}->GetVoices;
    for (my $i = 0; $i < $tokens->Count; $i++)
    {
        $self->{_sapi5}->SetProperty('Voice', $tokens->Item($i)) if $tokens->Item($i)->Id eq $self->{_voice};
    }
}

sub _initmacspeech
{
    my $self = shift;
    return unless $self->{_engine} eq 'MacSpeech';
    for (my $i=1; $i <= CountVoices(); $i++)
    {
        my $voice = GetIndVoice($i);
        my $desc  = ${GetVoiceDescription($voice)};
        my ($synt, $id, $version,$nlen,$name,$clen,$comment,$gender,$age,$script,$language,$region)
                = unpack("x4 a4 l l C a63 C a255 s s s s s", $desc);
        $self->{_macspeech} = NewSpeechChannel($voice) if $id eq $self->{_voice};
    }
}

sub _initfestival
{
}

sub DESTROY
{
    my $self = shift;
    if (exists $self->{_agent})
    {
        $self->{_char}->Hide();
        $self->{_agent}->Characters->Unload($self->{_loadedchar});
    }    
}

1; # End of Speech::Synthesis

__END__

=pod

=head1 NAME

Speech::Synthesis - A generic interface for different Text To Speech Engines

=head1 VERSION

This is Speech::Synthesis 0.01

=head1 SYNOPSIS

    use Speech::Synthesis;

    my $foo = Speech::Synthesis->new();
    ...

=head1 CLASS METHODS

=head2 @engines = Speech::Synthesis->InstalledEngines()

This class method returns a list of installed Speech Engines. Depending on your
platform, it may return one or more of the following:

=over 4

=item 'MSAgent' (Win32 only)

=item 'SAPI4' (Win32 only)

=item 'SAPI5' (Win32 only)

=item 'MacSpeech' (OS X only)

=item 'Festival' (Not implemented yet)

=back

=head2 @langs = Speech::Synthesis->InstalledLanguages(engine => $engine)

This method queries the installed languages for the specified engine (see 'InstalledEngines').
The data that is returned uses the ISO 3166-1 conventions. This specification uses a two-letter,
capitalized code to identify a specific country. By catenating a language designator
with an underscore character and a regional designator, you get a designator that
identifies the locale for a specific language and country. It could return a list like
('en_US', 'en_GB', 'fr_CA', 'nl_NL').

=head2 @voices = Speech::Synthesis->InstalledVoices(%options)

This method queries the installed voices for the Speech Synthesis object. You can
supply one or more options, which will have a filtering effect on the returned
voices. These options are:

=over 4

=item engine

This takes an engine name as used in InstalledEngines (mandatory).

=item language

This takes one or more of the language values as returned by InstalledLanguages()

=item gender

This parameter can be one of the following: 'male', 'female' or 'neutral'.

=back

The voices array that this method returns is an array of hashrefs. Each hashref
contains at least the following keys: 'id', 'name', 'description',
'language', 'gender', 'age'.  It may return more keys, depending on what the
selected engine supports. If a key has an undefined value, it simply isn't available.

=head2 @avatars = Speech::Synthesis->InstalledAvatars(engine => $engine)

This class method currently only works for the 'MSAgent' engine (so that's
the only value for the $engine that will actually return anything), and
it will return a list of avatars (MS Agent Characters) that are currently
installed.

=head1 INSTANCE METHODS

=head2 $ss = Speech::Synthesis->new(%options)

This is the constructor. Parameters can be supplied using key/value combinations.
Valid parameters are:

=over 4

=item engine

The value for the 'engine' key can be one of the speech engine values described
in the InstalledEngines class method.

=item voice

The value of the 'voice' key can be one of the 'id' values as defined in the array
of hashrefs that the InstalledVoices method returns.

=item language

This parameter is mandatory when you specify 'MSAgent' as the engine. It will
be ignored otherwise

=item avatar

This parameter is mandatory when you specify 'MSAgent' as the engine. It will
be ignored otherwise. It is the avatar (or Agent Character) that will
show up on your desktop and "speak" the text for you.
It might be used for other engines in the future.

=item async

This parameter defines wether we will wait until speaking finishes or not.
By default, async = 1. If you want your code to wait until it finishes
speaking, set it to 0. (not supported for MSAgent)

=back

=head2 $o = $ss->getobject()

This method returns the original Perl object that the Speech::Synthesis
module uses at that very moment. It doesn't support Mac::Speech (since
that module doesn't use objects)

=head2 $ss->voice($id)

This method gets or sets the id of the voice. This is the same 'id' as used in the
voices array of hashrefs in the InstalledVoices method.

=head2 $ss->speak($string)

This method speaks the $string using the selected engine and the selected voice.

=head1 BUGS AND CAVEATS

The working of asynchronous speecht doesn't really work yet. It seems to work for SAPI5 only.
Festival support is being worked on.

=head1 AUTHOR

Jouke Visser, C<< <jouke@pvoice.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-speech-synthesis@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Speech-Synthesis>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Jouke Visser, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut


