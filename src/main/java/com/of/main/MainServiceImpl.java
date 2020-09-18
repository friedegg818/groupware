package com.of.main;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.dao.CommonDAO;
import com.of.scheduler.Scheduler;

@Service("main.mainService")
public class MainServiceImpl implements MainService {
	@Autowired
	private CommonDAO dao;

	@Override
	public void insertTodo(Main dto) throws Exception {
		try {
			dao.insertData("main.insertTodo", dto);			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}	
	}

	@Override
	public List<Main> listTodo(Map<String, Object> map) {
		List<Main> list=null;
		try {
			list=dao.selectList("main.listTodo", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public void deleteTodo(int todoNum) throws Exception {
		try {			
			dao.deleteData("main.deleteTodo", todoNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;			
		}
		
	}

	@Override
	public void updateTodo(int todoNum) throws Exception {
		try {
			dao.updateData("main.updateTodo", todoNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}
	
	@Override
	public void updateTodo2(int todoNum) throws Exception {
		try {
			dao.updateData("main.updateTodo2", todoNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}
	
	@Override
	public List<Scheduler> listWeekScheduler(Map<String, Object> map) {
		List<Scheduler> list =null;
		try {
			list=dao.selectList("main.listWeekScheduler", map);
		} catch (Exception e) {
			e.printStackTrace();
		}	
		return list;
	}

	
	
	
	
}