#!/usr/bin/perl -w
use strict;
use warnings;

use strict;
use LWP::UserAgent;

use IO::File;
 use URI::Escape;
use Encode;
use XML::DOM;
use DBI;

use utf8;
#binmode(STDIN, ':encoding(gbk)');
#binmode(STDOUT, ':encoding(gbk)');
#binmode(STDERR, ':encoding(gbk)');

my $dbh;
my $table_name="page_index";
sub decode_url
{
	my $urldecode = uri_unescape($_[0]); #对经过UTF-8编码的URL进行URL解码
	return encode("gbk", decode("utf8", $urldecode));
}

sub encode_url
{
	my $utf8str=utf8::encode(decode("gbk",$_[0])); #进行UTF-8编码，函数直接操作变量
	return uri_escape($utf8str); #对已经经过UTF-8编码的对象进行URL编码
}

sub open_db
{
	my $db = "netspider";
	my $host = "localhost";
	my $user = "root";
	my $pwd = "1234";
	my $connection="dbi:mysql:$db:$host";
	$dbh = DBI->connect($connection,$user,$pwd) or die "failed to connect mysql,$!";


}
sub close_db
{
	$dbh->disconnect();
}
sub fetch_undeal
{
	my @ret ;
	
	my $sql = "select * from $table_name where state=0 and sub_category_count>0";
	my $sth = $dbh->prepare($sql) or die $dbh->errstr;
	my @data;

	$sth->execute() or die "错误: " . $sth->errstr;

	while (@data = $sth->fetchrow()) {
		push @ret,{'index_id'=>$data[0],'title'=>$data[2],'path'=>$data[7],'level'=>$data[8]};
	}
	$sth->finish();
	
	return @ret;
}

sub insert_catagory
{
	my ($parent_id,$row,$path,$level)=@_;

	my $sql = "select * from $table_name where title=? LIMIT 1";
	my $sth = $dbh->prepare($sql) or die $dbh->errstr;
	
	my $state = 0;
	my @data;
	my $rel_id=0;
	$sth->execute($row->{data_ct_title}) or die "错误: " . $sth->errstr;

	while (@data = $sth->fetchrow()) {
		$state=1;
		$rel_id=$data[0];
	}
	$sth->finish();

	if ($row->{child_catagory_count} == 0) {
		$state=1;
	}

	$sql = "insert into $table_name(parent_id,title,url,sub_category_count,page_count,state,level,rel_id) values(?,?,?,?,?,?,?,?)";
	$sth = $dbh->prepare($sql) or die $dbh->errstr;

	$sth->execute($parent_id,$row->{data_ct_title},$row->{catagory_url},$row->{child_catagory_count},$row->{page_count},$state,$level,$rel_id) or die "错误: " . $sth->errstr;
	$sth->finish();

	$sql = "update $table_name set path=? where index_id=?";
	$sth = $dbh->prepare($sql) or die $dbh->errstr;
	
	my $new_id=$dbh->{ q{mysql_insertid}};
	$path = $path."-".sprintf("%07d",$new_id);

	$sth->execute($path,$new_id) or die "错误: " . $sth->errstr;
	$sth->finish();
}

sub update_state
{
	
	my ($id)=@_;
	print "update id:$id\n";
	my $sql = "update $table_name set state=1 where index_id=?";
	my $sth = $dbh->prepare($sql) or die $dbh->errstr;

	$sth->execute($id) or die "错误: " . $sth->errstr;
	$sth->finish();
}

sub get_data{

	my ($title)=@_;
	my $method = 'GET';
	
	my @ns_headers = (
		'Accept' => '*/*',
		#'Accept-Encoding'=> 'gzip, deflate, sdch',
		'User-Agent' => 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.65 Safari/537.36',
		'Accept-Language' => 'zh-CN,zh;q=0.8',
		'Connection'=>'keep-alive',
		'Host'=>'zh.wikipedia.org',
		'X-Requested-With'=>'XMLHttpRequest'
	);
#Accept:*/*
#Accept-Encoding:gzip, deflate, sdch
#Accept-Language:zh-CN,zh;q=0.8
#Connection:keep-alive
#Cookie:GeoIP=CN:Guangzhou:23.1167:113.2500:v4; uls-previous-languages=%5B%22zh-cn%22%5D; mediaWiki.user.sessionId=TBzABhL7BxuG2Jv3UracjDEGCb16ZDXN; TBLkisOn=0
#Host:zh.wikipedia.org
#Referer:http://zh.wikipedia.org/wiki/Category:%E5%8A%A8%E7%89%A9
#User-Agent:Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.65 Safari/537.36
#X-Requested-With:XMLHttpRequest

	#my $url ="http://zh.wikipedia.org/w/index.php?skin=vector&uselang=zh-cn&debug=false&action=ajax&rs=efCategoryTreeAjaxWrapper&rsargs[]=";
	#$url .=$title."&rsargs[]={\"mode\":0,\"hideprefix\":20,\"showcount\":true,\"namespaces\":false}&rsargs[]=json";
	
	my $url = "http://zh.wikipedia.org/w/index.php?skin=vector&uselang=zh-cn&debug=false&action=ajax&rs=efCategoryTreeAjaxWrapper&rsargs%5B%5D=".$title."&rsargs%5B%5D=%7B%22mode%22%3A0%2C%22hideprefix%22%3A20%2C%22showcount%22%3Atrue%2C%22namespaces%22%3Afalse%7D&rsargs%5B%5D=json";
	#print decode_url($url)."\n";

	#my $request = new HTTP::Request $method => $url;

	my $useragent = new LWP::UserAgent;
	my $response = $useragent->get( $url,@ns_headers );
	
	#print $response->content_type."\r\n";

	#open(FOO, '>', "foo.out") or die "Can't redirect STDOUT: $!";
	return '<?xml version="1.0" encoding="utf-8"?><body>'.$response->content.'</body>';
	#close(FOO);
}

