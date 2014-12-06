package wiki.index;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Node;
import org.jsoup.nodes.TextNode;
import org.jsoup.nodes.Element;
import java.util.List;
import java.util.ArrayList;

/*
 enum SegmentType
 {
 NORMAL(0),
 BOLD(1),UNDERLINE(2),ITALIC(4);
 private SegmentType(int index) {

 this.index = index;
 }
 private int index;

 public int getValue()
 {
 return index;
 }
 }
 */
class Segment {
	public static final int STYLE_NORMAL = 0;
	public static final int STYLE_BOLD = 1;
	public static final int STYLE_ITALIC = 2;
	public static final int STYLE_UNDERLINE = 4;

	// private SegmentType type;
	private String text;
	private int style;

	public Segment() {
	}

	public Segment(int style, String text) {
		setStyle(style);
		setText(text);
	}

	public int getStyle() {
		return style;
	}

	public void setStyle(int style) {
		this.style = style;
	}

	/*
	 * public SegmentType getType() { return type; } public void
	 * setType(SegmentType type) { this.type = type; }
	 */
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
}

class Paragraph extends ArrayList<Segment> {

}

class Body extends ArrayList<Paragraph> {
	public String toString()
	{
		String value="";
		for (Paragraph p:this){
			for (Segment s:p)
			{
				if (s.getStyle() == Segment.STYLE_NORMAL){
					value +=s.getText();
				}else
				{
					String prefix="";
					String postfix="";
					if ((s.getStyle()|Segment.STYLE_BOLD) == s.getStyle()){
						prefix +="<b>";
						postfix = "</b>"+postfix;
					}
					if ((s.getStyle()|Segment.STYLE_ITALIC) == s.getStyle()){
						prefix +="<i>";
						postfix = "</i>"+postfix;
					}
					if ((s.getStyle()|Segment.STYLE_UNDERLINE) == s.getStyle()){
						prefix +="<u>";
						postfix = "</u>"+postfix;
					}
					value += prefix + s.getText() + postfix;
				}
			}
			value +="\n";
		}
		return value;
		
	}
}

public class HtmlParser {

	public static Body parser(String html)
	{
		Document doc = Jsoup.parseBodyFragment(html);
		Element body = doc.body();
		List<Node> nodes = body.childNodes();
		Element e;
		Body outBody = new Body();
		for (Node n_p : nodes) {
			Paragraph p = new Paragraph();
			List<Node> n_ss = n_p.childNodes();
			for (Node n_s : n_ss) {
				int styleValue = 0;
				String text = null;

				if (n_s.nodeName().equals("#text")) {
					
					text = ((TextNode) n_s).text();
				} else {
					e = (Element) n_s;
					text = e.ownText();
					if (n_s.nodeName().equals("span")) {
						String styleText = n_s.attr("style");
						if (styleText.length() == 0) {
							styleValue |= Segment.STYLE_NORMAL;
						} else {
							if (styleText.indexOf("text-decoration: underline") > -1) {
								styleValue |= Segment.STYLE_UNDERLINE;
							}
						}
					} else if (n_s.nodeName().equals("em")) {
						styleValue |= Segment.STYLE_ITALIC;
					} else if (n_s.nodeName().equals("strong")) {
						styleValue |= Segment.STYLE_BOLD;
					}
				}
				p.add(new Segment(styleValue, text.replace((char)160, ' ')));
			}
			outBody.add(p);

		}
		return outBody;
	}
	public static void main(String[] args) {
		String html ="";
		//html + = "<P>Dr. Jack Todd is <strong> very interested </strong>in clean water.<span style=\"text-decoration: underline;\">¡¡1</span><span style=\"text-decoration: underline;\">¡¡</span>£¬ so it''s natural that he is the developer of a small and affordable system (ÏµÍ³) to clean wastewater. His &ldquo;Living Machine&rdquo; can clean wastewater in your home or in your business.</p>";
		//html += "<p><span style=\"text-decoration: underline;\">&nbsp;&nbsp;&nbsp; </span><span style=\"text-decoration: underline;\">¡¡2</span><span style=\"text-decoration: underline;\">¡¡</span>.The wastewater goes into a big plastic tank where bacteria (Ï¸¾ú)start to break down the waste. A few days later after it is dealt with£¬ the water is brought into a greenhouse filled with plants and fish. With the help of sunlight£¬ the plants and animals remove more chemicals from the water£¬ making it cleaner£¬ then the water can be reused for washing or bathing.<span style=\"text-decoration: underline;\">¡¡3</span><span style=\"text-decoration: underline;\">¡¡</span>£¬but the water is clean enough for watering the flowing£¬ washing the dog£¬ or even for bathing or swimming. ¡¶¡·&lt; &gt;</p>";
		//html += "<p>&nbsp;</p>";
		html += "<p>&nbsp;&lt;</p>";

		
	}
}
