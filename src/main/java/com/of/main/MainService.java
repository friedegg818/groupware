package com.of.main;

import java.util.List;
import java.util.Map;

import com.of.scheduler.Scheduler;

public interface MainService {
	public void insertTodo(Main dto) throws Exception;
	public List<Main> listTodo(Map<String, Object> map);
	public void updateTodo(int todoNum) throws Exception;	// 할일 다 한 것 체크
	public void updateTodo2(int todoNum) throws Exception; 	// 체크 한 것 취소
	public void deleteTodo(int todoNum) throws Exception;
	
	public List<Scheduler> listWeekScheduler(Map<String, Object> map);
}
