# MT Plugin MultiCounterX Readme
### update：2017/2/18
---
## 概要（Overview）
GDを使ったマルチアクセスカウンタープラグインです。  
再構築時にファンクショナルタグを埋め込んだ場所にCGIへのリンクを含んだimgタグを出力します。  
セッション管理型の訪問カウンター、クッキーカウンター、昨日今日カウンター、合計カウンターの値が  
表示できます。これら値を自由なコメントに埋め込むことが可能です。  
imgタグを埋め込んだページ単位で独自のテキストアクセスログファイルを残します。  
集計グラフ表示アプリへのURLを設定しておけば、カウンター自体をクリックするとこのファイルを  
集計してグラフ表示することもできます。  
This plugin is multi access counter using GD module.   
MT output 'img' tag for this counter at a inserted functional tag place when the template was rebuilded.  
It can display yesterday visitor counter value, today visitor counter value, total visitor counter value. These values are embedded into free defined messages.  
This plugin output access log data into tab delimited original text file.  
If you set a program url to display graphs using these log data , blog owner (maybe you)
 can display that graphs when  this counter was clicked.

## 動作確認済み環境（Used environment for validation）
Fedora18 , Apache/2.4.4 (Fedora) , mod_proxy  , MovableType5.2.2（PSGI）  
Windows10 Home 64bit , Apache/2.4.23 (Win64)  , MovableType6.3.2

## 対応言語（Language）
日本語（Japanese)・英語（English）

## 必要モジュール（Prerequisites）
GD  
Jcode  
File::Path  
MT::Entry  
Encode  
URI::Escape  

## プラグインタイプ（Plugin Type）
ファンクショナルタグプラグイン（Functional Plugin）

## ファンクショナルタグ名（Functional Tag Name）
`<mt:CounterMessagesX>`


## プラグイン設定とメッセージ表示機能（Setting and Display Function Specification）
プラグイン設定はブログレベルのみです。システムレベル設定はありません。  
画像フレームの大きさを１つ定義し、その中に３種類のメッセージを表示します。  
各メッセージの意味は下記です。  
You can define only blog level setting.There aren't system level setting.  
2 messages are displayed in a picture frame.

- メッセージ１（Messages1）  
昨日のアクセス数・今日のアクセス数・合計アクセス数の３つの値を含めることができるメッセージ  
この順番に %s をメッセージに埋め込む  
Yesterday visitor counter value, today visitor counter value, total visitor counter value as '%s' in order are embedded into this message.  

- メッセージ２A（Messages2A）  
訪問回数（クッキーカウンター値）を %s として埋め込むセッション開始時メッセージ  
Cookie counter value as '%s' are embedded into this message. It is displayed when session was started.

- メッセージ2B（Messages2B）  
訪問回数（クッキーカウンター値）を %s として埋め込むセッション継続中  
（セッション時間内２回目以後リクエスト）のメッセージ  
Cookie counter value as '%s' are embedded into this message. It is displayed when session is ongoing.

- メッセージ3（Messages3）  
他の訪問中人数を %s として埋め込むメッセージ  
Other visiting people counter value as '%s' are embedded into this message.

ブログレベル設定項目と初期値は下記です。config.yaml内設定項目毎に説明します。  
Blog level setting term and initial value is below. These are defining in config.yaml.

1. MCFontfile:  
使用するフォントファイル（Font File Full Path）   
default: /usr/share/fonts/vlgothic/VL-Gothic-Regular.ttf

2. MCCGIURL:  
カウンターCGIのURL（Counter CGI URL）  
default: /mt/plugins/MultiCounterX/mcounterx.cgi

3. SESTIMEOUT:  
セッション継続時間 sec（Session Duration Time  sec ）  
default: 900

4. UNAMEVAL:  
カウンター管理者名（Owner Name）  
訪問人数グラフ表示プログラムを呼び出す前に入力したデータと照合します。  
Plugin compare this data with a data that visitor inputted before this plugin call CGI Program to Display Graphs.  
default: mcxowner

5. OWNERPASS:  
カウンター管理者パスワード（Owner Password）  
訪問人数グラフ表示プログラムを呼び出す前に入力したデータと照合します。   
Plugin compare this data with a data that visitor inputted before this plugin call CGI Program to Display Graphs.  
default: password

6. XSIZE:  
フレーム幅 px（Display Frame Width  px ）  
default: 360

7. YSIZE:  
フレーム高さ px（Display Frame Hight  px ）  
default: 51

8. FILLCOLOR:  
フレーム背景色（XXX,XXX,XXX）（Display Frame Back Ground Color:XXX,XXX,XXX）  
default: 255,255,255

9. BORDERCOLOR:  
フレーム枠色（XXX,XXX,XXX）（Display Frame Border Color:XXX,XXX,XXX）  
default: 255,255,255

10. SIZE:  
メッセージフォントサイズ（Messages Font Size）  
default: 10

11. M1:  
メッセージ1（昨日・今日・合計の人数埋め込み）  
（Message1:Including Yesterday/Today/Total Number of Visitors）  
default: Visits Today:%s Yesterday:%s Total:%s

12. M1COLOR:  
メッセージ1フォント色（XXX.XXX.XXX）（Font Color of Message1:XXX,XXX,XXX）  
default: 102,10,54

13. M1XPOS:  
メッセージ1開始X座標（左上原点）（Starting X Coordinate of Message1:Upper Left Origin）  
default: 2

