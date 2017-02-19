# ===================================================================
# ★ MultiCounterX  V1.00 ★
# ===================================================================
package MultiCounterX;
#use strict;
use base 'MT::App';
use GD;
use Jcode;
#use URI::Escape;
use File::Path;
use MT::Entry;
use Encode;
use URI::Escape;
# クラス変数定義
our($im);
our(
	$ifile,$LogFlg,$Lurl,$empty_id,$cpath,$qq,
	$CNTDIR,$IDFILE,$CNTFILE,$YTFILE,$LOGDIR,$LOGFILE,
	$C_cnt,$T_CNT,$Y_CNT,$TO_CNT,$Ninsyou_flag,$Houmon_cnt,$UNLOCK,$EX_LOCK,
	$idnamekey,$datenamekey,$ccntnamekey,$unamekey,$kname,$CType,$Debug,$c_id,
	$M1C,$M2AC,$M2BC,$M3C,$MESSIZE,
	$CallAuth,$FRAMEX,$FRAMEY,$FRAMEBCOLOR,$FRAMEFCOLOR,$M1COL,$M2ACOL,$M2BCOL,$M3COL,
	$M1X,$M1Y,$M2X,$M2Y,$M3X,$M3Y,
	$Keizoku_flag,$Fontfile,$U_id,$Ddir,$Dlog,$Owner,$OwnerPass,$Sep
);

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_) or return;
    $app->add_methods(
    	'clogin'=>\&disp_login1,
    	'selection'=>\&disp_selection,
    	'counter'=>\&main0
    );
    $app->{default_mode} = 'clogin';
	if($^O =~ /MSWin/){
		$Sep = "\\";
	}else{
		$Sep = '/';
	}
	$Ddir = $app->mt_dir . $Sep . join($Sep,('plugins','MultiCounterX','lib','logs','D'));
	$CNTDIR = $app->mt_dir . $Sep . join($Sep,('plugins','MultiCounterX','lib','countfiles')); # このディレクトリだけは事前作成
	$LOGDIR = $app->mt_dir . $Sep . join($Sep,('plugins','MultiCounterX','lib','logs'));
	##
##

#	$app->{requires_login} = 1 unless $app->mode eq 'counter';
#    これだとログインフォームが
#      <form method="post" action="http:/mt.psgi -p 5000">
#      になってしまう。。 /mt/mt.cgi  になって欲しい。。
#      暫定的に必ず次の画面で入力してもらうことにする。
	$app->{requires_login} = 0;
}

#sub script { return 'mcounterx.cgi'; }

