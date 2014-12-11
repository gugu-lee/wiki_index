#!/usr/bin/perl -w
use strict;
use warnings;

use XML::DOM;

binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
#binmode(STDERR, ':encoding(gbk)');

sub edit_image_path
{
	my $target=$_[0];
	return "media/".substr($target,rindex($target,"\\")+1); 
}

sub edit_type
{
	
	my $fn = $_[0];
	print $fn;
	#return;
	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parsefile($fn);

	my $type = $doc->getElementsByTagName("Types")->item(0);

	my $item = $doc->createElement("Default");
	$item->setAttribute("ContentType","image/png");
	$item->setAttribute("Extension","png");
	$type->appendChild($item);

	$item = $doc->createElement("Default");
	$item->setAttribute("ContentType","image/jpg");
	$item->setAttribute("Extension","jpg");
	$type->appendChild($item);

	$item = $doc->createElement("Default");
	$item->setAttribute("ContentType","image/gif");
	$item->setAttribute("Extension","gif");
	$type->appendChild($item);
	
	$doc->printToFile ("out.xml");
	$doc->dispose;

	#<Default Extension="png" ContentType="image/png"/><Default Extension="gif" ContentType="image/gif"/><Default Extension="jpg" ContentType="image/jpg"/>
}

sub edit_document
{
	#<a:blip r:link="rId11"/>
	#a:blip cstate="print" r:embed="rId11" />
	my $fn = $_[0];
	
	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parsefile($fn);
	
	#my $docElement = $doc->getDocumentElement();
	# print all HREF attributes of all CODEBASE elements
	#wp:inline
	
	my $inline_node = $doc->getElementsByTagName ("wp:inline");
	my $n = $inline_node->getLength;
	
	my $a_blip;
	my $doc_pr;
	my $a_link;
	my $rid;
	my $nv_pr;
	for (my $i = 0; $i < $n; $i++)
	{
		my $node = $inline_node->item ($i);
		$doc_pr = $node->getElementsByTagName ("wp:docPr")->item(0);
		$doc_pr->setAttribute("descr",edit_image_path($doc_pr->getAttribute("descr")));
		$a_link = $doc_pr->getElementsByTagName ("a:hlinkClick");
		if ($a_link->getLength()>0) {
			$doc_pr->removeChild ($a_link->item(0));
		}

		#pic:cNvPr
		$nv_pr=$node->getElementsByTagName ("pic:cNvPr")->item(0);
		#$nv_pr->setAttribute("name",edit_image_path($nv_pr->getAttribute("descr")));
		$nv_pr->removeAttribute("descr");
		$a_link = $nv_pr->getElementsByTagName ("a:hlinkClick");
		if ($a_link->getLength()>0) {
			$nv_pr->removeChild ($a_link->item(0));
		}

		$a_blip=$node->getElementsByTagName ("a:blip")->item(0);
		$rid=$a_blip->getAttribute("r:link");
		$a_blip->setAttribute("r:embed",$rid);
		$a_blip->setAttribute("cstate","print");
		$a_blip->removeAttribute("r:link");
	}


	
	# Print doc file
	my $f = new FileHandle ("file.xml", "w");
	binmode($f, ':encoding(utf8)');
	$doc->print($f);
	$doc->dispose;
}
sub edit_rels
{
	my $fn = $_[0];
	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parsefile($fn);#"E:\\temp\\xdl\\word\\_rels\\document.xml.rels");
	
	#my $docElement = $doc->getDocumentElement();
	# print all HREF attributes of all CODEBASE elements

	 my $nodes = $doc->getElementsByTagName ("Relationship");
	 my $n = $nodes->getLength;
	my $target;
	my $last_char;
	 for (my $i = 0; $i < $n; $i++)
	 {
		 my $node = $nodes->item ($i);
		 #my $type=
		 if ($node->getAttribute("Type")  eq "http://schemas.openxmlformats.org/officeDocument/2006/relationships/image") {
			 $target = $node->getAttribute("Target");
			$target = "media/".substr($target,rindex($target,"\\")+1); 
			print $target ."\n";
			 $node->setAttribute("Target",$target);
			 $node->removeAttribute("TargetMode");
		 }
	 }

	 # Print doc file
	 $doc->printToFile ("out.xml");
$doc->dispose;
}

sub main{
	my $docx_dir=$_[0];
	edit_type($docx_dir . "[Content_Types].xml");
	edit_document($docx_dir . "word\\document.xml");
	edit_rels($docx_dir . "word\\_rels\\document.xml.rels");
}

main();