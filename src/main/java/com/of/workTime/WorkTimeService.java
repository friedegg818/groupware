package com.of.workTime;

import java.util.List;
import java.util.Map;

public interface WorkTimeService {
	public void insertWorkTime(Map<String, Object> map) throws Exception;
	public void updateWorkTime(Map<String, Object> map) throws Exception;
	public WorkTime toDayChekc(int empNo);
	public List<WorkTime> monthList(Map<String, Object> map);
	public List<WorkTime> weekList(Map<String, Object> map);
	
	public void otherMemo(Map<String, Object> map) throws Exception;
	public void outInsert(Map<String, Object> map) throws Exception;
	public void outUpdate(Map<String, Object> map) throws Exception;
	
	public void insertVacation(Map<String, Object> map);
	
	public Map<String, Integer> countCode(Map<String, Object> map);
}