#sub cgi_path {
#    my $path = MT->config->CGIPath;
#    $path =~ s!/$!!;
#    $path =~ s!^https?://[^/]*!!;
#    $path .= '/plugins/MultiCounterX';
#    return $path;
#}
#---------------------------------------------
sub disp_selection {
my $app = shift;
my $plugin = MT->component('MultiCounterX');
my $blog_id = $app->param('bid');
$Owner = $plugin->get_config_value('UNAMEVAL', $blog_id);
$OwnerPass = $plugin->get_config_value('OWNERPASS', $blog_id);
my $graphURL = $plugin->get_config_value('AnalysisProgram', $blog_id);
my $font = $plugin->get_config_value('MCFontfile', $blog_id);

if(&ninshou($app->param('id'),$app->param('ps')) eq 'ng'){
	$CType = "text/html";
	$app->send_http_header("$CType");
	$app->print("Authentication Error !! Bad User ID ( ".$app->param('id')." ) or Password ( ".$app->param('ps')." ) <br>\n");
}else{

my $dst = << 'sl1';
<html>
<head>
<SCRIPT LANGUAGE="JavaScript1.1">
function dsp_grph(md,gf){
sl1

$dst .= " var durl='$graphURL';\n";

$dst .= << 'sl10';
 if(gf == 'mix'){
  gfst='disp_grp';
 }else if(gf == 'pie'){
  gfst='disp_grp_pie';
 }
 var paval = document.sel_da.Page.value;
 var yaval = document.sel_da.Year.value;
 var moval = document.sel_da.Month.value;
 var titleval = document.sel_da.Title.value;
 var logdirval = document.sel_da.Logdir.value;
 var ff = document.sel_da.FontFile.value;
  if((paval != '***')&&(yaval != '***')&&(moval != '***')){
  document.location = durl + '?act='+gfst+'&page='+paval+'&year='+yaval+'&month='+moval+'&logdir='+logdirval+'&kizititle='+titleval+'&fontfile='+ff;
 }else{
  alert('正しく選択してください');
 }
  return;
}
</SCRIPT>

</head>
<body>

<p>
<form name="sel_da">
sl10

$dst .= "<input type = \"hidden\" name = \"Page\" value = \"" . $app->param('page') . "\">\n";
$dst .= "<input type = \"hidden\" name = \"FontFile\" value = \"" . $font . "\">\n";
#$dst .= "<input type = \"hidden\" name = \"Title\" value = \"" . $app->param('kizititle') . "\">\n";
my $entry = MT::Entry->load($app->param('page'));
my $tit = $entry->title;
Encode::decode('utf8',"$tit") if !(Encode::is_utf8("$tit"));#フラグがついていないなら（実際は付いていた）
$tit = uri_escape_utf8( $tit );
$dst .= "<input type = \"hidden\" name = \"Title\" value = \"" . $tit . "\">\n";
my @wdt = split(/_/,&get_local_time('exp2'));
my $nowyear = $wdt[0];
my($ii,$jj);
$dst .= "<p>西暦年選択：\n";
$dst .= "<select name =\"Year\">\n";
$dst .= "<option value=\"***\" selected>（選択）</option>\n";
for($ii=0;$ii<=10;$ii++){
	$jj = $nowyear - $ii;
	$dst .="<option value=\"$jj\">$jj年</option>\n";
}

$dst .= << 'sl2';
 </select>　
 月選択：
 <select name ="Month">
  <option value="***" selected>（選択）</option>
  <option value="1">1月</option>
  <option value="2">2月</option>
  <option value="3">3月</option>
  <option value="4">4月</option>
  <option value="5">5月</option>
  <option value="6">6月</option>
  <option value="7">7月</option>
  <option value="8">8月</option>
  <option value="9">9月</option>
  <option value="10">10月</option>
  <option value="11">11月</option>
  <option value="12">12月</option>
 </select>
 </p>
sl2
$dst .= "<input type = \"hidden\" name =\"Logdir\" value = \"$LOGDIR\">\n";

$dst .= << 'sl3';
 <p>
<span><b>●棒・折れ線複合グラフ</b></span>　
<input style="background-color:#f684ba;border-color:#fdf5e6 #fdf5e6 #ffdab9 #ffdab9;" type="button" name="disp_grp2" value="Agent毎の訪問者数グラフ" onclick="dsp_grph('psgi2','mix')"></br>
</p>
 <p>
<span><b>●円グラフ</b></span>　
<input style="background-color:#f684ba;border-color:#fdf5e6 #fdf5e6 #ffdab9 #ffdab9;" type="button" name="disp_grp5" value="Agent毎の訪問者数グラフ" onclick="dsp_grph('psgi2','pie')"></br>
</p>
</form>
</p>

</body>
</html>

sl3
$CType = "text/html";
$app->send_http_header("$CType");
$app->print("$dst");

}

print "\n";

}
#---------------------------------------------
sub main0 {
	my $app = shift;
	$Debug = 0; #0:運用、1:イメージ出力機能テスト、2:テキスト出力
	$Dlog = 1; #1:デバッグ用ログ出力
	#$Fontfile = '/usr/share/fonts/vlgothic/VL-Gothic-Regular.ttf';
	$Fontfile = $app->param('Fontfile');
	if($Debug == 2){
		$CType = "text/html";
	}else{
		$CType = "image/png";
	}
	#&debug_write($app->mt_dir);
	#&debug_write($app->app_dir);
	my $PID = $app->param('blogid'); # ブログID
	# カウンターフォーマットをクエリーから取得
	$FRAMEX = $app->param('XSIZE');
	$FRAMEY = $app->param('YSIZE');
	$FRAMEFCOLOR = $app->param('FILLCOLOR');
	$FRAMEBCOLOR = $app->param('BORDERCOLOR');
	$MESSIZE = $app->param('SIZE');
	$M1 = $app->param('M1');
	$M1COL = $app->param('M1COLOR');
	$M1X = $app->param('M1XPOS');
	$M1Y = $app->param('M1YPOS');
	$M2A = $app->param('M2A');
	$M2ACOL = $app->param('M2ACOLOR');
	$M2B = $app->param('M2B');
	$M2BCOL = $app->param('M2BCOLOR');
	$M2X = $app->param('M2XPOS');
	$M2Y = $app->param('M2YPOS');
	$M3 = $app->param('M3');
	$M3COL = $app->param('M3COLOR');
	$M3X = $app->param('M3XPOS');
	$M3Y = $app->param('M3YPOS');

	$Ninsyou_flag = 1; # 画像表示認証不要

	#$app->{no_print_body} = 1,$app->send_http_header("$CType"),$app->print(&dbg_out("Test1")),return if($Debug == 1);
	$app->send_http_header("$CType"),$app->print(&dbg_out("Test1")),return if($Debug == 1);

	&init_counter($app,$PID,$app->param('SesTimeOut'),$app->param('KanriID')); # カウンター初期化
	&initgd; # GD初期化
	$app->print(&imgout);

}

