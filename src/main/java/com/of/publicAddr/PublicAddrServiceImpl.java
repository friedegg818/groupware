package com.of.publicAddr;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.dao.CommonDAO;

@Service("publicAddrService")
public class PublicAddrServiceImpl implements PublicAddrService {

	@Autowired
	private CommonDAO dao;

	@Override
	public List<PublicAddr> listPublicAddr(Map<String, Object> map) {
		
		List<PublicAddr> list = null;

		try {
			list = dao.selectList("publicAddr.listPublicAddr", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		
		int result = 0;

		try {
			result = dao.selectOne("publicAddr.dataCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	@Override
	public PublicAddr readpublicAddr(int empNo) {
		
		PublicAddr dto = null;

		try {
			dto = dao.selectOne("publicAddr.readPublicAddr", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return dto;
	}

	// ---------------------------------------------------------------------------------------------
	// 공용 주소록 내보내기
	@Override
	public List<PublicAddr> listAllPublicAddr() {
		
		List<PublicAddr> list = null;

		try {
			list = dao.selectList("publicAddr.listAllPublicAddr");
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

}
