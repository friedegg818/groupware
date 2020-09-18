package com.of.scheduler;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.dao.CommonDAO;

@Service("scheduler.schedulerService")
public class SchedulerServiceImpl implements SchedulerService{
	
	@Autowired
	CommonDAO dao;
	
	@Override
	public void insertScheduler(Scheduler scheduler) throws Exception {
		try {
			dao.insertData("scheduler.insertScheduler", scheduler);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public List<Scheduler> listMonthSchedule(Map<String, Object> map) {
		List<Scheduler> list =null;
		try {
			list=dao.selectList("scheduler.listMonthScheduler", map);
		} catch (Exception e) {
			e.printStackTrace();
		}	
		return list;
	}

	@Override
	public Scheduler readScheduler(int schNum) {
		Scheduler scheduler =null;
		
		try {
			// 게시물 가져오기
			scheduler=dao.selectOne("scheduler.readScheduler", schNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return scheduler;
	}

	@Override
	public int updateScheduler(Scheduler scheduler) throws Exception {
		int result=0;
		try {
			result=dao.updateData("scheduler.updateScheduler", scheduler);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return result;
	}

	@Override
	public void deleteScheduler(int schNum) throws Exception {
		try {
			dao.deleteData("scheduler.deleteScheduler", schNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

}