#-----------------------------------------------
sub disp_error{
my $app = shift;
my $dispst = @_;
$CType = "text/html";
$app->send_http_header("$CType");
$app->print($dispst);
}
#-----------------------------------------------
sub ninshou{
my($uid,$ps)=@_;

if(($uid eq $Owner) and ($ps eq $OwnerPass)){
	return 'ok';
}else{
	return 'ng';
}
}
#-----------------------------------------------
sub disp_login1{
my $app = shift;
#my $qss = $app->uri() . "?__mode=selection"; # psgiだとどうしても「http:/mt.psgi -p 5000?__mode=selection」になってしまう！
my $qss = $app->param('cgi') . "?__mode=selection"; #
my $dst = << 'sl1';
<html>
<head>
<SCRIPT LANGUAGE="JavaScript1.1">
function toauth(){
 var paval = document.sel_da.Page.value;
 var idval = document.sel_da.ID.value;
 var passval = document.sel_da.PWSS.value;
 var titleval = document.sel_da.Title.value;
 var bidval = document.sel_da.BlogID.value;
 //if((idval)&&(passval)){
sl1

$dst .= "  document.location = '$qss' + '&id='+idval+'&ps='+passval+'&page='+paval+'&kizititle='+titleval+'&bid='+bidval;\n";

$dst .= << 'sl11';
 //}else{
 // alert('正しく選択してください');
 //}
  return;
}
</SCRIPT>

</head>
<body>

<p>
<form name="sel_da">
 ID:<input type="text" name ="ID" size="20">　
 PASS:<input type="password" name ="PWSS" size="20">　
sl11

$dst .= "<input type = \"hidden\" name = \"Page\" value = \"" . $app->param('Page') . "\">\n";
$dst .= "<input type = \"hidden\" name = \"Title\" value = \"" . $app->param('kizititle') . "\">\n";
$dst .= "<input type = \"hidden\" name = \"BlogID\" value = \"" . $app->param('bid') . "\">\n";

$dst .= << 'sl2';
<input style="background-color:#f684ba;border-color:#fdf5e6 #fdf5e6 #ffdab9 #ffdab9;" type="button" name="auth" value="GO" onclick="toauth()"></br>
</form>
sl2

$dst .= "</body></html>\n";

$CType = "text/html";
$app->send_http_header("$CType");
$app->print($dst);
print "\n"; #これが無いとうまく動かない。。？
}
#-----------------------------------------------
sub debug_write{
my($st)=@_;
my($fn);
if($Dlog == 1){
	$fn = "$Ddir".$Sep."D".get_local_time('exp2').".txt";
	if(-d $Ddir){
	}else{
		if(!($^O =~ /MSWin/)){
			umask(0000);            # マスクを変更
			mkpath($Ddir,0,0777); #デバッグ出力ディレクトリ無かったら一気に作る
			umask(0022);            # マスクを戻す
		}
	}
	open DD,">>$fn";
	print DD get_local_time('all') . "\t$st\n";
	close DD;
}
}
#-----------------------------------------------
sub init_counter {
my $app = shift;
#カウンター値のセットアップ
#具体的に下記をセットする。
# $T_CNT,$Y_CNT,$TO_CNT,$U_id,$C_cnt,$Keizoku_flag,$Houmon_cnt,$JustAuthed,$empty_id;
my $scid = $_[0]; # セッション管理するコンテンツID
my $SES_TOUT = $_[1]; # セッションタイムアウト時間 秒
my $KanriN = $_[2]; # 管理者ID
my($yyy,$mmm,@r_da,$i,$cname,$dname,$cntname,$un,$uname);
$LogFlg = 1; #ロギングON
$cpath = $app->uri(); #クッキー送信するパス
#$cpath = '/'; #クッキー送信するパス
####カウンタ値等のリセット
$T_CNT = 0; #今日カウンタ
$Y_CNT = 0; #昨日カウンタ
$TO_CNT = 0; #合計カウンタ
$U_id='';
$C_cnt=0; #クッキーカウンタ
$Keizoku_flag = 0;#セッション継続中フラグリセット
$JustAuthed=0; #認証直後フラグリセット
$CallAuth=0; #認証スクリプトからの呼び出しでない
$Houmon_cnt=0; # 訪問中カウンターリセット
#print "$scid",'--',"$U_id<br>\n";
$yyy=(localtime(time))[5];
$mmm=((localtime(time))[4])+1;
if ($yyy<2000){ #Y2K対応
	$yyy = $yyy + 1900;
}else{
	$yyy = $yyy + 2000;
}
#### 初期設定 ####
$EX_LOCK=2; #ｆｌｏｃｋの排他ロックモード
$UNLOCK=8;  #ｆｌｏｃｋの解除
#$meth = $ENV{'REQUEST_METHOD'};
#2014/10/7#
$idnamekey=$scid.'_MCSESX_ID'; # セッション管理用クッキーID名KEY
$datenamekey=$scid.'_MCSESX_DATE'; # セッション管理用クッキー日付名KEY
$ccntnamekey=$scid.'_MCCXCNT'; # セッション管理用クッキーカウンター名KEY
$unamekey=$scid.'_MCXUNAME'; # セッション管理用クッキーユーザー名KEY
$kname=$KanriN; #管理者の名前 クッキーで送ってきた名前がこれと一致するとカウンター及びログに反映しない
#========
#print "$idnamekey",'--',"$unamekey<br>\n";
$IDFILE=$CNTDIR.$Sep.$scid.'_id.txt'; # セッションIDの使用中フラグ保持ファイル名
$CNTFILE=$CNTDIR.$Sep.$scid.'_cnt.txt'; # 訪問中カウンターファイル名
$YTFILE=$CNTDIR.$Sep.$scid.'_yt.txt'; # 昨日今日カウンターファイル名
$LOGDIR=$LOGDIR.$Sep."$scid";
$LOGFILE=$LOGDIR.$Sep.'img' . $yyy . '_' . $mmm . '.txt'; # ログファイルフルパス
$Keizoku_flag=0;#セッション継続中フラグリセット
$yyy=(localtime(time))[5];
$mmm=((localtime(time))[4])+1;
if ($yyy<2000){ #Y2K対応
	$yyy = $yyy + 1900;
}else{
	$yyy = $yyy + 2000;
}
#$U_id=&get_domain;
#========
#使用中IDがタイムアウトしてたらその使用中フラグリセット＆発行日時文字をヌルにする
my $h_cnt = 0;
if(!(-e $IDFILE)){ #IDファイル無ければ作る
	open IDF,">$IDFILE" or die "Cannot Open $IDFILE :$!";   #上書き用
	flock IDF, $EX_LOCK;
	for ($i = 0;$i < 200;$i++){ #
		print IDF "0\n";
	}
	flock IDF, $UNLOCK;
	close IDF;
}
open IDF,"<$IDFILE" or die "Cannot Open $IDFILE :$!";   #読み込み用
flock IDF, $EX_LOCK;
$i=-1;
$empty_id=10000; #空きID番号にダミーセット
while(<IDF>){
	s/\r\n//g;
	s/\n//g;
	$i++;
	$r_da[$i] = $_;
	@line = split(',',$r_da[$i]);
	if ($line[0] == 1){ #ID使用中フラグ立ってたら
		if (($line[1]+$SES_TOUT) < time){ #現在時刻（1970.1.1からの秒数）より過去なら
			$r_da[$i]=0; #読んだ行番号（=ID）の使用中フラグをリセット＆発行日時情報をヌル
			if ($empty_id > $i){
				$empty_id=$i;
			}
		}else{
			$h_cnt++; #訪問中カウンターインクリメント
		}
	}else{ #ID使用中で無かったら
		if ($empty_id > $i){
			$empty_id=$i;
		}
	}
}
flock IDF, $UNLOCK;
close IDF;
open IDF,"+<$IDFILE" or die "Cannot Open $IDFILE :$!";   #読み書き用
flock IDF, $EX_LOCK;
truncate(IDF, 0);
seek(IDF, 0, 0);
for ($i=0;$i<@r_da;$i++){ #書きもどす
	print IDF "$r_da[$i]\n";
}
flock IDF, $UNLOCK;
close IDF;
#訪問中カウンターファイルに出力
if(!(-e $CNTFILE)){ #訪問中カウンタファイル無ければ作る
	open CNTF,">$CNTFILE" or die "Cannot Open $CNTFILE :$!";   #上書き用
	flock CNTF, $EX_LOCK;
	print CNTF "\n";
	flock CNTF, $UNLOCK;
	close CNTF;
}
open CNTF,"+<$CNTFILE" or die "Cannot Open $CNTFILE :$!";   #読み書き用
flock CNTF, $EX_LOCK;
truncate(CNTF, 0);
seek(CNTF, 0, 0);
print CNTF "$h_cnt\n"; #書きもどす
flock CNTF, $UNLOCK;
close CNTF;
$Houmon_cnt = $h_cnt;

######cookieの取り出し
my $cookie=$ENV{'HTTP_COOKIE'};
my @part=split(';',$cookie);
$c_id='';
my $c_da=0;
foreach $w (@part){
#2011/11#
	if ($w =~ /$idnamekey/){
		($cname,$c_id)=split('=',$w); #セッションＩＤ
	}
	if ($w =~ /$datenamekey/){
		($dname,$c_da)=split('=',$w); #セッション登録日
	}
	if ($w =~ /$ccntnamekey/){
		($cntname,$C_cnt)=split('=',$w); #クッキーカウンター
	}
	if ($w =~ /$unamekey/){
		($un,$uname)=split('=',$w); #登録者名
	}
########
	&debug_write("cookies -- $w");
}

if ($c_id eq ''){ #クッキーから取り出したセッションＩＤがヌルなら
	&debug_write("セッションID ヌル");
	&send_cookie($app,$scid,$uname);
	#print "セッション確立0！<br>\n";
	&ytfile_w; #昨日今日カウンターファイル更新
	&log_w; #ログファイルに書き出し
}else{
	#print "A0<br>";
	my $idflag = (split(',',$r_da[$c_id]))[0];
	if (!($idflag)){ #使用中フラグ立ってなかったら
		&debug_write("使用中フラグなし1 T_CNT = $T_CNT");
		&send_cookie($app,$scid,$uname);
		&ytfile_w; #昨日今日カウンターファイル更新
		&log_w; #ログファイルに書き出し
		&debug_write("使用中フラグなし2 T_CNT = $T_CNT");
	}else{ #使用中フラグ立ってたら
		if (($c_da + $SES_TOUT) < time){ #クッキーのセッション情報がタイムアウトなら
			&debug_write("使用中フラグあり＆タイムアウト1 T_CNT = $T_CNT");
			&send_cookie($app,$scid,$uname);
			#print "セッション再確立！<br>\n";
			&ytfile_w; #昨日今日カウンターファイル更新
			&log_w; #ログファイルに書き出し
			&debug_write("使用中フラグあり＆タイムアウト2 T_CNT = $T_CNT");
		}else{ #タイムアウトしてなかったら受信IDと現在日時をファイル出力後クッキー再送信
			if($aflg = [split(',',$r_da[$c_id])]->[2]){ #認証直後フラグ立っていればJustAuthedセット
				if($aflg == 1){
					$JustAuthed = 1;
				}
			}
			my $start = time;
			my $exp_st = get_local_time('exp',$start+60); #有効期限１分
			my $exp_st2 = get_local_time('exp',$start+60*60*24*365*5); #有効期限５年
			&id_out($c_id,$start); #ID情報をファイルへ
			$Keizoku_flag=1;
			$Ninsyou_flag=1; #認証フラグセット
			#######cookie送信処理  MT::Appの機能を使う
			my %ckdt =
			(	'-name'  => "$idnamekey",
				'-value' => "$c_id",
				'-expires' => "$exp_st2"
#				'-path' => "$cpath"
			);
			$app->bake_cookie(%ckdt);
			%ckdt =
			(	'-name'  => "$datenamekey",
				'-value' => "$start",
				'-expires' => "$exp_st2"
#				'-path' => "$cpath"
			);
			$app->bake_cookie(%ckdt);
			%ckdt =
			(	'-name'  => "$ccntnamekey",
				'-value' => "$C_cnt",
				'-expires' => "$exp_st2"
#				'-path' => "$cpath"
			);
			$app->bake_cookie(%ckdt);
		    $app->{no_print_body} = 1 if($Debug != 2);
			$app->send_http_header("$CType");
			###########################################
			$empty_id = 0;#空きIDリセット
			&ytfile_r; #昨日今日カウンターファイルから読み込み
			&debug_write("使用中フラグあり＆NOTタイムアウト T_CNT = $T_CNT c_da = $c_da");
		}
	}
}

####
&debug_write("cid -- $c_id : idflg -- $idflag : cda -- $c_da : ses_tout -- $SES_TOUT : time -- ".time);
&debug_write("idnamekey -- $idnamekey : datenamekey -- $datenamekey");
####

if(!($uname eq '')){
	$U_id=$uname; #ユーザーIDをクッキー送信してきてたらそれをメンバ変数にセット
	my $rw = &getuser($U_id);
	if($rw ne 'AU60'){
		#return 'INIT_10';
		# ユーザーIDに対応するユーザー名NoHitの時の処理
	}else{
		# ユーザーIDに対応するユーザー名Hitの時の処理
	}
}

#========
return 'INIT_OK';
}

