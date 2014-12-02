#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use URI::Escape;
use Encode;
use utf8;
my $dbh;
my $fh;

my $table_name="page_index";
my $pre_row = undef;
sub decode_url
{
	my $urldecode = uri_unescape($_[0]); 
	return encode("gbk", decode("utf8", $urldecode));
}

sub encode_url
{
	my $utf8str=utf8::encode(decode("gbk",$_[0])); 
	return uri_escape($utf8str); 
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
	my ($offset,$page_size) = @_;
	my @ret ;
	#where parent_id=?
	my $sql = "select * from $table_name  order by path LIMIT $page_size offset $offset";
	print "$sql\n";
	my $sth = $dbh->prepare($sql) or die $dbh->errstr;
	my @data;

	$sth->execute() or die "error:" . $sth->errstr;

	while (@data = $sth->fetchrow()) {
		push @ret,{'index_id'=>$data[0],'title'=>$data[2],'sub_category_count'=>$data[4],'page_count'=>$data[5],'path'=>$data[7],'level'=>$data[8],'rel_id'=>$data[9]};
	}
	$sth->finish();
	
	return @ret;
}


sub output
{
	my ($offset,$page_size)=@_;
	my @undeal = fetch_undeal($offset,$page_size);

	if (!@undeal) {
		return 0;
	}
	for my $row (@undeal) {

		my $title = decode_url($row->{title});
		
		if ($row->{sub_category_count}>0 and $row->{rel_id}==0) {
			print $fh "<ul><li><input type=\"checkbox\" id=\"item-".$row->{index_id}."\" checked=\"checked\" /><label for=\"item-".$row->{index_id}."\">".$title."(sub-catagory:".$row->{sub_category_count}.",page:".$row->{page_count}.")</label>";
		}else{
			print $fh "<li><a href=\"./\">".$title."(sub-catagory:".$row->{sub_category_count}.",page:".$row->{page_count}.")</a></li>";
		}
		if ($pre_row) {
			if ($row->{level}<$pre_row->{level}) {
				print $fh "</ul>\n";
			}
		}
		$pre_row=$row;
		#
		
		#my $level = $row->{level};
		#print $fh "<span style=\"padding-left:";
		#print $fh $level*20;

		#while ($level-- >0) {
			#print "--";
		#}
		#print $fh "px\">";
		#print $fh $title;
		#print $fh "(sub-catagory:".$row->{sub_category_count}.",page:".$row->{page_count}.")</span><br>\n";		
	}
	return 1;
}

sub main
{
	open_db();
	open($fh, '>', "Index_C1.html") or die "Can't redirect STDOUT: $!";
	print $fh "<!DOCTYPE HTML><HTML lang=\"zh_CN\"><HEAD><meta charset=\"GBK\"> <link rel=\"stylesheet\"	href=\"tree.css\"/><TITLE> Index </TITLE> </HEAD> <BODY> <p><font color=\"blue\" size=\"4\">\n<div class=\"css-treeview\">\n<ul>";
	
	my $i=0;
	my $page_size=10000;

	while (1) {
		if (!output($i++ * $page_size,$page_size)){
			last;
		}
	}
	
	print $fh "</ul>\n</div>\n</font></P> </BODY></HTML>\n";
	close($fh);
	
	close_db();
}
if (@ARGV) {
	$table_name=$ARGV[0];
}
main();
#print sprintf("%05d", 5)."\n";
#print sprintf("%05d", 35)."\n";