package MultiCounterX::L10N::en_us;

use strict;
use base 'MultiCounterX::L10N';
use vars qw( %Lexicon );

%Lexicon = (
    'MultiCounterX plugin config' => 'Multi CounterX',
    '_PLUGIN_DESCRIPTION' => 'Session Controled Counter , Yesterday/Today Counter',
    '_PLUGIN_AUTHOR' => 'Tsutomu Igarashi',
    '_MCXFont' => 'Font File Full Path',
    '_MCXCGI' => 'Counter CGI URL',
    '_MCXSesTout' => 'Session Duration Time  sec ',
    '_MCXOwner' => 'Owner Name',
    '_MCXOwnerPass' => 'Owner Password',
    '_MCXFrameWidth' => 'Display Frame Width  px ',
    '_MCXFrameHight' => 'Display Frame Hight  px ',
    '_MCXFrameBGColor' => 'Display Frame Back Ground Color:***,***,***',
    '_MCXFrameBDColor' => 'Display Frame Border Color:***,***,***',
    '_MCXFontSize' => 'Messages Font Size',
    '_MCXMessage1' => 'Message1:Including Yesterday/Today/Total Number of Visitors',
    '_MCXMessage1FontColor' => 'Font Color of Message1:***,***,***',
    '_MCXMessage1StartXCoordinate' => 'Starting X Coordinate of Message1:Upper Left Origin',
    '_MCXMessage1StartYCoordinate' => 'Starting Y Coordinate of Message1:Upper Left Origin',
    '_MCXMessage2A' => 'Message2A:Session Starting Message Including Visit Frequency',
    '_MCXMessage2AFontColor' => 'Font Color of Message2A:***,***,***',
    '_MCXMessage2B' => 'Message2B:Session Ongoing Message Including Visit Frequency',
    '_MCXMessage2BFontColor' => 'Font Color of Message2B:***,***,***',
    '_MCXMessage2A2BStartXCoordinate' => 'Starting X Coordinate of Message2A,2B:Upper Left Origin',
    '_MCXMessage2A2BStartYCoordinate' => 'Starting Y Coordinate of Message2A,2B:Upper Left Origin',
    '_MCXMessage3' => 'Message3:Including Other Number of Visiting',
    '_MCXMessage3FontColor' => 'Font Color of Message3:***,***,***',
    '_MCXMessage3StartXCoordinate' => 'Starting X Coordinate of Message3:Upper Left Origin',
    '_MCXMessage3StartYCoordinate' => 'Starting Y Coordinate of Message3:Upper Left Origin',
    '_MCXAnalysisProgram' => 'CGI Program URL to Display Graphs of the Number of Visits',
    '_MCXDoAnalysis' => 'To Display Graphs of the Number of Visits [You Need Other Program]'
);

1;
