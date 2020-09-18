package com.of.employee;

import java.util.List;
import java.util.Map;

import com.of.publicAddr.PublicAddr;

public interface EmployeeService {	
	public List<Employee> listEmployee(Map<String, Object> map);
	public List<Employee> listEmployeeLeave(Map<String, Object> map);
	
	public int dataCount(Map<String, Object> map);
	public int dataCountLeave(Map<String, Object> map);
	
	public Employee loginEmployee(String empNo);
	
	public void insertEmployee(Employee dto) throws Exception;
	public void insertPublicAddr(PublicAddr dto) throws Exception;
	
	public void updateEmployee(Employee dto) throws Exception;
	public void updateLastLogin(String empNo) throws Exception;
	
	public Employee readEmployee(int employeeNum);
	public Employee readEmployee(String empNo);
	
	public List<Employee> listEmpOrg(Map<String, Object> map);
	public List<String> listDept();
}
