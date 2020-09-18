package com.of.employee;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.dao.CommonDAO;
import com.of.publicAddr.PublicAddr;

@Service("employee.employeeService")
public class EmployeeServiceImpl implements EmployeeService {

	@Autowired
	private CommonDAO dao;

	// ---------------------------------------------------------------------------------------------
	// 로그인
	@Override
	public Employee loginEmployee(String empNo) {

		Employee dto = null;

		try {
			dto = dao.selectOne("employee.loginEmployee", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return dto;
	}

	// ---------------------------------------------------------------------------------------------
	// 사원 리스트
	@Override
	public List<Employee> listEmployee(Map<String, Object> map) {

		List<Employee> list = null;

		try {
			list = dao.selectList("employee.listEmployee", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
	
	@Override
	public List<Employee> listEmployeeLeave(Map<String, Object> map) {

		List<Employee> list = null;

		try {
			list = dao.selectList("employee.listEmployeeLeave", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// ---------------------------------------------------------------------------------------------
	// 데이터 개수
	@Override
	public int dataCount(Map<String, Object> map) {

		int result = 0;

		try {
			result = dao.selectOne("employee.dataCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
	@Override
	public int dataCountLeave(Map<String, Object> map) {

		int result = 0;

		try {
			result = dao.selectOne("employee.dataCountLeave", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	// ---------------------------------------------------------------------------------------------
	// 사원 등록
	@Override
	public void insertEmployee(Employee dto) throws Exception {

		try {
			dao.insertData("employee.insertEmployee1", dto);
			dao.insertData("employee.insertEmployee2", dto);
			dao.insertData("employee.insertEmployee3", dto);
			dao.insertData("employee.insertEmployee4", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}

	}
	
	@Override
	public void insertPublicAddr(PublicAddr publicDto) throws Exception {
		
		try {
			dao.insertData("employee.insertEmployee5", publicDto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	// ---------------------------------------------------------------------------------------------
	@Override
	public Employee readEmployee(int employeeNum) {

		Employee dto = null;

		try {
			dto = dao.selectOne("employee.readEmployee", employeeNum);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return dto;

	}

	@Override
	public Employee readEmployee(String empNo) {

		Employee dto = null;

		try {
			dto = dao.selectOne("employee.readEmployee2", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return dto;
	}

	// ---------------------------------------------------------------------------------------------
	// 사원 수정
	@Override
	public void updateEmployee(Employee dto) throws Exception {

		try {
			if(dto.getEnterDate() != null) {
				dto.setEnable(0);
				dao.updateData("employee.updateEmployee1", dto);
			}else {
				dao.updateData("employee.updateEmployee1", dto);
			}
			
			dao.updateData("employee.updateEmployee2", dto);
			dao.updateData("employee.updateEmployee3", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	// ---------------------------------------------------------------------------------------------
	// 사원 접속일
	@Override
	public void updateLastLogin(String empNo) throws Exception {

		try {
			dao.updateData("employee.updateLastLogin", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// 조직도
	@Override
	public List<Employee> listEmpOrg(Map<String, Object> map) {
		List<Employee> list = null;

		try {
			list = dao.selectList("employee.listEmpOrg", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<String> listDept() {
		List<String> list = null;

		try {
			list = dao.selectList("employee.listDept");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	

}
