package MultiCounterX::Tags;
use strict;
use URI::Escape;
use utf8; # 以後全ての文字がutf8（フラグ付き）となる
use Encode;
sub _hdlr_counter_output {
    my ($ctx, $args) = @_;
    my $blog_id = 'blog:' . $ctx->stash('blog_id');
    my $plugin = MT->component('MultiCounterX');

    my $MCFontfile = $plugin->get_config_value('MCFontfile', $blog_id);
    my $CGIURL = $plugin->get_config_value('MCCGIURL', $blog_id);
    my $SESTIMEOUT = $plugin->get_config_value('SESTIMEOUT', $blog_id);
    my $UNAMEVAL = $plugin->get_config_value('UNAMEVAL', $blog_id);
    my $XSIZE = $plugin->get_config_value('XSIZE', $blog_id);
    my $YSIZE = $plugin->get_config_value('YSIZE', $blog_id);
    my $FILLCOLOR = $plugin->get_config_value('FILLCOLOR', $blog_id);
    my $BORDERCOLOR = $plugin->get_config_value('BORDERCOLOR', $blog_id);
    my $SIZE = $plugin->get_config_value('SIZE', $blog_id);
    my $M1 = $plugin->get_config_value('M1', $blog_id);
    $M1 = uri_escape_utf8( $M1 );
    my $M1COLOR = $plugin->get_config_value('M1COLOR', $blog_id);
    my $M1XPOS = $plugin->get_config_value('M1XPOS', $blog_id);
    my $M1YPOS = $plugin->get_config_value('M1YPOS', $blog_id);
    my $M2A = $plugin->get_config_value('M2A', $blog_id);
    $M2A = uri_escape_utf8( $M2A );
    my $M2ACOLOR = $plugin->get_config_value('M2ACOLOR', $blog_id);
    my $M2B = $plugin->get_config_value('M2B', $blog_id);
    Encode::decode('utf8',"$M2B") if !(Encode::is_utf8("$M2B"));#フラグがついていないなら（実際は付いていた）
    my $M2B = uri_escape_utf8( $M2B );
    # アンエスケープするには下記
   	#   my $MM2B = uri_unescape( $M2B );
    #   $MM2B = Encode::decode('utf8', $MM2B);#utfフラグをon
    my $M2BCOLOR = $plugin->get_config_value('M2BCOLOR', $blog_id);
    my $M2XPOS = $plugin->get_config_value('M2XPOS', $blog_id);
    my $M2YPOS = $plugin->get_config_value('M2YPOS', $blog_id);
    my $M3 = $plugin->get_config_value('M3', $blog_id);
    $M3 = uri_escape_utf8( $M3 ); 
    my $M3COLOR = $plugin->get_config_value('M3COLOR', $blog_id);
    my $M3XPOS = $plugin->get_config_value('M3XPOS', $blog_id);
    my $M3YPOS = $plugin->get_config_value('M3YPOS', $blog_id);

    my $entry = $ctx->stash('entry')
        || $ctx->error(MT->translate('You used an tag outside of the proper context.'));

    my $kiziID = $entry->id() || return;
    my $kiziTitle = $entry->title() || return;
#    Encode::decode('utf8',"$kiziTitle") if !(Encode::is_utf8("$kiziTitle"));#フラグがついていないなら（実際は付いていた）
	my $retst = "__mode=counter&blogid=$kiziID&SesTimeOut=$SESTIMEOUT&KanriID=$UNAMEVAL&Fontfile=$MCFontfile&";
	$retst .= "XSIZE=$XSIZE&YSIZE=$YSIZE&FILLCOLOR=$FILLCOLOR&BORDERCOLOR=$BORDERCOLOR&SIZE=$SIZE&";
	$retst .= "M1=$M1&M1COLOR=$M1COLOR&M1XPOS=$M1XPOS&M1YPOS=$M1YPOS&M2A=$M2A&M2ACOLOR=$M2ACOLOR&";
	$retst .= "M2B=$M2B&M2BCOLOR=$M2BCOLOR&M2XPOS=$M2XPOS&M2YPOS=$M2YPOS&M3=$M3&M3COLOR=$M3COLOR&M3XPOS=$M3XPOS&M3YPOS=$M3YPOS";
	$retst .= "&DoAnal=" . $plugin->get_config_value('DoAnalysis', $blog_id);
	my $retst2 = "__mode=clogin&Page=$kiziID&cgi=$CGIURL&bid=$blog_id";
	if(($plugin->get_config_value('DoAnalysis', $blog_id) eq 'do') and ($plugin->get_config_value('AnalysisProgram', $blog_id) ne '')){
	    return '<a href="'.$CGIURL.'?'.$retst2.'"><img src = "' . $CGIURL .'?' . $retst .'"/></a>';
	}else{
	    return '<img src = "' . $CGIURL .'?' . $retst .'"/>';
	}
}

1;
