package global.sesoc.team.vo;

public class Item {
	private int recipeNo;
	private int itemNo;
	private String itemCategory;
	private String itemName;
	private int itemCount;
	private int itemPrice;
	
	public Item() {
		super();
	}

	public Item(int recipeNo, int itemNo, String itemCategory, String itemName, int itemCount, int itemPrice) {
		super();
		this.recipeNo = recipeNo;
		this.itemNo = itemNo;
		this.itemCategory = itemCategory;
		this.itemName = itemName;
		this.itemCount = itemCount;
		this.itemPrice = itemPrice;
	}

	public int getRecipeNo() {
		return recipeNo;
	}

	public void setRecipeNo(int recipeNo) {
		this.recipeNo = recipeNo;
	}

	public int getItemNo() {
		return itemNo;
	}

	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	public String getItemCategory() {
		return itemCategory;
	}

	public void setItemCategory(String itemCategory) {
		this.itemCategory = itemCategory;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public int getItemCount() {
		return itemCount;
	}

	public void setItemCount(int itemCount) {
		this.itemCount = itemCount;
	}

	public int getItemPrice() {
		return itemPrice;
	}

	public void setItemPrice(int itemPrice) {
		this.itemPrice = itemPrice;
	}

	@Override
	public String toString() {
		return "Item [recipeNo=" + recipeNo + ", itemNo=" + itemNo + ", itemCategory=" + itemCategory + ", itemName="
				+ itemName + ", itemCount=" + itemCount + ", itemPrice=" + itemPrice + "]";
	}
	
}