sub parse_item{

	my ($span,$toggle_span,$data_ct_title);
	my $hasChildCatagory=0;
	my ($catagory_url,$index_title,$child_index_info);
	my ($child_catagory_count,$page_count,$file_count);
	
	my $catagory={};
	for $span ($_[0]->getChildNodes()) {
		
		if ($span->getNodeName() eq "span"){
			if ($span->getAttribute("class") eq "CategoryTreeEmptyBullet"){
				$hasChildCatagory=0;

			}elsif ($span->getAttribute("class") eq "CategoryTreeBullet") {
				#$toggle_span=$span->getFirstChild();
				#for $toggle_span($span->getChildNodes()) {
				#	if (($toggle_span->getNodeName() eq "span") and ($toggle_span->getAttribute("class") eq "CategoryTreeToggle")) {
				#		$data_ct_title = uri_escape_utf8($toggle_span->getAttribute("data-ct-title"));
				#	}
				#}
				#$catagory->{data_ct_title}=$data_ct_title;
				$hasChildCatagory=1;
			}elsif ($span->getAttribute("dir") eq "ltr") {
				$child_index_info=$span->getAttribute("title");
								
				$child_index_info = uri_escape_utf8($child_index_info); #对已经经过UTF-8编码的对象进行URL编码
				my $tmp =uri_escape_utf8("含有");
				$child_index_info =~ s/$tmp//g;
				$tmp =uri_escape_utf8("个子分类，");
				$child_index_info =~ s/$tmp/\t/g;
				$tmp =uri_escape_utf8("个页面和");
				$child_index_info =~ s/$tmp/\t/g;
				$tmp =uri_escape_utf8("个文件");
				$child_index_info =~ s/$tmp//g;
				$child_index_info =~ s/\%2C//g;
				($child_catagory_count,$page_count,$file_count) = split /\t/,$child_index_info ;

				$catagory->{child_catagory_count}=$child_catagory_count;
				$catagory->{page_count}=$page_count;
				$catagory->{file_count}=$file_count;
			
			}
		}elsif ($span->getNodeName() eq "a"){
			$catagory->{catagory_url}=$span->getAttribute("href");
			$data_ct_title=$span->getAttribute("href");
			$data_ct_title =~ s/\/wiki\/Category://g;
			$catagory->{data_ct_title}=$data_ct_title;
		}
	}
					
	return $catagory;
				
}
sub parse_xml
{
	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parse($_[0]);
	
	my $docElement = $doc->getDocumentElement();
	my $sectiond_iv ;
	
	my $item_div;
	my @catagorys;

	
	for $sectiond_iv($docElement->getChildNodes()) {
		if ($sectiond_iv->getNodeName() eq "div" ) {
			for $item_div ($sectiond_iv->getChildNodes()) {
				if ($item_div->getNodeName eq "div" and $item_div->getAttribute("class") eq "CategoryTreeItem") {
					push (@catagorys, parse_item($item_div));
				}
			}	
		}
	}
	# Avoid memory leaks - cleanup circular references for garbage collection
	$doc->dispose;
	return @catagorys;
}

sub main
{

	open_db();
	while (1) {
	
		my @undeal = fetch_undeal();
		if (!@undeal) {
			last;
		}
		
		while (my $row = pop @undeal) {

			my $page = decode_url(get_data($row->{title}));
			#print ($row->{level}+1)."\n";

			my @child_catagorys = parse_xml(get_data($row->{title}));
			while (my $c = pop @child_catagorys) {
				insert_catagory($row->{index_id},$c, $row->{path},$row->{level}+1);
				
			}
			update_state($row->{index_id});
		}
		}
	close_db();
}

if (@ARGV) {
	$table_name=$ARGV[0];
}

main();

