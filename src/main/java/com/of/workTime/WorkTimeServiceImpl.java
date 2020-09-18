package com.of.workTime;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.dao.CommonDAO;

@Service("workTime.workTimeService")
public class WorkTimeServiceImpl implements WorkTimeService {
	@Autowired
	private CommonDAO dao;
	
	@Override
	public void insertWorkTime(Map<String, Object> map) throws Exception {
		try {
			dao.insertData("workTime.insertWorkTime", map);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	@Override
	public void updateWorkTime(Map<String, Object> map) throws Exception {
		try {
			String key = (String)map.get("workCode");
			
			if(key == null) {
				dao.updateData("workTime.updateWorkTime", map);
			}else {
				dao.updateData("workTime.updateWorkTime", map);
				dao.updateData("workTime.updateWorkCode", map);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public WorkTime toDayChekc(int empNo) {
		WorkTime dto = new WorkTime();
		try {
			dto = dao.selectOne("workTime.toDayChekc", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public List<WorkTime> monthList(Map<String, Object> map) {
		List<WorkTime> list = null;
		try {
			list = dao.selectList("workTime.monthList", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<WorkTime> weekList(Map<String, Object> map) {
		List<WorkTime> list = null;
		try {
			list = dao.selectList("workTime.weekList", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public void otherMemo(Map<String, Object> map) throws Exception {
		try {
			dao.insertData("workTime.otherMemo", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void outInsert(Map<String, Object> map) throws Exception {
		try {
			dao.insertData("workTime.insertOutWorkTime", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void outUpdate(Map<String, Object> map) throws Exception {
		try {
			dao.updateData("workTime.updateOutWorkTime", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void insertVacation(Map<String, Object> map) {
		try {
			dao.insertData("workTime.insertVacation", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public Map<String, Integer> countCode(Map<String, Object> map) {
		Map<String, Integer> countMap = new HashMap<String, Integer>();
		try {
			int result = dao.selectOne("workTime.countCodeB", map);
			countMap.put("codeB", result);
			
			result = dao.selectOne("workTime.countCodeC", map);
			countMap.put("codeC", result);
			
			result = dao.selectOne("workTime.countCodeG", map);
			countMap.put("codeG", result);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return countMap;
	}
}
