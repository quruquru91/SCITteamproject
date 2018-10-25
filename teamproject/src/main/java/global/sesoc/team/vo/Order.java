package global.sesoc.team.vo;

public class Order {
	private String productname;
	private int unitprice;
	private int quantity;
	
	public Order() {
		super();
	}
	
	public Order(String productname, int unitprice, int quantity) {
		super();
		this.productname = productname;
		this.unitprice = unitprice;
		this.quantity = quantity;
	}
	
	public String getProductname() {
		return productname;
	}
	public void setProductname(String productname) {
		this.productname = productname;
	}
	public int getUnitprice() {
		return unitprice;
	}
	public void setUnitprice(int unitprice) {
		this.unitprice = unitprice;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	@Override
	public String toString() {
		return "Order [productname=" + productname + ", unitprice=" + unitprice + ", quantity=" + quantity + "]";
	}
}
