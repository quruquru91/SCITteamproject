package global.sesoc.team.vo;

public class Employee {
	private String companyno;
	private String empid;
	private String emppassword;
	private String empname;
	private String empdept;
	private String empauthorization;
	private String empphone;
	
	public Employee() {
		super();
	}

	public Employee(String companyno, String empid, String emppassword, String empname, String empdept,
			String empauthorization, String empphone) {
		super();
		this.companyno = companyno;
		this.empid = empid;
		this.emppassword = emppassword;
		this.empname = empname;
		this.empdept = empdept;
		this.empauthorization = empauthorization;
		this.empphone = empphone;
	}

	public String getCompanyno() {
		return companyno;
	}

	public void setCompanyno(String companyno) {
		this.companyno = companyno;
	}

	public String getEmpid() {
		return empid;
	}

	public void setEmpid(String empid) {
		this.empid = empid;
	}

	public String getEmppassword() {
		return emppassword;
	}

	public void setEmppassword(String emppassword) {
		this.emppassword = emppassword;
	}

	public String getEmpname() {
		return empname;
	}

	public void setEmpname(String empname) {
		this.empname = empname;
	}

	public String getEmpdept() {
		return empdept;
	}

	public void setEmpdept(String empdept) {
		this.empdept = empdept;
	}

	public String getEmpauthorization() {
		return empauthorization;
	}

	public void setEmpauthorization(String empauthorization) {
		this.empauthorization = empauthorization;
	}

	public String getEmpphone() {
		return empphone;
	}

	public void setEmpphone(String empphone) {
		this.empphone = empphone;
	}

	@Override
	public String toString() {
		return "Employee [companyno=" + companyno + ", empid=" + empid + ", emppassword=" + emppassword + ", empname="
				+ empname + ", empdept=" + empdept + ", empauthorization=" + empauthorization + ", empphone=" + empphone
				+ "]";
	}
}
