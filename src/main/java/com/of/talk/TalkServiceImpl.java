package com.of.talk;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.dao.CommonDAO;

@Service
public class TalkServiceImpl implements TalkService{
	
	@Autowired
	private CommonDAO dao;

	@Override
	public void insertTalk(Talk dto) throws Exception {
		try {
			dao.insertData("talk.insertTalk", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}	
	}

	@Override
	public List<Talk> listTalk(Map<String, Object> map) {
		List<Talk> list =null;
		
		try {
			list=dao.selectList("talk.listTalk", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public int dataCount() {
		int result=0;
		
		try {
			result=dao.selectOne("talk.dataCount");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void deleteTalk(Map<String, Object> map) throws Exception {
		try {
			dao.deleteData("talk.deleteTalk", map);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

}
