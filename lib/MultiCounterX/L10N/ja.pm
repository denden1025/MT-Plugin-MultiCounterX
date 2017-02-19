package MultiCounterX::L10N::ja;

use strict;
use base 'MultiCounterX::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'MultiCounterX plugin config' => 'Multi CounterX',
    '_PLUGIN_DESCRIPTION' => 'セッション管理型カウンター・昨日今日カウンター',
    '_PLUGIN_AUTHOR' => 'webkoza.com',
    '_MCXFont' => '使用するフォントファイル',
    '_MCXCGI' => 'カウンターCGIのURL',
    '_MCXSesTout' => 'セッション継続時間 sec ',
    '_MCXOwner' => 'カウンター管理者名',
    '_MCXOwnerPass' => 'カウンター管理者パスワード',
    '_MCXFrameWidth' => 'フレーム幅 px ',
    '_MCXFrameHight' => 'フレーム高さ px ',
    '_MCXFrameBGColor' => 'フレーム背景色（***,***,***）',
    '_MCXFrameBDColor' => 'フレーム枠色（***,***,***）',
    '_MCXFontSize' => 'メッセージフォントサイズ',
    '_MCXMessage1' => 'メッセージ1（昨日・今日・合計の人数埋め込み）',
    '_MCXMessage1FontColor' => 'メッセージ1フォント色（***,***,***）',
    '_MCXMessage1StartXCoordinate' => 'メッセージ1開始X座標（左上原点）',
    '_MCXMessage1StartYCoordinate' => 'メッセージ1開始Y座標（左上原点）',
    '_MCXMessage2A' => 'メッセージ2A（訪問回数埋め込み・セッション開始時メッセージ）',
    '_MCXMessage2AFontColor' => 'メッセージ2Aフォント色（***,***,***）',
    '_MCXMessage2B' => 'メッセージ2B（訪問回数埋め込み・セッション継続中メッセージ）',
    '_MCXMessage2BFontColor' => 'メッセージ2Bフォント色（***,***,***）',
    '_MCXMessage2A2BStartXCoordinate' => 'メッセージ2A,2B開始X座標（左上原点）',
    '_MCXMessage2A2BStartYCoordinate' => 'メッセージ2A,2B開始Y座標（左上原点）',
    '_MCXMessage3' => 'メッセージ3（他の訪問中人数埋め込み）',
    '_MCXMessage3FontColor' => 'メッセージ3フォント色（***,***,***）',
    '_MCXMessage3StartXCoordinate' => 'メッセージ3開始X座標（左上原点）',
    '_MCXMessage3StartYCoordinate' => 'メッセージ3開始Y座標（左上原点）',
    '_MCXAnalysisProgram' => '訪問人数グラフ表示プログラムURL',
    '_MCXDoAnalysis' => '訪問人数グラフ表示を行う（別途CGIプログラム必要）'
);

1;