14. M1YPOS:  
メッセージ1開始Y座標（左上原点）（Starting Y Coordinate of Message1:Upper Left Origin）  
default: 12

15. M2A:  
メッセージ2A（訪問回数埋め込み・セッション開始時メッセージ）  
（Message2A:Session Starting Message Including Visit Frequency）  
default: Thanks %s vists

16. M2ACOLOR:  
メッセージ2Aフォント色（XXX,XXX,XXX）（Font Color of Message2A:XXX,XXX,XXX）  
default: 80,80,80

17. M2B:
メッセージ2B（訪問回数埋め込み・セッション継続中メッセージ）  
（Session Ongoing Message Including Visit Frequency）  
default: You are visiting %s times

18. M2BCOLOR:  
メッセージ2Bフォント色（XXX,XXX,XXX）（Font Color of Message2B:XXX,XXX,XXX）  
default: 6,79,154

19. M2XPOS:  
メッセージ2A,2B開始X座標（左上原点）（Starting X Coordinate of Message2A,2B:Upper Left Origin）  
default: 2

20. M2YPOS:  
メッセージ2A,2B開始Y座標（左上原点）（Starting Y Coordinate of Message2A,2B:Upper Left Origin）  
default: 27

21. M3:  
メッセージ3（他の訪問中人数埋め込み）（Message3:Including Other Number of Visiting）  
default: Other %s people are visiting

22. M3COLOR:  
メッセージ3フォント色（XXX,XXX,XXX）（Font Color of Message3:XXX,XXX,XXX）  
default: 11,59,28

23. M3XPOS:  
メッセージ3開始X座標（左上原点）（Starting X Coordinate of Message3:Upper Left Origin）  
default: 2

24. M3YPOS:  
メッセージ3開始Y座標（左上原点）（Starting Y Coordinate of Message3:Upper Left Origin）  
default: 42

25. AnalysisProgram:  
訪問人数グラフ表示プログラムURL（CGI Program URL to Display Graphs of the Number of Visits）  
このプログラムに特定のクエリーパラメータを渡すことができます。  
（Special query parameters are passed to this program.）  
default: (null)

26. DoAnalysis:  
訪問人数グラフ表示を行う（別途CGIプログラム必要）  
（To Display Graphs of the Number of Visits [You Need Other Program]）  
default: 1

## 訪問人数グラフ表示プログラム連携機能（'LogGraph' coordination）
下記の訪問人数グラフ表示プログラムと連携することができます。
This plugin can coordinate the following program 'LogGraph'.  
[GitHub Repository](https://github.com/denden1025/LogGraph)  
設定項目のAnalysisProgramとDoAnalysisがともに空欄で無いときは、ファンクショナルタグを貼り付けたページを再構築した際に、カウンターimgタグにグラフ表示プログラムへのリンクを張ります。  
カウンターをクリックすると、集計する年月を選択し、アクションとして２つのグラフ種別のリクエストボタンを有するページを提供します。  
この際下記クエリー文字列を付加してグラフ表示アプリを呼び出します。  
MT output 'a' tag for a link to 'LogGraph' program surrounding a 'img' tag to display counter messages when that page was rebuilded. It needs that 'AnalysisProgram' and 'DoAnalysis' are filled in blanks too.

1. act  
disp_grp : 横軸に日、縦軸にその日の訪問人数をエージェント別に積み上げた棒グラフ表示  
　　　　　　（Display color coding bar graph each agent of the number of visits）  
disp_grp_pie : 指定月の総訪問人数をエージェント別パーセンテージで円グラフ表示  
　　　　　　（Display color coding pie graph each agent of the number of visits）

2. page  
ページ番号（半角数値）（Page Number）:   
lodirで指定されるログ保存ディレクトリ配下のページ番号の名前のディレクトリを探し、この中のログを収集する。  
Page number to collect log data

3. year  
西暦年4桁（半角数値）  
Year 4 digit (half-width English numbers)

4. month  
月（半角数値、1または２桁）  
Month (half-width English numbers , 1 or 2 digit)

5. logdir  
ログ保存ディレクトリフルパス（最後の/は不要）。下記固定  
Directory full path to save log data ( Don't need last '/' )  
（mt-directory）/plugins/MultiCounterX/lib/logs  
 or  
（mt-directory）\plugins\MultiCounterX\lib\logs

6. kizititle  
グラフタイトル欄に表示させるタイトル文字列。ブログ記事のタイトル文字列をuriescapeしたもの。  
Graph title string = URI escaped MT entry title

## 出力ログ仕様：タブ区切りテキスト（Log file Specification : tab delimited text）
アクセス秒（time for perl format）  
YYYY年MM月DD日 hh:mm:ss  
ユーザー名（クッキーあれば）（User name cookie）  
性別（Sex）  
REMOTE_HOST  
REMOTE_ADDR  
HTTP_X_FORWARDED_FOR  
HTTP_CACHE_INFO  
HTTP_FROM  
HTTP_CLIENT_IP  
HTTP_SP_HOST  
HTTP_CACHE_CONTROL  
HTTP_X_LOCKING  
HTTP_USER_AGENT  
HTTP_REFERER,HTTP_VIA  
HTTP_FORWARDED  

## コピーライト（Copyright）
Copyright (C) 2017 Tsutomu Igarashi (www.webkoza.com) All Rights Reserved.  

## 許諾（License）
MIT License