#-----------------------------------------------
sub getuser{ # uidをもらって名前を得る
$retval='AU61'; # ヒット無し
return $retval;
}

#-----------------------------------------------
sub send_cookie{
my($app,$scid,$unval) = @_;
my($startt,$exp_st,$exp_st2,%ckdt);
&debug_write("empty_id -- $empty_id");

if (!($empty_id == 10000)){ #空きID有れば

	$startt = time;
	$exp_st = &get_local_time('exp',$startt+60); #有効期限１分
	$exp_st2 = &get_local_time('exp',$startt+60*60*24*365*5); #有効期限５年
	#######cookie送信処理  MT::Appの機能を使う
	%ckdt =
	(	'-name'  => "$idnamekey",
		'-value' => "$empty_id",
		'-expires' => "$exp_st2"
#		'-path' => "$cpath"
	);
	$app->bake_cookie(%ckdt);
	%ckdt =
	(	'-name'  => "$datenamekey",
		'-value' => "$startt",
		'-expires' => "$exp_st2"
#		'-path' => "$cpath"
	);
	$app->bake_cookie(%ckdt);
	$C_cnt++;
	%ckdt =
	(	'-name'  => "$ccntnamekey",
		'-value' => "$C_cnt",
		'-expires' => "$exp_st2"
#		'-path' => "$cpath"
	);
	$app->bake_cookie(%ckdt);
	if($unval){
		%ckdt =
		(	'-name'  => "$unamekey",
			'-value' => "$unval",
			'-expires' => "$exp_st2"
#			'-path' => "$cpath"
		);
	}
	##########################################
	&debug_write("Send1 empty_id -- $empty_id : datenameval -- ".$startt."path -- ".$cpath." : Ninsyou_flag -- $Ninsyou_flag");
	&id_out($empty_id,$startt); #ID情報をファイルへ
	if(-e $CNTFILE){ #訪問中カウンターファイル
		open CNTF,"+<$CNTFILE" or die "Cannot Open $CNTFILE :$!";   #読み書き用
		flock CNTF, $EX_LOCK;
		truncate(CNTF, 0);
		seek(CNTF, 0, 0);
		$Houmon_cnt++;
		print CNTF "$Houmon_cnt\n"; #インクリメントして書きもどす
		flock CNTF, $UNLOCK;
		close CNTF;
	}else{
	}
    $app->{no_print_body} = 1 if($Debug != 2);
	$app->send_http_header("$CType");
}else{ #空きIDなければクッキー送信しない
    $app->{no_print_body} = 1 if($Debug != 2);
	$app->send_http_header("$CType");
	# &html1;
}
&debug_write("Send2 empty_id -- $empty_id : datenameval -- ".$startt."path -- ".$cpath." : Ninsyou_flag -- $Ninsyou_flag");

}

