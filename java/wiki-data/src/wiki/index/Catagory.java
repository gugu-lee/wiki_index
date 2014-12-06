package wiki.index;

import java.util.ArrayDeque;

public class Catagory
{
	private int indexId;
	private String title;
	private String path;
	private String disabled;
	private String parentId;
	private int subCatagoryCount;
	private int pageCount;
	private ArrayDeque<Catagory> subCatagory;
	
	public ArrayDeque<Catagory> getSubCatagory() {
		return subCatagory;
	}
	public void setSubCatagory(ArrayDeque<Catagory> subCatagory) {
		this.subCatagory = subCatagory;
	}
	public int getIndexId() {
		return indexId;
	}
	public void setIndexId(int indexId) {
		this.indexId = indexId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getDisabled() {
		return disabled;
	}
	public void setDisabled(String disabled) {
		this.disabled = disabled;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public int getSubCatagoryCount() {
		return subCatagoryCount;
	}
	public void setSubCatagoryCount(int subCatagoryCount) {
		this.subCatagoryCount = subCatagoryCount;
	}
	public int getPageCount() {
		return pageCount;
	}
	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}
	
	
}
