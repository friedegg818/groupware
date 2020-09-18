package com.of.privateaddr;
 
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.dao.CommonDAO;

@Service("privateAddrService")
public class PrivateAddrServiceImpl implements PrivateAddrService {

	@Autowired
	private CommonDAO dao;

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 리스트
	@Override
	public List<PrivateAddr> listPrivateAddr(Map<String, Object> map) {

		List<PrivateAddr> list = null;

		try {
			list = dao.selectList("privateAddr.listPrivateAddr", map);
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
			result = dao.selectOne("privateAddr.dataCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 빠른등록
	@Override
	public void insertPrivateAddrSpeed(PrivateAddr dto) throws Exception {
		try {
			dao.insertData("privateAddr.insertPrivateAddrSpeed", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 등록
	@Override
	public void insertPrivateAddr(PrivateAddr dto) throws Exception {
		try {
			dao.insertData("privateAddr.insertPrivateAddr", dto);
			// dao.insertData("privateAddr.insertPrivateAddr3", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	// ---------------------------------------------------------------------------------------------
	// 모달 추가
	@Override
	public int modalInsert(PrivateAddr dto) throws Exception {
		int groupNum = 0;
		try {
			groupNum = dao.selectOne("privateAddr.seq_group");
			dto.setGroupNum(groupNum);
			dao.insertData("privateAddr.modalInsert", dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return groupNum;
	}

	// ---------------------------------------------------------------------------------------------
	// 모달 리스트
	@Override
	public List<PrivateAddr> modalList(String empNo) {

		List<PrivateAddr> list = null;

		try {
			list = dao.selectList("privateAddr.listModal", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 수정
	@Override
	public void updatePrivateAddr(PrivateAddr dto) throws Exception {

		try {
			dao.updateData("privateAddr.updatePrivateAddr", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public PrivateAddr readAddress(int addrNum) {

		PrivateAddr dto = null;

		try {
			dto = dao.selectOne("privateAddr.readAddress", addrNum);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return dto;
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 삭제
	@Override
	public void deletePrivateAddr(int addrNum) throws Exception {
		try {
			dao.deleteData("privateAddr.deletePrivateAddr", addrNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 내보내기
	@Override
	public List<PrivateAddr> listAllPrivateAddr(String empNo) {

		List<PrivateAddr> list = null;

		try {
			list = dao.selectList("privateAddr.listAllPrivateAddr", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

}