#-----------------------------------------------
sub id_out{ #ID番号とID発行日時をもらってファイルに出力
	my($id_num,$id_date) = @_;
	my(@r_da,$wread,@rdata,$wout);
	if(-e $IDFILE){ #IDファイル

		####IDファイル読み込み
		open IDF,"<$IDFILE" or die "Cannot Open $IDFILE :$!";   #読み込み用
		flock IDF, $EX_LOCK;
		undef $/; #区切り文字を未定義にする
		$wread = <IDF>;
		@rdata = split(/\n/,$wread);
		flock IDF, $UNLOCK;
		close IDF;
		$/ = "\n"; #区切り文字を改行に戻す
		$i=-1;
		for(@rdata){
			s/\r\n//g;
			s/\n//g;
			$i++;
			$r_da[$i]=$_;
			if ($i == $id_num){
				if($CallAuth == 1){ #認証スクリプトからの呼び出しならば直後フラグを付けてレコード保存
					$r_da[$i] = "1,$id_date,1"
				}else{
					$r_da[$i] = "1,$id_date"
				}
				#last;
			}
		}
		&debug_write("IDファイル発見。IDデータセット完了");
		####IDファイルに書き出し
		$wout = join("\n",@r_da);
		open IDF,"+<$IDFILE" or die "Cannot Open $IDFILE :$!";   #読み書き用
		flock IDF, $EX_LOCK;
		truncate(IDF, 0);
		seek(IDF, 0, 0);
		print IDF "$wout\n";
		flock IDF, $UNLOCK;
		close IDF;
		&debug_write("IDファイル更新完了");

	}else{
	}
}
#-----------------------------------------------
sub ytfile_w{
#昨日今日カウンターファイル更新
my ($work,$w,$tday0,$mod0,$tday1,$mod1,$tday2,$mod2);
$T_CNT = 0;
$Y_CNT = 0;
$TO_CNT = 0;
if (-e $YTFILE){
#	open R,"<$YTFILE" or print "Cannot Open $YTFILE :$!"; #読み込み専用
	open R,"<$YTFILE" or die "Cannot Open $YTFILE :$!"; #読み込み専用
	flock R, $EX_LOCK;
	$work=<R>;
	$_=$work;
	s/\r//;
	s/\n//;
	$work=$_;
	($w,$T_CNT)=split(/=/,$work);
	$T_CNT=0 if!($T_CNT);
	$work=<R>;
	$_=$work;
	s/\r//;
	s/\n//;
	$work=$_;
	($w,$Y_CNT)=split(/=/,$work);
	$Y_CNT=0 if!($Y_CNT);
	$work=<R>;
	$_=$work;
	s/\r//;
	s/\n//;
	$work=$_;
	($w,$TO_CNT)=split(/=/,$work);
	$TO_CNT=0 if!($TO_CNT);
	$tday0=(localtime(time))[5]; #今日の年
	$mod0=(localtime((stat(R))[9]))[5];
	$tday1=(localtime(time))[4]; #今日の月－１
	$mod1=(localtime((stat(R))[9]))[4];
	$tday2=(localtime(time))[3]; #今日の日
	$mod2=(localtime((stat(R))[9]))[3];
	flock R, $UNLOCK;
	close R;
  if (!($kname eq $U_id)){
  	$TO_CNT++; #トータルカウント値インクリ
	if (($mod0 == $tday0) and ($mod1 == $tday1) and ($mod2 == $tday2)){ #本日最初でない場合
		$T_CNT++;
	}elsif (($mod0 == $tday0) and ($mod1 == $tday1) and ($mod2 == $tday2-1)){ #更新日が昨日の場合
		$Y_CNT=$T_CNT;
		$T_CNT=1;
	}else{ #更新日が昨日より前
		$Y_CNT=0;
		$T_CNT=1;
	}
  }else{ #管理者アクセスならカウントアップしない
	if (($mod0 == $tday0) and ($mod1 == $tday1) and ($mod2 == $tday2)){ #本日最初でない場合
	}elsif (($mod0 == $tday0) and ($mod1 == $tday1) and ($mod2 == $tday2-1)){ #更新日が昨日の場合
		$Y_CNT=$T_CNT;
		$T_CNT=0;
	}else{ #更新日が昨日より前
		$Y_CNT=0;
		$T_CNT=0;
	}
  }
  &debug_write("YTファイル発見。YTデータセット完了");
}else{ #昨日今日カウンタファイル無ければ作る
	open YTF,">$YTFILE" or die "Cannot Open $YTFILE :$!";   #上書き用
	flock YTF, $EX_LOCK;
	print YTF "\n";
	flock YTF, $UNLOCK;
	close YTF;
	$T_CNT = 1;
	$TO_CNT = 1;
}
open W,"+<$YTFILE" or die "Cannot Open $YTFILE :$!"; #読み書き用
flock W, $EX_LOCK;
truncate(W, 0);
seek(W, 0, 0);
print W "T=$T_CNT\n";
print W "Y=$Y_CNT\n";
print W "TO=$TO_CNT\n";
flock W, $UNLOCK;
close W;
&debug_write("YTファイル更新完了");

}
#-----------------------------------------------
sub ytfile_r{
#昨日今日カウンターファイルから読み込み
my ($work,$w,$tday0,$mod0,$tday1,$mod1,$tday2,$mod2);
if (-e $YTFILE){
	open R,"<$YTFILE" or die "Cannot Open $YTFILE :$!"; #読み込み専用
	flock R, $EX_LOCK;
	$work=<R>;
	$_=$work;
	s/\r//;
	s/\n//;
	$work=$_;
	($w,$T_CNT)=split(/=/,$work);
	$T_CNT=0 if!($T_CNT);
	$work=<R>;
	$_=$work;
	s/\r//;
	s/\n//;
	$work=$_;
	($w,$Y_CNT)=split(/=/,$work);
	$Y_CNT=0 if!($Y_CNT);
	$work=<R>;
	$_=$work;
	s/\r//;
	s/\n//;
	$work=$_;
	($w,$TO_CNT)=split(/=/,$work);
	$TO_CNT=0 if!($TO_CNT);
	$tday0=(localtime(time))[5]; #今日の年
	$mod0=(localtime((stat(R))[9]))[5];
	$tday1=(localtime(time))[4]; #今日の月－１
	$mod1=(localtime((stat(R))[9]))[4];
	$tday2=(localtime(time))[3]; #今日の日
	$mod2=(localtime((stat(R))[9]))[3];
	flock R, $UNLOCK;
	close R;
	if (($mod0 == $tday0) and ($mod1 == $tday1) and ($mod2 == $tday2)){ #本日最初でない場合
		#何もしない
		&debug_write("本日最初でない");
	}elsif (($mod0 == $tday0) and ($mod1 == $tday1) and ($mod2 == $tday2-1)){ #更新日が昨日の場合
		$Y_CNT=$T_CNT;
		$T_CNT=0;
		&debug_write("更新日が昨日");
	}else{ #更新日が昨日より前
		$Y_CNT=0;
		$T_CNT=0;
		&debug_write("更新日が昨日より前");
	}
}

}
#-----------------------------------------------
sub log_w{

my($wlog);
if (!($kname eq $U_id) and ($LogFlg)){ #管理者でなくて且つロギングフラグONなら

##区切り文字をタブに変更 h121006 ##
$wlog = join("\t" , ($ENV{'REMOTE_HOST'},$ENV{'REMOTE_ADDR'},$ENV{'HTTP_X_FORWARDED_FOR'},$ENV{'HTTP_CACHE_INFO'},$ENV{'HTTP_FROM'},$ENV{'HTTP_CLIENT_IP'},$ENV{'HTTP_SP_HOST'},$ENV{'HTTP_CACHE_CONTROL'},$ENV{'HTTP_X_LOCKING'},$ENV{'HTTP_USER_AGENT'},$ENV{'HTTP_REFERER'},$ENV{'HTTP_VIA'},$ENV{'HTTP_FORWARDED'}));
if(-d $LOGDIR){
}else{
	&debug_write("ログディレクトリ無し。$LOGDIR");
	umask(0000);            # マスクを変更
	mkpath($LOGDIR,0,0777); #ログディレクトリ無かったら一気に作る
	&debug_write("ログディレクトリ作成完了。$LOGDIR");
}
umask(0022);            # マスクを戻す
if (-e $LOGFILE){
	open W,">>$LOGFILE" or die "Cannot Open $LOGFILE :$!"; #追加書き込み
	flock W, $EX_LOCK;
}else{
	open W,">$LOGFILE" or die "Cannot Open $LOGFILE :$!"; #
	flock W, $EX_LOCK;
	truncate(W, 0);
	seek(W, 0, 0);
}
#print W get_local_time('all'),",$uname,$ENV{'REMOTE_HOST'},$ENV{'REMOTE_USER'},$ENV{'REMOTE_ADDR'},$ENV{'HTTP_USER_AGEN#T'},$ENV{'HTTP_REFERER'},$ENV{'AUTH_TYPE'},$ENV{'LOGON_USER'}\n";
##区切り文字をタブに変更 h121006 ##
#print W time,"\t",get_local_time('all'),"\t$DMAIN\t",'',"\t$wlog\n";
print W time,"\t",get_local_time('all'),"\t$U_id\t",'',"\t$wlog\n";
flock W, $UNLOCK;
close W;

&debug_write("指定管理者ID:$kname クッキーUID:$U_id ログフラグ:$LogFlg");

}

}
#-----------------------------------------------
sub get_local_time{
	my ($type,$ysec) = @_;
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$wareki_nen,$seireki_nen,
	@month,$month,$tuki,@tuki,@youbi,$youbi,$current_time,$seireki,$wareki);
	if ($type eq 'exp'){
		($sec,$min,$hour,$mday,$mon,$year,$wday) = (gmtime($ysec))[0,1,2,3,4,5,6];
		$year_new = (gmtime($ysec))[5];
	}else{
		($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime)[0,1,2,3,4,5,6];
	}
	if ($year<2000){ #Y2K対応
		$seireki_nen = $year + 1900;
	}else{
		$seireki_nen = $year + 2000;
	}
	$wareki_nen = "平成" . ($year - 88);
	if ($type eq 'exp'){
		@month = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
		$month = $month[$mon];
	}else{
		$month = $mon + 1;
	}
	if ($type eq 'exp'){
		@youbi = ("Sun","Mon","Tue","Wed","Thr","Fri","Sat");
	}else{
		@youbi = ("日","月","火","水","木","金","土");
	}
	$youbi = $youbi[$wday];
	$current_time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
	$seireki = "$seireki_nen" . "年" . "$month" . "月" . "$mday" . "日" ."($youbi)";
	$wareki = "$wareki_nen" . "年" . "$month" . "月" . "$mday" . "日" . "($youbi)";
	if ($type eq "ct"){
		return $current_time;
	}
	elsif ($type eq "w"){
		return $wareki;
	}
	elsif ($type eq "all"){
		return $seireki.' '.$current_time;
	}
	elsif ($type eq "exp"){
		return $youbi.','.' '.$mday.'-'.$month.'-'.$seireki_nen.' '.$current_time.' GMT';
	}
	elsif ($type eq "exp2"){
		return $seireki_nen.'_'.$month.'_'.$mday;
	}
	else {
		return $seireki;
	}
}
#-----------------------------------------------
#sub get_domain{
#my($w,@ww);
#$w = $ENV{'REMOTE_ADDR'};
#$w = `nslookup "$w"`;
#@ww = split(/Name:/,$w);
#return (split(/Address:/,$ww[1]))[0];
#}
#---------------------------------------------
sub dbg_out{ #GD初期化前のデバッグ出力
	my($text)=@_;
	my($bodercolor,$fillcolor,$textcol);
	#print "Content-type: image/png\n\n";
	$im = new GD::Image(400,51) || die;
	$bodercolor = $im->colorAllocate(0,0,0);
	$fillcolor = $im->colorAllocate(0,0,0);
	$textcol = $im->colorAllocate(255,0,0);
	$im->fill(0,0,$fillcolor);
	$im->rectangle(0,0,399,50,$bodercolor);
	&outst(30,30,"$text",$textcol,18);
	binmode STDOUT;
	#print $im->png;
	return $im->png;
}
#---------------------------------------------
sub initgd{
my($black,$bcolor,$fcolor,@w);
# create a new image
if($Debug==1){
	$im = new GD::Image($FRAMEX+350,$FRAMEY+350) || die;
}else{
	$im = new GD::Image($FRAMEX,$FRAMEY) || die;
}
# allocate some colors
$black = $im->colorAllocate(0,0,0);
@w = split(/,/,$FRAMEBCOLOR);
$bcolor = $im->colorAllocate($w[0],$w[1],$w[2]);
@w = split(/,/,$FRAMEFCOLOR);
$fcolor = $im->colorAllocate($w[0],$w[1],$w[2]);
@w = split(',',$M1COL);
$M1C = $im->colorAllocate($w[0],$w[1],$w[2]);
@w = split(/,/,$M2ACOL);
$M2AC = $im->colorAllocate($w[0],$w[1],$w[2]);
@w = split(/,/,$M2BCOL);
$M2BC = $im->colorAllocate($w[0],$w[1],$w[2]);
@w = split(/,/,$M3COL);
$M3C = $im->colorAllocate($w[0],$w[1],$w[2]);
# make the background transparent and interlaced
#$im->transparent($fcolor);
#$im->interlaced('true');
$im->fill(0,0,$fcolor);
$im->rectangle(0,0,$FRAMEX - 1,$FRAMEY - 1,$bcolor);

	&debug_write("Debug -- $Debug : FRAMEX -- $FRAMEX : FRAMEY -- $FRAMEY");
	&debug_write("FRAMEBCOLOR -- $FRAMEBCOLOR : FRAMEFCOLOR -- $FRAMEFCOLOR : M1COL -- $M1COL");
	&debug_write("M2ACOL -- $M2ACOL : M2BCOL -- $M2BCOL : M3COL -- $M3COL");
}
#---------------------------------------------
sub imgout{ # カウンターイメージ出力
my ($text1,$text2,$x,$y,$i,$text3);
$x = $M1X;
$y = $M1Y;
$Houmon_cnt = $Houmon_cnt-1; #自分を除く
&outst($x,$y,'Too Many People!',$M1C,$MESSIZE) , return if($empty_id == 10000);
$text1 = sprintf("$M1",$T_CNT,$Y_CNT,$TO_CNT);
&outst($x,$y,$text1,$M1C,$MESSIZE);
$x = $M2X;
$y = $M2Y;
if (($C_cnt <= 1) and ($Keizoku_flag == 0)){ #初訪問者かクッキー未対応ブラウザ
	$text2 = 'Welcome!';
	&outst($x,$y,$text2,$M2AC,$MESSIZE);
}elsif (($C_cnt > 1) and ($Keizoku_flag == 0)){ #再訪&セッション確立
	$text2 = sprintf("$M2A",$C_cnt);
	&outst($x,$y,$text2,$M2AC,$MESSIZE);
}elsif ($Keizoku_flag == 1){ #セッション継続中
	$text2 = sprintf("$M2B",$C_cnt);
	&outst($x,$y,$text2,$M2BC,$MESSIZE);
}
$text3 = sprintf("$M3",$Houmon_cnt);
$x = $M3X;
$y = $M3Y;
&outst($x,$y,$text3,$M3C,$MESSIZE);
if($Debug==1){
	$i = -15;
	$i += 15;
	&outst($M1X,$M3Y+20+$i,"XXX",$M3C,$MESSIZE); # デバッグ出力
}
binmode STDOUT;
#print $im->png;
return $im->png;
}
#---------------------------------------------
sub outst{
my($x,$y,$text,$col,$textsize) = @_;
#  $im->stringFT($str_color,         # 色
#  $font_file, $size,  # フォント・フォントサイズ
#  $angle*($PI/180),   # 回転角度
#  $str_x, $str_y,     # X・Y 座標
#  $str);              # 表示文字列
	#$im->string(gdGiantFont,$x,$y,$text,$col);
	#$im->string(gdLargeFont,$x,$y,$text,$col);
	#$im->string(gdMediumBoldFont,$x,$y,$text,$col);
	$text = Jcode::jcode("$text")->utf8;
	$im->stringFT($col,$Fontfile,$textsize,0,$x,$y,$text);
}
#---------------------------------------------

1; #
